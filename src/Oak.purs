module Oak
  ( createApp
  , Tag
  , text
  , div
  , App
  , button
  ) where

foreign import data App :: Type

foreign import nativeCreateApp :: forall a. a -> App

data Tag =
  Tag { name     :: String
      , children :: Array Tag
      }
  | Text String

type TagOptions =
  { }

text :: String -> Tag
text s = Text s

div :: TagOptions -> Array Tag -> Tag
div opts children = Tag {name: "div", children: children}

button :: TagOptions -> Array Tag -> Tag
button opts children = Tag {name: "button", children: children}

createApp :: forall msg model.
             { init :: model
             , update :: msg -> model -> model
             , view :: model -> Tag
             } -> App
createApp opts = nativeCreateApp opts
