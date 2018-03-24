module Oak.Html.Attribute where

import Oak.Css ( StyleAttribute )

data Attribute msg
  = EventHandler String msg
  | StringEventHandler String (String -> msg)
  | SimpleAttribute String String
  | Style (Array StyleAttribute)


value :: ∀ msg. String -> Attribute msg
value val = SimpleAttribute "value" val


style :: ∀ msg. Array StyleAttribute -> Attribute msg
style attrs = Style attrs
