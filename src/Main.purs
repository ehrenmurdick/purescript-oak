module Main where

import Prelude
  ( Unit
  , bind
  , ($)
  )


import Control.Monad.Eff
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Either
import Data.Array
import Data.Maybe
import Data.Map as M
import Data.Functor
import Data.String.Regex
import Data.String.Regex.Flags
import Partial.Unsafe
  ( unsafePartialBecause
  )


import Oak
import Oak.Html
  ( Html
  , div
  , li
  , text
  , textarea
  , ul
  )
import Oak.Html.Events
import Oak.Cmd
import Oak.Document
  ( getElementById
  , appendChildNode
  , DOM
  )
import Oak.Debug


type Model =
  { emailBody :: String
  , fields :: Array String
  , rows :: Array Row
  }


type Row = M.Map String String

-- fields: [
--   "name",
--   "thing"
-- ]

-- rows: [
--   { name: "Ehren", thing: "" }
-- ]


data Msg
  = OnEmailBodyUpdate String


fieldRegex :: Regex
fieldRegex =
  unsafePartialBecause "hard coded regex"
    $ fromRight
    $ regex "\\$\\{[^}]+\\}" global


flatten :: ∀ a. Array (Maybe a) -> Array a
flatten ary =
  unsafePartialBecause "All nothings removed"
    $ map fromJust (filter isJust ary)

-- match :: Regex -> String -> Maybe (Array (Maybe String))

getFieldsFromBody :: String -> Array String
getFieldsFromBody body =
  case match fieldRegex body of
    Nothing -> []
    Just fields -> flatten fields

update :: Msg -> Model -> Model
update (OnEmailBodyUpdate value) model =
  model
    { emailBody = value
    , fields = trace $ getFieldsFromBody value
    }


next :: Msg -> Model -> Cmd () Msg
next _ _ = none


view :: Model -> Html Msg
view model =
  div []
    [ div [] [ text model.emailBody ]
    , textarea [ onInput OnEmailBodyUpdate ] [ text model.emailBody ]
    , ul [] $ map renderField model.fields
    ]

renderField :: String -> Html Msg
renderField name = li [] [ text name ]



init :: Model
init = { emailBody: ""
       , fields: []
       , rows: []
       }


app :: App () Model Msg
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
