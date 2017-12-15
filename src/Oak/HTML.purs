module Oak.HTML ( text
                , div
                , button
                , HTML
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

div :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
div opts children = HTML {name: "div", children: children, options: opts}

button :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
button opts children = HTML {name: "button", children: children, options: opts}
