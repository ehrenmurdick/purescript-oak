module Oak.HTML.Attributes ( onClick
                           , Attribute
                           ) where

data Attribute msg =
  OnClick msg

onClick :: forall msg. msg -> Attribute msg
onClick a = OnClick a
