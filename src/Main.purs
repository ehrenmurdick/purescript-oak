module Main where

import Oak ( createApp
           , text
           , div
           , Tag
           , App
           , button
           )

type Model =
  { }

data Msg = None

view :: Model -> Tag
view model = div {} [ text "hello"
                    , button {} [text "+"]
                    ]

update :: Msg -> Model -> Model
update msg model = model

init :: Model
init = {}

main :: App
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
