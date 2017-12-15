module Main where

import Prelude ( (+)
               , (-)
               , show
               )

import Oak ( createApp, App )

import Oak.HTML ( text
                , div
                , button
                , input
                , br
                , HTML
                )

import Oak.HTML.Attributes ( onClick
                           , onInput
                           )

type Model =
  { number :: Int
  , message :: String
  }

data Msg = Inc
         | Dec
         | SetMessage String

view :: Model -> (HTML Msg)
view model = div [] [ div [] [ text (show model.number)
                             , button [(onClick Inc)] [text "+"]
                             , button [(onClick Dec)] [text "-"]
                             ]
                    , br []
                    , div [] [ text model.message
                             , br []
                             , input [(onInput SetMessage)] []
                             ]
                    ]

update :: Msg -> Model -> Model
update Inc model = model { number = model.number + 1 }
update Dec model = model { number = model.number - 1 }
update (SetMessage s) model = model { message = s }

init :: Model
init = { number: 0
       , message: ""
       }

main :: App
main =
  createApp
    { init: init
    , view: view
    , update: update
    }
