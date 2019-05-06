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

foreign import getElementByIdImpl ::
  Fn1
  String
  (Effect Element)

foreign import appendChildNodeImpl ::
  Element
    -> Node
    -> Effect Unit

appendChildNode ::
  Element
    -> Node
    -> Effect Unit
appendChildNode element rootNode =
  appendChildNodeImpl element rootNode

getElementById ::
  String
    -> Effect Element
getElementById = runFn1 getElementByIdImpl

