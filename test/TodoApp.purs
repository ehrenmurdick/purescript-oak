module Test.TodoApp (main) where

-- This app exists to exercise Oak end-to-end: every Attribute constructor
-- (SimpleAttribute, BooleanAttribute, DataAttribute, Style, EventHandler,
-- StringEventHandler, KeyPressEventHandler), a spread of Html tags, the
-- Oak.Css style helpers, the Either/Maybe re-exports, the `next` command
-- pattern, Oak.Window's native dialogs, Oak.Subscription's window events,
-- Oak.Storage's JSON persistence, and Oak.Document's ready/mount lifecycle
-- -- wired up as a working todo list.

import Oak hiding (data_)
import Oak.Storage as Storage
import Oak.Subscription (Subscription, onWindowEvent)
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
  | Load
  | Loaded (Array Todo)

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
  DeleteTodo tid -> model { todos = filter (\t -> t.id /= tid) model.todos }
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
  Load -> model
  Loaded todos -> model
    { todos = todos
    , nextId = fromMaybe 0 (maximum (map _.id todos)) + 1
    }

-- next (command pattern -- persistence, logging, and the Oak.Window dialogs,
-- which feed their answers back in through `continue`)
------------------------------------------------------------------------

todosKey :: String
todosKey = "oak.todos"

next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next msg model continue = case msg of
  -- the boot message: it reads storage rather than writing to it, so it must
  -- not fall through to the save below
  Load -> do
    stored <- Storage.get Storage.localStorage todosKey
    case stored of
      Just todos -> continue (Loaded todos)
      Nothing -> log "no saved todos, starting from the defaults"
  _ -> do
    announce msg continue
    saved <- Storage.set Storage.localStorage todosKey model.todos
    if saved then pure unit else log "could not save todos"

-- | The logging/dialog half of `next`, split out so every message can fall
-- | through to the save above.
announce :: Msg -> (Msg -> Effect Unit) -> Effect Unit
announce msg continue = case msg of
  AddTodo -> log "added a todo (button)"
  DraftKeyDown code | code == 13 -> log "added a todo (enter key)"
  AskDeleteTodo tid ->
    confirm "Delete this todo?" \ok ->
      if ok then continue (DeleteTodo tid) else log "delete cancelled"
  DeleteTodo tid -> log ("deleted todo " <> show tid)
  AskRenameTodo tid currentText ->
    prompt' "Rename this todo:" currentText case _ of
      Just t | t /= "" -> continue (RenameTodo tid t)
      Just _ -> alert "A todo can't be empty."
      Nothing -> log "rename cancelled"
  RenameTodo tid _ -> log ("renamed todo " <> show tid)
  ClearCompleted -> alert' "Cleared the completed todos." (log "cleared completed todos")
  ToggleWatchResize -> log "toggled the resize subscription"
  WindowResized -> log "window resized"

  _ -> pure unit

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
        ]
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
-- Re-run after every update, so unchecking the box below actually detaches
-- the resize listener rather than just ignoring it.

subscriptions :: Model -> Array (Subscription Msg)
subscriptions model =
  if model.watchingResize then [ onWindowEvent "resize" WindowResized ] else []

app :: App Msg Model
app = createApp { init, view, update, next, subscriptions }

main :: Effect Unit
main = onDocumentReady do
  -- Load is dispatched as the boot message so `next` can restore from storage
  rootNode <- runApp app (Just Load)
  container <- getElementById "app"
  appendChildNode container rootNode
