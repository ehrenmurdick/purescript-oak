module Oak.Cmd.Http.Conversion
  ( defaultEncode
  , defaultDecode
  , makeEncoder
  , makeDecoder
  ) where

import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON, genericEncode, genericEncodeJSON)
import Data.Either (Either(..))
import Data.Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON, genericEncode, genericEncodeJSON)
import Data.Foreign.Generic.Class (class GenericEncode, class GenericDecode)
import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode, class Encode)
import Prelude (show, ($), class Show)
import Control.Monad.Except (runExcept)
import Data.Foreign (Foreign, F)
import Data.Foreign.Generic.Types (Options)

codingOptions :: Options
codingOptions = defaultOptions { unwrapSingleConstructors = true }

defaultEncode ::
  ∀ a rep.
    Generic a rep
      => GenericEncode rep
      => a
      -> Foreign
defaultEncode = genericEncode codingOptions


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
makeEncoder structured = genericEncodeJSON codingOptions structured

defaultDecode ::
  ∀ a rep.
    Generic a rep
      => GenericDecode rep
      => Foreign
      -> F a
defaultDecode = genericDecode codingOptions

makeDecoder :: ∀ a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> Either String a
makeDecoder json =
  case runExcept $ genericDecodeJSON codingOptions json of
    Left err -> Left (show err)
    Right result -> Right result