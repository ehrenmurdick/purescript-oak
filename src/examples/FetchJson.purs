module Oak.Examples.FetchJson where

-- spago install fetch simple-json aff

import Effect (Effect)
import Effect.Aff (Aff, Error, never, runAff_)
import Effect.Class (liftEffect)
import Effect.Console (logShow)
import Fetch as F

import Oak
import Oak.Html.Attribute (for, id_)
import Simple.JSON as JSON

-- div in prelude conflicts with div in Oak.Html
import Prelude hiding (div)

type User =
  { id :: Int
  , name :: String
  }

type Model =
  { message :: String
  }

-- the GoGet msg tells next to start performing the fetch request.
-- the Got msg will be used for the response from trying to fetch a user.
data Msg
  = SetText String
  | GoGet
  | Got (Either Error User)

view :: Model -> Html Msg
view model = div []
  [ text model.message
  , div [] [ button [ onClick GoGet ] [ text "Perform GET" ] ]
  ]

-- the continue function expects a Msg, but runAff_ will call its callback with
-- Either Error a.
-- Recall that the type of the Got msg is
-- Either Error User -> Msg,
-- so we can just compose that with continue to get:
-- Either Error User -> Effect Unit
-- which is what runAff_ expects.
next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next GoGet _ continue = runAff_ (Got >>> continue) do
  (user :: User) <-
    getJson "https://jsonplaceholder.typicode.com/users//1"
  pure user
next _ _ _ = mempty

update :: Msg -> Model -> Model
update msg model = case msg of
  SetText s -> model { message = s }
  GoGet -> model { message = "performing request!" }
  Got (Left _) -> model { message = "there was an error!" }
  Got (Right user) -> model
    { message = "the user's name is " <> user.name }

init :: Model
init = { message: "" }

getJson :: ∀ a. JSON.ReadForeign a => String -> Aff a
getJson url = do
  { text } <- F.fetch url {}
  json <- text
  case (JSON.readJSON json) of
    Right (t :: a) -> pure t
    Left e -> do
      logShow_ e
      -- if there was an error, do nothing after logging.
      never

logShow_ :: ∀ a. Show a => a -> Aff Unit
logShow_ = logShow >>> liftEffect


app :: App Msg Model
app = createApp { init, view, update, next }

main :: Effect Unit
main = do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
