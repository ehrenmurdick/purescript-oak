Oak is an implementation of the Elm architecture in Purescript.

```purescript
module Main (main) where

import Prelude
  ( (+)
  , (-)
  , Unit
  , bind
  )

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Tuple

import Oak
  ( runApp
  , createApp
  , App
  )
import Oak.Html
  ( Html
  , button
  , div
  , text
  , p
  )
import Oak.Html.Events
  ( onClick
  , onInput
  )
import Oak.Document
  ( getElementById
  , appendChildNode
  , DOM
  )

import Oak.Cmd

type Model =
  { response :: String
  , pending :: Boolean
  }

data Msg
  = Go

view :: Model -> Html Msg
view model =
  div []
    [ p [] [ text model.response ]
    , p [] [ text "request pending: ", text model.pending ]
    , button [ onClick Go ] [ text "request" ]
    ]


update :: Msg -> Model -> Tuple Model (Cmd (http :: HTTP) Msg)
update Go model = Tuple (model { pending = true } ) none

init :: Model
init = { response: "", pending: false }

app :: App (http :: HTTP) Model Msg
app = createApp
  { init: init
  , view: view
  , update: update
  }

main :: Eff (exception :: EXCEPTION, dom :: DOM) Unit
main = do
  rootNode <- runApp app
  container <- getElementById "app"
  appendChildNode container rootNode
```
