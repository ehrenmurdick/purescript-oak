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

import Oak

import Prelude hiding (div)
import Effect

type Model = { number :: Int }

data Msg
  = Inc
  | Dec

view :: Model -> Html Msg
view model = div []
  [ div []
      [ button [ onClick Inc ] [ text "+" ]
      , text $ show model.number
      ]
  , div []
      [ button [ onClick Dec ] [ text "-" ]
      , text $ show model.number
      ]
  ]

next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next msg mod h = mempty

update :: Msg -> Model -> Model
update msg model = case msg of
  Inc -> model { number = model.number + 1 }
  Dec -> model { number = model.number - 1 }

init :: Model
init = { number: 0 }

app :: App Msg Model
app = createApp { init, view, update, next }

main :: Effect Unit
main = do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
```
