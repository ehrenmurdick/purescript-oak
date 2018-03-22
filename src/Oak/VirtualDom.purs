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
import Oak.VirtualDom.Native as N

render :: forall e h model msg r.
  (msg -> Eff ( st :: ST h | e ) r)
    -> Html msg
    -> Eff ( st :: ST h | e ) N.Tree
render h (Tag name attrs children) =
  N.renderN name (combineAttrs attrs h) (sequence $ map (render h) children)
render h (Text str) = N.textN str

concatAttr :: forall msg eff.
  (msg -> eff)
    -> Attribute msg
    -> N.NativeAttrs
    -> N.NativeAttrs
concatAttr handler (EventHandler name msg) attrs =
  N.concatHandlerFun name (\_ -> handler msg) attrs
concatAttr handler (StringEventHandler name f) attrs =
  N.concatEventTargetValueHandlerFun name (\e -> handler (f e)) attrs
concatAttr handler (SimpleAttribute name value) attrs =
  N.concatSimpleAttr name value attrs

combineAttrs :: forall msg eff.
  Array (Attribute msg)
    -> (msg -> eff)
    -> N.NativeAttrs
combineAttrs attrs handler =
  foldr (concatAttr handler) N.emptyAttrs attrs


patch :: forall e h.
  N.Tree
    -> N.Tree
    -> Maybe N.Node
    -> Eff ( st :: ST h | e ) N.Node
patch oldTree newTree maybeRoot =
  let root = unsafePartial (fromJust maybeRoot)
  in N.patch oldTree newTree root

