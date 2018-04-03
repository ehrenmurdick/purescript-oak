module Oak.Cmd where

import Prelude (show, ($))
import Data.Either (Either(..))
import Control.Monad.Except (runExcept)

import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON)
import Data.Foreign.Generic.Class (class GenericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Foreign (F, Foreign)

foreign import kind Command

foreign import data Cmd :: # Command -> Type -> Type

foreign import data HTTP :: Command

foreign import noneImpl :: ∀ c a. Cmd c a


none :: ∀ c a. Cmd c a
none = noneImpl


decodeOptions :: Options
decodeOptions = defaultOptions { unwrapSingleConstructors = true }


defaultDecode ::
  ∀ a rep.
    Generic a rep
      => GenericDecode rep
      => Foreign
      -> F a
defaultDecode = genericDecode decodeOptions


makeDecoder :: ∀ a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> Either String a
makeDecoder json =
  case runExcept $ genericDecodeJSON decodeOptions json of
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

