module Oak
  ( createApp
  , App
  ) where

import Oak.HTML (HTML(..))
import Oak.Native.VirtualDOM
  ( NativeDOM
  , VirtualDOM
  , nativeCreateElement
  , nativeText
  , nativeTag
  )
  
import Prelude (map)

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


render :: forall msg. HTML msg -> VirtualDOM
render (Text str) = nativeText str
render (HTML {name, children, options}) = nativeTag name {} (map render children)
