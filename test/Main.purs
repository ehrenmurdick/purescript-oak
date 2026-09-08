module Test.Main where

import Prelude

import Data.Foldable (find, traverse_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Effect.Ref as Ref
import Oak.Route (Mode(..), parseUrl, queryParam)
import Oak.Subscription (onInterval, onTimeout, onWindowDragEnd, onWindowDragEnter, onWindowEvent, sameSub)
import Oak.Subscription as Sub
import Test.BoardApp as Board
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
  check "map rewrites the message" (Sub.message (map Just (onInterval 1000 Tick))) (Just (Just Tick))

  -- a window event that builds its message from the event has no message to
  -- report until one fires, so the runtime reads it through `attach` instead
  check "a payload-carrying sub has no standing message"
    (Sub.message (onWindowDragEnd (\_ -> Tick)))
    Nothing

  -- payload-carrying window events reconcile by name, exactly like the plain
  -- ones: there is one window, and a `DragEvent -> msg` could never be
  -- compared even if the runtime wanted to
  check "same window drag event"
    (sameSub (onWindowDragEnd (\_ -> Tick)) (onWindowDragEnd (\_ -> Poll)))
    true
  check "different window drag events"
    (sameSub (onWindowDragEnd (\_ -> Tick)) (onWindowDragEnter (\_ -> Tick)))
    false
  -- and a drag subscription is not the plain window event of the same name
  check "a drag sub is not a plain window event"
    (sameSub (onWindowDragEnd (\_ -> Tick)) (onWindowEvent "dragend" Tick))
    false

  check "map rewrites a drag sub's message"
    (Sub.message (map Just (onWindowDragEnd (\_ -> Tick))))
    Nothing
  check "map keeps a drag sub's identity"
    (sameSub (map Just (onWindowDragEnd (\_ -> Tick))) (map Just (onWindowDragEnd (\_ -> Poll))))
    true

  log "Test.BoardApp -- where a dropped card lands"
  -- A drag is two messages folded through `update`, which is the whole point
  -- of keeping the drag in the model: none of this needs a browser.
  let
    ids :: String -> Board.Model -> Array Int
    ids colId model = case find (\col -> col.id == colId) model.columns of
      Just col -> map _.id col.cards
      Nothing -> []

    -- pick a card up and drop it on a slot, the way the browser would
    drag :: Int -> Board.Slot -> Board.Model -> Board.Model
    drag cid slot model =
      Board.update (Board.Dropped slot (show cid)) (Board.update (Board.Grabbed cid) model)

  check "the board starts as written" (ids "todo" Board.init) [ 1, 2, 3 ]

  -- reordering inside one column
  check "dropping onto a card lands above it"
    (ids "todo" (drag 3 (Board.Before 1) Board.init))
    [ 3, 1, 2 ]
  check "dropping on the tail sends a card to the end"
    (ids "todo" (drag 1 (Board.EndOf "todo") Board.init))
    [ 2, 3, 1 ]

  -- and the same two messages move a card between columns
  check "a card can leave its column"
    (ids "todo" (drag 1 (Board.EndOf "doing") Board.init))
    [ 2, 3 ]
  check "and arrive in another"
    (ids "doing" (drag 1 (Board.EndOf "doing") Board.init))
    [ 4, 1 ]
  check "arriving above a card in another column"
    (ids "todo" (drag 5 (Board.Before 2) Board.init))
    [ 1, 5, 2, 3 ]
  check "leaves the column it came from"
    (ids "done" (drag 5 (Board.Before 2) Board.init))
    [ 6 ]

  -- a drop that changes nothing must change nothing
  check "dropping a card on itself" (ids "todo" (drag 1 (Board.Before 1) Board.init)) [ 1, 2, 3 ]
  check "dropping the last card on its own tail"
    (ids "todo" (drag 3 (Board.EndOf "todo") Board.init))
    [ 1, 2, 3 ]

  -- dataTransfer is a string that has been out of the type system and back,
  -- so a payload that does not parse falls back to the card being dragged
  check "an unreadable payload falls back to the model"
    (ids "done" (Board.update (Board.Dropped (Board.EndOf "done") "not-an-id")
                   (Board.update (Board.Grabbed 1) Board.init)))
    [ 5, 6, 1 ]
  -- ...and with no drag in flight either, nothing moves
  check "a payload with nothing behind it moves nothing"
    (ids "todo" (Board.update (Board.Dropped (Board.EndOf "done") "not-an-id") Board.init))
    [ 1, 2, 3 ]

  -- A drop moves the card but deliberately leaves the drag running, so that
  -- the window subscriptions are still attached when the same `drop` event
  -- reaches the window. `dragend` is what ends it.
  check "a drop does not end the drag"
    (Board.update (Board.Dropped (Board.EndOf "doing") "1")
       (Board.update (Board.Grabbed 1) Board.init)).dragging
    (Just 1)
  check "a drop does put the drop zones out"
    (Board.update (Board.Dropped (Board.EndOf "doing") "1")
       (Board.update (Board.Grabbed 1) Board.init)).hovering
    Nothing

  -- the drop heard at the window is what ends a successful drag
  check "the window drop ends the drag"
    (Board.update (Board.DroppedAt 10.0 20.0)
       (Board.update (Board.Dropped (Board.EndOf "doing") "1")
          (Board.update (Board.Grabbed 1) Board.init))).dragging
    Nothing

  -- and `dragend` is what clears a drag that ended without a drop at all
  check "DragEnded puts the board back at rest"
    (Board.update Board.DragEnded (Board.update (Board.Grabbed 1) Board.init)).dragging
    Nothing

  failed <- Ref.read failures
  if failed == 0 then
    log "\nall checks passed"
  else
    throw (show failed <> " check(s) failed")
