Oak is an implementation of the Elm architecture in Purescript.

```purescript
module Main (main) where

import Prelude
  ( Unit
  , bind
  , (<>)
  , (#)
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
  , input
  , p
  )
import Oak.Html.Attribute ( value )
import Oak.Html.Events
  ( onClick
  , onInput
  )
import Oak.Document
  ( getElementById
  , appendChildNode
  , DOM
  )

import Oak.Cmd.Time (TIME, delay, seconds)
import Oak.Cmd.Http (HTTP, get, defaultDecode)
import Oak.Cmd (Cmd , none)

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
  , userId :: String
  }


data Msg
  = Go
  | SetUser (Either String User)
  | GoLater
  | SetId String


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
    , button [ onClick GoLater ] [ text "delayed request" ]
    , input  [ onInput SetId, value model.userId ] []
    ]


next :: Msg -> Model -> Cmd (http :: HTTP, time :: TIME) Msg
next Go { userId } =
  get ("http://localhost:3000/users/" <> userId) SetUser
next GoLater _ =
  delay (2 # seconds) Go
next _ _ = none


update :: Msg -> Model -> Model
update Go model =
  model { pending = true }

update GoLater model =
  model

update (SetId id) model =
  model { userId = id }


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
  , userId: "1"
  }

app :: App (http :: HTTP, time :: TIME) Model Msg
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
