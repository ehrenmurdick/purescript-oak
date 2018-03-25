module Main (main) where

import Prelude
  ( (+)
  , (-)
  , Unit
  , show
  )

import Control.Monad.Eff (Eff)

import Oak
  ( createApp
  , embed
  )
import Oak.Html
  ( Html
  , button
  , div
  , p
  , text
  , input
  )
import Oak.Html.Events
  ( onClick
  , onInput
  )
import Oak.Css
  ( backgroundImage
  , fontSize
  , backgroundSize
  , backgroundPosition
  )
import Oak.Html.Attribute
  ( Attribute
  , value
  , style
  )
import Oak.VirtualDom.Native (DOM)


type Model =
  { n :: Int
  , message :: String
  }

data Msg
  = Inc
  | Dec
  | SetMessage String

divStyle :: Attribute Msg
divStyle =
  style
    [ backgroundImage "url(http://placehold.it/200)"
    , backgroundSize "cover"
    , backgroundPosition "center"
    , fontSize "10px"
    ]

view :: Model -> Html Msg
view model = div []
  [ button [ onClick Inc ] [ text "+" ]
  , p [] [ text (show model.n) ]
  , div [ divStyle ]
    [ input [ onInput SetMessage, value model.message ] []
    , div [] [ text model.message ]
    ]
  , button [ onClick Dec ] [ text "-" ]
  ]

update :: Msg -> Model -> Model
update Inc model = model { n = model.n + 1 }
update Dec model = model { n = model.n - 1 }
update (SetMessage str) model = model { message = str }

init :: Model
init =
  { n: 0
  , message: ""
  }

main :: Eff (dom :: DOM) Unit
main =
  embed "app" (createApp
    { init: init
    , view: view
    , update: update
    })
