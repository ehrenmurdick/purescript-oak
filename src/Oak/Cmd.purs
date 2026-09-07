-- | Commands: the things an app asks the runtime to do after an update, and
-- | the messages that come back when they are done.
-- |
-- | An app's `next` returns a `Cmd msg`. A command is a value, so it can be
-- | built up, mapped over, and combined -- `Cmd.none` for nothing to do,
-- | `<>` or `batch` to run several -- and a command that produces no message
-- | says so in the way it is constructed rather than by ignoring an argument.
-- |
-- | ```purescript
-- | next :: Msg -> Model -> Cmd Msg
-- | next msg model = case msg of
-- |   Save -> Storage.set Storage.localStorage "todos" model.todos
-- |   Load -> Storage.get Storage.localStorage "todos" Loaded
-- |   _    -> Cmd.none
-- | ```
-- |
-- | Most commands are built by the wrappers in `Oak.Storage.Cmd`,
-- | `Oak.Window.Cmd`, `Oak.Navigation.Cmd` and `Oak.Cmd.Aff` rather than by
-- | the constructors here. Reach for `effect`, `perform` and `ask` to wrap
-- | an effect of your own, and for `callback` when nothing else fits.
module Oak.Cmd
  ( Cmd
  , ask
  , batch
  , callback
  , dispatch
  , effect
  , none
  , perform
  , run
  ) where

import Data.Foldable (traverse_)
import Data.Functor (class Functor)
import Effect (Effect)
import Prelude (class Monoid, class Semigroup, Unit, bind, discard, pure, unit, (>>>))

-- | Something to do, and optionally a message to feed back in afterwards.
data Cmd msg
  = Cmd ((msg -> Effect Unit) -> Effect Unit)

-- | Re-tag the messages a command produces. A command that produces none is
-- | left alone by this.
instance cmdFunctor :: Functor Cmd where
  map f (Cmd k) = Cmd \send -> k (f >>> send)

-- | Run both, left to right.
instance cmdSemigroup :: Semigroup (Cmd msg) where
  append (Cmd a) (Cmd b) = Cmd \send -> do
    a send
    b send

instance cmdMonoid :: Monoid (Cmd msg) where
  mempty = Cmd \_ -> pure unit

-- | Do nothing. The same command as `mempty`.
none :: ∀ msg. Cmd msg
none = Cmd \_ -> pure unit

-- | Run several commands, in order.
batch :: ∀ msg. Array (Cmd msg) -> Cmd msg
batch cmds = Cmd \send -> traverse_ (\(Cmd k) -> k send) cmds

-- | An effect the app never hears back from: a log line, a navigation, a
-- | write whose outcome doesn't matter.
effect :: ∀ msg. Effect Unit -> Cmd msg
effect e = Cmd \_ -> e

-- | An effect that produces a message.
-- |
-- | ```purescript
-- | Cmd.perform (Storage.keys Storage.localStorage <#> FoundKeys)
-- | ```
perform :: ∀ msg. Effect msg -> Cmd msg
perform e = Cmd \send -> do
  msg <- e
  send msg

-- | Feed a message back in, once this update has landed.
dispatch :: ∀ msg. msg -> Cmd msg
dispatch msg = Cmd \send -> send msg

-- | Wrap a callback-style effect -- a native dialog, an async request --
-- | turning whatever it answers with into a message.
-- |
-- | ```purescript
-- | Cmd.ask (Window.confirm "Delete this todo?") \ok ->
-- |   if ok then DeleteTodo tid else DeleteCancelled
-- | ```
ask :: ∀ a msg. ((a -> Effect Unit) -> Effect Unit) -> (a -> msg) -> Cmd msg
ask start toMsg = Cmd \send -> start (toMsg >>> send)

-- | The escape hatch: an effect handed the dispatcher itself, free to send
-- | any number of messages, or none. Everything else in this module is a
-- | special case of it.
callback :: ∀ msg. ((msg -> Effect Unit) -> Effect Unit) -> Cmd msg
callback k = Cmd k

-- runtime internals
--------------------

-- | Run a command, dispatching whatever messages it produces. Called by
-- | `Oak.runApp` after every update; apps have no reason to call it.
run :: ∀ msg. Cmd msg -> (msg -> Effect Unit) -> Effect Unit
run (Cmd k) send = k send
