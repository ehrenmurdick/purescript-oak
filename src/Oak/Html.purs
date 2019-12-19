module Oak.Html where

import Control.Monad.Writer

import Data.Array (concat)
import Oak.Html.Attribute (Attribute)
import Oak.Html.Present (present, class Present)
import Prelude
  ( class Functor
  , class Apply
  , class Applicative
  , class Bind
  , class Monad
  , discard
  , apply
  , map
  , pure
  , ($)
  , (<<<)
  , unit
  , Unit
  , pure
  )

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))

data T a b
  = T a b

data Builder s a
  = Builder (State s -> (T a (State s)))

data State s
  = State s

instance builderFunctor :: Functor (Builder s) where
  map f b = Builder $ \s ->
    let Builder b_a = b
        T v new_s = b_a s
    in T (f v) new_s

instance builderApply :: Apply (Builder s) where
  apply a b = Builder $ \s ->
    let Builder b_a = a
        T f new_s = b_a s
        Builder a_a = b
        T v new_s_ = a_a new_s
    in T (f v) new_s_

instance builderApplicative :: Applicative (Builder s) where
  pure a = Builder $ \s ->
    T a s

instance builderBind :: Bind (Builder s) where
  bind :: forall a b s. Builder s a -> (a -> Builder s b) -> Builder s b
  bind b f = Builder $ \s ->
    let Builder b_a = b
        T v new_s = b_a s
        Builder new_b = f v
    in new_b new_s

instance htmlFunctor :: Functor Html where
  map ::
    forall msg1 msg2.
    (msg1 -> msg2) ->
    Html msg1 ->
    Html msg2
  map f html = case html of
    Text str -> Text str
    Tag name attrs children -> Tag name (map (map f) attrs) (map (map f) children)
