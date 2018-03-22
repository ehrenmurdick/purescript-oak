module Oak.Html where

import Oak.Html.Attribute

data Html msg
  = Text String
  | Tag String (Array (Attribute msg)) (Array (Html msg))


text :: forall msg. String -> Html msg
text str = Text str


a :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
a attrs children = Tag "a" attrs children


abbr :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
abbr attrs children = Tag "abbr" attrs children


address :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
address attrs children = Tag "address" attrs children


area :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
area attrs children = Tag "area" attrs children


article :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
article attrs children = Tag "article" attrs children


aside :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
aside attrs children = Tag "aside" attrs children


audio :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
audio attrs children = Tag "audio" attrs children


b :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
b attrs children = Tag "b" attrs children


bdi :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
bdi attrs children = Tag "bdi" attrs children


bdo :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
bdo attrs children = Tag "bdo" attrs children


big :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
big attrs children = Tag "big" attrs children


blockquote :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
blockquote attrs children = Tag "blockquote" attrs children


br :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
br attrs children = Tag "br" attrs children


button :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
button attrs children = Tag "button" attrs children


canvas :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
canvas attrs children = Tag "canvas" attrs children


caption :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
caption attrs children = Tag "caption" attrs children


center :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
center attrs children = Tag "center" attrs children


cite :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
cite attrs children = Tag "cite" attrs children


code :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
code attrs children = Tag "code" attrs children


col :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
col attrs children = Tag "col" attrs children


colgroup :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
colgroup attrs children = Tag "colgroup" attrs children


data_ :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
data_ attrs children = Tag "data" attrs children


datalist :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
datalist attrs children = Tag "datalist" attrs children


dd :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dd attrs children = Tag "dd" attrs children


del :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
del attrs children = Tag "del" attrs children


details :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
details attrs children = Tag "details" attrs children


dfn :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dfn attrs children = Tag "dfn" attrs children


dialog :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dialog attrs children = Tag "dialog" attrs children


dir :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dir attrs children = Tag "dir" attrs children


div_ :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
div_ attrs children = Tag "div" attrs children


dl :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dl attrs children = Tag "dl" attrs children


dt :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
dt attrs children = Tag "dt" attrs children


em :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
em attrs children = Tag "em" attrs children


fieldset :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
fieldset attrs children = Tag "fieldset" attrs children


figcaption :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
figcaption attrs children = Tag "figcaption" attrs children


figure :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
figure attrs children = Tag "figure" attrs children


font :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
font attrs children = Tag "font" attrs children


footer :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
footer attrs children = Tag "footer" attrs children


form :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
form attrs children = Tag "form" attrs children


h1 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h1 attrs children = Tag "h1" attrs children


h2 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h2 attrs children = Tag "h2" attrs children


h3 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h3 attrs children = Tag "h3" attrs children


h4 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h4 attrs children = Tag "h4" attrs children


h5 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h5 attrs children = Tag "h5" attrs children


h6 :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
h6 attrs children = Tag "h6" attrs children


header :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
header attrs children = Tag "header" attrs children


hr :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
hr attrs children = Tag "hr" attrs children


i :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
i attrs children = Tag "i" attrs children


img :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
img attrs children = Tag "img" attrs children


input :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
input attrs children = Tag "input" attrs children


ins :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ins attrs children = Tag "ins" attrs children


kbd :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
kbd attrs children = Tag "kbd" attrs children


label :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
label attrs children = Tag "label" attrs children


legend :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
legend attrs children = Tag "legend" attrs children


li :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
li attrs children = Tag "li" attrs children


link :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
link attrs children = Tag "link" attrs children


main :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
main attrs children = Tag "main" attrs children


map :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
map attrs children = Tag "map" attrs children


mark :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
mark attrs children = Tag "mark" attrs children


menu :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
menu attrs children = Tag "menu" attrs children


menuitem :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
menuitem attrs children = Tag "menuitem" attrs children


meter :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
meter attrs children = Tag "meter" attrs children


nav :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
nav attrs children = Tag "nav" attrs children


ol :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ol attrs children = Tag "ol" attrs children


optgroup :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
optgroup attrs children = Tag "optgroup" attrs children


option :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
option attrs children = Tag "option" attrs children


output :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
output attrs children = Tag "output" attrs children


p :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
p attrs children = Tag "p" attrs children


picture :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
picture attrs children = Tag "picture" attrs children


pre :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
pre attrs children = Tag "pre" attrs children


progress :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
progress attrs children = Tag "progress" attrs children


q :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
q attrs children = Tag "q" attrs children


rp :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
rp attrs children = Tag "rp" attrs children


rt :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
rt attrs children = Tag "rt" attrs children


ruby :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ruby attrs children = Tag "ruby" attrs children


s :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
s attrs children = Tag "s" attrs children


samp :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
samp attrs children = Tag "samp" attrs children


section :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
section attrs children = Tag "section" attrs children


select :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
select attrs children = Tag "select" attrs children


small :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
small attrs children = Tag "small" attrs children


source :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
source attrs children = Tag "source" attrs children


span :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
span attrs children = Tag "span" attrs children


strike :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
strike attrs children = Tag "strike" attrs children


strong :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
strong attrs children = Tag "strong" attrs children


sub :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
sub attrs children = Tag "sub" attrs children


summary :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
summary attrs children = Tag "summary" attrs children


sup :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
sup attrs children = Tag "sup" attrs children


svg :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
svg attrs children = Tag "svg" attrs children


table :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
table attrs children = Tag "table" attrs children


tbody :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tbody attrs children = Tag "tbody" attrs children


td :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
td attrs children = Tag "td" attrs children


template :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
template attrs children = Tag "template" attrs children


textarea :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
textarea attrs children = Tag "textarea" attrs children


tfoot :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tfoot attrs children = Tag "tfoot" attrs children


th :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
th attrs children = Tag "th" attrs children


thead :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
thead attrs children = Tag "thead" attrs children


time :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
time attrs children = Tag "time" attrs children


tr :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tr attrs children = Tag "tr" attrs children


track :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
track attrs children = Tag "track" attrs children


tt :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
tt attrs children = Tag "tt" attrs children


u :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
u attrs children = Tag "u" attrs children


ul :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
ul attrs children = Tag "ul" attrs children


var :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
var attrs children = Tag "var" attrs children


video :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
video attrs children = Tag "video" attrs children


wbr :: forall msg. Array (Attribute msg) -> Array (Html msg) -> Html msg
wbr attrs children = Tag "wbr" attrs children
