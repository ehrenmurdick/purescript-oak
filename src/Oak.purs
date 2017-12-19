module Oak
  ( createApp
  , App
  ) where

import Oak.HTML (HTML)

foreign import data App :: Type

foreign import nativeCreateApp :: forall a. a -> App

createApp :: forall msg model.
             { init :: model
             , update :: msg -> model -> model
             , view :: model -> HTML msg
             } -> App
createApp opts = nativeCreateApp opts
