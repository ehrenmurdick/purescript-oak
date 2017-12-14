module Oak
  ( createApp
  , Tag
  , text
  , div
  , App
  , button
  , TagOption
  , onClick
  ) where

foreign import data App :: Type

foreign import nativeCreateApp :: forall a. a -> App

data Tag msg =
  Tag { name     :: String
      , children :: Array (Tag msg)
      , options  :: Array (TagOption msg)
      }
  | Text String

data TagOption msg =
  OnClick msg

onClick :: forall msg. msg -> TagOption msg
onClick a = OnClick a

text :: forall msg. String -> Tag msg
text s = Text s

div :: forall msg. Array (TagOption msg) -> Array (Tag msg) -> (Tag msg)
div opts children = Tag {name: "div", children: children, options: opts}

button :: forall msg. Array (TagOption msg) -> Array (Tag msg) -> (Tag msg)
button opts children = Tag {name: "button", children: children, options: opts}

createApp :: forall msg model.
             { init :: model
             , update :: msg -> model -> model
             , view :: model -> (Tag msg)
             } -> App
createApp opts = nativeCreateApp opts
