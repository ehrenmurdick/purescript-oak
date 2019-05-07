module Oak.Cmd.Random
  ( Random
  , generate
  ) where

import Data.Function.Uncurried
 ( Fn1
 , runFn1
 )

import Oak.Cmd (Cmd)

data Random = Random Number

foreign import mathRandom :: ∀ m.
  Fn1
    (Number -> m)
    (Cmd m)

generate :: ∀ m.
  (Number -> m)
    -> Cmd m
generate msgCtor = (runFn1 mathRandom) msgCtor
