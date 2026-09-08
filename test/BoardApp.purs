module Test.BoardApp
  ( CardId
  , Card
  , Column
  , ColumnId
  , Model
  , Msg(..)
  , Slot(..)
  , init
  , main
  , update
  ) where

-- A drag-and-drop board, which exercises the HTML5 drag protocol end to end:
-- `onDragstartWith` putting a payload on the drag, `allowDrop` and `onDrop'`
-- picking it up again, `onDragenter` tracking what is being hovered, and
-- `Oak.Subscription`'s payload-carrying window events catching the parts of
-- a drag no element sees.
--
-- Cards reorder within a column and move between columns through the same
-- two messages, because both are the same thing to the model: take the card
-- out of wherever it is, and put it back at the slot that was dropped on.

import Oak
import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Oak.Html.Attribute (className, draggable, id_, key)
import Oak.Html.Events (allowDrop, onDragstartWith, onDrop')
import Oak.Subscription (Subscription, onWindowDragEnd, onWindowDrop)

import Prelude hiding (div)

import Data.Array (filter, findIndex, insertAt, last, length, snoc, take)
import Data.Foldable (find)
import Data.Int (fromString, round)
import Data.Maybe (fromMaybe)
import Effect (Effect)
import Effect.Class.Console (log)

type CardId = Int

type ColumnId = String

type Card = { id :: CardId, title :: String, owner :: String }

type Column = { id :: ColumnId, name :: String, cards :: Array Card }

-- | Where a drop puts the card it is carrying.
-- |
-- | Both cases are drop *targets* in the view -- a card, and the strip of
-- | space at the bottom of a column -- which is what lets one `Dropped`
-- | message cover reordering and moving between columns alike.
data Slot
  = Before CardId
  | EndOf ColumnId

derive instance eqSlot :: Eq Slot

instance showSlot :: Show Slot where
  show (Before cid) = "Before " <> show cid
  show (EndOf colId) = "EndOf " <> show colId

type Model =
  { columns :: Array Column
  , dragging :: Maybe CardId
  , hovering :: Maybe Slot
  , lastDrop :: Maybe { x :: Int, y :: Int }
  , moves :: Array String
  }

data Msg
  = Grabbed CardId
  -- | The payload comes back as a string, because `dataTransfer` is the only
  -- | thing the browser will carry across a drag.
  | Dropped Slot String
  | Hovering Slot
  | DragEnded
  | DroppedAt Number Number

-- | Needed by `runApp` to reconcile subscriptions -- and this app has two
-- | that come and go with the drag.
derive instance eqMsg :: Eq Msg

-- model
--------

init :: Model
init =
  { columns:
      [ { id: "todo"
        , name: "Todo"
        , cards:
            [ { id: 1, title: "Payload-carrying attributes", owner: "attr" }
            , { id: 2, title: "Window drag subscriptions", owner: "sub" }
            , { id: 3, title: "Keyboard reordering", owner: "a11y" }
            ]
        }
      , { id: "doing"
        , name: "In progress"
        , cards:
            [ { id: 4, title: "preventDefault on dragover", owner: "vdom" }
            ]
        }
      , { id: "done"
        , name: "Done"
        , cards:
            [ { id: 5, title: "Keyed list reordering", owner: "vdom" }
            , { id: 6, title: "Preventing event handlers", owner: "attr" }
            ]
        }
      ]
  , dragging: Nothing
  , hovering: Nothing
  , lastDrop: Nothing
  , moves: []
  }

-- update
---------

findCard :: CardId -> Array Column -> Maybe Card
findCard cid columns = case find (\col -> hasCard cid col) columns of
  Nothing -> Nothing
  Just col -> find (\c -> c.id == cid) col.cards

hasCard :: CardId -> Column -> Boolean
hasCard cid col = case find (\c -> c.id == cid) col.cards of
  Just _ -> true
  Nothing -> false

columnOf :: CardId -> Array Column -> Maybe ColumnId
columnOf cid columns = map _.id (find (hasCard cid) columns)

without :: CardId -> Column -> Column
without cid col = col { cards = filter (\c -> c.id /= cid) col.cards }

-- | Put the card back, in the one column the slot names. Every other column
-- | is handed back untouched, so a move out of a column and into another is
-- | just this run across the whole board after `without` has taken the card
-- | out of all of them.
place :: Card -> Slot -> Column -> Column
place card slot col = case slot of
  EndOf colId ->
    if colId == col.id then col { cards = snoc col.cards card } else col
  Before target -> case findIndex (\c -> c.id == target) col.cards of
    -- the index is computed after the card has been removed, which is what
    -- makes "before this card" mean the same thing whether the card came
    -- from this column or another one
    Just i -> col { cards = fromMaybe col.cards (insertAt i card col.cards) }
    Nothing -> col

-- | A drop that would put the card back exactly where it started. Worth
-- | catching: it is the most common thing a user does by accident, and
-- | logging it as a move would be a lie.
noMove :: CardId -> Slot -> Model -> Boolean
noMove cid slot model = case slot of
  Before target -> target == cid
  EndOf colId -> case columnOf cid model.columns of
    Just from -> from == colId && lastIn colId model.columns == Just cid
    Nothing -> false

lastIn :: ColumnId -> Array Column -> Maybe CardId
lastIn colId columns = do
  col <- find (\c -> c.id == colId) columns
  card <- last col.cards
  pure card.id

moveCard :: CardId -> Slot -> Model -> Model
moveCard cid slot model = case findCard cid model.columns of
  Nothing -> model
  Just card ->
    if noMove cid slot model then model
    else model
      { columns = map (place card slot) (map (without cid) model.columns)
      , moves = take 5 ([ describe card slot ] <> model.moves)
      }

describe :: Card -> Slot -> String
describe card slot = "#" <> show card.id <> " " <> card.title <> " -> " <> case slot of
  Before target -> "before #" <> show target
  EndOf colId -> "end of " <> colId

-- | Which card a drop is carrying.
-- |
-- | The payload is what the browser handed back, and it is the honest
-- | answer -- it is the only thing that survives a drag between two windows
-- | of the same app. It is also a string that has been out of the type
-- | system and back, so a drop that arrives unparseable falls back to the
-- | card this app watched being picked up.
grabbedCard :: String -> Model -> Maybe CardId
grabbedCard payload model = case fromString payload of
  Just cid -> Just cid
  Nothing -> model.dragging

update :: Msg -> Model -> Model
update msg model = case msg of
  Grabbed cid -> model { dragging = Just cid, hovering = Nothing }
  Hovering slot -> model { hovering = Just slot }
  -- Note what this does *not* do: it moves the card and puts the drop zones
  -- out, but it leaves `dragging` set. Ending the drag here would end it too
  -- early. Oak dispatches, updates and re-renders synchronously inside the
  -- DOM handler, so a `subscriptions` that stopped asking for the window
  -- listeners at this point would have them detached while the very `drop`
  -- event that got us here is still on its way up to the window -- and
  -- `DroppedAt` below would never arrive. `dragend` always follows `drop`,
  -- so ending the drag there is both simpler and correct.
  Dropped slot payload -> hoverOff case grabbedCard payload model of
    Nothing -> model
    Just cid -> moveCard cid slot model
  -- The other way a drag ends: cancelled with Escape, or let go over
  -- something that never allowed a drop. Neither sends a `drop` anywhere, so
  -- without this the card left behind stays dimmed for good.
  DragEnded -> cleared model
  -- The drop, heard a second time as it reaches the window. This is where a
  -- successful drag ends, and it has to be: a card dropped into a *different*
  -- column is a node virtual-dom moves between two parents, which means the
  -- node the drag started on is destroyed and rebuilt. `dragend` then fires
  -- on a node that is no longer in the document, and an event on a detached
  -- node has no window to bubble to -- so `DragEnded` never arrives for
  -- exactly the drags this app exists to demonstrate.
  DroppedAt x y -> cleared (model { lastDrop = Just { x: round x, y: round y } })

cleared :: Model -> Model
cleared model = model { dragging = Nothing, hovering = Nothing }

hoverOff :: Model -> Model
hoverOff model = model { hovering = Nothing }

-- next
-------

next :: Msg -> Model -> Cmd Msg
next msg _ = case msg of
  Grabbed cid -> Cmd.effect (log ("picked up card " <> show cid))
  Dropped _ payload -> Cmd.effect (log ("dropped, dataTransfer = " <> show payload))
  _ -> Cmd.none

-- subscriptions
----------------
-- Both only exist while a drag is in flight: the listeners go up on
-- `Grabbed` and come down on `DragEnded`, which is the cheapest way to keep
-- drag-rate events off an app that is sitting still.
--
-- The window is the only place that hears the end of a drag reliably. A drag
-- cancelled with Escape, or let go over something that never allowed a drop,
-- sends no `drop` to any element -- only `dragend`, on the card it started
-- from.

subscriptions :: Model -> Array (Subscription Msg)
subscriptions model = case model.dragging of
  Nothing -> []
  Just _ ->
    -- `dragend` fires on the card the drag started from and bubbles up, so
    -- the window hears it even when the drag ends somewhere no drop target
    -- ever saw -- outside the window, or cancelled with Escape.
    [ onWindowDragEnd (\_ -> DragEnded)
    -- and this is a payload actually being read off a subscription: the
    -- window has no idea which element was dropped on, but the event knows
    -- where the pointer was.
    , onWindowDrop (\e -> DroppedAt e.clientX e.clientY)
    ]

-- view
-------

view :: Model -> Html Msg
view model =
  div [ id_ "board" ]
    [ h1 [] [ text "Oak Board" ]
    , p [ className "hint" ]
        [ text "Drag a card onto another card to drop it above that card, or onto the strip at the foot of a column to send it to the end." ]
    , div [ className "columns" ] (map (viewColumn model) model.columns)
    , viewFooter model
    ]

viewColumn :: Model -> Column -> Html Msg
viewColumn model col =
  div [ className "column", key ("col-" <> col.id) ]
    [ h2 []
        [ text col.name
        , span [ className "count" ] [ text (show (length col.cards)) ]
        ]
    , div [ className "cards" ]
        (map (viewCard model) col.cards <> [ viewTail model col ])
    ]

viewCard :: Model -> Card -> Html Msg
viewCard model card =
  div
    [ key ("card-" <> show card.id)
    , className (cardClass model card)
    , draggable true
    -- Starts the drag *and* gives it a payload. A drag that sets no data
    -- never starts at all in Firefox, so this is the usual way in.
    , onDragstartWith (show card.id) (Grabbed card.id)
    -- A card is a drop target as well as a drag source: `allowDrop` is what
    -- makes it accept one, and it dispatches nothing, so a drag hovering
    -- here does not repaint the app on every frame.
    , allowDrop
    , onDragenter (Hovering (Before card.id))
    , onDrop' (\e -> Dropped (Before card.id) e.dataTransfer)
    ]
    [ span [ className "title" ] [ text card.title ]
    , span [ className "owner" ] [ text card.owner ]
    ]

-- | The card carries its own drag state as classes. Dimming the card being
-- | dragged is the app's doing -- the browser's drag image is a screenshot
-- | of the element either way, and it is taken before this class lands.
cardClass :: Model -> Card -> String
cardClass model card =
  "card"
    <> (if model.hovering == Just (Before card.id) then " drop-above" else "")
    <> (if model.dragging == Just card.id then " dragging" else "")

-- | The drop zone at the foot of a column.
-- |
-- | It is a strip of its own rather than the column body, deliberately.
-- | `dragenter` bubbles, so a column that was itself a drop target would
-- | hear every card's `dragenter` a moment after the card did and overwrite
-- | what is being hovered with its own answer.
viewTail :: Model -> Column -> Html Msg
viewTail model col =
  div
    [ key ("tail-" <> col.id)
    , className ("tail" <> if model.hovering == Just (EndOf col.id) then " drop-into" else "")
    , allowDrop
    , onDragenter (Hovering (EndOf col.id))
    , onDrop' (\e -> Dropped (EndOf col.id) e.dataTransfer)
    ]
    [ text (if length col.cards == 0 then "drop a card here" else "drop at the end") ]

viewFooter :: Model -> Html Msg
viewFooter model =
  footer []
    [ div [ className "drops" ]
        [ text
            ( case model.lastDrop of
                Nothing -> "no drops yet"
                Just p -> "last drop at " <> show p.x <> ", " <> show p.y <> " (from a window subscription)"
            )
        ]
    , div [ className "moves" ]
        ( if length model.moves == 0 then [ text "nothing moved yet" ]
          else map (\m -> div [] [ text m ]) model.moves
        )
    ]

-- entry point
--------------

app :: App Msg Model
app = createApp { init, view, update, next, subscriptions }

main :: Effect Unit
main = onDocumentReady do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
