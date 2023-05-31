module Oak.Html.Attribute where

import Prelude
  ( (<>)
  , (>>>)
  )

import Data.Functor (class Functor)

import Oak.Css (StyleAttribute)

type KeyPressEvent =
  { altKey :: Boolean
  , charCode :: Int
  , code :: String
  , ctrlKey :: Boolean
  , isComposing :: Boolean
  , key :: String
  , keyCode :: Int
  , location :: Int
  , metaKey :: Boolean
  , repeat :: Boolean
  , shiftKey :: Boolean
  , which :: Boolean
  }

data Attribute msg
  = BooleanAttribute String Boolean
  | DataAttribute String String
  | EventHandler String msg
  | KeyPressEventHandler String (KeyPressEvent -> msg)
  | SimpleAttribute String String
  | StringEventHandler String (String -> msg)
  | Style (Array StyleAttribute)

instance attributeFunctor :: Functor Attribute where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Attribute msg1 -> Attribute msg2
  map f attr =
    case attr of
      StringEventHandler n ctor -> StringEventHandler n (ctor >>> f)
      EventHandler n msg -> EventHandler n (f msg)
      KeyPressEventHandler n ctor -> KeyPressEventHandler n (ctor >>> f)
      BooleanAttribute n bool -> BooleanAttribute n bool
      DataAttribute n dat -> DataAttribute n dat
      SimpleAttribute a b -> SimpleAttribute a b
      Style a -> Style a

-- special attrs
----------------

style :: ∀ msg. Array StyleAttribute -> Attribute msg
style attrs = Style attrs

-- data-*
data_ :: ∀ msg. String -> String -> Attribute msg
data_ attrName val = DataAttribute ("data-" <> attrName) val

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

accept :: ∀ msg. String -> Attribute msg
accept val = SimpleAttribute "accept" val

acceptCharset :: ∀ msg. String -> Attribute msg
acceptCharset val = SimpleAttribute "accept-charset" val

accesskey :: ∀ msg. String -> Attribute msg
accesskey val = SimpleAttribute "accesskey" val

action :: ∀ msg. String -> Attribute msg
action val = SimpleAttribute "action" val

align :: ∀ msg. String -> Attribute msg
align val = SimpleAttribute "align" val

alt :: ∀ msg. String -> Attribute msg
alt val = SimpleAttribute "alt" val

async :: ∀ msg. String -> Attribute msg
async val = SimpleAttribute "async" val

autocomplete :: ∀ msg. String -> Attribute msg
autocomplete val = SimpleAttribute "autocomplete" val

autofocus :: ∀ msg. String -> Attribute msg
autofocus val = SimpleAttribute "autofocus" val

autoplay :: ∀ msg. String -> Attribute msg
autoplay val = SimpleAttribute "autoplay" val

bgcolor :: ∀ msg. String -> Attribute msg
bgcolor val = SimpleAttribute "bgcolor" val

border :: ∀ msg. String -> Attribute msg
border val = SimpleAttribute "border" val

charset :: ∀ msg. String -> Attribute msg
charset val = SimpleAttribute "charset" val

cite :: ∀ msg. String -> Attribute msg
cite val = SimpleAttribute "cite" val

className :: ∀ msg. String -> Attribute msg
className val = SimpleAttribute "className" val

color :: ∀ msg. String -> Attribute msg
color val = SimpleAttribute "color" val

cols :: ∀ msg. String -> Attribute msg
cols val = SimpleAttribute "cols" val

colspan :: ∀ msg. String -> Attribute msg
colspan val = SimpleAttribute "colspan" val

content :: ∀ msg. String -> Attribute msg
content val = SimpleAttribute "content" val

controls :: ∀ msg. String -> Attribute msg
controls val = SimpleAttribute "controls" val

coords :: ∀ msg. String -> Attribute msg
coords val = SimpleAttribute "coords" val

-- using data_ for the more common data-* attr use case
-- naming this data__ (note two underscores) for lack
-- of a better idea. I'm open to suggestions
data__ :: ∀ msg. String -> Attribute msg
data__ val = SimpleAttribute "data" val

datetime :: ∀ msg. String -> Attribute msg
datetime val = SimpleAttribute "datetime" val

default :: ∀ msg. String -> Attribute msg
default val = SimpleAttribute "default" val

defer :: ∀ msg. String -> Attribute msg
defer val = SimpleAttribute "defer" val

dir :: ∀ msg. String -> Attribute msg
dir val = SimpleAttribute "dir" val

dirname :: ∀ msg. String -> Attribute msg
dirname val = SimpleAttribute "dirname" val

download :: ∀ msg. String -> Attribute msg
download val = SimpleAttribute "download" val

draggable :: ∀ msg. String -> Attribute msg
draggable val = SimpleAttribute "draggable" val

dropzone :: ∀ msg. String -> Attribute msg
dropzone val = SimpleAttribute "dropzone" val

enctype :: ∀ msg. String -> Attribute msg
enctype val = SimpleAttribute "enctype" val

for :: ∀ msg. String -> Attribute msg
for val = SimpleAttribute "for" val

form :: ∀ msg. String -> Attribute msg
form val = SimpleAttribute "form" val

formaction :: ∀ msg. String -> Attribute msg
formaction val = SimpleAttribute "formaction" val

headers :: ∀ msg. String -> Attribute msg
headers val = SimpleAttribute "headers" val

height :: ∀ msg. String -> Attribute msg
height val = SimpleAttribute "height" val

high :: ∀ msg. String -> Attribute msg
high val = SimpleAttribute "high" val

href :: ∀ msg. String -> Attribute msg
href val = SimpleAttribute "href" val

hreflang :: ∀ msg. String -> Attribute msg
hreflang val = SimpleAttribute "hreflang" val

httpEquiv :: ∀ msg. String -> Attribute msg
httpEquiv val = SimpleAttribute "http-equiv" val

id_ :: ∀ msg. String -> Attribute msg
id_ val = SimpleAttribute "id" val

ismap :: ∀ msg. String -> Attribute msg
ismap val = SimpleAttribute "ismap" val

kind_ :: ∀ msg. String -> Attribute msg
kind_ val = SimpleAttribute "kind" val

label :: ∀ msg. String -> Attribute msg
label val = SimpleAttribute "label" val

lang :: ∀ msg. String -> Attribute msg
lang val = SimpleAttribute "lang" val

list :: ∀ msg. String -> Attribute msg
list val = SimpleAttribute "list" val

loop :: ∀ msg. String -> Attribute msg
loop val = SimpleAttribute "loop" val

low :: ∀ msg. String -> Attribute msg
low val = SimpleAttribute "low" val

max :: ∀ msg. String -> Attribute msg
max val = SimpleAttribute "max" val

maxlength :: ∀ msg. String -> Attribute msg
maxlength val = SimpleAttribute "maxlength" val

media :: ∀ msg. String -> Attribute msg
media val = SimpleAttribute "media" val

method :: ∀ msg. String -> Attribute msg
method val = SimpleAttribute "method" val

min :: ∀ msg. String -> Attribute msg
min val = SimpleAttribute "min" val

multiple :: ∀ msg. String -> Attribute msg
multiple val = SimpleAttribute "multiple" val

muted :: ∀ msg. String -> Attribute msg
muted val = SimpleAttribute "muted" val

name :: ∀ msg. String -> Attribute msg
name val = SimpleAttribute "name" val

novalidate :: ∀ msg. String -> Attribute msg
novalidate val = SimpleAttribute "novalidate" val

open :: ∀ msg. String -> Attribute msg
open val = SimpleAttribute "open" val

optimum :: ∀ msg. String -> Attribute msg
optimum val = SimpleAttribute "optimum" val

pattern :: ∀ msg. String -> Attribute msg
pattern val = SimpleAttribute "pattern" val

placeholder :: ∀ msg. String -> Attribute msg
placeholder val = SimpleAttribute "placeholder" val

poster :: ∀ msg. String -> Attribute msg
poster val = SimpleAttribute "poster" val

preload :: ∀ msg. String -> Attribute msg
preload val = SimpleAttribute "preload" val

readonly :: ∀ msg. String -> Attribute msg
readonly val = SimpleAttribute "readonly" val

rel :: ∀ msg. String -> Attribute msg
rel val = SimpleAttribute "rel" val

required :: ∀ msg. String -> Attribute msg
required val = SimpleAttribute "required" val

reversed :: ∀ msg. String -> Attribute msg
reversed val = SimpleAttribute "reversed" val

rows :: ∀ msg. String -> Attribute msg
rows val = SimpleAttribute "rows" val

rowspan :: ∀ msg. String -> Attribute msg
rowspan val = SimpleAttribute "rowspan" val

sandbox :: ∀ msg. String -> Attribute msg
sandbox val = SimpleAttribute "sandbox" val

scope :: ∀ msg. String -> Attribute msg
scope val = SimpleAttribute "scope" val

selected :: ∀ msg. String -> Attribute msg
selected val = SimpleAttribute "selected" val

shape :: ∀ msg. String -> Attribute msg
shape val = SimpleAttribute "shape" val

size :: ∀ msg. String -> Attribute msg
size val = SimpleAttribute "size" val

sizes :: ∀ msg. String -> Attribute msg
sizes val = SimpleAttribute "sizes" val

span :: ∀ msg. String -> Attribute msg
span val = SimpleAttribute "span" val

spellcheck :: ∀ msg. String -> Attribute msg
spellcheck val = SimpleAttribute "spellcheck" val

src :: ∀ msg. String -> Attribute msg
src val = SimpleAttribute "src" val

srcdoc :: ∀ msg. String -> Attribute msg
srcdoc val = SimpleAttribute "srcdoc" val

srclang :: ∀ msg. String -> Attribute msg
srclang val = SimpleAttribute "srclang" val

srcset :: ∀ msg. String -> Attribute msg
srcset val = SimpleAttribute "srcset" val

start :: ∀ msg. String -> Attribute msg
start val = SimpleAttribute "start" val

step :: ∀ msg. String -> Attribute msg
step val = SimpleAttribute "step" val

tabindex :: ∀ msg. String -> Attribute msg
tabindex val = SimpleAttribute "tabindex" val

target :: ∀ msg. String -> Attribute msg
target val = SimpleAttribute "target" val

title :: ∀ msg. String -> Attribute msg
title val = SimpleAttribute "title" val

translate :: ∀ msg. String -> Attribute msg
translate val = SimpleAttribute "translate" val

type_ :: ∀ msg. String -> Attribute msg
type_ val = SimpleAttribute "type" val

usemap :: ∀ msg. String -> Attribute msg
usemap val = SimpleAttribute "usemap" val

value :: ∀ msg. String -> Attribute msg
value val = SimpleAttribute "value" val

width :: ∀ msg. String -> Attribute msg
width val = SimpleAttribute "width" val

wrap :: ∀ msg. String -> Attribute msg
wrap val = SimpleAttribute "wrap" val
