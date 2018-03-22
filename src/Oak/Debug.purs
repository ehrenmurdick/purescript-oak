module Oak.Debug where

import Data.Function.Uncurried
  ( Fn1
  , runFn1
  )

foreign import traceImpl :: ∀ a. Fn1 a a

trace :: ∀ a. a -> a
trace = runFn1 traceImpl
