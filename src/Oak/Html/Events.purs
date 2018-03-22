module Oak.Html.Events where

import Oak.Html.Attribute

onClick :: forall msg.
  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg

onInput :: forall msg.
  (String -> msg) -> Attribute msg
onInput f = StringEventHandler "oninput" f
