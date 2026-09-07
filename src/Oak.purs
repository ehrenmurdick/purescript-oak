module Oak
  ( module Data.Either
  , module Data.Maybe
  , module Oak.Document
  , module Oak.Html
  , module Oak.Html.Events
  , module Oak.Route
  , module Oak.Window
  , App
  , createApp
  , createRoutedApp
  , runApp
  , unwrapApp
  ) where

import Oak.Html

import Data.Array (filter, nubByEq)
import Data.Either (Either(..), choose, either, fromLeft, fromRight, hush, isLeft, isRight, note, note')
import Data.Foldable (any, find, traverse_)
import Data.Maybe (Maybe(..), fromJust)
import Data.Monoid (mempty)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Ref (Ref, new, read, write) as Ref
import Oak.Document (Element, Node, appendChildNode, getElementById, onDocumentReady)
import Oak.Html.Events (onAbort, onAfterprint, onBeforeprint, onBeforeunload, onBlur, onCanplay, onCanplaythrough, onChange, onClick, onContextmenu, onCopy, onCuechange, onCut, onDblclick, onDrag, onDragend, onDragenter, onDragleave, onDragover, onDragstart, onDrop, onDurationchange, onEmptied, onEnded, onError, onFocus, onHashchange, onInput, onInvalid, onKeydown, onKeypress, onKeyup, onLoad, onLoadeddata, onLoadedmetadata, onLoadstart, onMousedown, onMousemove, onMouseout, onMouseover, onMouseup, onMousewheel, onOffline, onOnline, onPagehide, onPageshow, onPaste, onPause, onPlay, onPlaying, onPopstate, onProgress, onRatechange, onReset, onResize, onScroll, onSearch, onSeeked, onSeeking, onSelect, onStalled, onStorage, onSubmit, onSuspend, onTimeupdate, onToggle, onUnload, onVolumechange, onWaiting, onWheel)
import Oak.Navigation as Nav
import Oak.Route (Mode(..), QueryParam, Url, parseUrl, queryParam)
import Oak.Subscription (Subscription)
import Oak.Subscription as Sub
import Oak.VirtualDom (patch, render)
import Oak.VirtualDom.Native as N
import Oak.Window (alert, alert', confirm, prompt, prompt')
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, bind, discard, not, pure, Unit, unit, (>>=))
import Prim.Boolean (True)

data App msg model
  = App {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg, router :: Maybe (Router msg)}

-- | What the runtime needs in order to route: which half of the URL carries
-- | the route, and how to turn a URL into a message the app understands.
-- | `onNavigate` closes over the app's own parser, which is why the route
-- | type never appears in `App`'s signature.
type Router msg
  = {mode :: Mode, onNavigate :: Url -> msg}

data RunningApp msg model
  = RunningApp {update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg}

-- | createApp takes a record with a description of your Oak app.
-- | It has a few parts:
-- |
-- |
-- | `init`:
-- |
-- | the inital model state.
-- |
-- |
-- | `view`:
-- |
-- |
-- | Maps the current model to a view.
-- |
-- | `next`:
-- |
-- | This function takes a message and model and returns a command. For example,
-- | for sending an Http request when a user clicks a button. `next` would be
-- | called with the button click message and would return an `Oak.Cmd` that
-- | will execute the request.
-- |
-- |
-- | `update`:
-- |
-- | Takes an incoming message, and the previous model state,
-- | and returns the new model state.
-- |
-- |
-- | `subscriptions`:
-- |
-- | Maps the current model to the outside-world events the app wants to hear
-- | about, e.g. `\_ -> [ onOnline WentOnline ]`. It is re-run after every
-- | update, so an app can start and stop listening as its state changes.
-- | Return `[]` to subscribe to nothing. See `Oak.Subscription`.
createApp ::
  forall msg model.
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg} ->
  App msg model
createApp opts = App { init: opts.init
                     , view: opts.view
                     , next: opts.next
                     , subscriptions: opts.subscriptions
                     , update: opts.update
                     , router: Nothing
                     }

-- | Like `createApp`, but the app's screen is decided by the URL.
-- |
-- | Two fields on top of the usual five:
-- |
-- |
-- | `mode`:
-- |
-- | `Hash` keeps the route in the fragment and works anywhere, including
-- | from a `file://` URL. `Path` uses real paths, and needs the server to
-- | serve the app for every route.
-- |
-- |
-- | `onNavigate`:
-- |
-- | Turns a URL into a message, and is where your own route parser gets in:
-- | `\url -> RouteChanged (parse url)`. The runtime calls it for the
-- | initial URL before the first render, and again for every later
-- | navigation -- a link click, a `Oak.Navigation.push`, the back button.
-- | To the rest of the app a navigation is just another message.
-- |
-- | ```purescript
-- | app :: App Msg Model
-- | app = createRoutedApp
-- |   { init, view, update, next, subscriptions
-- |   , mode: Hash
-- |   , onNavigate: \url -> RouteChanged (parse url)
-- |   }
-- | ```
createRoutedApp ::
  forall msg model.
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg, mode :: Mode, onNavigate :: Url -> msg} ->
  App msg model
createRoutedApp opts = App { init: opts.init
                           , view: opts.view
                           , next: opts.next
                           , subscriptions: opts.subscriptions
                           , update: opts.update
                           , router: Just { mode: opts.mode, onNavigate: opts.onNavigate }
                           }

unwrapApp ::
  forall msg model.
  App msg model ->
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg}
unwrapApp (App app) = { init: app.init
                      , view: app.view
                      , next: app.next
                      , subscriptions: app.subscriptions
                      , update: app.update
                      }

-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
-- |
-- | The `Eq msg` is what lets the runtime reconcile subscriptions: it has to
-- | be able to tell whether the timer an app is asking for this update is the
-- | one already running. A `derive instance eqMsg :: Eq Msg` is normally all
-- | it takes.
runApp ::
  forall msg model.
  Eq msg =>
  App msg model ->
  Maybe msg ->
  Effect Node
runApp app initialMsg = do
  runApp_ app initialMsg

type Runtime msg model
  = {tree :: Maybe N.Tree, root :: Maybe Node, model :: model, subs :: Array (ActiveSub msg)}

-- | A subscription the runtime currently has a listener attached for.
-- |
-- | `sub` is kept for its identity only -- the message it carries is the one
-- | this listener was first attached with, which for a window event may since
-- | have gone stale. The message actually dispatched lives behind `current`,
-- | so a subscription whose message changed between updates can be refreshed
-- | in place without detaching and reattaching the underlying listener.
type ActiveSub msg
  = {sub :: Subscription msg, current :: Ref.Ref msg, unsubscribe :: Effect Unit}

-- TODO: investigate implementing monoid for App and replace
--       state loop with foldl
-- | Reconciles the subscriptions the app currently wants against the
-- | listeners already attached: subscriptions that disappeared are stopped,
-- | new ones are started, and ones that are still wanted keep their listener
-- | and just have their message refreshed.
syncSubs ::
  forall msg model.
  Eq msg =>
  Ref.Ref (Runtime msg model) ->
  (msg -> Effect Unit) ->
  Array (Subscription msg) ->
  Effect Unit
syncSubs ref dispatch subs = do
  env <- Ref.read ref
  -- two subscriptions to the same event share a listener, so the first wins
  let wanted = nubByEq Sub.sameSub subs
  traverse_ _.unsubscribe (filter (\a -> not (any (Sub.sameSub a.sub) wanted)) env.subs)
  active <- traverse (startOrRetain env.subs dispatch) wanted
  -- re-read: a subscription that fired during attach may have replaced env
  env' <- Ref.read ref
  Ref.write (env' { subs = active }) ref

startOrRetain ::
  forall msg.
  Eq msg =>
  Array (ActiveSub msg) ->
  (msg -> Effect Unit) ->
  Subscription msg ->
  Effect (ActiveSub msg)
startOrRetain active dispatch sub =
  case find (\a -> Sub.sameSub a.sub sub) active of
    Just a -> do
      Ref.write (Sub.message sub) a.current
      pure a
    Nothing -> do
      current <- Ref.new (Sub.message sub)
      unsubscribe <- Sub.attach sub (Ref.read current >>= dispatch)
      pure { sub: sub, current: current, unsubscribe: unsubscribe }

handler ::
  forall msg model.
  Eq msg =>
  Ref.Ref (Runtime msg model) ->
  RunningApp msg model ->
  msg ->
  Effect Unit
handler ref runningApp msg = do
  env <- Ref.read ref
  let (RunningApp app) = runningApp
  let oldTree = unsafePartial (fromJust env.tree)
  let oldRoot = unsafePartial (fromJust env.root)
  let newModel = app.update msg env.model
  newTree <- render (handler ref runningApp) (app.view newModel)
  newRoot <- patch newTree oldTree oldRoot
  let newRuntime = { root: Just newRoot
                   , tree: Just newTree
                   , model: newModel
                   , subs: env.subs
                   }
  Ref.write newRuntime ref
  syncSubs ref (handler ref runningApp) (app.subscriptions newModel)
  app.next msg newModel (handler ref runningApp)
  mempty

runApp_ :: forall msg model. Eq msg => App msg model -> Maybe msg -> Effect Node
runApp_ (App app) msg = do
  let runningApp = { view: app.view
                   , next: app.next
                   , subscriptions: app.subscriptions
                   , update: app.update
                   }
  -- A routed app's first screen is decided by the URL, and reading the URL
  -- is an effect while `init` is a pure value. The route is folded through
  -- `update` before the first render rather than dispatched as a message
  -- after it, so the initial paint is already the right screen instead of a
  -- flash of whatever `init` happened to say.
  initialNav <- initialNavMsg (App app)
  let initialModel = case initialNav of
        Just navMsg -> app.update navMsg app.init
        Nothing -> app.init
  ref <- Ref.new { tree: Nothing, root: Nothing, model: initialModel, subs: [] }
  tree <- render (handler ref (RunningApp runningApp)) (runningApp.view initialModel)
  let rootNode = (N.createRootNode tree)
  _ <- Ref.write { tree: Just tree, root: Just rootNode, model: initialModel, subs: [] } ref
  syncSubs ref (handler ref (RunningApp runningApp)) (app.subscriptions initialModel)
  -- Listeners go up before `next` runs, not after: a screen whose entry
  -- command navigates would otherwise push a URL nothing is listening for.
  case app.router of
    Just router ->
      Nav.start router.mode \raw ->
        handler ref (RunningApp runningApp) (router.onNavigate (parseUrl router.mode raw))
    Nothing -> pure unit
  -- The initial route gets its `next` like any other message, so a screen
  -- can kick off its entry fetch without a special case in the app.
  case initialNav of
    Just navMsg -> app.next navMsg initialModel (handler ref (RunningApp runningApp))
    Nothing -> pure unit
  case msg of
    (Just m) -> handler ref (RunningApp runningApp) m
    Nothing -> pure unit
  pure rootNode

-- | The message a routed app should be holding by the time it first renders.
-- | `Nothing` for an app built with `createApp`, which never looks at the URL.
initialNavMsg :: forall msg model. App msg model -> Effect (Maybe msg)
initialNavMsg (App app) = case app.router of
  Nothing -> pure Nothing
  Just router -> do
    raw <- Nav.currentUrl
    pure (Just (router.onNavigate (parseUrl router.mode raw)))
