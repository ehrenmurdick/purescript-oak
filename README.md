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

import Effect (Effect)

import Oak
import Oak.Html ( Html, div, text, button )
import Oak.Cmd
import Oak.Html.Events
import Oak.Document


type Model =
  { number :: Int
  }


data Msg
  = Inc
  | Dec


view :: Model -> Html Msg
view model =
  div []
    [ button [ onClick Inc ] [ text "+" ]
    , div [] [ text model.number ]
    , button [ onClick Dec ] [ text "-" ]
    ]


next :: Msg -> Model -> Cmd Msg
next _ _ = none

update :: Msg -> Model -> Model
update Inc model =
  model { number = model.number + 1 }
update Dec model =
  model { number = model.number - 1 }


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
