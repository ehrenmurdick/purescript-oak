module Oak.VirtualDom.Native where

import Control.Monad.Eff
import Control.Monad.ST
import Data.Function.Uncurried

foreign import data Tree :: Type
foreign import data Node :: Type
foreign import data NativeAttrs :: Type

foreign import data NODE :: Effect
foreign import data VDOM :: Effect
foreign import data PATCH :: Effect

foreign import emptyAttrs :: NativeAttrs

foreign import patchImpl :: forall e h.
  Fn3 Tree Tree Node (Eff ( st :: ST h | e ) Node)

patch :: forall e h.
  Tree
    -> Tree
    -> Node
    -> Eff ( st :: ST h | e ) Node
patch = runFn3 patchImpl

foreign import createRootNodeImpl :: forall e.
  Fn1 Tree (Eff ( createRootNode :: NODE | e ) Node)

createRootNode :: forall e.
  Tree -> Eff ( createRootNode :: NODE | e ) Node
createRootNode = runFn1 createRootNodeImpl

foreign import concatSimpleAttr :: forall eff event.
  String
    -> String
    -> NativeAttrs
    -> NativeAttrs

foreign import concatHandlerFun :: forall eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs

foreign import concatEventTargetValueHandlerFun :: forall eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs

foreign import textN :: forall e.
  String
    -> Eff e Tree

foreign import renderImpl :: forall msg h e model.
  Fn3
    String
    NativeAttrs
    ( Eff ( st :: ST h | e ) (Array Tree) )
    ( Eff ( st :: ST h | e ) Tree )

render :: forall msg h e model.
  String
    -> NativeAttrs
    -> Eff ( st :: ST h | e ) (Array Tree)
    -> Eff ( st :: ST h | e ) Tree
render = runFn3 renderImpl
