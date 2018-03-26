module Oak.VirtualDom where

import Prelude
  ( map
  , ($)
  , (<>)
  )
import Control.Monad.Eff (Eff)
import Control.Monad.ST (ST)
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
  , DOM
  )

render :: ∀ e h msg r.
  (msg -> Eff ( st :: ST h | e ) r)
    -> Html msg
    -> Eff ( st :: ST h | e ) N.Tree
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

patch :: ∀ e.
  N.Tree
    -> N.Tree
    -> Maybe Node
    -> Eff ( dom :: DOM | e ) Node
patch oldTree newTree maybeRoot =
  let root = unsafePartial (fromJust maybeRoot)
  in N.patch oldTree newTree root

