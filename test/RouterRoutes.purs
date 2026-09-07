-- | The route table for the example app, kept in its own module so the tests
-- | can reach it without pulling in a DOM.
-- |
-- | This is the zero-dependency shape Oak documents: a plain sum type, a
-- | `parse` that matches on segments, and a `print` that is the single place
-- | deciding what lands in someone's URL bar. The two are written
-- | independently, so `Test.Main` round-trips them.
module Test.RouterRoutes
  ( Route(..)
  , parse
  , print
  , samples
  ) where

import Prelude

import Data.Int as Int
import Data.Maybe (Maybe(..), maybe)
import Oak.Route (Url, queryParam)

data Route
  = Home
  | NoteList (Maybe String)
  | NoteDetail Int
  | TagView String
  | Settings
  | NotFound

derive instance eqRoute :: Eq Route

instance showRoute :: Show Route where
  show Home = "Home"
  show (NoteList t) = "NoteList " <> show t
  show (NoteDetail n) = "NoteDetail " <> show n
  show (TagView t) = "TagView " <> show t
  show Settings = "Settings"
  show NotFound = "NotFound"

parse :: Url -> Route
parse url = case url.segments of
  [] -> Home
  [ "notes" ] -> NoteList (queryParam "tag" url)
  [ "notes", n ] -> maybe NotFound NoteDetail (Int.fromString n)
  [ "tags", t ] -> TagView t
  [ "settings" ] -> Settings
  _ -> NotFound

print :: Route -> String
print = case _ of
  Home -> "/"
  NoteList Nothing -> "/notes"
  NoteList (Just t) -> "/notes?tag=" <> t
  NoteDetail n -> "/notes/" <> show n
  TagView t -> "/tags/" <> t
  Settings -> "/settings"
  NotFound -> "/404"

-- | Every shape of route, for the round-trip test.
samples :: Array Route
samples =
  [ Home
  , NoteList Nothing
  , NoteList (Just "ideas")
  , NoteDetail 42
  , TagView "ideas"
  , Settings
  ]
