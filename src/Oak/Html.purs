module Oak.Html where

import Data.Array (snoc)
import Oak.Html.Attribute (Attribute)
import Oak.Html.Present (present, class Present)
import Prelude
  ( class Functor
  , class Apply
  , class Applicative
  , class Bind
  , class Monoid
  , class Semigroup
  , mempty
  , map
  , ($)
  , unit
  , Unit
  , bind
  , join
  )

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))

data T a b
  = T a b

data Builder st a
  = Builder (st -> (T a st))

mapMsg :: forall a b. (a -> b) -> View a -> View b
mapMsg func (Builder v) = do
  let ff = mapMap func
      mapMap :: forall a1 b1. (a1 -> b1) -> Array (Html a1) -> Array (Html b1)
      mapMap f2 appl = map (map f2) appl
      T _ st = v []
      ss = ff st
  prev <- getBuilder
  putBuilder $ join [prev, ss]

instance builderFunctor :: Functor (Builder st) where
  map func builder = Builder $ \st ->
    let Builder b_a = builder
        T v new_s = b_a st
    in T (func v) new_s

instance builderApply :: Apply (Builder st) where
  apply appl builder = Builder $ \st ->
    let Builder b_a = appl
        T func new_s = b_a st
        Builder a_a = builder
        T v new_s_ = a_a new_s
    in T (func v) new_s_

instance builderApplicative :: Applicative (Builder st) where
  pure appl = Builder $ \st ->
    T appl st

instance builderMonoid ::
  ( Monoid appl
  , Monoid st
  ) =>
  Monoid (Builder st appl) where
  mempty = Builder $ \st ->
    T mempty mempty

instance builderSemigroup :: Semigroup (Builder st appl) where
  append (Builder b_a) (Builder a_a) = Builder $ \st ->
    let T v s_a = a_a st
        T x new_s = b_a s_a
    in T x new_s

instance builderBind :: Bind (Builder st) where
  bind ::
    forall appl b st.
    Builder st appl ->
    (appl -> Builder st b) ->
    Builder st b
  bind builder func = Builder $ \st ->
    let Builder b_a = builder
        T v new_s = b_a st
        Builder new_b = func v
    in new_b new_s

putBuilder :: forall st. st -> Builder st Unit
putBuilder val = Builder $ \_ ->
  T unit val

getBuilder :: forall st. Builder st st
getBuilder = Builder $ \val ->
  T val val

runBuilder :: forall msg. View msg -> Array (Html msg)
runBuilder (Builder b_a) = let T v new_s = b_a []
                           in new_s

instance htmlFunctor :: Functor Html where
  map ::
    forall msg1 msg2.
    (msg1 -> msg2) ->
    Html msg1 ->
    Html msg2
  map func html = case html of
    Text str -> Text str
    Tag name attrs children -> Tag name (map (map func) attrs) (map (map func) children)

type View msg
  = Builder (Array (Html msg)) Unit

class BodyAble a m where
  bodify :: a -> Array (Html m)

instance bodyAbleBuilder :: BodyAble (Builder (Array (Html msg)) Unit) msg where
  bodify = runBuilder

else instance bodyAblePresentable :: (Present a) => BodyAble a m where
  bodify :: forall a. Present a => a -> Array (Html m)
  bodify str = [Text (present str)]

text :: forall appl msg. Present appl => appl -> View msg
text val = do
  xs <- getBuilder
  let tag = Text (present val)
  putBuilder (snoc xs tag)

empty :: forall msg. View msg
empty = mempty

mkTagFn ::
  forall body msg.
  BodyAble body msg =>
  String ->
  Array (Attribute msg) ->
  body ->
  View msg
mkTagFn n attrs m = do
  xs <- getBuilder
  let tag = Tag n attrs (bodify m)
  putBuilder (snoc xs tag)

a ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
a = mkTagFn "a"

abbr ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
abbr = mkTagFn "abbr"

address ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
address = mkTagFn "address"

area ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
area = mkTagFn "area"

article ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
article = mkTagFn "article"

aside ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
aside = mkTagFn "aside"

audio ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
audio = mkTagFn "audio"

b ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
b = mkTagFn "b"

bdi ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
bdi = mkTagFn "bdi"

bdo ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
bdo = mkTagFn "bdo"

big ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
big = mkTagFn "big"

blockquote ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
blockquote = mkTagFn "blockquote"

br ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
br = mkTagFn "br"

button ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
button = mkTagFn "button"

canvas ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
canvas = mkTagFn "canvas"

caption ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
caption = mkTagFn "caption"

center ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
center = mkTagFn "center"

cite ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
cite = mkTagFn "cite"

code ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
code = mkTagFn "code"

col ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
col = mkTagFn "col"

colgroup ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
colgroup = mkTagFn "colgroup"

data_ ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
data_ = mkTagFn "data"

datalist ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
datalist = mkTagFn "datalist"

dd ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dd = mkTagFn "dd"

del ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
del = mkTagFn "del"

details ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
details = mkTagFn "details"

dfn ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dfn = mkTagFn "dfn"

dialog ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dialog = mkTagFn "dialog"

dir ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dir = mkTagFn "dir"

div ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
div = mkTagFn "div"

dl ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dl = mkTagFn "dl"

dt ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
dt = mkTagFn "dt"

em ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
em = mkTagFn "em"

fieldset ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
fieldset = mkTagFn "fieldset"

figcaption ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
figcaption = mkTagFn "figcaption"

figure ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
figure = mkTagFn "figure"

font ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
font = mkTagFn "font"

footer ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
footer = mkTagFn "footer"

form ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
form = mkTagFn "form"

h1 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h1 = mkTagFn "h1"

h2 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h2 = mkTagFn "h2"

h3 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h3 = mkTagFn "h3"

h4 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h4 = mkTagFn "h4"

h5 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h5 = mkTagFn "h5"

h6 ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
h6 = mkTagFn "h6"

header ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
header = mkTagFn "header"

hr ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
hr = mkTagFn "hr"

i ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
i = mkTagFn "i"

img ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
img = mkTagFn "img"

input ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
input = mkTagFn "input"

ins ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
ins = mkTagFn "ins"

kbd ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
kbd = mkTagFn "kbd"

label ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
label = mkTagFn "label"

legend ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
legend = mkTagFn "legend"

li ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
li = mkTagFn "li"

link ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
link = mkTagFn "link"

main ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
main = mkTagFn "main"

map_ ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
map_ = mkTagFn "map"

mark ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
mark = mkTagFn "mark"

menu ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
menu = mkTagFn "menu"

menuitem ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
menuitem = mkTagFn "menuitem"

meter ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
meter = mkTagFn "meter"

nav ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
nav = mkTagFn "nav"

ol ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
ol = mkTagFn "ol"

optgroup ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
optgroup = mkTagFn "optgroup"

option ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
option = mkTagFn "option"

output ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
output = mkTagFn "output"

p ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
p = mkTagFn "p"

picture ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
picture = mkTagFn "picture"

pre ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
pre = mkTagFn "pre"

progress ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
progress = mkTagFn "progress"

q ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
q = mkTagFn "q"

rp ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
rp = mkTagFn "rp"

rt ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
rt = mkTagFn "rt"

ruby ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
ruby = mkTagFn "ruby"

s ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
s = mkTagFn "s"

samp ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
samp = mkTagFn "samp"

section ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
section = mkTagFn "section"

select ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
select = mkTagFn "select"

small ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
small = mkTagFn "small"

source ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
source = mkTagFn "source"

span ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
span = mkTagFn "span"

strike ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
strike = mkTagFn "strike"

strong ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
strong = mkTagFn "strong"

sub ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
sub = mkTagFn "sub"

summary ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
summary = mkTagFn "summary"

sup ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
sup = mkTagFn "sup"

svg ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
svg = mkTagFn "svg"

table ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
table = mkTagFn "table"

tbody ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
tbody = mkTagFn "tbody"

td ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
td = mkTagFn "td"

template ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
template = mkTagFn "template"

textarea ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
textarea = mkTagFn "textarea"

tfoot ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
tfoot = mkTagFn "tfoot"

th ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
th = mkTagFn "th"

thead ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
thead = mkTagFn "thead"

time ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
time = mkTagFn "time"

tr ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
tr = mkTagFn "tr"

track ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
track = mkTagFn "track"

tt ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
tt = mkTagFn "tt"

u ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
u = mkTagFn "u"

ul ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
ul = mkTagFn "ul"

var ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
var = mkTagFn "var"

video ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
video = mkTagFn "video"

wbr ::
  forall body msg.
  BodyAble body msg =>
  Array (Attribute msg) ->
  body ->
  View msg
wbr = mkTagFn "wbr"
