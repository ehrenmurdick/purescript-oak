module Main where

import Prelude
  ( (+)
  , (-)
  , show
)

import Oak
  ( createApp
  , App
  )

import Oak.HTML
  ( text
  , div
  , button
  , input
  , br
  , HTML
  )

import Oak.HTML.Attributes
  ( Attribute
  , onClick
  , onInput
  , style
  )

import Oak.HTML.Style
  ( backgroundColor
  , fontWeight
  )

type Model =
  { number :: Int
  , message :: String
  }

data Msg
  = Inc
  | Dec
  | SetMessage String

myStyle :: Attribute Msg
myStyle = style [ backgroundColor "peachpuff"
                , fontWeight "bold"
                ]

view :: Model -> (HTML Msg)
view model = div [] [ div [myStyle] [ text (show model.number)
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
