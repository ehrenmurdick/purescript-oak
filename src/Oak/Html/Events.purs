module Oak.Html.Events where

import Oak.Html.Attribute

onClick :: forall msg.
  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg
