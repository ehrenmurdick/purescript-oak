module Oak
  ( createApp
  , HTML
  , App
  , text
  ) where

data App = App

data HTML msg = HTML

text :: forall msg. String -> HTML msg
text _ = HTML

createApp :: forall msg model.
  { init :: model
  , update :: msg -> model -> model
  , view :: model -> HTML msg
  } -> App
createApp opts = App
