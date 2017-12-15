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

br :: forall msg. Array (Attribute msg) -> HTML msg
br options = HTML { name: "br", children: [], options: options }

div :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
div opts children = HTML {name: "div", children: children, options: opts}

button :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
button opts children = HTML {name: "button", children: children, options: opts}

input :: forall msg. Array (Attribute msg) -> Array (HTML msg) -> (HTML msg)
input opts children = HTML {name: "input", children: children, options: opts}
