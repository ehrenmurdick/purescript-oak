module Main where

import Oak
  ( createApp
  , HTML
  , App
  , text
  )

type Model =
  { message :: String
  }

data Msg
  = None

view :: Model -> HTML Msg
view model = text model.message

update :: Msg -> Model -> Model
update _ model = model

init :: Model
init = { message: "hello from oak"
       }

main :: App
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
