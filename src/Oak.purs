module Oak where

import Prelude
import Control.Monad.Eff
import Control.Monad.ST
import Partial.Unsafe
import Data.Maybe

data Msg
  = None

-- main : Program Never number Msg
-- bind :: forall a b. m a -> (a -> m b) -> m b

data App model msg = App
  { model :: model
  , update :: msg -> model -> model
  , view :: model -> Html msg
  }


-- bind :: forall model msg.
--   App model msg ->
--   (model -> msg -> App model msg) ->
--   App model msg
-- bind app f = app

data Html msg
  = Text String
  | Tag String (Array (Html msg))

text :: forall msg. String -> Html msg
text str = Text str

div :: forall msg. Array (Html msg) -> Html msg
div children = Tag "div" children

createApp :: forall msg model.
  { init :: model
  , update :: msg -> model -> model
  , view :: model -> Html msg
  } -> App model msg
createApp opts = App
  { model: opts.init
  , view: opts.view
  , update: opts.update
  }

foreign import data Tree :: Type
foreign import data Node :: Type

foreign import data NODE :: Effect
foreign import data VDOM :: Effect
foreign import data PATCH :: Effect

type Runtime model msg =
  { app :: App model msg
  , tree :: Maybe Tree
  , root :: Maybe Node
  }

handler :: forall msg model eff h.
  STRef h (Runtime model msg)
  -> msg
  -> Eff ( st :: ST h | eff ) (Runtime model msg)
handler ref msg = do
  env <- readSTRef ref
  let (App app) = env.app
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update msg app.model
  newTree <- ?render (handler ref) (app.view newModel)
  newRoot <- ?patch newTree oldTree env.root
  let newAttrs = app { model = newModel }
  let newApp = App newAttrs
  let newRuntime =
        { app: newApp
        , root: Just newRoot
        , tree: Just newTree
        }
  writeSTRef ref newRuntime

runApp :: forall e h model msg.
  App model msg
    -> Eff ( dom :: VDOM
           , createRootNode :: NODE
           , renderVTree :: PATCH
           , st :: ST h
       | e) Unit
runApp (App app) = do
  ref <- newSTRef { app: (App app), tree: Nothing, root: Nothing }
  tree <- ?createElement handler (app.view app.model)
  rootNode <- ?createRootNode tree
  pure rootNode
