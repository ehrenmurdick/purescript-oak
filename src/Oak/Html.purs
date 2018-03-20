module Oak.Html where

import Oak.Html.Attribute

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))

text :: forall msg. String -> Html msg
text str = Text str

div :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
div attrs children = Tag "div" attrs children

p :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
p attrs children = Tag "p" attrs children

button :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
button attrs children = Tag "button" attrs children
