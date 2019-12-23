module Oak.Html where

import Control.Monad.Writer

import Data.Array (snoc)
import Oak.Html.Attribute (Attribute)
import Oak.Html.Present (present, class Present)
import Prelude
  ( class Functor
  , class Apply
  , class Applicative
  , class Bind
  , class Monad
  , class Monoid
  , class Semigroup
  , mempty
  , discard
  , apply
  , map
  , pure
  , ($)
  , (<<<)
  , unit
  , (>>=)
  , Unit
  , pure
  , bind
  , join
  )

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))

data T a b
  = T a b

data Builder s a
  = Builder (s -> (T a s))

mapMsg :: forall a b. (a -> b) -> View a -> View b
mapMsg f (Builder v) = do
  let ff = mapMap f
      mapMap :: forall a1 b1. (a1 -> b1) -> Array (Html a1) -> Array (Html b1)
      mapMap f a = map (map f) a
      T _ s = v []
      ss = ff s
  prev <- get
  put $ join [prev, ss]

instance builderFunctor :: Functor (Builder s) where
  map f b = Builder $ \s ->
    let Builder b_a = b
        T v new_s = b_a s
    in T (f v) new_s

instance builderApply :: Apply (Builder s) where
  apply a b = Builder $ \s ->
    let Builder b_a = a
        T f new_s = b_a s
        Builder a_a = b
        T v new_s_ = a_a new_s
    in T (f v) new_s_

instance builderApplicative :: Applicative (Builder s) where
  pure a = Builder $ \s ->
    T a s

instance builderMonoid :: (Monoid a, Monoid s) => Monoid (Builder s a) where
  mempty = Builder $ \s ->
    T mempty mempty

instance builderSemigroup :: Semigroup (Builder s a) where
  append (Builder b_a) (Builder a_a) = Builder $ \s ->
    let T v s_a = a_a s
        T x new_s = b_a s_a
    in T x new_s

instance builderBind :: Bind (Builder s) where
  bind :: forall a b s. Builder s a -> (a -> Builder s b) -> Builder s b
  bind b f = Builder $ \s ->
    let Builder b_a = b
        T v new_s = b_a s
        Builder new_b = f v
    in new_b new_s

put :: forall s. s -> Builder s Unit
put s = Builder $ \_ ->
  T unit s

get :: forall s. Builder s s
get = Builder $ \s ->
  T s s

runBuilder :: forall msg. View msg -> Array (Html msg)
runBuilder (Builder b_a) = let T v new_s = b_a []
                           in new_s

instance htmlFunctor :: Functor Html where
  map ::
    forall msg1 msg2.
    (msg1 -> msg2) ->
    Html msg1 ->
    Html msg2
  map f html = case html of
    Text str -> Text str
    Tag name attrs children -> Tag name (map (map f) attrs) (map (map f) children)

type View msg
  = Builder (Array (Html msg)) Unit

text :: forall msg. String -> View msg
text s = do
  xs <- get
  let tag = Text s
  put (snoc xs tag)

empty :: forall msg. View msg
empty = text ""

mkTagFn :: forall msg. String -> Array (Attribute msg) -> View msg -> View msg
mkTagFn n attrs m = do
  xs <- get
  let tag = Tag n attrs (runBuilder m)
  put (snoc xs tag)

a :: forall msg. Array (Attribute msg) -> View msg -> View msg
a = mkTagFn "a"

abbr :: forall msg. Array (Attribute msg) -> View msg -> View msg
abbr = mkTagFn "abbr"

address :: forall msg. Array (Attribute msg) -> View msg -> View msg
address = mkTagFn "address"

area :: forall msg. Array (Attribute msg) -> View msg -> View msg
area = mkTagFn "area"

article :: forall msg. Array (Attribute msg) -> View msg -> View msg
article = mkTagFn "article"

aside :: forall msg. Array (Attribute msg) -> View msg -> View msg
aside = mkTagFn "aside"

audio :: forall msg. Array (Attribute msg) -> View msg -> View msg
audio = mkTagFn "audio"

b :: forall msg. Array (Attribute msg) -> View msg -> View msg
b = mkTagFn "b"

bdi :: forall msg. Array (Attribute msg) -> View msg -> View msg
bdi = mkTagFn "bdi"

bdo :: forall msg. Array (Attribute msg) -> View msg -> View msg
bdo = mkTagFn "bdo"

big :: forall msg. Array (Attribute msg) -> View msg -> View msg
big = mkTagFn "big"

blockquote :: forall msg. Array (Attribute msg) -> View msg -> View msg
blockquote = mkTagFn "blockquote"

br :: forall msg. Array (Attribute msg) -> View msg -> View msg
br = mkTagFn "br"

button :: forall msg. Array (Attribute msg) -> View msg -> View msg
button = mkTagFn "button"

canvas :: forall msg. Array (Attribute msg) -> View msg -> View msg
canvas = mkTagFn "canvas"

caption :: forall msg. Array (Attribute msg) -> View msg -> View msg
caption = mkTagFn "caption"

center :: forall msg. Array (Attribute msg) -> View msg -> View msg
center = mkTagFn "center"

cite :: forall msg. Array (Attribute msg) -> View msg -> View msg
cite = mkTagFn "cite"

code :: forall msg. Array (Attribute msg) -> View msg -> View msg
code = mkTagFn "code"

col :: forall msg. Array (Attribute msg) -> View msg -> View msg
col = mkTagFn "col"

colgroup :: forall msg. Array (Attribute msg) -> View msg -> View msg
colgroup = mkTagFn "colgroup"

data_ :: forall msg. Array (Attribute msg) -> View msg -> View msg
data_ = mkTagFn "data"

datalist :: forall msg. Array (Attribute msg) -> View msg -> View msg
datalist = mkTagFn "datalist"

dd :: forall msg. Array (Attribute msg) -> View msg -> View msg
dd = mkTagFn "dd"

del :: forall msg. Array (Attribute msg) -> View msg -> View msg
del = mkTagFn "del"

details :: forall msg. Array (Attribute msg) -> View msg -> View msg
details = mkTagFn "details"

dfn :: forall msg. Array (Attribute msg) -> View msg -> View msg
dfn = mkTagFn "dfn"

dialog :: forall msg. Array (Attribute msg) -> View msg -> View msg
dialog = mkTagFn "dialog"

dir :: forall msg. Array (Attribute msg) -> View msg -> View msg
dir = mkTagFn "dir"

div :: forall msg. Array (Attribute msg) -> View msg -> View msg
div = mkTagFn "div"

dl :: forall msg. Array (Attribute msg) -> View msg -> View msg
dl = mkTagFn "dl"

dt :: forall msg. Array (Attribute msg) -> View msg -> View msg
dt = mkTagFn "dt"

em :: forall msg. Array (Attribute msg) -> View msg -> View msg
em = mkTagFn "em"

fieldset :: forall msg. Array (Attribute msg) -> View msg -> View msg
fieldset = mkTagFn "fieldset"

figcaption :: forall msg. Array (Attribute msg) -> View msg -> View msg
figcaption = mkTagFn "figcaption"

figure :: forall msg. Array (Attribute msg) -> View msg -> View msg
figure = mkTagFn "figure"

font :: forall msg. Array (Attribute msg) -> View msg -> View msg
font = mkTagFn "font"

footer :: forall msg. Array (Attribute msg) -> View msg -> View msg
footer = mkTagFn "footer"

form :: forall msg. Array (Attribute msg) -> View msg -> View msg
form = mkTagFn "form"

h1 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h1 = mkTagFn "h1"

h2 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h2 = mkTagFn "h2"

h3 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h3 = mkTagFn "h3"

h4 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h4 = mkTagFn "h4"

h5 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h5 = mkTagFn "h5"

h6 :: forall msg. Array (Attribute msg) -> View msg -> View msg
h6 = mkTagFn "h6"

header :: forall msg. Array (Attribute msg) -> View msg -> View msg
header = mkTagFn "header"

hr :: forall msg. Array (Attribute msg) -> View msg -> View msg
hr = mkTagFn "hr"

i :: forall msg. Array (Attribute msg) -> View msg -> View msg
i = mkTagFn "i"

img :: forall msg. Array (Attribute msg) -> View msg -> View msg
img = mkTagFn "img"

input :: forall msg. Array (Attribute msg) -> View msg -> View msg
input = mkTagFn "input"

ins :: forall msg. Array (Attribute msg) -> View msg -> View msg
ins = mkTagFn "ins"

kbd :: forall msg. Array (Attribute msg) -> View msg -> View msg
kbd = mkTagFn "kbd"

label :: forall msg. Array (Attribute msg) -> View msg -> View msg
label = mkTagFn "label"

legend :: forall msg. Array (Attribute msg) -> View msg -> View msg
legend = mkTagFn "legend"

li :: forall msg. Array (Attribute msg) -> View msg -> View msg
li = mkTagFn "li"

link :: forall msg. Array (Attribute msg) -> View msg -> View msg
link = mkTagFn "link"

main :: forall msg. Array (Attribute msg) -> View msg -> View msg
main = mkTagFn "main"

map_ :: forall msg. Array (Attribute msg) -> View msg -> View msg
map_ = mkTagFn "map"

mark :: forall msg. Array (Attribute msg) -> View msg -> View msg
mark = mkTagFn "mark"

menu :: forall msg. Array (Attribute msg) -> View msg -> View msg
menu = mkTagFn "menu"

menuitem :: forall msg. Array (Attribute msg) -> View msg -> View msg
menuitem = mkTagFn "menuitem"

meter :: forall msg. Array (Attribute msg) -> View msg -> View msg
meter = mkTagFn "meter"

nav :: forall msg. Array (Attribute msg) -> View msg -> View msg
nav = mkTagFn "nav"

ol :: forall msg. Array (Attribute msg) -> View msg -> View msg
ol = mkTagFn "ol"

optgroup :: forall msg. Array (Attribute msg) -> View msg -> View msg
optgroup = mkTagFn "optgroup"

option :: forall msg. Array (Attribute msg) -> View msg -> View msg
option = mkTagFn "option"

output :: forall msg. Array (Attribute msg) -> View msg -> View msg
output = mkTagFn "output"

p :: forall msg. Array (Attribute msg) -> View msg -> View msg
p = mkTagFn "p"

picture :: forall msg. Array (Attribute msg) -> View msg -> View msg
picture = mkTagFn "picture"

pre :: forall msg. Array (Attribute msg) -> View msg -> View msg
pre = mkTagFn "pre"

progress :: forall msg. Array (Attribute msg) -> View msg -> View msg
progress = mkTagFn "progress"

q :: forall msg. Array (Attribute msg) -> View msg -> View msg
q = mkTagFn "q"

rp :: forall msg. Array (Attribute msg) -> View msg -> View msg
rp = mkTagFn "rp"

rt :: forall msg. Array (Attribute msg) -> View msg -> View msg
rt = mkTagFn "rt"

ruby :: forall msg. Array (Attribute msg) -> View msg -> View msg
ruby = mkTagFn "ruby"

s :: forall msg. Array (Attribute msg) -> View msg -> View msg
s = mkTagFn "s"

samp :: forall msg. Array (Attribute msg) -> View msg -> View msg
samp = mkTagFn "samp"

section :: forall msg. Array (Attribute msg) -> View msg -> View msg
section = mkTagFn "section"

select :: forall msg. Array (Attribute msg) -> View msg -> View msg
select = mkTagFn "select"

small :: forall msg. Array (Attribute msg) -> View msg -> View msg
small = mkTagFn "small"

source :: forall msg. Array (Attribute msg) -> View msg -> View msg
source = mkTagFn "source"

span :: forall msg. Array (Attribute msg) -> View msg -> View msg
span = mkTagFn "span"

strike :: forall msg. Array (Attribute msg) -> View msg -> View msg
strike = mkTagFn "strike"

strong :: forall msg. Array (Attribute msg) -> View msg -> View msg
strong = mkTagFn "strong"

sub :: forall msg. Array (Attribute msg) -> View msg -> View msg
sub = mkTagFn "sub"

summary :: forall msg. Array (Attribute msg) -> View msg -> View msg
summary = mkTagFn "summary"

sup :: forall msg. Array (Attribute msg) -> View msg -> View msg
sup = mkTagFn "sup"

svg :: forall msg. Array (Attribute msg) -> View msg -> View msg
svg = mkTagFn "svg"

table :: forall msg. Array (Attribute msg) -> View msg -> View msg
table = mkTagFn "table"

tbody :: forall msg. Array (Attribute msg) -> View msg -> View msg
tbody = mkTagFn "tbody"

td :: forall msg. Array (Attribute msg) -> View msg -> View msg
td = mkTagFn "td"

template :: forall msg. Array (Attribute msg) -> View msg -> View msg
template = mkTagFn "template"

textarea :: forall msg. Array (Attribute msg) -> View msg -> View msg
textarea = mkTagFn "textarea"

tfoot :: forall msg. Array (Attribute msg) -> View msg -> View msg
tfoot = mkTagFn "tfoot"

th :: forall msg. Array (Attribute msg) -> View msg -> View msg
th = mkTagFn "th"

thead :: forall msg. Array (Attribute msg) -> View msg -> View msg
thead = mkTagFn "thead"

time :: forall msg. Array (Attribute msg) -> View msg -> View msg
time = mkTagFn "time"

tr :: forall msg. Array (Attribute msg) -> View msg -> View msg
tr = mkTagFn "tr"

track :: forall msg. Array (Attribute msg) -> View msg -> View msg
track = mkTagFn "track"

tt :: forall msg. Array (Attribute msg) -> View msg -> View msg
tt = mkTagFn "tt"

u :: forall msg. Array (Attribute msg) -> View msg -> View msg
u = mkTagFn "u"

ul :: forall msg. Array (Attribute msg) -> View msg -> View msg
ul = mkTagFn "ul"

var :: forall msg. Array (Attribute msg) -> View msg -> View msg
var = mkTagFn "var"

video :: forall msg. Array (Attribute msg) -> View msg -> View msg
video = mkTagFn "video"

wbr :: forall msg. Array (Attribute msg) -> View msg -> View msg
wbr = mkTagFn "wbr"
