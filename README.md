Oak is an implementation of the Elm architecture in Purescript.

```purescript
module Main (main) where

import Prelude
  ( Unit
  , bind
  )

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Either

import Data.Generic.Rep (class Generic)
import Data.Foreign.Class (class Decode)

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
  )
import Oak.Document
  ( getElementById
  , appendChildNode
  , DOM
  )

import Oak.Cmd
  ( Cmd
  , HTTP
  , defaultDecode
  , get
  , none
  )

data User =
  User
    { name :: String
    , id :: Int
    }

derive instance genericUser :: Generic User _

instance decodeUser :: Decode User where
  decode = defaultDecode


type Model =
  { response :: String
  , pending :: Boolean
  , user :: User
  }


data Msg
  = Go
  | SetUser (Either String User)


showUser :: User -> Html Msg
showUser (User { id, name }) =
  div []
    [ text id
    , text " "
    , text name
    ]


view :: Model -> Html Msg
view model =
  div []
    [ p [] [ text model.response ]
    , p [] [ text "request pending: ", text model.pending ]
    , p [] [ showUser model.user ]
    , button [ onClick Go ] [ text "request" ]
    ]


next :: Msg -> Model -> Cmd (http :: HTTP) Msg
next Go model =
  get "http://localhost:3000/users/1" SetUser
next _ _ = none


update :: Msg -> Model -> Model
update Go model =
    model { pending = true }

update (SetUser result) model =
  case result of
    Left err ->
      model { response = err, pending = false }
    Right user ->
      model { user = user, response = "success", pending = false }


init :: Model
init =
  { response: "pending"
  , pending: false
  , user: User { name: "", id: 0 }
  }

app :: App (http :: HTTP) Model Msg
app = createApp
  { init: init
  , view: view
  , update: update
  , next: next
  }

main :: Eff (exception :: EXCEPTION, dom :: DOM) Unit
main = do
  rootNode <- runApp app
  container <- getElementById "app"
  appendChildNode container rootNode
```
