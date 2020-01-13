module Oak.Html.Present where

import Prelude (show, identity)

-- | A type class for types that are presentable in HTML.
-- | This is here so you don't have to convert everything to
-- | a string before passing it into `Html.text`.
-- | For example you could show a number in html using just
-- | `text 2`.
class Present a where
  present :: a -> String

instance presentString :: Present String where
  present = identity

instance presentInt :: Present Int where
  present = show

instance presentBoolean :: Present Boolean where
  present = show
