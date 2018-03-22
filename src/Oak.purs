module Oak where

import Prelude
import Control.Monad.Eff
import Control.Monad.ST
import Partial.Unsafe
import Data.Maybe
import Data.Traversable
import Data.Foldable

import Oak.Debug
import Oak.Html
import Oak.Html.Attribute
import Oak.Html.Events
import Oak.VirtualDom
import Oak.VirtualDom.Native as N

-- main : Program Never number Msg
-- bind :: forall a b. m a -> (a -> m b) -> m b

data App model msg = App
  { model :: model
  , update :: msg -> model -> model
  , view :: model -> Html msg
  }

createApp :: forall msg model.
  { init :: model
  , update :: msg -> model -> model
  , view :: model -> Html msg
  } -> App model msg
createApp opts = App
  { model: opts.init
  , view: opts.view
  , update: opts.update
  }

type Runtime =
  { tree :: Maybe N.Tree
  , root :: Maybe N.Node
  }

handler :: forall msg model eff h.
  STRef h Runtime
    -> App model msg
    -> msg
    -> Eff ( st :: ST h | eff ) Runtime
handler ref app msg = do
  env <- readSTRef ref
  let (App app) = app
  let oldTree = unsafePartial (fromJust env.tree)
  let root = unsafePartial (fromJust env.root)
  let newModel = app.update msg app.model
  let newAttrs = app { model = newModel }
  let newApp = App newAttrs
  newTree <- render (handler ref newApp) (app.view newModel)
  newRoot <- patch newTree oldTree env.root
  let newRuntime =
        { root: Just newRoot
        , tree: Just newTree
        }
  writeSTRef ref newRuntime

runApp :: forall e h model msg.
  App model msg
    -> Eff ( dom :: N.VDOM
           , createRootNode :: N.NODE
           , renderVTree :: N.PATCH
           , st :: ST h
       | e) N.Node
runApp (App app) = do
  ref <- newSTRef { tree: Nothing, root: Nothing }
  tree <- render (handler ref (App app)) (app.view app.model)
  rootNode <- N.createRootNode tree
  _ <- writeSTRef ref { tree: Just tree, root: Just rootNode }
  pure rootNode
