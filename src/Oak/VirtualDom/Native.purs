module Oak.VirtualDom.Native where

import Effect (Effect)
import Control.Monad.ST (ST)
import Data.Function.Uncurried
  ( Fn1
  , Fn3
  , runFn1
  , runFn3
  )

import Oak.Document
  ( Node
  )

foreign import data Tree :: Type
foreign import data NativeAttrs :: Type

foreign import emptyAttrs :: NativeAttrs

foreign import patchImpl :: ∀ e.
  Fn3 Tree Tree Node (Effect Node)

patch :: ∀ e.
  Tree
    -> Tree
    -> Node
    -> Effect Node
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

foreign import concatBooleanAttrImpl ::
  Fn3 String Boolean NativeAttrs NativeAttrs

concatBooleanAttr ::
  String
    -> Boolean
    -> NativeAttrs
    -> NativeAttrs
concatBooleanAttr = runFn3 concatBooleanAttrImpl


foreign import concatDataAttrImpl ::
  Fn3 String String NativeAttrs NativeAttrs

concatDataAttr ::
  String
    -> String
    -> NativeAttrs
    -> NativeAttrs
concatDataAttr = runFn3 concatDataAttrImpl

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
  Fn1 String (Effect Tree)

text :: ∀ e.
  String
    -> Effect Tree
text = runFn1 textImpl

foreign import renderImpl :: ∀ h e.
  Fn3
    String
    NativeAttrs
    ( Effect (Array Tree) )
    ( Effect Tree )

render :: ∀ h e.
  String
    -> NativeAttrs
    -> Effect (Array Tree)
    -> Effect Tree
render = runFn3 renderImpl
