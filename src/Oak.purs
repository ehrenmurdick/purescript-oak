module Oak
  ( module Data.Either
  , module Data.Maybe
  , module Oak.Document
  , module Oak.Html
  , module Oak.Html.Events
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
import Data.Maybe (Maybe(..), fromJust)
import Data.Monoid (mempty)
import Effect (Effect)
import Effect.Ref (Ref, new, read, write) as Ref
import Oak.Document (Element, Node, appendChildNode, getElementById, onDocumentReady)
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
import Oak.VirtualDom (patch, render)
import Prelude (bind, discard, pure, Unit, unit)

import Oak.VirtualDom.Native as N

data App msg model
  = App {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, view :: model -> View msg}

data RunningApp msg model
  = RunningApp {update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, view :: model -> View msg}

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
-- | Maps the current model to an html view.
-- |
-- | `next`:
-- |
-- | This function maps a message and model to a command. For example,
-- | for sending an Http request when a user clicks a button.
-- | `next` would be called with the button click message and would
-- | return an `Oak.Cmd` that will execute the request.
-- |
-- |
-- | `update`:
-- |
-- | Takes an incoming message, and the previous model state,
-- | and returns the new model state.
createApp ::
  forall msg model.
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, view :: model -> View msg} ->
  App msg model
createApp opts = App { init: opts.init
                     , view: opts.view
                     , next: opts.next
                     , update: opts.update
                     }

unwrapApp ::
  forall msg model.
  App msg model ->
  {init :: model, update :: msg -> model -> model, next :: msg -> model -> (msg -> Effect Unit) -> Effect Unit, view :: model -> View msg}
unwrapApp (App app) = app

-- | Kicks off the running app, and returns an effect
-- | containing the root node of the app, which can
-- | be used to embed the application. See the `main` function
-- | of the example app in the readme.
runApp ::
  forall msg model.
  App msg model ->
  Maybe msg ->
  Effect (Array Node)
runApp msg app = do
  runApp_ msg app

type Runtime m
  = {tree :: Array N.Tree, root :: Array Node, model :: m}

handler ::
  forall msg model.
  Ref.Ref (Runtime model) ->
  RunningApp msg model ->
  msg ->
  Effect Unit
handler ref runningApp msg = do
  env <- Ref.read ref
  let (RunningApp app) = runningApp
  let oldTree = env.tree
  let root = env.root
  let newModel = app.update msg env.model
  newTree <- render (handler ref runningApp) (runBuilder (app.view newModel))
  newRoot <- patch newTree oldTree env.root
  let newRuntime = { root: newRoot
                   , tree: newTree
                   , model: newModel
                   }
  Ref.write newRuntime ref
  app.next msg newModel (handler ref runningApp)
  mempty

runApp_ :: forall msg model. App msg model -> Maybe msg -> Effect (Array Node)
runApp_ (App app) msg = do
  let runningApp = { view: app.view
                   , next: app.next
                   , update: app.update
                   }
  let initialModel = app.init
  ref <- Ref.new { tree: [], root: [], model: initialModel }
  tree <- render (handler ref (RunningApp runningApp)) (runBuilder (runningApp.view initialModel))
  let rootNode = (N.createRootNode tree)
  _ <- Ref.write { tree, root: rootNode, model: initialModel } ref
  case msg of
    (Just m) -> handler ref (RunningApp runningApp) m
    Nothing -> pure unit
  pure rootNode
