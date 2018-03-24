module Oak.Css where

data StyleAttribute
  = StyleAttribute String String

backgroundImage :: String -> StyleAttribute
backgroundImage val = StyleAttribute "background-image" val

fontSize :: String -> StyleAttribute
fontSize val = StyleAttribute "font-size" val
