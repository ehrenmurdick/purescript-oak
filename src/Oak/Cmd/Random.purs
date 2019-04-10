module Oak.Cmd.Random
  ( Random
  , RANDOM
  , generate
  ) where

import Prelude
import Data.Function.Uncurried
 ( Fn1
 , runFn1
 )

import Oak.Cmd

data Random = Random Number

foreign import data RANDOM :: Command

foreign import mathRandom :: ∀ c m.
  Fn1
    (Number -> m)
    (Cmd (random :: RANDOM | c) m)

generate :: ∀ c m. 
  (Number -> m)
    -> Cmd (random :: RANDOM | c) m
generate msgCtor = (runFn1 mathRandom) msgCtor