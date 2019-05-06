module Oak
  ( App
  , createApp
  , runApp
  ) where

import Prelude
  ( bind
  , pure
  )
import Oak.Cmd (Cmd)
import Effect (Effect)
import Effect.Ref
  ( Ref
  , new
  , read
  , write
  ) as Ref
import Partial.Unsafe (unsafePartial)
import Data.Maybe
  ( Maybe(..)
  , fromJust
  )

import Oak.Html (Html)
import Oak.VirtualDom
  ( patch
  , render
  )
import Oak.VirtualDom.Native as N
import Oak.Document
  ( Node
  )


data App c model msg flags = App
  { init :: flags -> model
  , update :: msg -> model -> model
  , next :: msg -> model -> Cmd c msg
  , view :: model -> Html msg
  }

data RunningApp c model msg = RunningApp
  { update :: msg -> model -> model
  , next :: msg -> model -> Cmd c msg
  , view :: model -> Html msg
  }

-- | createApp takes a record with a description of your Oak app.
-- | It has a few parts:
-- |
-- |
-- | `init`:
-- |
-- | A function from you flags type to the inital model state.
-- | Flags type can be `Unit` if you don't need this for anything.
-- |
-- |
-- | `view`:
-- |
-- |
-- | Maps the current model to an html view.
-- |
-- | `next`:
-- |
-- | This function maps a message and model to a command. For example,
-- | for sending an Http request when a user clicks a button.
-- | `next` would be called with the button click message and would
-- | return an `Oak.Cmd` that will execute the request.
-- |
-- |
-- | `update`:
-- |
-- | Takes an incoming message, and the previous model state,
-- | and returns the new model state.

createApp :: ∀ msg model c flags.
  { init :: flags -> model
  , update :: msg -> model -> model
  , next :: msg -> model -> Cmd c msg
  , view :: model -> Html msg
  } -> App c model msg flags
createApp opts = App
  { init: opts.init
  , view: opts.view
  , next: opts.next
  , update: opts.update
  }


-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
runApp :: ∀ c model msg flags.
  App c model msg flags -> flags -> Effect Node
runApp app flags = do
  runApp_ app flags



type Runtime m =
  { tree :: Maybe N.Tree
  , root :: Maybe Node
  , model :: m
  }

handler :: ∀ msg model c.
  Ref.Ref (Runtime model)
    -> RunningApp c model msg
    -> msg
    -> Effect (Runtime model)
handler ref runningApp msg = do
  env <- Ref.read ref
  let (RunningApp app) = runningApp
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update msg env.model
  let cmd = app.next msg newModel
  newTree <- render (handler ref runningApp) (app.view newModel)
  newRoot <- patch newTree oldTree env.root
  let newRuntime =
        { root: Just newRoot
        , tree: Just newTree
        , model: newModel
        }
  _ <- runCmd (handler ref runningApp) cmd
  _ <- Ref.write newRuntime ref
  pure newRuntime

foreign import runCmdImpl :: ∀ c model msg.
  (msg -> Effect (Runtime model))
    -> Cmd c msg
    -> Effect (Runtime model)

runCmd :: ∀ c model msg.
  (msg -> Effect (Runtime model))
    -> Cmd c msg
    -> Effect (Runtime model)
runCmd = runCmdImpl

runApp_ :: ∀ c model msg flags.
  App c model msg flags
    -> flags
    -> Effect Node
runApp_ (App app) flags = do
  let runningApp = { view: app.view
                   , next: app.next
                   , update: app.update
                   }
  let initialModel = app.init flags
  ref <- Ref.new { tree: Nothing, root: Nothing, model: initialModel }
  tree <- render (handler ref (RunningApp runningApp)) (runningApp.view initialModel)
  let rootNode = (N.createRootNode tree)
  _ <- Ref.write { tree: Just tree, root: Just rootNode, model: initialModel } ref
  pure rootNode
