-- | Web Storage, with a JSON layer over it.
-- |
-- | Every operation names the store it acts on, so the same functions cover
-- | both backing stores:
-- |
-- | ```purescript
-- | import Oak.Storage as Storage
-- |
-- | _ <- Storage.set Storage.localStorage "todos" model.todos
-- | (todos :: Maybe (Array Todo)) <- Storage.get Storage.localStorage "todos"
-- | ```
-- |
-- | Reads never throw and never distinguish their failures: a missing key,
-- | corrupt JSON, a value that doesn't match the type you asked for, and a
-- | browser that refuses storage outright (Safari private browsing, blocked
-- | site data) all come back as `Nothing`. Writes report whether the value
-- | actually landed, since a full quota loses data silently otherwise.
module Oak.Storage
  ( Store
  , clear
  , get
  , getItem
  , keys
  , localStorage
  , remove
  , sessionStorage
  , set
  , setItem
  ) where

import Data.Either (hush)
import Data.Function.Uncurried (Fn1, Fn2, Fn3, runFn1, runFn2, runFn3)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Prelude (Unit, bind, pure, (>>=), (>>>))
import Simple.JSON as JSON

-- | Which store to act on: `localStorage` or `sessionStorage`.
foreign import data Store :: Type

-- | Persists until it is cleared, and is shared across tabs of the same origin.
foreign import localStorage :: Store

-- | Persists for the lifetime of the tab.
foreign import sessionStorage :: Store

foreign import getItemImpl :: Fn2 Store String (Effect (Nullable String))

foreign import setItemImpl :: Fn3 Store String String (Effect Boolean)

foreign import removeItemImpl :: Fn2 Store String (Effect Unit)

foreign import clearImpl :: Fn1 Store (Effect Unit)

foreign import keysImpl :: Fn1 Store (Effect (Array String))

-- raw strings
--------------

-- | Read a raw string. `Nothing` if the key is absent or storage is refused.
getItem :: Store -> String -> Effect (Maybe String)
getItem store key = do
  raw <- runFn2 getItemImpl store key
  pure (toMaybe raw)

-- | Write a raw string. `false` if the write was refused or the quota is full.
setItem :: Store -> String -> String -> Effect Boolean
setItem = runFn3 setItemImpl

-- json
-------

-- | Read a value and decode it. `Nothing` if the key is absent, the stored
-- | JSON is corrupt, it doesn't match `a`, or storage is refused.
get :: ∀ a. JSON.ReadForeign a => Store -> String -> Effect (Maybe a)
get store key = do
  raw <- getItem store key
  pure (raw >>= (JSON.readJSON >>> hush))

-- | Encode a value and write it. `false` if the write was refused or the
-- | quota is full.
set :: ∀ a. JSON.WriteForeign a => Store -> String -> a -> Effect Boolean
set store key val = setItem store key (JSON.writeJSON val)

-- the rest of the store
------------------------

-- | Drop a single key.
remove :: Store -> String -> Effect Unit
remove = runFn2 removeItemImpl

-- | Drop every key in the store.
clear :: Store -> Effect Unit
clear = runFn1 clearImpl

-- | Every key currently in the store. `[]` if storage is refused.
keys :: Store -> Effect (Array String)
keys = runFn1 keysImpl
