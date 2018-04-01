module Oak.Cmd where


foreign import kind CmdEffect

foreign import data Cmd :: # CmdEffect -> Type -> Type

foreign import data HTTP :: CmdEffect

foreign import noneImpl :: ∀ c a. Cmd c a


none :: ∀ c a. Cmd c a
none = noneImpl
