module Oak.Cmd.Time where

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

foreign import data TIME :: Command

foreign import delayImpl :: ∀ c m.
  Fn2 Int m (Cmd (time :: TIME | c) m)


milliseconds :: Int -> Time
milliseconds x = Time x


seconds :: Int -> Time
seconds = milliseconds <<< (_ * 1000)


timeToMilliseconds :: Time -> Int
timeToMilliseconds (Time x) = x


delay :: ∀ c m.
  Time
    -> m
    -> Cmd (time :: TIME | c) m
delay amt msg = (runFn2 delayImpl) (timeToMilliseconds amt) msg
