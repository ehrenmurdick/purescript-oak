module Main where

import Prelude ( (+)
               , (-)
               , show
               )

import Oak ( createApp
           , text
           , div
           , Tag
           , App
           , button
           , onClick
           )

type Model =
  { number :: Int }

data Msg = Inc | Dec

view :: Model -> (Tag Msg)
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
