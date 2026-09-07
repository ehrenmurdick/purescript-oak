module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Effect.Ref as Ref
import Oak.Route (Mode(..), parseUrl, queryParam)
import Oak.Subscription (onInterval, onTimeout, onWindowEvent, sameSub)
import Oak.Subscription as Sub
import Test.RouterRoutes (parse, print, samples)

-- | A stand-in message type for the subscription checks below. Timer
-- | subscriptions are told apart by their messages, so they need the `Eq`.
data TimerMsg
  = Tick
  | Poll

derive instance eqTimerMsg :: Eq TimerMsg

instance showTimerMsg :: Show TimerMsg where
  show Tick = "Tick"
  show Poll = "Poll"

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

  log "Oak.Subscription -- what counts as the same subscription"
  -- window events are identified by name alone: there is one window, so one
  -- `resize` event, and two subscriptions to it share a single listener
  check "same window event" (sameSub (onWindowEvent "resize" Tick) (onWindowEvent "resize" Poll)) true
  check "different window events" (sameSub (onWindowEvent "resize" Tick) (onWindowEvent "online" Tick)) false

  -- timers are identified by duration *and* message, so an app can run two
  -- of them on the same period without one swallowing the other
  check "timer: same period and message" (sameSub (onInterval 1000 Tick) (onInterval 1000 Tick)) true
  check "timer: same period, other message" (sameSub (onInterval 1000 Tick) (onInterval 1000 Poll)) false
  check "timer: other period, same message" (sameSub (onInterval 1000 Tick) (onInterval 500 Tick)) false
  check "timeout: same duration and message" (sameSub (onTimeout 2500 Tick) (onTimeout 2500 Tick)) true
  check "timeout: same duration, other message" (sameSub (onTimeout 2500 Tick) (onTimeout 2500 Poll)) false

  -- and the three kinds never collide with each other
  check "an interval is not a timeout" (sameSub (onInterval 1000 Tick) (onTimeout 1000 Tick)) false
  check "a timer is not a window event" (sameSub (onInterval 1000 Tick) (onWindowEvent "resize" Tick)) false

  -- `map` rewrites the message a subscription sends without changing which
  -- subscription it is, so a mapped timer is still retained across updates
  check "map keeps a timer's identity"
    (sameSub (map Just (onInterval 1000 Tick)) (map Just (onInterval 1000 Tick)))
    true
  check "map keeps two timers apart"
    (sameSub (map Just (onInterval 1000 Tick)) (map Just (onInterval 1000 Poll)))
    false
  check "map rewrites the message" (Sub.message (map Just (onInterval 1000 Tick))) (Just Tick)

  failed <- Ref.read failures
  if failed == 0 then
    log "\nall checks passed"
  else
    throw (show failed <> " check(s) failed")
