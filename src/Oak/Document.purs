module Oak.Document (Element, Node, onDocumentReady, appendChildNode, getElementById) where

import Data.Function.Uncurried (Fn1, runFn1)
import Effect (Effect)
import Prelude (Unit)

foreign import data Element :: Type

foreign import data Node :: Type

foreign import getElementByIdImpl :: Fn1 String (Effect Element)

foreign import onDocumentReadyImpl :: Fn1 (Effect Unit) (Effect Unit)

foreign import appendChildNodeImpl :: Element -> (Array Node) -> Effect Unit

appendChildNode :: Element -> Array Node -> Effect Unit
appendChildNode element rootNode = appendChildNodeImpl element rootNode

getElementById :: String -> Effect Element
getElementById = runFn1 getElementByIdImpl

onDocumentReady :: Effect Unit -> Effect Unit
onDocumentReady = runFn1 onDocumentReadyImpl
