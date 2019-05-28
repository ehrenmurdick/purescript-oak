module Oak
  ( App
  , createApp
  , unwrapApp
  , runApp
  ) where

import Prelude
  ( bind
  , discard
  , pure
  , Unit
  )
import Data.Monoid (mempty)
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


data App msg model = App
  { init :: model
  , update :: msg -> model -> model
  , next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit
  , view :: model -> Html msg
  }

data RunningApp msg model = RunningApp
  { update :: msg -> model -> model
  , next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit
  , view :: model -> Html msg
  }

-- | createApp takes a record with a description of your Oak app.
-- | It has a few parts:
-- |
-- |
-- | `init`:
-- |
-- | the inital model state.
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

createApp :: ∀ msg model .
  { init :: model
  , update :: msg -> model -> model
  , next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit
  , view :: model -> Html msg
  } -> App msg model
createApp opts = App
  { init: opts.init
  , view: opts.view
  , next: opts.next
  , update: opts.update
  }


unwrapApp :: ∀ msg model.
  App msg model ->
    { init :: model
    , update :: msg -> model -> model
    , next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit
    , view :: model -> Html msg
    }
unwrapApp (App app) = app


-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
runApp :: ∀ msg model.
  App msg model -> Effect Node
runApp app = do
  runApp_ app



type Runtime m =
  { tree :: Maybe N.Tree
  , root :: Maybe Node
  , model :: m
  }

handler :: ∀ msg model.
  Ref.Ref (Runtime model)
    -> RunningApp msg model
    -> msg
    -> Effect Unit
handler ref runningApp msg = do
  env <- Ref.read ref
  let (RunningApp app) = runningApp
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update msg env.model
  newTree <- render (handler ref runningApp) (app.view newModel)
  newRoot <- patch newTree oldTree env.root
  let newRuntime =
        { root: Just newRoot
        , tree: Just newTree
        , model: newModel
        }
  Ref.write newRuntime ref
  app.next msg newModel (handler ref runningApp)
  mempty

runApp_ :: ∀ msg model.
  App msg model
    -> Effect Node
runApp_ (App app) = do
  let runningApp = { view: app.view
                   , next: app.next
                   , update: app.update
                   }
  let initialModel = app.init
  ref <- Ref.new { tree: Nothing, root: Nothing, model: initialModel }
  tree <- render (handler ref (RunningApp runningApp)) (runningApp.view initialModel)
  let rootNode = (N.createRootNode tree)
  _ <- Ref.write { tree: Just tree, root: Just rootNode, model: initialModel } ref
  pure rootNode
