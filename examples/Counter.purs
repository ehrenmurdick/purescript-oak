module Examples.Counter (main) where


-- this is the example app featured in the README

import Oak
import Oak.Cmd (Cmd)
import Oak.Subscription (Subscription)

import Prelude hiding (div)
import Effect

type Model = { number :: Int }

data Msg
  = Inc
  | Dec

-- | `runApp` reconciles subscriptions by comparing messages, so every message
-- | type needs this -- even in an app like this one that subscribes to
-- | nothing.
derive instance eqMsg :: Eq Msg

view :: Model -> Html Msg
view model = div []
  [ div []
      [ button [ onClick Inc ] [ text "+" ]
      , text $ show model.number
      ]
  , div []
      [ button [ onClick Dec ] [ text "-" ]
      , text $ show model.number
      ]
  ]

-- this app has nothing for the runtime to do
next :: Msg -> Model -> Cmd Msg
next msg mod = mempty

update :: Msg -> Model -> Model
update msg model = case msg of
  Inc -> model { number = model.number + 1 }
  Dec -> model { number = model.number - 1 }

init :: Model
init = { number: 0 }

-- this app doesn't listen to anything outside its own view
subscriptions :: Model -> Array (Subscription Msg)
subscriptions _ = []

app :: App Msg Model
app = createApp { init, view, update, next, subscriptions }

main :: Effect Unit
main = do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
