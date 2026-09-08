-- | Subscriptions let an app listen to events that come from outside the
-- | view -- the browser's connectivity events and its timers, for now.
-- |
-- | An app's `subscriptions` function is re-run after every update, and the
-- | runtime reconciles the result against what is currently attached: new
-- | subscriptions are started, ones that disappeared are stopped, and ones
-- | that are still wanted keep the listener they already had.
-- |
-- | ```purescript
-- | subscriptions :: Model -> Array (Subscription Msg)
-- | subscriptions model =
-- |   if model.watchingConnection
-- |     then [ onOnline WentOnline, onOffline WentOffline ]
-- |     else []
-- | ```
-- |
-- | Note that `Oak.Html.Events` also exports `onOnline` and `onOffline` (the
-- | element attributes of the same name), so this module is deliberately not
-- | re-exported from `Oak`. Import it qualified, or by name:
-- |
-- | ```purescript
-- | import Oak.Subscription (Subscription, onInterval, onOffline, onOnline)
-- | ```
-- |
-- | Reconciling requires comparing messages -- two timers of the same period
-- | are only the same timer if they also send the same message -- so a
-- | message type needs an `Eq` instance to be run by `Oak.runApp`. A
-- | `derive instance eqMsg :: Eq Msg` is normally all it takes.
module Oak.Subscription
  ( Subscription
  , attach
  , message
  , onInterval
  , onOffline
  , onOnline
  , onTimeout
  , onWindowDragEnd
  , onWindowDragEnter
  , onWindowDragEvent
  , onWindowDragLeave
  , onWindowDragOver
  , onWindowDrop
  , onWindowEvent
  , sameSub
  ) where

import Data.Foldable (traverse_)
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Functor (class Functor)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Oak.Html.Attribute (DragEvent)
import Prelude (class Eq, Unit, bind, discard, map, pure, unit, (&&), (==), (>>=))

foreign import addWindowListenerImpl :: Fn2 String (Effect Unit) (Effect (Effect Unit))

foreign import addWindowDragListenerImpl :: Fn2 String (DragEvent -> Effect Unit) (Effect (Effect Unit))

-- | The handle the browser hands back for a running timer. Opaque because
-- | `setInterval` returns a number in the browser and an object under Node,
-- | and nothing outside this module needs to look at it.
foreign import data TimerId :: Type

foreign import setIntervalImpl :: Fn2 Int (Effect Unit) (Effect TimerId)

foreign import clearIntervalImpl :: TimerId -> Effect Unit

foreign import setTimeoutImpl :: Fn2 Int (Effect Unit) (Effect TimerId)

foreign import clearTimeoutImpl :: TimerId -> Effect Unit

-- | A description of something to listen to, and the message to send when it
-- | fires. Build these with `onOnline`, `onOffline`, `onWindowEvent`,
-- | `onInterval` or `onTimeout`.
data Subscription msg
  = WindowEvent String msg
  | WindowDragEvent String (DragEvent -> msg)
  | Interval Int msg
  | Timeout Int msg

instance subscriptionFunctor :: Functor Subscription where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Subscription msg1 -> Subscription msg2
  map f (WindowEvent name msg) = WindowEvent name (f msg)
  map f (WindowDragEvent name g) = WindowDragEvent name (map f g)
  map f (Interval ms msg) = Interval ms (f msg)
  map f (Timeout ms msg) = Timeout ms (f msg)

-- | Listen for an event on `window` by name.
-- |
-- | This is the escape hatch the typed helpers are built from -- use it for
-- | any window event Oak doesn't wrap yet, e.g.
-- | `onWindowEvent "resize" WindowResized`.
onWindowEvent :: ∀ msg. String -> msg -> Subscription msg
onWindowEvent name msg = WindowEvent name msg

-- | Send a message when the browser regains its network connection.
onOnline :: ∀ msg. msg -> Subscription msg
onOnline msg = onWindowEvent "online" msg

-- | Send a message when the browser loses its network connection.
onOffline :: ∀ msg. msg -> Subscription msg
onOffline msg = onWindowEvent "offline" msg

-- | Send a message every `ms` milliseconds, for as long as the subscription
-- | keeps being returned.
-- |
-- | ```purescript
-- | subscriptions model =
-- |   if model.running then [ onInterval 1000 Tick ] else []
-- | ```
-- |
-- | The timer starts the first update the subscription appears on, keeps
-- | ticking untouched while it stays in the list -- returning it again does
-- | not restart the countdown -- and is cleared on the first update it is
-- | missing from.
-- |
-- | A timer is identified by its period *and* its message, so
-- | `[ onInterval 1000 Tick, onInterval 1000 Poll ]` runs two independent
-- | timers, while changing either the period or the message stops the old
-- | timer and starts a new one.
onInterval :: ∀ msg. Int -> msg -> Subscription msg
onInterval ms msg = Interval ms msg

-- | Send a message once, `ms` milliseconds after the subscription first
-- | appears.
-- |
-- | ```purescript
-- | subscriptions model =
-- |   if model.flash then [ onTimeout 3000 HideFlash ] else []
-- | ```
-- |
-- | Dropping the subscription before it fires cancels the timer. After it has
-- | fired it stays attached but spent, so leaving it in the list does not
-- | re-arm it -- take it out of the list (typically in the `update` that
-- | handles its own message) and put it back to run it again.
-- |
-- | Like intervals, timeouts are told apart by duration and message together,
-- | so two timeouts that send different messages run on their own clocks even
-- | at the same duration.
onTimeout :: ∀ msg. Int -> msg -> Subscription msg
onTimeout ms msg = Timeout ms msg

-- drag events on the window
----------------------------
--
-- A drag is reported to the elements it passes over, which is enough for
-- most apps -- see `Oak.Html.Events`. These are for the parts of a drag no
-- element sees: a file dragged in from the desktop, which arrives with no
-- `dragstart` of its own, and a drag that ends outside every drop target,
-- which is the usual way for a highlighted UI to get stuck.

-- | Listen for a drag event on `window` by name, with the event's payload.
-- |
-- | The escape hatch the five below are built from. Note that a window
-- | listener does not cancel anything, so subscribing to `"dragover"` here
-- | does *not* make the page accept drops -- that is `allowDrop` on an
-- | element -- and dropping a file on a page that never cancels still
-- | navigates the browser away from it.
onWindowDragEvent :: ∀ msg. String -> (DragEvent -> msg) -> Subscription msg
onWindowDragEvent name f = WindowDragEvent name f

-- | A drag entered the page, or moved into another element on it. Fires
-- | often, and for drags the app started as well as ones from outside it.
onWindowDragEnter :: ∀ msg. (DragEvent -> msg) -> Subscription msg
onWindowDragEnter f = onWindowDragEvent "dragenter" f

-- | A drag is moving over the page. This fires on every frame of every drag
-- | anywhere in the document, and each message is a full render and diff --
-- | subscribe to it only while a drag is actually in flight, and prefer the
-- | others.
onWindowDragOver :: ∀ msg. (DragEvent -> msg) -> Subscription msg
onWindowDragOver f = onWindowDragEvent "dragover" f

-- | A drag left an element, which includes leaving the window entirely.
onWindowDragLeave :: ∀ msg. (DragEvent -> msg) -> Subscription msg
onWindowDragLeave f = onWindowDragEvent "dragleave" f

-- | Something was dropped somewhere on the page. Only fires where the drop
-- | was allowed -- see `Oak.Html.Events.allowDrop`.
-- |
-- | This arrives after the dropped-on element's own `onDrop'` has run and
-- | the view has been re-rendered, because Oak dispatches and repaints
-- | synchronously inside the DOM handler and the event carries on bubbling
-- | afterwards. That makes it the safe place to end a drag: a `subscriptions`
-- | that stops asking for these in response to the *element's* drop tears
-- | the listener down while that same event is still on its way up, and this
-- | never fires at all.
onWindowDrop :: ∀ msg. (DragEvent -> msg) -> Subscription msg
onWindowDrop f = onWindowDragEvent "drop" f

-- | A drag has finished, however it finished.
-- |
-- | `dragend` fires on the element the drag started from and bubbles to the
-- | window, whether the drag was dropped, refused, or cancelled with Escape
-- | -- including when it ends outside the window, where no element hears
-- | anything at all. An app that dims a card or lights a drop zone while
-- | dragging wants this to put it back, or the highlight outlives the drag.
-- |
-- | It is not quite a guarantee, and the gap is worth knowing about. The
-- | event fires on the source element, and a drop that moves that element to
-- | a new parent in the view is a node virtual-dom rebuilds rather than
-- | moves. `dragend` then fires on a node that is no longer in the document,
-- | and an event on a detached node has nothing to bubble through, so this
-- | never hears it. For a drag that ends in a drop, `onWindowDrop` is the
-- | reliable half; this one covers the drags that end without one.
-- |
-- | ```purescript
-- | subscriptions model = case model.dragging of
-- |   Just _ -> [ onWindowDragEnd (\_ -> DragEnded) ]
-- |   Nothing -> []
-- | ```
onWindowDragEnd :: ∀ msg. (DragEvent -> msg) -> Subscription msg
onWindowDragEnd f = onWindowDragEvent "dragend" f


-- runtime internals
--------------------

-- | Do these two subscriptions describe the same thing to listen to? This is
-- | what the runtime reconciles on, so two subscriptions that answer `true`
-- | here share a single listener.
-- |
-- | A window event is identified by its name alone: there is only one
-- | `window`, so one `online` event, and the message is free to change from
-- | one update to the next without the listener being touched. That is what
-- | lets a window event carry a payload at all -- a `DragEvent -> msg` could
-- | never be compared, and never has to be. A timer is
-- | identified by its duration *and* its message, because two timers on the
-- | same period that send different messages really are two timers.
sameSub :: ∀ msg. Eq msg => Subscription msg -> Subscription msg -> Boolean
sameSub (WindowEvent name1 _) (WindowEvent name2 _) = name1 == name2
sameSub (WindowDragEvent name1 _) (WindowDragEvent name2 _) = name1 == name2
sameSub (Interval ms1 msg1) (Interval ms2 msg2) = ms1 == ms2 && msg1 == msg2
sameSub (Timeout ms1 msg1) (Timeout ms2 msg2) = ms1 == ms2 && msg1 == msg2
sameSub _ _ = false

-- | The message this subscription sends when it fires, for the ones whose
-- | message does not depend on the event.
-- |
-- | `Nothing` for a subscription that builds its message from a payload --
-- | there is no event here to build it from. The runtime does not go through
-- | this; `attach` dispatches for itself, because it is the only place that
-- | has both the subscription and the event.
message :: ∀ msg. Subscription msg -> Maybe msg
message (WindowEvent _ msg) = Just msg
message (WindowDragEvent _ _) = Nothing
message (Interval _ msg) = Just msg
message (Timeout _ msg) = Just msg

-- | Start listening, dispatching this subscription's message every time the
-- | event fires. Returns the effect that stops listening again.
-- |
-- | The subscription arrives in a `Ref` rather than by value because a
-- | listener outlives the update that started it: the app's `subscriptions`
-- | runs again after every message and may hand back the same subscription
-- | carrying a different message, and the runtime refreshes it in place
-- | rather than detaching and reattaching. So the message to send is read at
-- | the moment the event fires, not at the moment the listener goes up.
-- |
-- | Which subscription is in the `Ref` never changes -- `sameSub` is what
-- | decides a refresh is legal, and it can only answer `true` for two of the
-- | same shape. The mismatched cases below are unreachable, and dispatch
-- | nothing rather than inventing a message.
attach :: ∀ msg. Ref (Subscription msg) -> (msg -> Effect Unit) -> Effect (Effect Unit)
attach ref dispatch = do
  sub <- Ref.read ref
  attachSub sub ref dispatch

attachSub :: ∀ msg. Subscription msg -> Ref (Subscription msg) -> (msg -> Effect Unit) -> Effect (Effect Unit)
attachSub (WindowDragEvent name _) ref dispatch =
  runFn2 addWindowDragListenerImpl name \event ->
    fire ref dispatch case _ of
      WindowDragEvent _ f -> Just (f event)
      _ -> Nothing
attachSub (WindowEvent name _) ref dispatch =
  runFn2 addWindowListenerImpl name (fire ref dispatch message)
attachSub sub ref dispatch = attachTimer sub (fire ref dispatch message)

-- | Read the freshest version of a subscription and dispatch what it says to.
fire :: ∀ msg. Ref (Subscription msg) -> (msg -> Effect Unit) -> (Subscription msg -> Maybe msg) -> Effect Unit
fire ref dispatch toMsg = do
  sub <- Ref.read ref
  traverse_ dispatch (toMsg sub)

attachTimer :: ∀ msg. Subscription msg -> Effect Unit -> Effect (Effect Unit)
attachTimer (Interval ms _) action = do
  idRef <- Ref.new Nothing
  timerId <- runFn2 setIntervalImpl ms action
  Ref.write (Just timerId) idRef
  pure (clearWith clearIntervalImpl idRef)
attachTimer (Timeout ms _) action = do
  idRef <- Ref.new Nothing
  -- The id is forgotten as the timeout fires: a one-shot handle is dead once
  -- it has run, and the browser is free to hand the same number out to a
  -- later timer, which unsubscribing would then cancel by mistake. The
  -- callback cannot run before the `write` below, since it is queued and JS
  -- finishes this effect first.
  timerId <- runFn2 setTimeoutImpl ms (Ref.write Nothing idRef >>= \_ -> action)
  Ref.write (Just timerId) idRef
  pure (clearWith clearTimeoutImpl idRef)
-- the window events are attached by `attachSub` before this is reached
attachTimer _ _ = pure (pure unit)

-- | Stop a timer, if it is still running, and forget its id so that a second
-- | unsubscribe is a no-op.
clearWith :: (TimerId -> Effect Unit) -> Ref (Maybe TimerId) -> Effect Unit
clearWith clear idRef = do
  running <- Ref.read idRef
  Ref.write Nothing idRef
  traverse_ clear running
