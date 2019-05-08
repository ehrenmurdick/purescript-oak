module Oak.Cmd
  ( Cmd(..)
  , none
  , performEffectThen
  , performEffect
  ) where

import Effect (Effect)
import Prelude (map, const, Unit)

data Cmd msg
  = Cmd (Effect msg)
  | Stop (Effect Unit)
  | None

none :: ∀ msg. Cmd msg
none = None

performEffectThen :: ∀ a msg. msg -> Effect a -> Cmd msg
performEffectThen m e = Cmd (map (const m) e)

performEffect :: ∀ a msg. Effect Unit -> Cmd msg
performEffect e = Stop e
