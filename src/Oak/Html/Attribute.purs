module Oak.Html.Attribute where

import Prelude ( (<>) )

import Oak.Css ( StyleAttribute )
import Oak.Html.Present

type KeyPressEvent =
  { altKey      :: Boolean
  , charCode    :: Int
  , code        :: String
  , ctrlKey     :: Boolean
  , isComposing :: Boolean
  , key         :: String
  , keyCode     :: Int
  , location    :: Int
  , metaKey     :: Boolean
  , repeat      :: Boolean
  , shiftKey    :: Boolean
  , which       :: Boolean
  }


data Attribute msg
  = BooleanAttribute String Boolean
  | EventHandler String msg
  | KeyPressEventHandler String (KeyPressEvent -> msg)
  | StringEventHandler String (String -> msg)
  | SimpleAttribute String String
  | DataAttribute String String
  | Style (Array StyleAttribute)


-- special attrs
----------------

style :: ∀ msg. Array StyleAttribute -> Attribute msg
style attrs = Style attrs

-- data-*
data_ :: ∀ msg v. Present v => String -> v -> Attribute msg
data_ name val = DataAttribute ("data-" <> name) (present val)


-- boolean attrs
----------------

checked :: ∀ msg. Boolean -> Attribute msg
checked b = BooleanAttribute "checked" b


contenteditable :: ∀ msg. Boolean -> Attribute msg
contenteditable b = BooleanAttribute "contenteditable" b


disabled :: ∀ msg. Boolean -> Attribute msg
disabled b = BooleanAttribute "disabled" b


hidden :: ∀ msg. Boolean -> Attribute msg
hidden b = BooleanAttribute "hidden" b


-- regular string attributes
----------------------------

accept :: ∀ msg v. Present v => v -> Attribute msg
accept val = SimpleAttribute "accept" (present val)


acceptCharset :: ∀ msg v. Present v => v -> Attribute msg
acceptCharset val = SimpleAttribute "accept-charset" (present val)


accesskey :: ∀ msg v. Present v => v -> Attribute msg
accesskey val = SimpleAttribute "accesskey" (present val)


action :: ∀ msg v. Present v => v -> Attribute msg
action val = SimpleAttribute "action" (present val)


align :: ∀ msg v. Present v => v -> Attribute msg
align val = SimpleAttribute "align" (present val)


alt :: ∀ msg v. Present v => v -> Attribute msg
alt val = SimpleAttribute "alt" (present val)


async :: ∀ msg v. Present v => v -> Attribute msg
async val = SimpleAttribute "async" (present val)


autocomplete :: ∀ msg v. Present v => v -> Attribute msg
autocomplete val = SimpleAttribute "autocomplete" (present val)


autofocus :: ∀ msg v. Present v => v -> Attribute msg
autofocus val = SimpleAttribute "autofocus" (present val)


autoplay :: ∀ msg v. Present v => v -> Attribute msg
autoplay val = SimpleAttribute "autoplay" (present val)

bgcolor :: ∀ msg v. Present v => v -> Attribute msg
bgcolor val = SimpleAttribute "bgcolor" (present val)


border :: ∀ msg v. Present v => v -> Attribute msg
border val = SimpleAttribute "border" (present val)


charset :: ∀ msg v. Present v => v -> Attribute msg
charset val = SimpleAttribute "charset" (present val)


cite :: ∀ msg v. Present v => v -> Attribute msg
cite val = SimpleAttribute "cite" (present val)


class_ :: ∀ msg v. Present v => v -> Attribute msg
class_ val = SimpleAttribute "className" (present val)


color :: ∀ msg v. Present v => v -> Attribute msg
color val = SimpleAttribute "color" (present val)


cols :: ∀ msg v. Present v => v -> Attribute msg
cols val = SimpleAttribute "cols" (present val)


colspan :: ∀ msg v. Present v => v -> Attribute msg
colspan val = SimpleAttribute "colspan" (present val)


content :: ∀ msg v. Present v => v -> Attribute msg
content val = SimpleAttribute "content" (present val)


controls :: ∀ msg v. Present v => v -> Attribute msg
controls val = SimpleAttribute "controls" (present val)


coords :: ∀ msg v. Present v => v -> Attribute msg
coords val = SimpleAttribute "coords" (present val)


-- using data_ for the more common data-* attr use case
-- naming this data__ (note two underscores) for lack
-- of a better idea. I'm open to suggestions
data__ :: ∀ msg v. Present v => v -> Attribute msg
data__ val = SimpleAttribute "data" (present val)


datetime :: ∀ msg v. Present v => v -> Attribute msg
datetime val = SimpleAttribute "datetime" (present val)


default :: ∀ msg v. Present v => v -> Attribute msg
default val = SimpleAttribute "default" (present val)


defer :: ∀ msg v. Present v => v -> Attribute msg
defer val = SimpleAttribute "defer" (present val)


dir :: ∀ msg v. Present v => v -> Attribute msg
dir val = SimpleAttribute "dir" (present val)


dirname :: ∀ msg v. Present v => v -> Attribute msg
dirname val = SimpleAttribute "dirname" (present val)


download :: ∀ msg v. Present v => v -> Attribute msg
download val = SimpleAttribute "download" (present val)


draggable :: ∀ msg v. Present v => v -> Attribute msg
draggable val = SimpleAttribute "draggable" (present val)


dropzone :: ∀ msg v. Present v => v -> Attribute msg
dropzone val = SimpleAttribute "dropzone" (present val)


enctype :: ∀ msg v. Present v => v -> Attribute msg
enctype val = SimpleAttribute "enctype" (present val)


for :: ∀ msg v. Present v => v -> Attribute msg
for val = SimpleAttribute "for" (present val)


form :: ∀ msg v. Present v => v -> Attribute msg
form val = SimpleAttribute "form" (present val)


formaction :: ∀ msg v. Present v => v -> Attribute msg
formaction val = SimpleAttribute "formaction" (present val)


headers :: ∀ msg v. Present v => v -> Attribute msg
headers val = SimpleAttribute "headers" (present val)


height :: ∀ msg v. Present v => v -> Attribute msg
height val = SimpleAttribute "height" (present val)


high :: ∀ msg v. Present v => v -> Attribute msg
high val = SimpleAttribute "high" (present val)


href :: ∀ msg v. Present v => v -> Attribute msg
href val = SimpleAttribute "href" (present val)


hreflang :: ∀ msg v. Present v => v -> Attribute msg
hreflang val = SimpleAttribute "hreflang" (present val)


httpEquiv :: ∀ msg v. Present v => v -> Attribute msg
httpEquiv val = SimpleAttribute "http-equiv" (present val)


id_ :: ∀ msg v. Present v => v -> Attribute msg
id_ val = SimpleAttribute "id" (present val)


ismap :: ∀ msg v. Present v => v -> Attribute msg
ismap val = SimpleAttribute "ismap" (present val)


kind_ :: ∀ msg v. Present v => v -> Attribute msg
kind_ val = SimpleAttribute "kind" (present val)


label :: ∀ msg v. Present v => v -> Attribute msg
label val = SimpleAttribute "label" (present val)


lang :: ∀ msg v. Present v => v -> Attribute msg
lang val = SimpleAttribute "lang" (present val)


list :: ∀ msg v. Present v => v -> Attribute msg
list val = SimpleAttribute "list" (present val)


loop :: ∀ msg v. Present v => v -> Attribute msg
loop val = SimpleAttribute "loop" (present val)


low :: ∀ msg v. Present v => v -> Attribute msg
low val = SimpleAttribute "low" (present val)


max :: ∀ msg v. Present v => v -> Attribute msg
max val = SimpleAttribute "max" (present val)


maxlength :: ∀ msg v. Present v => v -> Attribute msg
maxlength val = SimpleAttribute "maxlength" (present val)


media :: ∀ msg v. Present v => v -> Attribute msg
media val = SimpleAttribute "media" (present val)


method :: ∀ msg v. Present v => v -> Attribute msg
method val = SimpleAttribute "method" (present val)


min :: ∀ msg v. Present v => v -> Attribute msg
min val = SimpleAttribute "min" (present val)


multiple :: ∀ msg v. Present v => v -> Attribute msg
multiple val = SimpleAttribute "multiple" (present val)


muted :: ∀ msg v. Present v => v -> Attribute msg
muted val = SimpleAttribute "muted" (present val)


name :: ∀ msg v. Present v => v -> Attribute msg
name val = SimpleAttribute "name" (present val)


novalidate :: ∀ msg v. Present v => v -> Attribute msg
novalidate val = SimpleAttribute "novalidate" (present val)


open :: ∀ msg v. Present v => v -> Attribute msg
open val = SimpleAttribute "open" (present val)


optimum :: ∀ msg v. Present v => v -> Attribute msg
optimum val = SimpleAttribute "optimum" (present val)


pattern :: ∀ msg v. Present v => v -> Attribute msg
pattern val = SimpleAttribute "pattern" (present val)


placeholder :: ∀ msg v. Present v => v -> Attribute msg
placeholder val = SimpleAttribute "placeholder" (present val)


poster :: ∀ msg v. Present v => v -> Attribute msg
poster val = SimpleAttribute "poster" (present val)


preload :: ∀ msg v. Present v => v -> Attribute msg
preload val = SimpleAttribute "preload" (present val)


readonly :: ∀ msg v. Present v => v -> Attribute msg
readonly val = SimpleAttribute "readonly" (present val)


rel :: ∀ msg v. Present v => v -> Attribute msg
rel val = SimpleAttribute "rel" (present val)


required :: ∀ msg v. Present v => v -> Attribute msg
required val = SimpleAttribute "required" (present val)


reversed :: ∀ msg v. Present v => v -> Attribute msg
reversed val = SimpleAttribute "reversed" (present val)


rows :: ∀ msg v. Present v => v -> Attribute msg
rows val = SimpleAttribute "rows" (present val)


rowspan :: ∀ msg v. Present v => v -> Attribute msg
rowspan val = SimpleAttribute "rowspan" (present val)


sandbox :: ∀ msg v. Present v => v -> Attribute msg
sandbox val = SimpleAttribute "sandbox" (present val)


scope :: ∀ msg v. Present v => v -> Attribute msg
scope val = SimpleAttribute "scope" (present val)


selected :: ∀ msg v. Present v => v -> Attribute msg
selected val = SimpleAttribute "selected" (present val)


shape :: ∀ msg v. Present v => v -> Attribute msg
shape val = SimpleAttribute "shape" (present val)


size :: ∀ msg v. Present v => v -> Attribute msg
size val = SimpleAttribute "size" (present val)


sizes :: ∀ msg v. Present v => v -> Attribute msg
sizes val = SimpleAttribute "sizes" (present val)


span :: ∀ msg v. Present v => v -> Attribute msg
span val = SimpleAttribute "span" (present val)


spellcheck :: ∀ msg v. Present v => v -> Attribute msg
spellcheck val = SimpleAttribute "spellcheck" (present val)


src :: ∀ msg v. Present v => v -> Attribute msg
src val = SimpleAttribute "src" (present val)


srcdoc :: ∀ msg v. Present v => v -> Attribute msg
srcdoc val = SimpleAttribute "srcdoc" (present val)


srclang :: ∀ msg v. Present v => v -> Attribute msg
srclang val = SimpleAttribute "srclang" (present val)


srcset :: ∀ msg v. Present v => v -> Attribute msg
srcset val = SimpleAttribute "srcset" (present val)


start :: ∀ msg v. Present v => v -> Attribute msg
start val = SimpleAttribute "start" (present val)


step :: ∀ msg v. Present v => v -> Attribute msg
step val = SimpleAttribute "step" (present val)


tabindex :: ∀ msg v. Present v => v -> Attribute msg
tabindex val = SimpleAttribute "tabindex" (present val)


target :: ∀ msg v. Present v => v -> Attribute msg
target val = SimpleAttribute "target" (present val)


title :: ∀ msg v. Present v => v -> Attribute msg
title val = SimpleAttribute "title" (present val)


translate :: ∀ msg v. Present v => v -> Attribute msg
translate val = SimpleAttribute "translate" (present val)


type_ :: ∀ msg v. Present v => v -> Attribute msg
type_ val = SimpleAttribute "type" (present val)


usemap :: ∀ msg v. Present v => v -> Attribute msg
usemap val = SimpleAttribute "usemap" (present val)


value :: ∀ msg v. Present v => Present v => v -> Attribute msg
value val = SimpleAttribute "value" (present val)


width :: ∀ msg v. Present v => v -> Attribute msg
width val = SimpleAttribute "width" (present val)


wrap :: ∀ msg v. Present v => v -> Attribute msg
wrap val = SimpleAttribute "wrap" (present val)

