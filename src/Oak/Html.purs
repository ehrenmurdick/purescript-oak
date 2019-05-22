module Oak.Html where

import Prelude
  ( map
  )

import Oak.Html.Present
  ( present
  , class Present
  )
import Oak.Html.Attribute ( Attribute )
import Data.Functor ( class Functor )

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


text :: ∀ a msg. (Present a) => a -> Html msg
text val = Text (present val)


a :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
a attrs children = Tag "a" attrs children


abbr :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
abbr attrs children = Tag "abbr" attrs children


address :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
address attrs children = Tag "address" attrs children


area :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
area attrs children = Tag "area" attrs children


article :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
article attrs children = Tag "article" attrs children


aside :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
aside attrs children = Tag "aside" attrs children


audio :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
audio attrs children = Tag "audio" attrs children


b :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
b attrs children = Tag "b" attrs children


bdi :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
bdi attrs children = Tag "bdi" attrs children


bdo :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
bdo attrs children = Tag "bdo" attrs children


big :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
big attrs children = Tag "big" attrs children


blockquote :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
blockquote attrs children = Tag "blockquote" attrs children


br :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
br attrs children = Tag "br" attrs children


button :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
button attrs children = Tag "button" attrs children


canvas :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
canvas attrs children = Tag "canvas" attrs children


caption :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
caption attrs children = Tag "caption" attrs children


center :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
center attrs children = Tag "center" attrs children


cite :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
cite attrs children = Tag "cite" attrs children


code :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
code attrs children = Tag "code" attrs children


col :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
col attrs children = Tag "col" attrs children


colgroup :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
colgroup attrs children = Tag "colgroup" attrs children


data_ :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
data_ attrs children = Tag "data" attrs children


datalist :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
datalist attrs children = Tag "datalist" attrs children


dd :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dd attrs children = Tag "dd" attrs children


del :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
del attrs children = Tag "del" attrs children


details :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
details attrs children = Tag "details" attrs children


dfn :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dfn attrs children = Tag "dfn" attrs children


dialog :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dialog attrs children = Tag "dialog" attrs children


dir :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dir attrs children = Tag "dir" attrs children


div :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
div attrs children = Tag "div" attrs children


dl :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dl attrs children = Tag "dl" attrs children


dt :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dt attrs children = Tag "dt" attrs children


em :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
em attrs children = Tag "em" attrs children


fieldset :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
fieldset attrs children = Tag "fieldset" attrs children


figcaption :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
figcaption attrs children = Tag "figcaption" attrs children


figure :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
figure attrs children = Tag "figure" attrs children


font :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
font attrs children = Tag "font" attrs children


footer :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
footer attrs children = Tag "footer" attrs children


form :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
form attrs children = Tag "form" attrs children


h1 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h1 attrs children = Tag "h1" attrs children


h2 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h2 attrs children = Tag "h2" attrs children


h3 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h3 attrs children = Tag "h3" attrs children


h4 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h4 attrs children = Tag "h4" attrs children


h5 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h5 attrs children = Tag "h5" attrs children


h6 :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h6 attrs children = Tag "h6" attrs children


header :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
header attrs children = Tag "header" attrs children


hr :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
hr attrs children = Tag "hr" attrs children


i :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
i attrs children = Tag "i" attrs children


img :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
img attrs children = Tag "img" attrs children


input :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
input attrs children = Tag "input" attrs children


ins :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ins attrs children = Tag "ins" attrs children


kbd :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
kbd attrs children = Tag "kbd" attrs children


label :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
label attrs children = Tag "label" attrs children


legend :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
legend attrs children = Tag "legend" attrs children


li :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
li attrs children = Tag "li" attrs children


link :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
link attrs children = Tag "link" attrs children


main :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
main attrs children = Tag "main" attrs children


map_ :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
map_ attrs children = Tag "map" attrs children


mark :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
mark attrs children = Tag "mark" attrs children


menu :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
menu attrs children = Tag "menu" attrs children


menuitem :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
menuitem attrs children = Tag "menuitem" attrs children


meter :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
meter attrs children = Tag "meter" attrs children


nav :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
nav attrs children = Tag "nav" attrs children


ol :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ol attrs children = Tag "ol" attrs children


optgroup :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
optgroup attrs children = Tag "optgroup" attrs children


option :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
option attrs children = Tag "option" attrs children


output :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
output attrs children = Tag "output" attrs children


p :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
p attrs children = Tag "p" attrs children


picture :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
picture attrs children = Tag "picture" attrs children


pre :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
pre attrs children = Tag "pre" attrs children


progress :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
progress attrs children = Tag "progress" attrs children


q :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
q attrs children = Tag "q" attrs children


rp :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
rp attrs children = Tag "rp" attrs children


rt :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
rt attrs children = Tag "rt" attrs children


ruby :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ruby attrs children = Tag "ruby" attrs children


s :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
s attrs children = Tag "s" attrs children


samp :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
samp attrs children = Tag "samp" attrs children


section :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
section attrs children = Tag "section" attrs children


select :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
select attrs children = Tag "select" attrs children


small :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
small attrs children = Tag "small" attrs children


source :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
source attrs children = Tag "source" attrs children


span :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
span attrs children = Tag "span" attrs children


strike :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
strike attrs children = Tag "strike" attrs children


strong :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
strong attrs children = Tag "strong" attrs children


sub :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
sub attrs children = Tag "sub" attrs children


summary :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
summary attrs children = Tag "summary" attrs children


sup :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
sup attrs children = Tag "sup" attrs children


svg :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
svg attrs children = Tag "svg" attrs children


table :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
table attrs children = Tag "table" attrs children


tbody :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tbody attrs children = Tag "tbody" attrs children


td :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
td attrs children = Tag "td" attrs children


template :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
template attrs children = Tag "template" attrs children


textarea :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
textarea attrs children = Tag "textarea" attrs children


tfoot :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tfoot attrs children = Tag "tfoot" attrs children


th :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
th attrs children = Tag "th" attrs children


thead :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
thead attrs children = Tag "thead" attrs children


time :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
time attrs children = Tag "time" attrs children


tr :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tr attrs children = Tag "tr" attrs children


track :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
track attrs children = Tag "track" attrs children


tt :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tt attrs children = Tag "tt" attrs children


u :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
u attrs children = Tag "u" attrs children


ul :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ul attrs children = Tag "ul" attrs children


var :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
var attrs children = Tag "var" attrs children


video :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
video attrs children = Tag "video" attrs children


wbr :: ∀ msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
wbr attrs children = Tag "wbr" attrs children

