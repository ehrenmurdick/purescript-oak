Oak is an implementation of the Elm architecture in Purescript.

```
module Main where

import Prelude ( (+)
               , (-)
               , show
               )

import Oak ( createApp, App )

import Oak.HTML ( text
                , div
                , button
                , HTML
                )

import Oak.HTML.Attributes (onClick)

type Model =
  { number :: Int }

data Msg = Inc | Dec

view :: Model -> (HTML Msg)
view model = div [] [ text (show model.number)
                    , button [(onClick Inc)] [text "+"]
                    , button [(onClick Dec)] [text "-"]
                    ]

update :: Msg -> Model -> Model
update Inc model = { number: model.number + 1 }
update Dec model = { number: model.number - 1 }

init :: Model
init = { number: 0 }

main :: App
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
```
