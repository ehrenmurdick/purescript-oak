module Main where

import Oak
import Prelude ((+), show)

type Model =
  { n :: Int
  }

data Msg
  = None

view :: Model -> Html Msg
view model = div [] [ text (show model.n) ]

update :: Msg -> Model -> Model
update _ model = model { n = model.n + 1 }

init :: Model
init = { n: 0
       }

main :: App Model Msg
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
