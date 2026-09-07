module Test.TodoApp (main) where

-- This app exists to exercise Oak end-to-end: every Attribute constructor
-- (SimpleAttribute, BooleanAttribute, DataAttribute, Style, EventHandler,
-- StringEventHandler, KeyPressEventHandler), a spread of Html tags, the
-- Oak.Css style helpers, the Either/Maybe re-exports, Oak.Cmd's commands,
-- Oak.Window's native dialogs, Oak.Subscription's window events
-- and timers, Oak.Storage's JSON persistence, and Oak.Document's ready/mount
-- lifecycle -- wired up as a working todo list.

import Oak hiding (alert, alert', confirm, prompt, prompt', data_)
import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Oak.Storage.Cmd as Storage
import Oak.Window.Cmd as Window
import Oak.Subscription (Subscription, onInterval, onTimeout, onWindowEvent)
import Oak.Css (color, fontWeight, textDecoration)
import Oak.Html.Attribute
  ( KeyPressEvent
  , checked
  , className
  , data_
  , disabled
  , for
  , hidden
  , id_
  , key
  , placeholder
  , style
  , type_
  , value
  )
import Oak.Html.Events (onKeydown')

import Prelude hiding (div)

import Data.Array (filter, length)
import Data.Foldable (maximum)
import Data.Maybe (fromMaybe)
import Effect (Effect)
import Effect.Class.Console (log)

type Todo =
  { id :: Int
  , text :: String
  , completed :: Boolean
  }

data Filter = All | Active | Completed

derive instance eqFilter :: Eq Filter

type Model =
  { todos :: Array Todo
  , draft :: String
  , nextId :: Int
  , editing :: Maybe Int
  , editText :: String
  , filter :: Filter
  , watchingResize :: Boolean
  , resizes :: Int
  , ticking :: Boolean
  , ticks :: Int
  , blink :: Boolean
  , notice :: Maybe String
  }

data Msg
  = UpdateDraft String
  | DraftKeyDown Int
  | AddTodo
  | ToggleTodo Int
  | AskDeleteTodo Int
  | DeleteTodo Int
  | AskRenameTodo Int String
  | RenameTodo Int String
  | StartEdit Int String
  | UpdateEditText String
  | EditKeyDown KeyPressEvent
  | CommitEdit
  | CancelEdit
  | SetFilter Filter
  | ClearCompleted
  | ToggleWatchResize
  | WindowResized
  | ToggleTicking
  | Tick
  | Blink
  | DismissNotice
  | Load
  | Loaded (Maybe (Array Todo))
  | Saved
  | SaveFailed
  | DeleteCancelled
  | RenameCancelled
  | RenameRejected
  | ClearedAcknowledged

-- | Only needed because this app starts timers: `onInterval` and `onTimeout`
-- | tell two timers of the same duration apart by their messages.
derive instance eqMsg :: Eq Msg

-- model
--------

init :: Model
init =
  { todos:
      [ { id: 1, text: "Learn Oak", completed: true }
      , { id: 2, text: "Build a todo app", completed: false }
      , { id: 3, text: "Open it in a browser", completed: false }
      ]
  , draft: ""
  , nextId: 4
  , editing: Nothing
  , editText: ""
  , filter: All
  , watchingResize: true
  , resizes: 0
  , ticking: false
  , ticks: 0
  , blink: false
  , notice: Nothing
  }

-- update
---------

validateDraft :: String -> Either String String
validateDraft s = if s == "" then Left "draft is empty" else Right s

addTodo :: Model -> Model
addTodo model = case validateDraft model.draft of
  Left _ -> model
  Right t -> model
    { todos = model.todos <> [ { id: model.nextId, text: t, completed: false } ]
    , draft = ""
    , nextId = model.nextId + 1
    }

commitEdit :: Model -> Model
commitEdit model = case model.editing of
  Nothing -> model
  Just editId -> case validateDraft model.editText of
    Left _ -> model
    Right t -> model
      { todos = map (\td -> if td.id == editId then td { text = t } else td) model.todos
      , editing = Nothing
      , editText = ""
      }

cancelEdit :: Model -> Model
cancelEdit model = model { editing = Nothing, editText = "" }

update :: Msg -> Model -> Model
update msg model = case msg of
  UpdateDraft s -> model { draft = s }
  DraftKeyDown code -> if code == 13 then addTodo model else model
  AddTodo -> addTodo model
  ToggleTodo tid -> model
    { todos = map (\t -> if t.id == tid then t { completed = not t.completed } else t) model.todos
    }
  AskDeleteTodo _ -> model
  DeleteTodo tid -> model
    { todos = filter (\t -> t.id /= tid) model.todos
    , notice = Just ("Deleted todo " <> show tid)
    }
  AskRenameTodo _ _ -> model
  RenameTodo tid t -> model
    { todos = map (\td -> if td.id == tid then td { text = t } else td) model.todos
    }
  StartEdit tid currentText -> model { editing = Just tid, editText = currentText }
  UpdateEditText s -> model { editText = s }
  EditKeyDown e
    | e.key == "Enter" -> commitEdit model
    | e.key == "Escape" -> cancelEdit model
    | otherwise -> model
  CommitEdit -> commitEdit model
  CancelEdit -> cancelEdit model
  SetFilter f -> model { filter = f }
  ClearCompleted -> model { todos = filter (not <<< _.completed) model.todos }
  ToggleWatchResize -> model { watchingResize = not model.watchingResize }
  WindowResized -> model { resizes = model.resizes + 1 }
  ToggleTicking -> model { ticking = not model.ticking }
  Tick -> model { ticks = model.ticks + 1 }
  Blink -> model { blink = not model.blink }
  DismissNotice -> model { notice = Nothing }
  Load -> model
  Loaded Nothing -> model
  Loaded (Just todos) -> model
    { todos = todos
    , nextId = fromMaybe 0 (maximum (map _.id todos)) + 1
    }
  -- the outcomes of a write and of the dialogs: nothing to keep, they exist
  -- so that `next` has something to report on
  Saved -> model
  SaveFailed -> model
  DeleteCancelled -> model
  RenameCancelled -> model
  RenameRejected -> model
  ClearedAcknowledged -> model

-- next (commands -- persistence, logging, and the Oak.Window dialogs, whose
-- answers come back as messages of their own)
------------------------------------------------------------------------

todosKey :: String
todosKey = "oak.todos"

next :: Msg -> Model -> Cmd Msg
next msg model = case msg of
  -- the boot message: it reads storage rather than writing to it, so it must
  -- not fall through to the save below
  Load -> Storage.get Storage.localStorage todosKey Loaded
  Loaded Nothing -> Cmd.effect (log "no saved todos, starting from the defaults")
  Loaded (Just _) -> Cmd.none
  -- the clock and its toast change nothing worth keeping, and a write a
  -- second is a rude thing to do to localStorage
  Tick -> Cmd.none
  Blink -> Cmd.none
  DismissNotice -> Cmd.none
  -- the answers to a save and to the dialogs. They are matched here rather
  -- than left to the fallthrough for a reason: a save that reported itself
  -- into the save branch would save again, forever.
  Saved -> Cmd.none
  SaveFailed -> Cmd.effect (log "could not save todos")
  DeleteCancelled -> Cmd.effect (log "delete cancelled")
  RenameCancelled -> Cmd.effect (log "rename cancelled")
  RenameRejected -> Window.alert "A todo can't be empty."
  ClearedAcknowledged -> Cmd.effect (log "cleared completed todos")
  _ -> announce msg <> save model.todos

-- | Write the list, and say so if the write was refused.
save :: Array Todo -> Cmd Msg
save todos =
  Storage.set' Storage.localStorage todosKey todos \saved ->
    if saved then Saved else SaveFailed

-- | The logging/dialog half of `next`, split out so every message can be
-- | combined with the save above.
announce :: Msg -> Cmd Msg
announce msg = case msg of
  AddTodo -> Cmd.effect (log "added a todo (button)")
  DraftKeyDown code | code == 13 -> Cmd.effect (log "added a todo (enter key)")
  AskDeleteTodo tid ->
    Window.confirm "Delete this todo?" \ok ->
      if ok then DeleteTodo tid else DeleteCancelled
  DeleteTodo tid -> Cmd.effect (log ("deleted todo " <> show tid))
  AskRenameTodo tid currentText ->
    Window.prompt' "Rename this todo:" currentText case _ of
      Just t | t /= "" -> RenameTodo tid t
      Just _ -> RenameRejected
      Nothing -> RenameCancelled
  RenameTodo tid _ -> Cmd.effect (log ("renamed todo " <> show tid))
  ClearCompleted -> Window.alert' "Cleared the completed todos." ClearedAcknowledged
  ToggleWatchResize -> Cmd.effect (log "toggled the resize subscription")
  WindowResized -> Cmd.effect (log "window resized")
  ToggleTicking -> Cmd.effect (log "toggled the clock subscription")

  _ -> Cmd.none

-- view
-------

activeCount :: Array Todo -> Int
activeCount todos = length (filter (not <<< _.completed) todos)

completedCount :: Array Todo -> Int
completedCount todos = length (filter _.completed todos)

visibleTodos :: Model -> Array Todo
visibleTodos model = case model.filter of
  All -> model.todos
  Active -> filter (not <<< _.completed) model.todos
  Completed -> filter _.completed model.todos

filterName :: Filter -> String
filterName f = case f of
  All -> "All"
  Active -> "Active"
  Completed -> "Completed"

view :: Model -> Html Msg
view model =
  div
    [ id_ "todoapp" ]
    [ header []
        [ h1 [] [ text "Oak Todos" ]
        , div []
            [ input
                [ type_ "text"
                , placeholder "What needs to be done?"
                , value model.draft
                , onInput UpdateDraft
                , onKeydown DraftKeyDown
                ]
                []
            , button
                [ onClick AddTodo
                , disabled (model.draft == "")
                ]
                [ text "Add" ]
            ]
        ]
    , ul [ className "todo-list" ]
        (map (viewTodo model.editing model.editText) (visibleTodos model))
    , footer []
        [ span [] [ text (show (activeCount model.todos) <> " item(s) left") ]
        , span [] (map (viewFilterButton model.filter) [ All, Active, Completed ])
        , button
            [ onClick ClearCompleted
            , hidden (completedCount model.todos == 0)
            ]
            [ text "Clear completed" ]
        , div []
            [ input
                [ type_ "checkbox"
                , id_ "watch-resize"
                , checked model.watchingResize
                , onChange ToggleWatchResize
                ]
                []
            , label [ for "watch-resize" ] [ text "watch window.resize" ]
            , span
                [ style (if model.watchingResize then [] else [ color "#999" ]) ]
                [ text (" -- " <> show model.resizes <> " resize(s) seen") ]
            ]
        , div []
            [ input
                [ type_ "checkbox"
                , id_ "run-clock"
                , checked model.ticking
                , onChange ToggleTicking
                ]
                []
            , label [ for "run-clock" ] [ text "tick once a second" ]
            , span
                [ style (if model.ticking then [] else [ color "#999" ]) ]
                [ text (" -- " <> show model.ticks <> " tick(s)") ]
            -- driven by a second interval on the same 1s period as Tick: same
            -- duration, different message, so they are two separate timers
            , span [] [ text (if model.ticking && model.blink then " *" else "") ]
            ]
        ]
    , viewNotice model.notice
    ]

-- | A toast that clears itself: `subscriptions` asks for a one-shot timer
-- | while a notice is showing and stops asking once `DismissNotice` has
-- | emptied it, which is also what lets the next delete arm a fresh one.
viewNotice :: Maybe String -> Html Msg
viewNotice notice = case notice of
  Nothing -> div [ hidden true ] []
  Just msg ->
    div
      [ className "notice", style [ color "#666" ] ]
      [ text msg
      , button [ onClick DismissNotice ] [ text "x" ]
      ]

viewTodo :: Maybe Int -> String -> Todo -> Html Msg
viewTodo editing editText todo =
  li
    [ key ("todo-" <> show todo.id)
    , className (if todo.completed then "completed" else "")
    ]
    ( case editing of
        Just editId | editId == todo.id ->
          [ input
              [ type_ "text"
              , value editText
              , onInput UpdateEditText
              , onKeydown' EditKeyDown
              , onBlur CommitEdit
              ]
              []
          ]
        _ ->
          [ input
              [ type_ "checkbox"
              , checked todo.completed
              , onChange (ToggleTodo todo.id)
              ]
              []
          , span
              [ onDblclick (StartEdit todo.id todo.text)
              , style
                  ( if todo.completed then
                      [ textDecoration "line-through", color "#999" ]
                    else
                      []
                  )
              ]
              [ text todo.text ]
          , button [ onClick (AskRenameTodo todo.id todo.text) ] [ text "rename" ]
          , button [ onClick (AskDeleteTodo todo.id) ] [ text "x" ]
          ]
    )

viewFilterButton :: Filter -> Filter -> Html Msg
viewFilterButton current f =
  button
    [ onClick (SetFilter f)
    , data_ "filter" (filterName f)
    , style (if current == f then [ fontWeight "bold" ] else [])
    ]
    [ text (filterName f) ]

-- entry point
--------------

-- subscriptions
-----------------
-- Re-run after every update, so unchecking a box below actually detaches the
-- resize listener or clears the interval, rather than just ignoring them.
-- The timeout is the odd one out: it is one-shot, and only re-arms because
-- the update that handles its message drops it from this list.

subscriptions :: Model -> Array (Subscription Msg)
subscriptions model =
  (if model.watchingResize then [ onWindowEvent "resize" WindowResized ] else [])
    <> (if model.ticking then [ onInterval 1000 Tick, onInterval 1000 Blink ] else [])
    <> (case model.notice of
          Just _ -> [ onTimeout 2500 DismissNotice ]
          Nothing -> [])

app :: App Msg Model
app = createApp { init, view, update, next, subscriptions }

main :: Effect Unit
main = onDocumentReady do
  -- Load is dispatched as the boot message so `next` can restore from storage
  rootNode <- runApp app (Just Load)
  container <- getElementById "app"
  appendChildNode container rootNode
