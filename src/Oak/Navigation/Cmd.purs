-- | `Oak.Navigation`, as commands.
-- |
-- | ```purescript
-- | import Oak.Navigation.Cmd as Nav
-- |
-- | next :: Msg -> Model -> Cmd Msg
-- | next msg _ = case msg of
-- |   GoTo route -> Nav.push (print route)
-- |   GoBack     -> Nav.back
-- |   _          -> Cmd.none
-- | ```
-- |
-- | As in `Oak.Navigation`, paths are written the way the app thinks of them
-- | -- `"/todos/42"`, never `"#/todos/42"` -- and following a link needs
-- | none of this, since the runtime intercepts anchor clicks itself.
module Oak.Navigation.Cmd
  ( back
  , forward
  , load
  , push
  , replace
  ) where

import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Oak.Navigation as Nav

-- | Navigate to a path, adding a history entry.
push :: ∀ msg. String -> Cmd msg
push path = Cmd.effect (Nav.push path)

-- | Navigate to a path, rewriting the current history entry.
replace :: ∀ msg. String -> Cmd msg
replace path = Cmd.effect (Nav.replace path)

-- | Leave the app entirely, with a full page load.
load :: ∀ msg. String -> Cmd msg
load url = Cmd.effect (Nav.load url)

-- | Go back one entry, as the browser's back button does.
back :: ∀ msg. Cmd msg
back = Cmd.effect Nav.back

-- | Go forward one entry.
forward :: ∀ msg. Cmd msg
forward = Cmd.effect Nav.forward
