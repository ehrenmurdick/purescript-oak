module Oak.Cmd
  ( Cmd(..)
  , none
  , runEffThen
  , runEff
  ) where

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff)
import Prelude (map, const, Unit)

data Cmd msg
  = EffCmdThen (Effect msg)
  | EffCmdStop (Effect Unit)
  | AffCmdStop (Aff Unit)
  | None

none :: ∀ msg. Cmd msg
none = None

runEffThen :: ∀ a msg. msg -> Effect a -> Cmd msg
runEffThen m e = EffCmdThen (map (const m) e)

runEff :: ∀ a msg. Effect Unit -> Cmd msg
runEff e = AffCmdStop (liftEffect e)

runAff :: ∀ a msg. Aff Unit -> Cmd msg
runAff a = AffCmdStop a
