module Oak.Html where

import Control.Monad.Writer

import Prelude
  ( class Functor
  , discard
  , map
  , pure
  , (<<<)
  , unit
  , Unit
  , pure
  )

import Oak.Html.Present
  ( present
  , class Present
  )
import Oak.Html.Attribute ( Attribute )

import Data.Tuple (fst)

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))


instance htmlFunctor :: Functor Html where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Html msg1 -> Html msg2
  map f html =
    case html of
      Text str -> Text str
      Tag name attrs children ->
        Tag name (map (map f) attrs) (map (map f) children)


root children = Tag "div" [] (execWriter children)


empty = tell []


text :: ∀ a msg.
  (Present a)
    => a
    -> Writer (Array (Html msg)) Unit
text val = do
  let tag = Text (present val)
  tell [tag]
  pure unit


div :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
div attrs children = do
  let tag = Tag "div" attrs (execWriter children)
  tell [tag]
  pure unit

