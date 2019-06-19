module Oak.Html where

import Control.Monad.Writer

import Prelude
  ( class Functor
  , discard
  , map
  , pure
  , (<<<)
  , unit
  , Unit
  , pure
  )

import Oak.Html.Present
  ( present
  , class Present
  )
import Oak.Html.Attribute ( Attribute )

import Data.Tuple (fst)

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))


instance htmlFunctor :: Functor Html where
  map :: ∀ msg1 msg2. (msg1 -> msg2) -> Html msg1 -> Html msg2
  map f html =
    case html of
      Text str -> Text str
      Tag name attrs children ->
        Tag name (map (map f) attrs) (map (map f) children)


root :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Html msg
root attrs children = Tag "div" attrs (execWriter children)


empty :: ∀ msg. Writer (Array (Html msg)) Unit
empty = tell []


text :: ∀ a msg.
  (Present a)
    => a
    -> Writer (Array (Html msg)) Unit
text val = do
  let tag = Text (present val)
  tell [tag]
  pure unit


mkTagFn :: ∀ msg.
  String
    -> Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
mkTagFn name attrs children = do
  let tag = Tag name attrs (execWriter children)
  tell [tag]
  pure unit



a :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
a = mkTagFn "a"


abbr :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
abbr = mkTagFn "abbr"


address :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
address = mkTagFn "address"


area :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
area = mkTagFn "area"


article :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
article = mkTagFn "article"


aside :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
aside = mkTagFn "aside"


audio :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
audio = mkTagFn "audio"


b :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
b = mkTagFn "b"


bdi :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
bdi = mkTagFn "bdi"


bdo :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
bdo = mkTagFn "bdo"


big :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
big = mkTagFn "big"


blockquote :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
blockquote = mkTagFn "blockquote"


br :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
br = mkTagFn "br"


button :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
button = mkTagFn "button"


canvas :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
canvas = mkTagFn "canvas"


caption :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
caption = mkTagFn "caption"


center :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
center = mkTagFn "center"


cite :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
cite = mkTagFn "cite"


code :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
code = mkTagFn "code"


col :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
col = mkTagFn "col"


colgroup :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
colgroup = mkTagFn "colgroup"


data_ :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
data_ = mkTagFn "data"


datalist :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
datalist = mkTagFn "datalist"


dd :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dd = mkTagFn "dd"


del :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
del = mkTagFn "del"


details :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
details = mkTagFn "details"


dfn :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dfn = mkTagFn "dfn"


dialog :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dialog = mkTagFn "dialog"


dir :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dir = mkTagFn "dir"


div :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
div = mkTagFn "div"


dl :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dl = mkTagFn "dl"


dt :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
dt = mkTagFn "dt"


em :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
em = mkTagFn "em"


fieldset :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
fieldset = mkTagFn "fieldset"


figcaption :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
figcaption = mkTagFn "figcaption"


figure :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
figure = mkTagFn "figure"


font :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
font = mkTagFn "font"


footer :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
footer = mkTagFn "footer"


form :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
form = mkTagFn "form"


h1 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h1 = mkTagFn "h1"


h2 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h2 = mkTagFn "h2"


h3 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h3 = mkTagFn "h3"


h4 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h4 = mkTagFn "h4"


h5 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h5 = mkTagFn "h5"


h6 :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
h6 = mkTagFn "h6"


header :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
header = mkTagFn "header"


hr :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
hr = mkTagFn "hr"


i :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
i = mkTagFn "i"


img :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
img = mkTagFn "img"


input :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
input = mkTagFn "input"


ins :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
ins = mkTagFn "ins"


kbd :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
kbd = mkTagFn "kbd"


label :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
label = mkTagFn "label"


legend :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
legend = mkTagFn "legend"


li :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
li = mkTagFn "li"


link :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
link = mkTagFn "link"


main :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
main = mkTagFn "main"


map_ :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
map_ = mkTagFn "map"


mark :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
mark = mkTagFn "mark"


menu :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
menu = mkTagFn "menu"


menuitem :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
menuitem = mkTagFn "menuitem"


meter :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
meter = mkTagFn "meter"


nav :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
nav = mkTagFn "nav"


ol :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
ol = mkTagFn "ol"


optgroup :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
optgroup = mkTagFn "optgroup"


option :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
option = mkTagFn "option"


output :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
output = mkTagFn "output"


p :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
p = mkTagFn "p"


picture :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
picture = mkTagFn "picture"


pre :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
pre = mkTagFn "pre"


progress :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
progress = mkTagFn "progress"


q :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
q = mkTagFn "q"


rp :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
rp = mkTagFn "rp"


rt :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
rt = mkTagFn "rt"


ruby :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
ruby = mkTagFn "ruby"


s :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
s = mkTagFn "s"


samp :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
samp = mkTagFn "samp"


section :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
section = mkTagFn "section"


select :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
select = mkTagFn "select"


small :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
small = mkTagFn "small"


source :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
source = mkTagFn "source"


span :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
span = mkTagFn "span"


strike :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
strike = mkTagFn "strike"


strong :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
strong = mkTagFn "strong"


sub :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
sub = mkTagFn "sub"


summary :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
summary = mkTagFn "summary"


sup :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
sup = mkTagFn "sup"


svg :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
svg = mkTagFn "svg"


table :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
table = mkTagFn "table"


tbody :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
tbody = mkTagFn "tbody"


td :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
td = mkTagFn "td"


template :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
template = mkTagFn "template"


textarea :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
textarea = mkTagFn "textarea"


tfoot :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
tfoot = mkTagFn "tfoot"


th :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
th = mkTagFn "th"


thead :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
thead = mkTagFn "thead"


time :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
time = mkTagFn "time"


tr :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
tr = mkTagFn "tr"


track :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
track = mkTagFn "track"


tt :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
tt = mkTagFn "tt"


u :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
u = mkTagFn "u"


ul :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
ul = mkTagFn "ul"


var :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
var = mkTagFn "var"


video :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
video = mkTagFn "video"


wbr :: ∀ msg.
  Array (Attribute msg)
    -> Writer (Array (Html msg)) Unit
    -> Writer (Array (Html msg)) Unit
wbr = mkTagFn "wbr"
