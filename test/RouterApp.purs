module Test.RouterApp (main) where

-- A routed multi-screen app, in Hash mode so it runs straight from a
-- file:// URL. It exercises the whole routing surface: link navigation
-- through plain anchors, programmatic navigation from `next`, the back
-- button, a query parameter, an opted-out external link, a form that
-- navigates without reloading, and the entry effect that fires for the
-- initial route before anything is painted.

import Oak

import Oak.Css (color, fontWeight, marginRight, textDecoration)
import Oak.Html.Attribute (href, placeholder, rel, style, target, type_, value)
import Oak.Navigation as Nav
import Oak.Subscription (Subscription)
import Test.RouterRoutes (Route(..), parse, print)

import Prelude hiding (div)

import Data.Array (filter, find)
import Data.Int as Int
import Effect (Effect)
import Effect.Class.Console (log)

type Note =
  { id :: Int
  , title :: String
  , tag :: String
  , body :: String
  }

notes :: Array Note
notes =
  [ { id: 1
    , title: "The runtime owns the router"
    , tag: "design"
    , body: "Because the router lives inside runApp, it can intercept link \
            \clicks in JavaScript and hand the URL straight to onNavigate. \
            \Neither payload-carrying subscriptions nor a preventDefault \
            \attribute turned out to be necessary."
    }
  , { id: 2
    , title: "Hash mode runs from a file:// URL"
    , tag: "design"
    , body: "history.pushState throws on a file: origin, so this example \
            \uses Hash mode and opens with no server at all. Path mode is \
            \the same app with one field changed."
    }
  , { id: 3
    , title: "State survives navigation"
    , tag: "runtime"
    , body: "The counter in the footer keeps climbing as you move around. \
            \Screens are branches of one view function, not apps that get \
            \mounted and torn down, so nothing is lost on the way."
    }
  ]

type Model =
  { route :: Route
  , visits :: Int
  , jumpTo :: String
  }

data Msg
  = RouteChanged Route
  | Navigate String
  | GoBack
  | UpdateJump String
  | SubmitJump

derive instance eqMsg :: Eq Msg

-- The runtime folds the real URL through `update` before the first render,
-- so this placeholder is never actually painted.
init :: Model
init = { route: Home, visits: 0, jumpTo: "" }

update :: Msg -> Model -> Model
update msg model = case msg of
  -- arriving anywhere clears the jump box
  RouteChanged route ->
    model { route = route, visits = model.visits + 1, jumpTo = "" }
  UpdateJump draft -> model { jumpTo = draft }
  Navigate _ -> model
  GoBack -> model
  SubmitJump -> model

next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next msg model _ = case msg of
  Navigate path -> Nav.push path
  GoBack -> Nav.back
  -- `next` sees the model as `update` left it, so the jump box has to keep
  -- its value until after the navigation reads it.
  SubmitJump -> case Int.fromString model.jumpTo of
    Just n -> Nav.push (print (NoteDetail n))
    Nothing -> Nav.push (print NotFound)
  UpdateJump _ -> mempty
  -- An entry effect. The initial route gets this too, which is how a screen
  -- would kick off the fetch for the data it needs.
  RouteChanged route -> log ("entered " <> print route)

-- this app listens to nothing outside its own view
subscriptions :: Model -> Array (Subscription Msg)
subscriptions _ = []

-- views
--------

view :: Model -> Html Msg
view model =
  div []
    [ header []
        [ h1 [] [ text "Oak Router" ]
        , navBar model.route
        ]
    , section [] [ screen model.route ]
    , hr [] []
    , footer []
        [ small []
            [ text ("navigations this session: " <> show model.visits)
            , text " — the counter survives every route change"
            ]
        , div []
            [ button [ onClick GoBack, style [ marginRight "0.5rem" ] ]
                [ text "Back" ]
            , button [ onClick (Navigate (print (NoteDetail 2))) ]
                [ text "Jump to note 2 (Nav.push)" ]
            ]
        , jumpForm model
        ]
    ]

-- A real form, with Enter-to-submit and a submit button. `onSubmit` cancels
-- the browser's own submission, so this navigates like anything else rather
-- than reloading the page and throwing the model away -- watch the counter
-- above keep climbing.
jumpForm :: Model -> Html Msg
jumpForm model =
  form [ onSubmit SubmitJump ]
    [ input
        [ type_ "text"
        , value model.jumpTo
        , placeholder "note number"
        , onInput UpdateJump
        , style [ marginRight "0.5rem" ]
        ]
        []
    , button [ type_ "submit" ] [ text "Jump (form submit)" ]
    ]

navBar :: Route -> Html Msg
navBar current =
  nav []
    ( map (navLink current)
        [ Home
        , NoteList Nothing
        , NoteList (Just "design")
        , Settings
        ]
    )

-- A plain anchor with a real href. The runtime intercepts the click, so
-- this navigates without a page load -- but middle-click and "copy link
-- address" still do what anyone would expect them to.
navLink :: Route -> Route -> Html Msg
navLink current route =
  a
    [ href (print route)
    , style
        ( [ marginRight "1rem" ]
            <> if route == current then [ fontWeight "bold" ] else []
        )
    ]
    [ text (routeLabel route) ]

routeLabel :: Route -> String
routeLabel = case _ of
  Home -> "Home"
  NoteList Nothing -> "All notes"
  NoteList (Just t) -> "Tagged " <> t
  NoteDetail n -> "Note " <> show n
  TagView t -> "#" <> t
  Settings -> "Settings"
  NotFound -> "Not found"

screen :: Route -> Html Msg
screen route = case route of
  Home ->
    div []
      [ h2 [] [ text "A routed Oak app" ]
      , p []
          [ text "Every link below is an ordinary "
          , code [] [ text "a [ href ... ]" ]
          , text ". The URL in the bar is real: bookmark it, reload, or use \
                 \the browser's own back button and you land on the same screen."
          ]
      , p [] [ a [ href (print (NoteList Nothing)) ] [ text "Browse the notes →" ] ]
      ]

  NoteList tag ->
    let
      shown = case tag of
        Nothing -> notes
        Just t -> filter (\note -> note.tag == t) notes
    in
      div []
        [ h2 [] [ text (routeLabel (NoteList tag)) ]
        , case tag of
            Nothing -> empty
            Just _ ->
              p []
                [ small []
                    [ text "filtered by the "
                    , code [] [ text "?tag=" ]
                    , text " query parameter"
                    ]
                ]
        , ul [] (map noteRow shown)
        ]

  NoteDetail n -> case find (\note -> note.id == n) notes of
    Just note ->
      div []
        [ h2 [] [ text note.title ]
        , p [] [ text note.body ]
        , p [] [ a [ href (print (TagView note.tag)) ] [ text ("#" <> note.tag) ] ]
        ]
    Nothing ->
      div []
        [ h2 [] [ text "No such note" ]
        , p [] [ text ("There is no note " <> show n <> ".") ]
        ]

  TagView t ->
    div []
      [ h2 [] [ text ("Notes tagged " <> t) ]
      , ul [] (map noteRow (filter (\note -> note.tag == t) notes))
      ]

  Settings ->
    div []
      [ h2 [] [ text "Settings" ]
      , p [] [ text "Nothing to configure — this screen exists to prove that \
                    \deep links work." ]
      , p []
          [ a
              [ href "https://pursuit.purescript.org/packages/purescript-oak"
              , rel "external"
              , target "_blank"
              ]
              [ text "Oak on Pursuit" ]
          , small [ style [ color "#666" ] ]
              [ text " — rel=\"external\" opts this link out of the router" ]
          ]
      ]

  NotFound ->
    div []
      [ h2 [] [ text "Not found" ]
      , p []
          [ text "No route matched. Try "
          , a [ href (print Home) ] [ text "going home" ]
          , text "."
          ]
      ]

noteRow :: Note -> Html Msg
noteRow note =
  li []
    [ a [ href (print (NoteDetail note.id)) ] [ text note.title ]
    , small [ style [ color "#666", textDecoration "none" ] ]
        [ text ("  #" <> note.tag) ]
    ]

-- wiring
---------

app :: App Msg Model
app =
  createRoutedApp
    { init
    , view
    , update
    , next
    , subscriptions
    , mode: Hash
    , onNavigate: \url -> RouteChanged (parse url)
    }

main :: Effect Unit
main = onDocumentReady do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
