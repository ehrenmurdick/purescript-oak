-- | URL parsing for routed apps.
-- |
-- | This module is the pure half of Oak's routing: it turns the browser's
-- | location into a `Url` record that an app can match on. It does not touch
-- | the browser itself -- `Oak.Navigation` does that, and the runtime wires
-- | the two together when you build an app with `createRoutedApp`.
-- |
-- | An app never calls `parseUrl` directly. It receives an already-parsed
-- | `Url` through the `onNavigate` function it hands to `createRoutedApp`:
-- |
-- | ```purescript
-- | data Route = Home | Todos | Todo Int | NotFound
-- |
-- | parse :: Url -> Route
-- | parse url = case url.segments of
-- |   []           -> Home
-- |   ["todos"]    -> Todos
-- |   ["todos", n] -> maybe NotFound Todo (Int.fromString n)
-- |   _            -> NotFound
-- | ```
-- |
-- | Oak deliberately ships no route matcher of its own. Pattern matching on
-- | `segments` covers most apps; anything bigger can hand `url.raw` to a
-- | combinator library without Oak knowing about it.
module Oak.Route
  ( Mode(..)
  , QueryParam
  , Url
  , modeTag
  , parseUrl
  , queryParam
  ) where

import Data.Array (filter, find)
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (Pattern(..))
import Data.String as String
import Prelude (class Eq, map, (#), (/=), (<>), (==))

foreign import decodeComponent :: String -> String

-- | Which part of the URL carries the route.
-- |
-- | `Hash` keeps the route in the fragment (`/index.html#/todos/42`). It
-- | needs no server configuration and works from a `file://` URL, which is
-- | why it is the right default for a demo or a static host.
-- |
-- | `Path` uses real paths (`/todos/42`) via the History API. Deep links
-- | need the server to serve the app for every path, and `pushState` is
-- | forbidden on `file://` origins.
data Mode
  = Hash
  | Path

derive instance eqMode :: Eq Mode

-- | One decoded `key=value` pair from the query string.
type QueryParam
  = { key :: String, value :: String }

-- | A location broken into the pieces a route matcher wants.
-- |
-- | `segments` is empty for `/` and never contains empty strings, so a
-- | trailing slash never changes what a route matches. Its contents are
-- | percent-decoded, which is what you want for matching.
-- |
-- | `path` and `raw` are left encoded, because they exist to be handed to
-- | something that does its own decoding. `path` is the normalised path on
-- | its own; `raw` appends the query string, and is what a combinator
-- | library such as `routing-duplex` expects to be given.
type Url
  = { path :: String
    , segments :: Array String
    , query :: Array QueryParam
    , fragment :: Maybe String
    , raw :: String
    }

-- | Break a string at the first occurrence of a separator, dropping it.
breakOn :: String -> String -> { before :: String, after :: Maybe String }
breakOn sep s = case String.indexOf (Pattern sep) s of
  Nothing -> { before: s, after: Nothing }
  Just i ->
    let
      parts = String.splitAt i s
    in
      { before: parts.before
      , after: Just (String.drop (String.length sep) parts.after)
      }

-- | Parse a location-relative string -- `pathname + search + hash`, which is
-- | exactly what `Oak.Navigation.currentUrl` hands back.
-- |
-- | In `Path` mode the route is the path and query, and anything after `#`
-- | becomes `fragment`. In `Hash` mode the route is everything after the
-- | first `#`, parsed as a small URL of its own; a hash-mode route has
-- | nowhere to put a second fragment, so `fragment` is always `Nothing`.
parseUrl :: Mode -> String -> Url
parseUrl mode input =
  let
    afterHash = breakOn "#" input

    -- the part of the input that actually describes the route
    routePart = case mode of
      Path -> afterHash.before
      Hash -> fromMaybe "" afterHash.after

    fragment = case mode of
      Path -> afterHash.after
      Hash -> Nothing

    split_ = breakOn "?" routePart

    rawSegments = filter (_ /= "") (String.split (Pattern "/") split_.before)

    queryString = fromMaybe "" split_.after

    path = "/" <> intercalate "/" rawSegments
  in
    { path: path
    , segments: map decodeComponent rawSegments
    , query: parseQuery queryString
    , fragment: fragment
    , raw: if queryString == "" then path else path <> "?" <> queryString
    }

parseQuery :: String -> Array QueryParam
parseQuery s =
  String.split (Pattern "&") s
    # filter (_ /= "")
    # map toParam
  where
  toParam pair =
    let
      parts = breakOn "=" pair
    in
      { key: decodeValue parts.before
      , value: decodeValue (fromMaybe "" parts.after)
      }

  -- query strings encode a space as "+" as well as "%20"
  decodeValue v = decodeComponent (String.replaceAll (Pattern "+") (String.Replacement " ") v)

-- | Look up a query parameter by name.
-- |
-- | ```purescript
-- | queryParam "filter" url  -- Just "active", for "/todos?filter=active"
-- | ```
queryParam :: String -> Url -> Maybe String
queryParam k url = map _.value (find (\p -> p.key == k) url.query)

-- runtime internals
--------------------

-- | How `Oak.Navigation`'s FFI names a mode.
modeTag :: Mode -> String
modeTag Hash = "hash"
modeTag Path = "path"
