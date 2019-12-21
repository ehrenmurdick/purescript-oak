module Oak.VirtualDom where

import Data.Array (concat)
import Data.Foldable (intercalate)
import Data.Maybe (Maybe, fromJust)
import Data.Monoid (mempty)
import Data.Semigroup (append)
import Data.Traversable (foldr, sequence)
import Effect (Effect)
import Oak.Css (StyleAttribute(..))
import Oak.Document (Node)
import Oak.Html (Html(..))
import Oak.Html.Attribute (Attribute(..))
import Partial.Unsafe (unsafePartial)
import Prelude (map, ($), (<>))

import Oak.VirtualDom.Native as N

render ::
  forall msg r.
  (msg -> Effect r) ->
  Array (Html msg) ->
  Effect (Array N.Tree)
render h xs = sequence (map (renderTag h) xs)

renderTag :: forall msg r. (msg -> Effect r) -> Html msg -> Effect N.Tree
renderTag h (Tag name attrs children) = let rendered = sequence $ map (renderTag h) children
                                            foo = rendered
                                        in N.render name (combineAttrs attrs h) foo

renderTag h (Text str) = N.text str

concatAttr ::
  forall msg eff.
  (msg -> eff) ->
  Attribute msg ->
  N.NativeAttrs ->
  N.NativeAttrs
concatAttr handler (EventHandler name msg) attrs = N.concatHandlerFun name (\_ ->
  handler msg) attrs

concatAttr handler (StringEventHandler name f) attrs = N.concatEventTargetValueHandlerFun name (\e ->
  handler (f e)) attrs

concatAttr handler (SimpleAttribute name value) attrs = N.concatSimpleAttr name value attrs

concatAttr handler (Style styles) attrs = N.concatSimpleAttr "style" (stringifyStyles styles) attrs

concatAttr handler (BooleanAttribute name b) attrs = N.concatBooleanAttr name b attrs

concatAttr handler (DataAttribute name val) attrs = N.concatDataAttr name val attrs

concatAttr handler (KeyPressEventHandler name f) attrs = N.concatHandlerFun name (\e ->
  handler (f e)) attrs

stringifyStyle :: StyleAttribute -> String
stringifyStyle (StyleAttribute name value) = name <> ":" <> value

stringifyStyles :: Array StyleAttribute -> String
stringifyStyles attrs = intercalate ";" (map stringifyStyle attrs)

combineAttrs ::
  forall msg eff.
  Array (Attribute msg) ->
  (msg -> eff) ->
  N.NativeAttrs
combineAttrs attrs handler = foldr (concatAttr handler) N.emptyAttrs attrs

patch :: Array N.Tree -> Array N.Tree -> Array Node -> Effect (Array Node)
patch oldTree newTree root = N.patch oldTree newTree root
