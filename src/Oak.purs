module Oak
  ( createApp
  , App
  , VirtualDOM
  , NativeDOM
  ) where

import Oak.HTML (HTML(..))
import Prelude (map)

foreign import data VirtualDOM :: Type
foreign import data NativeDOM :: Type

type NativeOptions = {}

type App = { rootNode :: NativeDOM }

data ApplicationState msg model =
  ApplicationState { model :: model
                   , rootNode :: NativeDOM
                   , tree :: VirtualDOM
                   , update :: msg -> model -> model
                   , view :: model -> HTML msg
                   }

createApp :: forall msg model.
             { init :: model
             , update :: msg -> model -> model
             , view :: model -> (HTML msg)
             } -> App
createApp {init, update, view} =
  let
    model = init
    rendered = render (view model)
    rootNode = nativeCreateElement rendered
    app = ApplicationState { model: model
                           , update: update
                           , rootNode: rootNode
                           , view: view
                           , tree: rendered
                           }
  in
    { rootNode: rootNode }

foreign import nativeText :: String -> VirtualDOM
foreign import nativeTag :: String -> NativeOptions -> Array VirtualDOM -> VirtualDOM
foreign import nativeCreateElement :: VirtualDOM -> NativeDOM

render :: forall msg. HTML msg -> VirtualDOM
render (Text str) = nativeText str
render (HTML {name, children, options}) = nativeTag name {} (map render children)
