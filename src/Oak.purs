module Oak where

import Prelude
import Control.Monad.Eff
import Control.Monad.ST
import Partial.Unsafe
import Data.Maybe
import Data.Traversable
import Data.Foldable

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
  | Tag String (Array (Attribute msg)) (Array (Html msg))

data Attribute msg
  = EventHandler String msg

onClick :: forall msg.
  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg

text :: forall msg. String -> Html msg
text str = Text str

div :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
div attrs children = Tag "div" attrs children

p :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
p attrs children = Tag "p" attrs children

button :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
button attrs children = Tag "button" attrs children

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
foreign import data NativeAttrs :: Type

foreign import data NODE :: Effect
foreign import data VDOM :: Effect
foreign import data PATCH :: Effect

type Runtime model msg =
  { app :: App model msg
  , tree :: Maybe Tree
  , root :: Maybe Node
  }

foreign import textN :: forall e.
  String
    -> Eff e Tree

foreign import renderN :: forall msg h e model.
  String
    -> NativeAttrs
    -> Eff ( st :: ST h | e ) (Array Tree)
    -> Eff ( st :: ST h | e ) Tree

render :: forall e h model msg.
  (msg -> Eff ( st :: ST h | e ) (Runtime model msg) )
    -> Html msg
    -> Eff ( st :: ST h | e ) Tree
render h (Tag name attrs children) =
  renderN name (combineAttrs attrs h) (sequence $ map (render h) children)
render h (Text str) = textN str

foreign import concatHandlerFun :: forall eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs

foreign import emptyAttrsN :: NativeAttrs

concatAttr :: forall msg eff.
  (msg -> eff)
    -> Attribute msg
    -> NativeAttrs
    -> NativeAttrs
concatAttr handler (EventHandler name msg) attrs =
  concatHandlerFun name (\_ -> handler msg) attrs

combineAttrs :: forall msg eff.
  Array (Attribute msg)
    -> (msg -> eff)
    -> NativeAttrs
combineAttrs attrs handler =
  foldr (concatAttr handler) emptyAttrsN attrs

foreign import patchN :: forall e h.
  Tree
    -> Tree
    -> Node
    -> Eff ( st :: ST h | e ) Node

patch :: forall e h.
  Tree
    -> Tree
    -> Maybe Node
    -> Eff ( st :: ST h | e ) Node
patch oldTree newTree maybeRoot =
  let root = unsafePartial (fromJust maybeRoot)
  in patchN oldTree newTree root

foreign import trace :: forall a. a -> a

handler :: forall msg model eff h.
  STRef h (Runtime model msg)
    -> msg
    -> Eff ( st :: ST h | eff ) (Runtime model msg)
handler ref msg = do
  env <- readSTRef ref
  let (App app) = env.app
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update (trace msg) app.model
  newTree <- render (handler ref) (app.view newModel)
  newRoot <- patch newTree oldTree env.root
  let newAttrs = app { model = newModel }
  let newApp = App newAttrs
  let newRuntime =
        { app: newApp
        , root: Just newRoot
        , tree: Just newTree
        }
  writeSTRef ref newRuntime

foreign import createRootNode :: forall e.
  Tree
    -> Eff ( createRootNode :: NODE | e ) Node

runApp :: forall e h model msg.
  App model msg
    -> Eff ( dom :: VDOM
           , createRootNode :: NODE
           , renderVTree :: PATCH
           , st :: ST h
       | e) Node
runApp (App app) = do
  ref <- newSTRef { app: (App app), tree: Nothing, root: Nothing }
  tree <- render (handler ref) (app.view app.model)
  rootNode <- createRootNode tree
  _ <- writeSTRef ref { app: (App app), tree: Just tree, root: Just rootNode }
  pure rootNode
