module Oak.Cmd.Http.Options
  ( HttpOptions(..)
  , MediaType(..)
  , HttpOption(..)
  , Header(..)
  , NativeOptions
  , combineOptions
  , defaultHeaders
  , defaultHeadersWithBody
  ) where

import Oak.Cmd.Http.Conversion (makeEncoder)
import Data.Foreign.Generic.Class (class GenericEncode)
import Data.Generic.Rep (class Generic)
import Data.Traversable (foldr)
import Prelude (show, class Show, (<>))
import Data.Function.Uncurried
  ( Fn3
  , runFn3
  )

foreign import data NativeOptions :: Type
foreign import emptyOptions :: NativeOptions

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
