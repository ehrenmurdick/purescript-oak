module Oak.VirtualDom.Native where

import Control.Monad.Eff
import Control.Monad.ST

foreign import data Tree :: Type
foreign import data Node :: Type
foreign import data NativeAttrs :: Type

foreign import data NODE :: Effect
foreign import data VDOM :: Effect
foreign import data PATCH :: Effect

foreign import emptyAttrsN :: NativeAttrs

foreign import patchN :: forall e h.
  Tree
    -> Tree
    -> Node
    -> Eff ( st :: ST h | e ) Node

foreign import createRootNode :: forall e.
  Tree
    -> Eff ( createRootNode :: NODE | e ) Node

foreign import concatHandlerFun :: forall eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs

foreign import textN :: forall e.
  String
    -> Eff e Tree

foreign import renderN :: forall msg h e model.
  String
    -> NativeAttrs
    -> Eff ( st :: ST h | e ) (Array Tree)
    -> Eff ( st :: ST h | e ) Tree
