module Oak.HTML.Attributes ( onClick
                           , Attribute
                           , onInput
                           ) where

data Attribute msg = OnClick msg
                   | OnInput (String -> msg)

onClick :: forall msg. msg -> Attribute msg
onClick a = OnClick a

onInput :: forall msg. (String -> msg) -> Attribute msg
onInput a = OnInput a
