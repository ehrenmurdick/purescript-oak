module Oak.Native.VirtualDOM
  ( nativeText
  , nativeTag
  , nativeCreateElement
  , VirtualDOM
  , NativeDOM
  , NativeOptions
  ) where

type NativeOptions = {}

foreign import data VirtualDOM :: Type
foreign import data NativeDOM :: Type

foreign import nativeText :: String -> VirtualDOM
foreign import nativeTag :: String -> NativeOptions -> Array VirtualDOM -> VirtualDOM
foreign import nativeCreateElement :: VirtualDOM -> NativeDOM
