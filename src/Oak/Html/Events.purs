module Oak.Html.Events where

import Oak.Html.Attribute

onClick :: ∀ msg.
  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg

onInput :: ∀ msg.
  (String -> msg) -> Attribute msg
onInput f = StringEventHandler "oninput" f
