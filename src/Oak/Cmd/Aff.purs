-- | Running `Aff` from `next`.
-- |
-- | The tagger comes first here and last in the other command wrappers, so
-- | that the argument likely to span several lines -- the `Aff` itself --
-- | is the one that trails:
-- |
-- | ```purescript
-- | import Oak.Cmd.Aff as Aff
-- |
-- | next GoGet _ = Aff.attempt Got do
-- |   (user :: User) <- getJson "https://example.com/users/1"
-- |   pure user
-- | ```
module Oak.Cmd.Aff
  ( attempt
  , launch
  , perform
  ) where

import Data.Either (Either, either)
import Effect.Aff (Aff, Error, runAff_)
import Effect.Exception (throwException)
import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Prelude (Unit, pure, unit, (<<<))

-- | Run an `Aff` and send its result -- success or failure -- as a message.
attempt :: ∀ a msg. (Either Error a -> msg) -> Aff a -> Cmd msg
attempt toMsg aff = Cmd.callback \send -> runAff_ (send <<< toMsg) aff

-- | Run an `Aff` you have already narrowed to a success value, sending that
-- | value as a message. A failure is rethrown rather than swallowed, so it
-- | surfaces in the console instead of vanishing.
perform :: ∀ a msg. (a -> msg) -> Aff a -> Cmd msg
perform toMsg aff =
  Cmd.callback \send -> runAff_ (either throwException (send <<< toMsg)) aff

-- | Run an `Aff` for its effects alone, with no message afterwards.
launch :: ∀ msg. Aff Unit -> Cmd msg
launch aff = Cmd.effect (runAff_ (either throwException (\_ -> pure unit)) aff)
