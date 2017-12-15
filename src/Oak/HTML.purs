module Oak.HTML ( text
                , div
                , button
                , HTML
                , input
                , br
                ) where

import Oak.HTML.Attributes (Attribute)

data HTML msg =
  HTML { name     :: String
      , children :: Array (HTML msg)
      , options  :: Array (Attribute msg)
      }
  | Text String

text :: forall msg. String -> HTML msg
text s = Text s

tag :: forall msg. String -> Array (Attribute msg) -> Array (HTML msg) -> HTML msg
tag name options children = HTML { name: name, options: options, children: children }

br :: forall msg. Array (Attribute msg) -> HTML msg
br options = tag "br" options []

div :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
div = tag "div"

button :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
button = tag "button"

input :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
input = tag "input"
