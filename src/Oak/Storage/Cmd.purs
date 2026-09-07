-- | `Oak.Storage`, as commands.
-- |
-- | The same operations as `Oak.Storage`, shaped for returning from `next`.
-- | Reads take a function from the value they found to a message; writes are
-- | fire-and-forget unless you use the primed version, which reports whether
-- | the write actually landed.
-- |
-- | The `Store` type and the two stores are re-exported, so a single import
-- | covers a whole app:
-- |
-- | ```purescript
-- | import Oak.Storage.Cmd as Storage
-- |
-- | next :: Msg -> Model -> Cmd Msg
-- | next msg model = case msg of
-- |   Load -> Storage.get Storage.localStorage "todos" Loaded
-- |   _    -> Storage.set Storage.localStorage "todos" model.todos
-- | ```
-- |
-- | The reads answer with the same `Maybe` as `Oak.Storage`'s, so `Loaded`
-- | there takes a `Maybe (Array Todo)`: a missing key, corrupt JSON and a
-- | browser that refuses storage all arrive as `Nothing`.
module Oak.Storage.Cmd
  ( module Oak.Storage
  , clear
  , get
  , getItem
  , keys
  , remove
  , set
  , set'
  , setItem
  , setItem'
  ) where

import Data.Maybe (Maybe)
import Oak.Cmd (Cmd)
import Oak.Cmd as Cmd
import Oak.Storage (Store, localStorage, sessionStorage)
import Oak.Storage as Storage
import Prelude (void, (<#>))
import Simple.JSON as JSON

-- json
-------

-- | Read a value and decode it, sending the result as a message.
get :: ∀ a msg. JSON.ReadForeign a => Store -> String -> (Maybe a -> msg) -> Cmd msg
get store key toMsg = Cmd.perform (Storage.get store key <#> toMsg)

-- | Encode a value and write it, ignoring whether it landed.
set :: ∀ a msg. JSON.WriteForeign a => Store -> String -> a -> Cmd msg
set store key val = Cmd.effect (void (Storage.set store key val))

-- | `set`, reporting the outcome. `false` means the quota is full or storage
-- | was refused, and the value is gone.
set' :: ∀ a msg. JSON.WriteForeign a => Store -> String -> a -> (Boolean -> msg) -> Cmd msg
set' store key val toMsg = Cmd.perform (Storage.set store key val <#> toMsg)

-- raw strings
--------------

-- | Read a raw string, sending it as a message.
getItem :: ∀ msg. Store -> String -> (Maybe String -> msg) -> Cmd msg
getItem store key toMsg = Cmd.perform (Storage.getItem store key <#> toMsg)

-- | Write a raw string, ignoring whether it landed.
setItem :: ∀ msg. Store -> String -> String -> Cmd msg
setItem store key val = Cmd.effect (void (Storage.setItem store key val))

-- | `setItem`, reporting the outcome.
setItem' :: ∀ msg. Store -> String -> String -> (Boolean -> msg) -> Cmd msg
setItem' store key val toMsg = Cmd.perform (Storage.setItem store key val <#> toMsg)

-- the rest of the store
------------------------

-- | Every key currently in the store, as a message.
keys :: ∀ msg. Store -> (Array String -> msg) -> Cmd msg
keys store toMsg = Cmd.perform (Storage.keys store <#> toMsg)

-- | Drop a single key.
remove :: ∀ msg. Store -> String -> Cmd msg
remove store key = Cmd.effect (Storage.remove store key)

-- | Drop every key in the store.
clear :: ∀ msg. Store -> Cmd msg
clear store = Cmd.effect (Storage.clear store)
