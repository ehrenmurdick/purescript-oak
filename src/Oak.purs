module Oak
  ( createApp
  , App
  , Tag
  , text
  , div
  ) where

type AppOptions = forall model msg.
  { init   :: model
  , update :: msg   -> model -> model
  , view   :: model -> Tag
  }

data Tag =
  Tag { name     :: String
      , children :: Array Tag
      }
  | Text String

type TagOptions =
  { }

foreign import data App :: Type

foreign import createAppImpl :: AppOptions -> App

text :: String -> Tag
text s = Text s

div :: TagOptions -> Array Tag -> Tag
div opts children = Tag {name: "div", children: children}

createApp :: AppOptions -> App
createApp opts = createAppImpl opts
