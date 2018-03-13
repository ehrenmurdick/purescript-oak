module Oak where

import Prelude
  ( bind
  , map
  , Unit
  )

import Control.Monad.Eff

-- main : Program Never number Msg
-- bind :: forall a b. m a -> (a -> m b) -> m b

data App model msg = App
  { model :: model
  , update :: msg -> model -> model
  , view :: model -> HTML msg
  }


-- bind :: forall model msg.
--   App model msg ->
--   (model -> msg -> App model msg) ->
--   App model msg
-- bind app f = app

data HTML msg
  = Text String
  | Tag String (Array (HTML msg))

text :: forall msg. String -> HTML msg
text str = Text str

div :: forall msg. Array (HTML msg) -> HTML msg
div children = Tag "div" children

createApp :: forall msg model.
  { init :: model
  , update :: msg -> model -> model
  , view :: model -> HTML msg
  } -> App model msg
createApp opts = App
  { model: opts.init
  , view: opts.view
  , update: opts.update
  }

-- bind :: forall a b. m a -> (a -> m b) -> m b

foreign import data Tree :: Type
foreign import data DOM :: Effect
-- foreign import data Eff :: # Effect -> Type -> Type

foreign import renderN :: String -> Array Tree -> Tree
foreign import nativeText :: String -> Tree

renderHTML :: forall msg. HTML msg -> Tree
renderHTML (Tag name children) = renderN name (map renderHTML children)
renderHTML (Text str) = nativeText str

foreign import performSideEffect :: RootNode -> Tree -> Tree -> Eff (dom :: DOM) Unit

handleMsg :: forall model msg. App model msg -> RootNode -> Tree -> msg -> Eff (dom :: DOM) Unit
handleMsg (App app) root tree msg =
  let
    newModel = app.update msg app.model
    newTree = renderHTML (app.view newModel)
  in
    performSideEffect root tree newTree

render :: forall model msg. App model msg -> RootNode -> Tree -> Eff (dom :: DOM) Unit
render (App app) node oldTree =
  let
    root = app.view app.model
    newTree = renderHTML root
  in
    performSideEffect node oldTree newTree

foreign import data RootNode :: Type

runApp :: forall model msg. App model msg -> RootNode -> Eff (dom :: DOM) Unit
runApp app@(App opts) rootNode = render app rootNode (renderHTML (opts.view opts.model))
