module Oak.Cmd.Time
  ( Time
  , milliseconds
  , seconds
  , delay
  ) where

import Prelude
  ( (<<<)
  , (*)
  )

import Data.Function.Uncurried
  ( Fn2
  , runFn2
  )

import Oak.Cmd

data Time = Time Int

foreign import delayImpl :: ∀ m.
  Fn2 Int m (Cmd m)


milliseconds :: Int -> Time
milliseconds x = Time x


seconds :: Int -> Time
seconds = milliseconds <<< (_ * 1000)


timeToMilliseconds :: Time -> Int
timeToMilliseconds (Time x) = x


delay :: ∀ m.
  Time
    -> m
    -> Cmd m
delay amt msg = (runFn2 delayImpl) (timeToMilliseconds amt) msg
