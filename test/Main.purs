module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Effect.Ref as Ref
import Oak.Route (Mode(..), parseUrl, queryParam)
import Test.RouterRoutes (parse, print, samples)

main :: Effect Unit
main = do
  failures <- Ref.new 0

  let
    check :: forall a. Eq a => Show a => String -> a -> a -> Effect Unit
    check name actual expected =
      if actual == expected then
        log ("  ok   " <> name)
      else do
        log ("  FAIL " <> name)
        log ("         expected: " <> show expected)
        log ("         actual:   " <> show actual)
        n <- Ref.read failures
        Ref.write (n + 1) failures

  log "Oak.Route -- Path mode"
  let root = parseUrl Path "/"
  check "root path" root.path "/"
  check "root segments" root.segments []

  let todos = parseUrl Path "/todos/42"
  check "segments" todos.segments [ "todos", "42" ]
  check "path" todos.path "/todos/42"
  check "raw" todos.raw "/todos/42"

  -- a trailing slash must not change what a route matches
  check "trailing slash" (parseUrl Path "/todos/").segments [ "todos" ]
  check "doubled slashes" (parseUrl Path "//todos//42//").segments [ "todos", "42" ]

  let filtered = parseUrl Path "/todos?filter=active&page=2"
  check "query is off the path" filtered.path "/todos"
  check "raw keeps the query" filtered.raw "/todos?filter=active&page=2"
  check "query pairs" filtered.query
    [ { key: "filter", value: "active" }, { key: "page", value: "2" } ]
  check "queryParam hit" (queryParam "filter" filtered) (Just "active")
  check "queryParam miss" (queryParam "nope" filtered) Nothing
  check "plus decodes to space" (queryParam "b" (parseUrl Path "/x?b=hi+there")) (Just "hi there")

  check "fragment" (parseUrl Path "/todos#notes").fragment (Just "notes")
  check "no fragment" todos.fragment Nothing

  -- segments are decoded for matching; path and raw stay encoded for
  -- anything that does its own decoding
  check "segment decoded" (parseUrl Path "/tags/hello%20world").segments [ "tags", "hello world" ]
  check "path stays encoded" (parseUrl Path "/tags/hello%20world").path "/tags/hello%20world"
  -- malformed encoding must not throw
  check "bad encoding survives" (parseUrl Path "/tags/%zz").segments [ "tags", "%zz" ]

  log "Oak.Route -- Hash mode"
  check "no hash is the root" (parseUrl Hash "/index.html").segments []
  check "bare hash is the root" (parseUrl Hash "/index.html#/").segments []
  check "hash segments" (parseUrl Hash "/index.html#/todos/42").segments [ "todos", "42" ]
  check "hash query" (queryParam "tag" (parseUrl Hash "/i.html#/notes?tag=ideas")) (Just "ideas")
  -- a hash route has nowhere to put a second fragment
  check "hash fragment is always Nothing" (parseUrl Hash "/i.html#/todos").fragment Nothing
  check "the document path is ignored" (parseUrl Hash "/deep/page.html#/todos").path "/todos"

  log "Test.RouterRoutes -- parse and print round trip"
  traverse_
    ( \route -> do
        check ("Path: " <> print route) (parse (parseUrl Path (print route))) route
        check ("Hash: " <> print route) (parse (parseUrl Hash ("/i.html#" <> print route))) route
    )
    samples

  log "Test.RouterRoutes -- non-routes"
  check "unknown path" (parse (parseUrl Path "/nope")) (parse (parseUrl Path "/404"))
  check "non-numeric id" (parse (parseUrl Path "/notes/abc")) (parse (parseUrl Path "/404"))

  failed <- Ref.read failures
  if failed == 0 then
    log "\nall checks passed"
  else
    throw (show failed <> " check(s) failed")
