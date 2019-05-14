Oak is an implementation of the Elm architecture in Purescript.

```
bower install purescript-oak
```

This library requires the `virtual-dom` module. You can get it by using npm to install virtual-dom.

```
npm install virtual-dom
```

Documentation is published on [pursuit](https://pursuit.purescript.org/packages/purescript-oak/).


A breif example Oak app:

```
module Main (main) where

import Prelude
  ( Unit
  , (+)
  , (-)
  , bind
  , unit
  , discard
  )

import Data.Monoid (mempty)
import Effect.Random (randomInt)

import Effect (Effect)
import Effect.Console (log)
import Oak
  ( App
  , createApp
  , runApp
  )
import Oak.Html
  ( Html
  , div
  , text
  , button
  , br
  )
import Oak.Html.Events ( onClick )
import Oak.Document
  ( appendChildNode
  , getElementById
  )


type Model =
  { number :: Int
  }


data Msg
  = Inc
  | Dec
  | GetRand
  | Set Int


view :: Model -> Html Msg
view model =
  div []
    [ button [ onClick Inc ] [ text "+" ]
    , div [] [ text model.number ]
    , button [ onClick Dec ] [ text "-" ]
    , br [] []
    , button [ onClick GetRand ] [ text "random" ]
    ]

next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next GetRand model h = do
  log "generating random int"
  n <- randomInt 0 100
  h (Set n)
next _ _ _       = mempty

update :: Msg -> Model -> Model
update msg model =
  case msg of
    Inc ->
      model { number = model.number + 1 }
    Dec ->
      model { number = model.number - 1 }
    (Set n) ->
      model { number = n }
    GetRand ->
      model

init :: Unit -> Model
init _ =
  { number: 0
  }

app :: App Model Msg Unit
app = createApp
  { init: init
  , view: view
  , update: update
  , next: next
  }

main :: Effect Unit
main = do
  rootNode <- runApp app unit
  container <- getElementById "app"
  appendChildNode container rootNode
```
