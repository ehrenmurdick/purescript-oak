module Oak.VirtualDom.Native where

import Data.Function.Uncurried (Fn1, Fn2, Fn3, Fn4, runFn1, runFn2, runFn3, runFn4)
import Effect (Effect)
import Oak.Document (Node)
import Oak.Html.Attribute (DragEvent)

foreign import data Tree :: Type

foreign import data NativeAttrs :: Type

foreign import emptyAttrs :: NativeAttrs

foreign import patchImpl :: Fn3 Tree Tree Node (Effect Node)

patch :: Tree -> Tree -> Node -> Effect Node
patch = runFn3 patchImpl

foreign import createRootNodeImpl :: Fn1 Tree Node

createRootNode :: Tree -> Node
createRootNode = runFn1 createRootNodeImpl

foreign import concatSimpleAttrImpl :: Fn3 String String NativeAttrs NativeAttrs

concatSimpleAttr :: String -> String -> NativeAttrs -> NativeAttrs
concatSimpleAttr = runFn3 concatSimpleAttrImpl

foreign import concatBooleanAttrImpl :: Fn3 String Boolean NativeAttrs NativeAttrs

concatBooleanAttr :: String -> Boolean -> NativeAttrs -> NativeAttrs
concatBooleanAttr = runFn3 concatBooleanAttrImpl

foreign import concatForcedBooleanAttrImpl :: Fn3 String Boolean NativeAttrs NativeAttrs

concatForcedBooleanAttr :: String -> Boolean -> NativeAttrs -> NativeAttrs
concatForcedBooleanAttr = runFn3 concatForcedBooleanAttrImpl

foreign import concatForcedStringAttrImpl :: Fn3 String String NativeAttrs NativeAttrs

concatForcedStringAttr :: String -> String -> NativeAttrs -> NativeAttrs
concatForcedStringAttr = runFn3 concatForcedStringAttrImpl

foreign import concatDataAttrImpl :: Fn3 String String NativeAttrs NativeAttrs

concatDataAttr :: String -> String -> NativeAttrs -> NativeAttrs
concatDataAttr = runFn3 concatDataAttrImpl

foreign import concatHandlerFunImpl :: forall eff event. Fn3 String (event -> eff) NativeAttrs NativeAttrs

concatHandlerFun ::
  forall eff event.
  String ->
  (event -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatHandlerFun = runFn3 concatHandlerFunImpl

foreign import concatPreventingHandlerFunImpl :: forall eff event. Fn3 String (event -> eff) NativeAttrs NativeAttrs

concatPreventingHandlerFun ::
  forall eff event.
  String ->
  (event -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatPreventingHandlerFun = runFn3 concatPreventingHandlerFunImpl

foreign import concatEventTargetValueHandlerFunImpl :: forall eff event. Fn3 String (event -> eff) NativeAttrs NativeAttrs

concatEventTargetValueHandlerFun ::
  forall eff event.
  String ->
  (event -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatEventTargetValueHandlerFun = runFn3 concatEventTargetValueHandlerFunImpl

foreign import concatDragHandlerFunImpl :: forall eff. Fn3 String (DragEvent -> eff) NativeAttrs NativeAttrs

concatDragHandlerFun ::
  forall eff.
  String ->
  (DragEvent -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatDragHandlerFun = runFn3 concatDragHandlerFunImpl

foreign import concatPreventingDragHandlerFunImpl :: forall eff. Fn3 String (DragEvent -> eff) NativeAttrs NativeAttrs

concatPreventingDragHandlerFun ::
  forall eff.
  String ->
  (DragEvent -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatPreventingDragHandlerFun = runFn3 concatPreventingDragHandlerFunImpl

foreign import concatDataTransferHandlerFunImpl :: forall eff event. Fn4 String String (event -> eff) NativeAttrs NativeAttrs

concatDataTransferHandlerFun ::
  forall eff event.
  String ->
  String ->
  (event -> eff) ->
  NativeAttrs ->
  NativeAttrs
concatDataTransferHandlerFun = runFn4 concatDataTransferHandlerFunImpl

foreign import concatPreventDefaultImpl :: Fn2 String NativeAttrs NativeAttrs

concatPreventDefault :: String -> NativeAttrs -> NativeAttrs
concatPreventDefault = runFn2 concatPreventDefaultImpl

foreign import textImpl :: Fn1 String (Effect Tree)

text :: String -> Effect Tree
text = runFn1 textImpl

foreign import renderImpl :: Fn3 String NativeAttrs (Effect (Array Tree)) (Effect Tree)

render :: String -> NativeAttrs -> Effect (Array Tree) -> Effect Tree
render = runFn3 renderImpl
