module Oak.Cmd
  ( kind Command
  , Cmd
  , none
  ) where

foreign import kind Command

foreign import data Cmd :: # Command -> Type -> Type

foreign import noneImpl :: ∀ c a. Cmd c a


none :: ∀ c a. Cmd c a
none = noneImpl
