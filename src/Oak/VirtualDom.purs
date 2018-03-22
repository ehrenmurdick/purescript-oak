module Oak.VirtualDom where

import Prelude
import Control.Monad.Eff
import Control.Monad.ST
import Data.Foldable
import Data.Maybe
import Data.Traversable
import Partial.Unsafe

import Oak.Html
  ( Html(..)
  )
import Oak.Html.Attribute
import Oak.VirtualDom.Native

render :: forall e h model msg r.
  (msg -> Eff ( st :: ST h | e ) r)
    -> Html msg
    -> Eff ( st :: ST h | e ) Tree
render h (Tag name attrs children) =
  renderN name (combineAttrs attrs h) (sequence $ map (render h) children)
render h (Text str) = textN str

concatAttr :: forall msg eff.
  (msg -> eff)
    -> Attribute msg
    -> NativeAttrs
    -> NativeAttrs
concatAttr handler (EventHandler name msg) attrs =
  concatHandlerFun name (\_ -> handler msg) attrs
concatAttr handler (StringEventHandler name f) attrs =
  concatEventTargetValueHandlerFun name (\e -> handler (f e)) attrs
concatAttr handler (SimpleAttribute name value) attrs =
  concatSimpleAttr name value attrs

combineAttrs :: forall msg eff.
  Array (Attribute msg)
    -> (msg -> eff)
    -> NativeAttrs
combineAttrs attrs handler =
  foldr (concatAttr handler) emptyAttrsN attrs


patch :: forall e h.
  Tree
    -> Tree
    -> Maybe Node
    -> Eff ( st :: ST h | e ) Node
patch oldTree newTree maybeRoot =
  let root = unsafePartial (fromJust maybeRoot)
  in patchN oldTree newTree root

