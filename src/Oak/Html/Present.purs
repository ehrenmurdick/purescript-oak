module Oak.Html.Present where

import Prelude
  ( show
  , id
  )

class Present a where
  present :: a -> String


instance presentString :: Present String where
  present = id

instance presentInt :: Present Int where
  present = show
