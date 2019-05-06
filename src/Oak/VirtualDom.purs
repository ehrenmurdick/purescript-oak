module Oak.VirtualDom where

import Prelude
  ( map
  , ($)
  , (<>)
  )
import Effect (Effect)
import Data.Maybe (Maybe, fromJust)
import Data.Traversable (foldr, sequence)
import Partial.Unsafe (unsafePartial)
import Data.Foldable (intercalate)

import Oak.Html
  ( Html(..)
  )
import Oak.Html.Attribute (Attribute(..))
import Oak.Css (StyleAttribute(..))
import Oak.VirtualDom.Native as N
import Oak.Document
  ( Node
  )

render :: ∀ msg r.
  (msg -> Effect r)
    -> Html msg
    -> Effect N.Tree
render h (Tag name attrs children) =
  N.render name (combineAttrs attrs h) (sequence $ map (render h) children)
render h (Text str) = N.text str

concatAttr :: ∀ msg eff.
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
concatAttr handler (Style styles) attrs =
  N.concatSimpleAttr "style" (stringifyStyles styles) attrs
concatAttr handler (BooleanAttribute name b) attrs =
  N.concatBooleanAttr name b attrs
concatAttr handler (DataAttribute name val) attrs =
  N.concatDataAttr name val attrs
concatAttr handler (KeyPressEventHandler name f) attrs =
  N.concatHandlerFun name (\e -> handler (f e)) attrs

stringifyStyle :: StyleAttribute -> String
stringifyStyle (StyleAttribute name value) =
  name <> ":" <> value

stringifyStyles :: Array StyleAttribute -> String
stringifyStyles attrs = intercalate ";" (map stringifyStyle attrs)

combineAttrs :: ∀ msg eff.
  Array (Attribute msg)
    -> (msg -> eff)
    -> N.NativeAttrs
combineAttrs attrs handler =
  foldr (concatAttr handler) N.emptyAttrs attrs

patch ::
  N.Tree
    -> N.Tree
    -> Maybe Node
    -> Effect Node
patch oldTree newTree maybeRoot =
  let root = unsafePartial (fromJust maybeRoot)
  in N.patch oldTree newTree root

