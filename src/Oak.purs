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
import Control.Monad.Eff
  ( Eff
  , kind Effect
  )
import Control.Monad.ST
  ( ST
  , STRef
  , newSTRef
  , readSTRef
  , runST
  , writeSTRef
  )
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
  , NODE
  , DOM
  )


data App c model msg = App
  { model :: model
  , update :: msg -> model -> model
  , next :: msg -> model -> Cmd c msg
  , view :: model -> Html msg
  }

-- | createApp takes a record with a description of your Oak app.
-- | It has a few parts:
-- |
-- |
-- | `init`:
-- |
-- | Should the initial model state.
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

createApp :: ∀ msg model c.
  { init :: model
  , update :: msg -> model -> model
  , next :: msg -> model -> Cmd c msg
  , view :: model -> Html msg
  } -> App c model msg
createApp opts = App
  { model: opts.init
  , view: opts.view
  , next: opts.next
  , update: opts.update
  }


-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
runApp :: ∀ c e model msg.
  App c model msg -> Eff (dom :: DOM | e) Node
runApp app = do
  runST (runApp_ app)



type Runtime m =
  { tree :: Maybe N.Tree
  , root :: Maybe Node
  , model :: m
  }

handler :: ∀ msg model eff c h.
  STRef h (Runtime model)
    -> App c model msg
    -> msg
    -> Eff ( dom :: DOM, st :: ST h | eff ) (Runtime model)
handler ref app msg = do
  env <- readSTRef ref
  let (App app) = app
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update msg env.model
  let cmd = app.next msg newModel
  let newAttrs = app { model = newModel }
  let newApp = App newAttrs
  newTree <- render (handler ref newApp) (app.view newModel)
  newRoot <- patch newTree oldTree env.root
  let newRuntime =
        { root: Just newRoot
        , tree: Just newTree
        , model: newAttrs.model
        }
  _ <- runCmd (handler ref newApp) cmd
  writeSTRef ref newRuntime

foreign import runCmdImpl :: ∀ c e model msg.
  (msg -> Eff e (Runtime model))
    -> Cmd c msg
    -> Eff e (Runtime model)

runCmd :: ∀ c e model msg.
  (msg -> Eff e (Runtime model))
    -> Cmd c msg
    -> Eff e (Runtime model)
runCmd = runCmdImpl

runApp_ :: ∀ c e h model msg.
  App c model msg
    -> Eff ( st :: ST h, dom :: DOM | e) Node
runApp_ (App app) = do
  ref <- newSTRef { tree: Nothing, root: Nothing, model: app.model }
  tree <- render (handler ref (App app)) (app.view app.model)
  rootNode <- finalizeRootNode (N.createRootNode tree)
  _ <- writeSTRef ref { tree: Just tree, root: Just rootNode, model: app.model }
  pure rootNode


foreign import finalizeRootNode :: ∀ r.
  Eff (createRootNode :: NODE | r) Node
    -> Eff r Node

