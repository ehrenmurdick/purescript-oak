module Oak.HTML.Style
  ( Property
  , backgroundColor
  , fontWeight
  ) where

data Property = BackgroundColor String
              | FontWeight String
              | Border String

backgroundColor :: String -> Property
backgroundColor = BackgroundColor

fontWeight :: String -> Property
fontWeight = FontWeight
