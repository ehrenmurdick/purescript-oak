module Oak
  ( module Data.Either
  , module Data.Maybe
  , module Oak.Document
  , module Oak.Html
  , module Oak.Html.Events
  , module Oak.Window
  , App
  , createApp
  , runApp
  , unwrapApp
  ) where

import Oak.Html

import Data.Either
  ( Either(..)
  , choose
  , either
  , fromLeft
  , fromRight
  , hush
  , isLeft
  , isRight
  , note
  , note'
  )
import Data.Array (filter, nubByEq)
import Data.Foldable (elem, find, traverse_)
import Data.Maybe (Maybe(..), fromJust)
import Data.Monoid (mempty)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Ref (Ref, new, read, write) as Ref
import Oak.Document
  ( Element
  , Node
  , appendChildNode
  , getElementById
  , onDocumentReady
  )
import Oak.Html.Events
  ( onAbort
  , onAfterprint
  , onBeforeprint
  , onBeforeunload
  , onBlur
  , onCanplay
  , onCanplaythrough
  , onChange
  , onClick
  , onContextmenu
  , onCopy
  , onCuechange
  , onCut
  , onDblclick
  , onDrag
  , onDragend
  , onDragenter
  , onDragleave
  , onDragover
  , onDragstart
  , onDrop
  , onDurationchange
  , onEmptied
  , onEnded
  , onError
  , onFocus
  , onHashchange
  , onInput
  , onInvalid
  , onKeydown
  , onKeypress
  , onKeyup
  , onLoad
  , onLoadeddata
  , onLoadedmetadata
  , onLoadstart
  , onMousedown
  , onMousemove
  , onMouseout
  , onMouseover
  , onMouseup
  , onMousewheel
  , onOffline
  , onOnline
  , onPagehide
  , onPageshow
  , onPaste
  , onPause
  , onPlay
  , onPlaying
  , onPopstate
  , onProgress
  , onRatechange
  , onReset
  , onResize
  , onScroll
  , onSearch
  , onSeeked
  , onSeeking
  , onSelect
  , onStalled
  , onStorage
  , onSubmit
  , onSuspend
  , onTimeupdate
  , onToggle
  , onUnload
  , onVolumechange
  , onWaiting
  , onWheel
  )
import Oak.Subscription (Subscription)
import Oak.Subscription as Sub
import Oak.VirtualDom (patch, render)
import Oak.Window (alert, alert', confirm, prompt, prompt')
import Partial.Unsafe (unsafePartial)
import Prelude (bind, discard, map, not, pure, Unit, unit, (==), (>>=))

import Oak.VirtualDom.Native as N

data App msg model
  = App {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg}

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
                     }

unwrapApp ::
  forall msg model.
  App msg model ->
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, subscriptions :: model -> Array (Subscription msg), view :: model -> View msg}
unwrapApp (App app) = app

-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
runApp ::
  forall msg model.
  App msg model ->
  Maybe msg ->
  Effect Node
runApp msg app = do
  runApp_ msg app

type Runtime msg model
  = {tree :: Maybe N.Tree, root :: Maybe Node, model :: model, subs :: Array (ActiveSub msg)}

-- | A subscription the runtime currently has a listener attached for. The
-- | message lives behind a ref so that a subscription whose message changed
-- | between updates can be refreshed in place, without detaching and
-- | reattaching the underlying listener.
type ActiveSub msg
  = {key :: String, current :: Ref.Ref msg, unsubscribe :: Effect Unit}

-- TODO: investigate implementing monoid for App and replace
--       state loop with foldl
-- TODO: decouple rendering from app event loop to facilitate
--       different rendering backends

-- | Reconciles the subscriptions the app currently wants against the
-- | listeners already attached: subscriptions that disappeared are stopped,
-- | new ones are started, and ones that are still wanted keep their listener
-- | and just have their message refreshed.
syncSubs ::
  forall msg model.
  Ref.Ref (Runtime msg model) ->
  (msg -> Effect Unit) ->
  Array (Subscription msg) ->
  Effect Unit
syncSubs ref dispatch subs = do
  env <- Ref.read ref
  -- two subscriptions to the same event share a listener, so the first wins
  let wanted = nubByEq (\a b -> Sub.key a == Sub.key b) subs
  let wantedKeys = map Sub.key wanted
  traverse_ _.unsubscribe (filter (\a -> not (elem a.key wantedKeys)) env.subs)
  active <- traverse (startOrRetain env.subs dispatch) wanted
  -- re-read: a subscription that fired during attach may have replaced env
  env' <- Ref.read ref
  Ref.write (env' { subs = active }) ref

startOrRetain ::
  forall msg.
  Array (ActiveSub msg) ->
  (msg -> Effect Unit) ->
  Subscription msg ->
  Effect (ActiveSub msg)
startOrRetain active dispatch sub =
  case find (\a -> a.key == Sub.key sub) active of
    Just a -> do
      Ref.write (Sub.message sub) a.current
      pure a
    Nothing -> do
      current <- Ref.new (Sub.message sub)
      unsubscribe <- Sub.attach sub (Ref.read current >>= dispatch)
      pure { key: Sub.key sub, current: current, unsubscribe: unsubscribe }

handler ::
  forall msg model.
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

runApp_ :: forall msg model. App msg model -> Maybe msg -> Effect Node
runApp_ (App app) msg = do
  let runningApp = { view: app.view
                   , next: app.next
                   , subscriptions: app.subscriptions
                   , update: app.update
                   }
  let initialModel = app.init
  ref <- Ref.new { tree: Nothing, root: Nothing, model: initialModel, subs: [] }
  tree <- render (handler ref (RunningApp runningApp)) (runningApp.view initialModel)
  let rootNode = (N.createRootNode tree)
  _ <- Ref.write { tree: Just tree, root: Just rootNode, model: initialModel, subs: [] } ref
  syncSubs ref (handler ref (RunningApp runningApp)) (app.subscriptions initialModel)
  case msg of
    (Just m) -> handler ref (RunningApp runningApp) m
    Nothing -> pure unit
  pure rootNode
