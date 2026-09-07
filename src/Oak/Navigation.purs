-- | Moving around a routed app, and the browser plumbing behind it.
-- |
-- | The effects here are the same shape as `Oak.Window`'s and
-- | `Oak.Storage`'s -- plain `Effect`s you call from `next`:
-- |
-- | ```purescript
-- | import Oak.Navigation as Nav
-- |
-- | next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
-- | next msg _ _ = case msg of
-- |   GoTo route -> Nav.push (print route)
-- |   _          -> mempty
-- | ```
-- |
-- | Paths are always written the way the app thinks of them -- `"/todos/42"`,
-- | never `"#/todos/42"`. In `Hash` mode the runtime adds the `#` for you, so
-- | changing the mode flag never means rewriting navigation code.
-- |
-- | You do not need this module to follow a link. The runtime intercepts
-- | clicks on same-origin anchors itself, so a plain
-- | `a [ href "/todos" ] [ text "Todos" ]` navigates without a full page
-- | load. Give an anchor `target`, `download`, or `rel="external"` to opt
-- | out of that and get ordinary browser behaviour back.
module Oak.Navigation
  ( back
  , currentUrl
  , forward
  , load
  , push
  , replace
  , start
  ) where

import Data.Function.Uncurried (Fn1, Fn2, runFn1, runFn2)
import Effect (Effect)
import Oak.Route (Mode, modeTag)
import Prelude (Unit)

foreign import pushImpl :: Fn1 String (Effect Unit)

foreign import replaceImpl :: Fn1 String (Effect Unit)

foreign import loadImpl :: Fn1 String (Effect Unit)

foreign import startImpl :: Fn2 String (String -> Effect Unit) (Effect Unit)

-- | The current location, relative to the origin: `pathname + search + hash`.
-- | Hand it to `Oak.Route.parseUrl` to get something matchable.
foreign import currentUrl :: Effect String

-- | Go back one entry, as the browser's back button does.
foreign import back :: Effect Unit

-- | Go forward one entry.
foreign import forward :: Effect Unit

-- | Navigate to a path, adding a history entry. The app is told about the
-- | new URL through its `onNavigate`, exactly as it would be for a click or
-- | a back button.
push :: String -> Effect Unit
push = runFn1 pushImpl

-- | Navigate to a path, rewriting the current history entry instead of
-- | adding one. Use it for redirects, so back doesn't return to a URL that
-- | immediately redirects again.
replace :: String -> Effect Unit
replace = runFn1 replaceImpl

-- | Leave the app entirely with a full page load. For links out, or for
-- | forcing a fresh boot.
load :: String -> Effect Unit
load = runFn1 loadImpl

-- runtime internals
--------------------

-- | Called once by `runApp` for a routed app. Records the mode, installs the
-- | URL listeners and the link interceptor, and registers the dispatcher
-- | that navigations are announced to. Apps don't call this.
start :: Mode -> (String -> Effect Unit) -> Effect Unit
start mode dispatch = runFn2 startImpl (modeTag mode) dispatch
