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

foreign import data Element :: Type
foreign import data DOM :: Effect
foreign import data Node :: Type
foreign import data NODE :: Effect

foreign import getElementByIdImpl :: Fn1 String (Eff (dom :: DOM) Element)

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

getElementById :: String -> Eff (dom :: DOM) Element
getElementById = runFn1 getElementByIdImpl

