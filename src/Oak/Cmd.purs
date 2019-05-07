module Oak.Cmd
  ( Cmd
  , none
  ) where

foreign import data Cmd :: Type -> Type

foreign import noneImpl :: ∀ a. Cmd a

none :: ∀ a. Cmd a
none = noneImpl
