module Oak.Document
  ( Node
  , Element
  , appendChildNode
  , getElementById
  ) where


import Prelude (Unit)
import Effect (Effect)
import Data.Function.Uncurried
  ( Fn1
  , runFn1
  )

foreign import data Element :: Type
foreign import data Node :: Type

foreign import getElementByIdImpl :: ∀ e.
  Fn1
  String
  (Effect Element)

foreign import appendChildNodeImpl :: ∀ e.
  Element
    -> Node
    -> Effect Unit

appendChildNode :: ∀ e.
  Element
    -> Node
    -> Effect Unit
appendChildNode element rootNode =
  appendChildNodeImpl element rootNode

getElementById :: ∀ e.
  String
    -> Effect Element
getElementById = runFn1 getElementByIdImpl

