module Oak.Document where


import Prelude (Unit)
import Control.Monad.Eff
  ( Eff
  , kind Effect
  )
import Data.Function.Uncurried
  ( Fn1
  , runFn1
  )
import Control.Monad.Eff.Exception (EXCEPTION)

foreign import data Element :: Type
foreign import data DOM :: Effect
foreign import data Node :: Type
foreign import data NODE :: Effect

foreign import getElementByIdImpl :: ∀ e.
  Fn1
  String
  (Eff (exception :: EXCEPTION, dom :: DOM | e) Element)

foreign import appendChildNodeImpl :: ∀ e.
  Element
    -> Node
    -> Eff (dom :: DOM | e) Unit

appendChildNode :: ∀ e.
  Element
    -> Node
    -> Eff (dom :: DOM | e) Unit
appendChildNode element rootNode =
  appendChildNodeImpl element rootNode

getElementById :: ∀ e.
  String
    -> Eff (exception :: EXCEPTION, dom :: DOM | e) Element
getElementById = runFn1 getElementByIdImpl

