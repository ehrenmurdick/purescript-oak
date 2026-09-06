-- | Subscriptions let an app listen to events that come from outside the
-- | view -- the browser's connectivity events, for now.
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
-- | import Oak.Subscription (Subscription, onOffline, onOnline)
-- | ```
module Oak.Subscription
  ( Subscription
  , attach
  , key
  , message
  , onOffline
  , onOnline
  , onWindowEvent
  ) where

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Functor (class Functor)
import Effect (Effect)
import Prelude (Unit, (<>))

foreign import addWindowListenerImpl :: Fn2 String (Effect Unit) (Effect (Effect Unit))

-- | A description of something to listen to, and the message to send when it
-- | fires. Build these with `onOnline`, `onOffline` or `onWindowEvent`.
data Subscription msg
  = WindowEvent String msg

instance subscriptionFunctor :: Functor Subscription where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Subscription msg1 -> Subscription msg2
  map f (WindowEvent name msg) = WindowEvent name (f msg)

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

-- runtime internals
--------------------

-- | Identifies what a subscription listens to, ignoring which message it
-- | sends. The runtime diffs on this, so two subscriptions with the same key
-- | share one listener.
key :: ∀ msg. Subscription msg -> String
key (WindowEvent name _) = "window:" <> name

-- | The message this subscription sends when it fires.
message :: ∀ msg. Subscription msg -> msg
message (WindowEvent _ msg) = msg

-- | Start listening, running the given effect every time the event fires.
-- | Returns the effect that stops listening again.
attach :: ∀ msg. Subscription msg -> Effect Unit -> Effect (Effect Unit)
attach (WindowEvent name _) action = runFn2 addWindowListenerImpl name action
