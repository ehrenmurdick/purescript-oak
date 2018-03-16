module Main where

import Oak

type Model =
  { message :: String
  }


view :: Model -> HTML Msg
view model = div [ text model.message ]

update :: Msg -> Model -> Model
update _ model = model

init :: Model
init = { message: "fack from oak"
       }

main :: App Model Msg
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
