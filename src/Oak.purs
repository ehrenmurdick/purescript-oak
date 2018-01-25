module Oak
  ( createApp
  , HTML
  , App
  , text
  , div
  ) where


import Prelude
  ( bind
  )

import Control.Monad (class Monad, ap)
import Control.Bind (class Bind)
import Control.Apply (class Apply)
import Control.Applicative (class Applicative, liftA1)
import Data.Functor (class Functor)

foreign import data NativeDOM :: Type

foreign import nativeTag :: String -> Array NativeDOM -> NativeDOM
foreign import nativeText :: String -> NativeDOM

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

foreign import data DOM :: Type -> Type -> Type
-- foreign import data Eff :: # Effect -> Type -> Type

foreign import bindD :: forall e a b. DOM e a -> (a -> DOM e b) -> DOM e b
-- foreign import bindE :: forall e a b. Eff e a -> (a -> Eff e b) -> Eff e b

instance bindDOM :: Bind (DOM msg) where
  bind = bindD

instance applyDOM :: Apply (DOM e) where
  apply = ap

instance monadDOM :: Monad (DOM e)

instance applicativeDOM :: Applicative (DOM e) where
  pure = pureD

foreign import pureD :: forall e a. a -> DOM e a


instance functorDOM :: Functor (DOM e) where
  map = liftA1


foreign import renderN :: forall model msg. App model msg -> DOM msg msg

render :: forall model msg. App model msg -> DOM msg msg
render = renderN


runApp app@(App opts) = do
  msg <- render app
  runApp app
