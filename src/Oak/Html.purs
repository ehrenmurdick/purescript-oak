module Oak.Html where

import Control.Monad.Writer

import Data.Array (snoc)
import Oak.Html.Attribute (Attribute)
import Oak.Html.Present (present, class Present)
import Prelude
  ( class Functor
  , class Apply
  , class Applicative
  , class Bind
  , class Monad
  , class Monoid
  , class Semigroup
  , mempty
  , discard
  , apply
  , map
  , pure
  , ($)
  , (<<<)
  , unit
  , (>>=)
  , Unit
  , pure
  , bind
  )

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))

data T a b
  = T a b

data Builder s a
  = Builder (s -> (T a s))

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

instance builderMonoid :: (Monoid a, Monoid s) => Monoid (Builder s a) where
  mempty = Builder $ \s ->
    T mempty mempty

instance builderSemigroup :: Semigroup (Builder s a) where
  append (Builder b_a) (Builder a_a) = Builder $ \s ->
    let T v s_a = a_a s
        T x new_s = b_a s_a
    in T x new_s

instance builderBind :: Bind (Builder s) where
  bind :: forall a b s. Builder s a -> (a -> Builder s b) -> Builder s b
  bind b f = Builder $ \s ->
    let Builder b_a = b
        T v new_s = b_a s
        Builder new_b = f v
    in new_b new_s

put :: forall s. s -> Builder s Unit
put s = Builder $ \_ ->
  T unit s

get :: forall s. Builder s s
get = Builder $ \s ->
  T s s

runBuilder :: forall msg. View msg -> Array (Html msg)
runBuilder (Builder b_a) = let T v new_s = b_a []
                           in new_s

instance htmlFunctor :: Functor Html where
  map ::
    forall msg1 msg2.
    (msg1 -> msg2) ->
    Html msg1 ->
    Html msg2
  map f html = case html of
    Text str -> Text str
    Tag name attrs children -> Tag name (map (map f) attrs) (map (map f) children)

type View msg
  = Builder (Array (Html msg)) Unit

text :: forall msg. String -> View msg
text s = do
  xs <- get
  let tag = Text s
  put (snoc xs tag)

empty :: forall msg. View msg
empty = text ""

div :: forall msg. Array (Attribute msg) -> View msg -> View msg
div attrs m = do
  xs <- get
  let tag = Tag "div" attrs (runBuilder m)
  put (snoc xs tag)
