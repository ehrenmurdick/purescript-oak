module Oak.Cmd.Http
  ( HTTP
  , get
  , post
  , put
  , patch
  , delete
  ) where

import Oak.Cmd.Http.Options (HttpOption(Headers, PATCH, PUT, POST, DELETE, GET), HttpOptions, NativeOptions, combineOptions, defaultHeaders, defaultHeadersWithBody)
import Oak.Cmd.Http.Conversion (defaultDecode, defaultEncode, makeDecoder)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic.Class (class GenericEncode, class GenericDecode)
import Prelude (($))
import Data.Function.Uncurried
  ( Fn5
  , runFn5
  )

import Oak.Cmd

foreign import data HTTP :: Command

get :: ∀ c m a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
get url msgCtor = fetch url [GET EmptyBody, Headers defaultHeaders] msgCtor

delete :: ∀ c m a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
delete url msgCtor = fetch url [DELETE EmptyBody, Headers defaultHeaders] msgCtor

post :: ∀ c m a t body e.
  Generic a t
    => GenericDecode t
    => Decode a
    => Generic body e
    => GenericEncode e
    => String
    -> body
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
post url body msgCtor = fetch url [POST body, Headers defaultHeadersWithBody] msgCtor

put :: ∀ c m a t body e.
  Generic a t
    => GenericDecode t
    => Decode a
    => Generic body e
    => GenericEncode e
    => String
    -> body
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
put url body msgCtor = fetch url [PUT body, Headers defaultHeadersWithBody] msgCtor

patch :: ∀ c m a t body e.
  Generic a t
    => GenericDecode t
    => Decode a
    => Generic body e
    => GenericEncode e
    => String
    -> body
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
patch url body msgCtor = fetch url [PATCH body, Headers defaultHeadersWithBody] msgCtor

fetch :: ∀ c m a t body e.
  Generic a t
    => GenericDecode t
    => Decode a
    => Generic body e
    => GenericEncode e
    => String
    -> HttpOptions body
    -> (Either String a -> m)
    -> Cmd (http :: HTTP | c) m
fetch url options msgCtor = (runFn5 fetchImpl) Left Right url (combineOptions options) f
  where
    f (Left err) = msgCtor $ Left err
    f (Right str) = msgCtor $ makeDecoder str

foreign import fetchImpl :: ∀ c m a.
  Fn5
    (String -> Either String a)
    (a -> Either String a)
    String
    NativeOptions
    (Either String a -> m)
    (Cmd (http :: HTTP | c) m)

data EmptyBody = EmptyBody

derive instance genericEmptyBody :: Generic EmptyBody _

instance decodeEmptyBody :: Decode EmptyBody where
  decode = defaultDecode

instance encodeEmptyBody :: Encode EmptyBody where
  encode = defaultEncode