module Oak.Html
  ( module Oak.Html.Tags
  ) where

import Prelude
  ( map
  ) as P
import Prelude
  ( (>>>)
  )

import Oak.Html.Tags ( Html(..) )
import Oak.Html.Attribute
  ( Attribute(..)
  )

map :: ∀ msg1 msg2. (msg1 -> msg2) -> Html msg1 -> Html msg2
map f html =
  case html of
    Text str -> Text str
    Tag name attrs children ->
      Tag name (P.map (mapAttr f) attrs) (P.map (map f) children)

mapAttr :: ∀ msg1 msg2. (msg1 -> msg2) -> Attribute msg1 -> Attribute msg2
mapAttr f attr =
  case attr of
    StringEventHandler name ctor -> StringEventHandler name (ctor >>> f)
    EventHandler name msg -> EventHandler name (f msg)
    KeyPressEventHandler name ctor -> KeyPressEventHandler name (ctor >>> f)
    BooleanAttribute name bool -> BooleanAttribute name bool
    DataAttribute name dat -> DataAttribute name dat
    SimpleAttribute a b -> SimpleAttribute a b
    Style a -> Style a
