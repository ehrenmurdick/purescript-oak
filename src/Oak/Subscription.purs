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
import Prelude (class Eq, Unit, bind, discard, pure, (&&), (==), (>>=))

foreign import addWindowListenerImpl :: Fn2 String (Effect Unit) (Effect (Effect Unit))

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
  | Interval Int msg
  | Timeout Int msg

instance subscriptionFunctor :: Functor Subscription where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Subscription msg1 -> Subscription msg2
  map f (WindowEvent name msg) = WindowEvent name (f msg)
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

-- runtime internals
--------------------

-- | Do these two subscriptions describe the same thing to listen to? This is
-- | what the runtime reconciles on, so two subscriptions that answer `true`
-- | here share a single listener.
-- |
-- | A window event is identified by its name alone: there is only one
-- | `window`, so one `online` event, and the message is free to change from
-- | one update to the next without the listener being touched. A timer is
-- | identified by its duration *and* its message, because two timers on the
-- | same period that send different messages really are two timers.
sameSub :: ∀ msg. Eq msg => Subscription msg -> Subscription msg -> Boolean
sameSub (WindowEvent name1 _) (WindowEvent name2 _) = name1 == name2
sameSub (Interval ms1 msg1) (Interval ms2 msg2) = ms1 == ms2 && msg1 == msg2
sameSub (Timeout ms1 msg1) (Timeout ms2 msg2) = ms1 == ms2 && msg1 == msg2
sameSub _ _ = false

-- | The message this subscription sends when it fires.
message :: ∀ msg. Subscription msg -> msg
message (WindowEvent _ msg) = msg
message (Interval _ msg) = msg
message (Timeout _ msg) = msg

-- | Start listening, running the given effect every time the event fires.
-- | Returns the effect that stops listening again.
attach :: ∀ msg. Subscription msg -> Effect Unit -> Effect (Effect Unit)
attach (WindowEvent name _) action = runFn2 addWindowListenerImpl name action
attach (Interval ms _) action = do
  idRef <- Ref.new Nothing
  timerId <- runFn2 setIntervalImpl ms action
  Ref.write (Just timerId) idRef
  pure (clearWith clearIntervalImpl idRef)
attach (Timeout ms _) action = do
  idRef <- Ref.new Nothing
  -- The id is forgotten as the timeout fires: a one-shot handle is dead once
  -- it has run, and the browser is free to hand the same number out to a
  -- later timer, which unsubscribing would then cancel by mistake. The
  -- callback cannot run before the `write` below, since it is queued and JS
  -- finishes this effect first.
  timerId <- runFn2 setTimeoutImpl ms (Ref.write Nothing idRef >>= \_ -> action)
  Ref.write (Just timerId) idRef
  pure (clearWith clearTimeoutImpl idRef)

-- | Stop a timer, if it is still running, and forget its id so that a second
-- | unsubscribe is a no-op.
clearWith :: (TimerId -> Effect Unit) -> Ref (Maybe TimerId) -> Effect Unit
clearWith clear idRef = do
  running <- Ref.read idRef
  Ref.write Nothing idRef
  traverse_ clear running
