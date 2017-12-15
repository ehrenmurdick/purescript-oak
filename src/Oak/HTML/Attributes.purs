module Oak.HTML.Attributes ( onClick
                           , Attribute
                           , onInput
                           , style
                           ) where

import Oak.HTML.Style
  ( Property  
  )

data Attribute msg = OnClick msg
                   | OnInput (String -> msg)
                   | Style (Array Property)

onClick :: forall msg. msg -> Attribute msg
onClick = OnClick

onInput :: forall msg. (String -> msg) -> Attribute msg
onInput = OnInput

style :: forall msg. Array Property -> Attribute msg
style = Style
