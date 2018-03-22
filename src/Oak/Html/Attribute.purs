module Oak.Html.Attribute where

data Attribute msg
  = EventHandler String msg
  | StringEventHandler String (String -> msg)
  | SimpleAttribute String String

value :: forall msg. String -> Attribute msg
value val = SimpleAttribute "value" val
