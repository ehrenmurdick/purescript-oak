-- | `Oak.Window`'s native dialogs, as commands.
-- |
-- | A dialog answers by sending a message, so every way it can be answered
-- | needs one -- including being cancelled:
-- |
-- | ```purescript
-- | import Oak.Window.Cmd as Window
-- |
-- | next (AskDeleteTodo tid) _ =
-- |   Window.confirm "Delete this todo?" \ok ->
-- |     if ok then DeleteTodo tid else DeleteCancelled
-- | ```
module Oak.Window.Cmd
  ( alert
  , alert'
  , confirm
  , prompt
  , prompt'
  ) where

import Data.Maybe (Maybe)
import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Oak.Window as Window

-- | Show a native alert box. The command is finished as soon as the box is
-- | up, without waiting for it to be dismissed.
alert :: ∀ msg. String -> Cmd msg
alert message = Cmd.effect (Window.alert message)

-- | Show a native alert box and send a message once it is dismissed.
alert' :: ∀ msg. String -> msg -> Cmd msg
alert' message msg = Cmd.callback \send -> Window.alert' message (send msg)

-- | Show a native confirmation box and turn the answer into a message.
confirm :: ∀ msg. String -> (Boolean -> msg) -> Cmd msg
confirm message toMsg = Cmd.ask (Window.confirm message) toMsg

-- | Show a native prompt box with an empty input. The tagger gets `Nothing`
-- | if the user cancelled.
prompt :: ∀ msg. String -> (Maybe String -> msg) -> Cmd msg
prompt message toMsg = Cmd.ask (Window.prompt message) toMsg

-- | `prompt` with the input prefilled with the given default value.
prompt' :: ∀ msg. String -> String -> (Maybe String -> msg) -> Cmd msg
prompt' message defaultValue toMsg = Cmd.ask (Window.prompt' message defaultValue) toMsg
