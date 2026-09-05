module Oak.Window
  ( alert
  , alert'
  , confirm
  , prompt
  , prompt'
  ) where

import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Prelude (Unit, pure, unit, (<<<))

foreign import alertImpl :: Fn2 String (Effect Unit) (Effect Unit)

foreign import confirmImpl :: Fn2 String (Boolean -> Effect Unit) (Effect Unit)

foreign import promptImpl :: Fn3 String String (Nullable String -> Effect Unit) (Effect Unit)

-- | Show a native alert box. Fire and forget -- the rest of your `next`
-- | continues immediately, without waiting for the user to dismiss it.
alert :: String -> Effect Unit
alert message = alert' message (pure unit)

-- | Show a native alert box and run the given effect once it is dismissed.
alert' :: String -> Effect Unit -> Effect Unit
alert' = runFn2 alertImpl

-- | Show a native confirmation box and hand the answer to the callback.
-- | Written to be composed with the `continue` function `next` is given:
-- |
-- | ```purescript
-- | next (AskDelete tid) _ continue =
-- |   confirm "Delete this todo?" \ok ->
-- |     if ok then continue (Delete tid) else pure unit
-- | ```
confirm :: String -> (Boolean -> Effect Unit) -> Effect Unit
confirm = runFn2 confirmImpl

-- | Show a native prompt box with an empty input. The callback gets `Nothing`
-- | if the user cancelled.
prompt :: String -> (Maybe String -> Effect Unit) -> Effect Unit
prompt message = prompt' message ""

-- | `prompt` with the input prefilled with the given default value.
prompt' :: String -> String -> (Maybe String -> Effect Unit) -> Effect Unit
prompt' message defaultValue k = runFn3 promptImpl message defaultValue (k <<< toMaybe)
