module Oak.Cmd.Http where

import Prelude (show, ($))

import Control.Monad.Except (runExcept)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON)
import Data.Foreign.Generic.Class (class GenericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Foreign (F, Foreign)
import Data.Either (Either(..))
import Data.Function.Uncurried
  ( Fn4
  , runFn4
  )

import Oak.Cmd

foreign import data HTTP :: Command

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
  Fn4
    (String -> Either String a)
    (a -> Either String a)
    String
    (Either String a -> m)
    (Cmd (http :: HTTP | c) m)


get :: ∀ c m a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
get url msgCtor = (runFn4 getImpl) Left Right url f
  where
    f (Left err) = msgCtor $ Left err
    f (Right str) = msgCtor $ makeDecoder str
