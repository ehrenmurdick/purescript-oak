module Oak.Cmd
  ( kind Command
  , Cmd
  , none
  , batch
  ) where

import Prelude

import Data.Function.Uncurried
  ( Fn2
  , runFn2
  )
import Data.Monoid
import Data.Traversable

foreign import kind Command

foreign import data Cmd :: # Command -> Type -> Type

foreign import noneImpl :: ∀ c a. Cmd c a


none :: ∀ c a. Cmd c a
none = noneImpl

foreign import appendImpl :: ∀ c1 c2 c3 msg.
  Fn2 (Cmd c1 msg) (Cmd c2 msg) (Cmd c3 msg)


instance semigroupCmd :: Semigroup (Cmd c a) where
  append = runFn2 appendImpl


instance monoidCmd :: Monoid (Cmd c a) where
  mempty = none


batch :: ∀ f c a. Foldable f => f (Cmd c a) -> Cmd c a
batch = fold
