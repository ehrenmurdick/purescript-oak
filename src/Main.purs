module Main where

import Oak
import Prelude ((-), (+), show)

type Model =
  { n :: Int
  }

data Msg
  = Inc
  | Dec

view :: Model -> Html Msg
view model = div []
  [ button [ onClick Inc ] [ text "+" ]
  , p [] [ text (show model.n) ]
  , button [ onClick Dec ] [ text "-" ]
  ]

update :: Msg -> Model -> Model
update Inc model = model { n = model.n + 1 }
update Dec model = model { n = model.n - 1 }

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
