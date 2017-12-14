module Main where

import Oak (App, createApp, text, div, Tag)

type Model =
  { }

data Msg = None

view :: Model -> Tag
view model = div {} [text "hello"]

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
