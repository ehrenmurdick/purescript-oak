module Oak.VirtualDom.Native where

import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.ST (ST)
import Data.Function.Uncurried
  ( Fn1
  , Fn3
  , runFn1
  , runFn3
  )

import Oak.Document
  ( DOM
  , Node
  )

foreign import data Tree :: Type
foreign import data NativeAttrs :: Type

foreign import emptyAttrs :: NativeAttrs

foreign import patchImpl :: ∀ e.
  Fn3 Tree Tree Node (Eff ( dom :: DOM | e ) Node)

patch :: ∀ e.
  Tree
    -> Tree
    -> Node
    -> Eff ( dom :: DOM | e ) Node
patch = runFn3 patchImpl

foreign import createRootNodeImpl ::
  Fn1 Tree Node

createRootNode ::
  Tree -> Node
createRootNode = runFn1 createRootNodeImpl

foreign import concatSimpleAttrImpl ::
  Fn3 String String NativeAttrs NativeAttrs

concatSimpleAttr ::
  String
    -> String
    -> NativeAttrs
    -> NativeAttrs
concatSimpleAttr = runFn3 concatSimpleAttrImpl

foreign import concatHandlerFunImpl :: ∀ eff event.
  Fn3 String (event -> eff) NativeAttrs NativeAttrs

concatHandlerFun :: ∀ eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs
concatHandlerFun = runFn3 concatHandlerFunImpl

foreign import concatEventTargetValueHandlerFunImpl :: ∀ eff event.
  Fn3 String (event -> eff) NativeAttrs NativeAttrs

concatEventTargetValueHandlerFun :: ∀ eff event.
  String
    -> (event -> eff)
    -> NativeAttrs
    -> NativeAttrs
concatEventTargetValueHandlerFun = runFn3 concatEventTargetValueHandlerFunImpl

foreign import textImpl :: ∀ e.
  Fn1 String (Eff e Tree)

text :: ∀ e.
  String
    -> Eff e Tree
text = runFn1 textImpl

foreign import renderImpl :: ∀ h e.
  Fn3
    String
    NativeAttrs
    ( Eff ( st :: ST h | e ) (Array Tree) )
    ( Eff ( st :: ST h | e ) Tree )

render :: ∀ h e.
  String
    -> NativeAttrs
    -> Eff ( st :: ST h | e ) (Array Tree)
    -> Eff ( st :: ST h | e ) Tree
render = runFn3 renderImpl
