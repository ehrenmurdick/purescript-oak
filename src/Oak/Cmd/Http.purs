module Oak.Cmd.Http
  ( HTTP
  , HttpOptions(..)
  , MediaType(..)
  , HttpOption(..)
  , Header(..)
  , defaultEncode
  , defaultDecode
  , get
  , post
  ) where

import Prelude (show, ($), class Show, (<>))

import Control.Monad.Except (runExcept)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON, genericEncode, genericEncodeJSON)
import Data.Foreign.Generic.Class (class GenericEncode, class GenericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Foreign (F, Foreign)
import Data.Traversable (foldr)
import Data.Either (Either(..))
import Data.Function.Uncurried
  ( Fn3
  , runFn3
  , Fn5
  , runFn5
  )

import Oak.Cmd


foreign import data HTTP :: Command
foreign import data NativeOptions :: Type
foreign import emptyOptions :: NativeOptions

-- Currently we only support JSON
-- TODO: support media types other than JSON
data MediaType
  = ApplicationJSON

instance showMediaType :: Show MediaType where
  show ApplicationJSON = "application/json; charset=utf-8"

data Header
  = Accept MediaType
  | ContentType MediaType

data HttpOption body
  = POST body
  | GET body
  | PUT body
  | PATCH body
  | DELETE body
  | Headers (Array Header)
  
type HttpOptions a = Array (HttpOption a)

defaultHeaders :: Array Header
defaultHeaders = [Accept ApplicationJSON]


defaultHeadersWithBody :: Array Header
defaultHeadersWithBody = defaultHeaders <> [ContentType ApplicationJSON]


encodeOptions :: Options
encodeOptions = defaultOptions { unwrapSingleConstructors = true }

defaultEncode ::
  ∀ a rep.
    Generic a rep
      => GenericEncode rep
      => a
      -> Foreign
defaultEncode = genericEncode encodeOptions


-- #genericEncodeJSON calls JSON.stringify, which throws an exception for
-- recursive data structures and returns undefined for functions. We can
-- assume that recursive data structures are impossible given Purescript's
-- immutability constraint. It is still possible to pass a function to
-- #genericeEncodeJSON so we should return a Maybe or Either.
-- TODO: return Maybe or Either instead of undefined.
makeEncoder :: ∀ a t.
  Generic a t
    => GenericEncode t
    => a
    -> String
makeEncoder structured = genericEncodeJSON encodeOptions structured

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

foreign import concatOptionImpl ::
  Fn3 String String NativeOptions NativeOptions

foreign import concatNativeOptionsImpl ::
  Fn3 String NativeOptions NativeOptions NativeOptions

concatHeader ::
    Header
    -> NativeOptions
    -> NativeOptions
concatHeader (ContentType a) options =
    runFn3 concatOptionImpl "Content-Type" (show a) options
concatHeader (Accept a) options =
    runFn3 concatOptionImpl "Accept" (show a) options

combineHeaders ::
  Array Header
    -> NativeOptions
combineHeaders headers =
  foldr concatHeader emptyOptions headers

concatOption :: ∀ body t.
  Generic body t
    => GenericEncode t
    => HttpOption body
    -> NativeOptions
    -> NativeOptions
concatOption (POST body) options =
    runFn3 concatOptionImpl "body" (makeEncoder body) postOptions where
      postOptions = runFn3 concatOptionImpl "method" "POST" options
concatOption (Headers headers) options =
    runFn3 concatNativeOptionsImpl "headers" nativeHeaders options where
      nativeHeaders = combineHeaders headers
concatOption _ options =
    options

combineOptions :: ∀ body t.
  Generic body t
    => GenericEncode t
    => HttpOptions body
    -> NativeOptions
combineOptions options =
  foldr concatOption emptyOptions options

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