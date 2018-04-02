module Oak.Cmd where

import Prelude
import Data.Either
import Control.Monad.Except

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Foreign.Class (class Encode, class Decode, encode, decode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON, genericEncodeJSON)
import Data.Foreign.Generic.Class (class GenericDecode)

foreign import kind Command

foreign import data Cmd :: # Command -> Type -> Type

foreign import data HTTP :: Command

foreign import noneImpl :: ∀ c a. Cmd c a


none :: ∀ c a. Cmd c a
none = noneImpl


opts = defaultOptions { unwrapSingleConstructors = true }

makeDecoder :: ∀ a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> Either String a
makeDecoder json =
  case runExcept $ genericDecodeJSON opts json of
    Left err -> Left (show err)
    Right result -> Right result

foreign import getImpl :: ∀ c m a.
  (String -> Either String a)
    -> (a -> Either String a)
    -> String
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m


get :: ∀ c m a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
get url msgCtor = getImpl Left Right url f
  where
    f (Left err) = msgCtor $ Left err
    f (Right str) = msgCtor $ makeDecoder str

