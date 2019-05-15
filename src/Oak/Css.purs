
-- | The Oak.Css module can be used to add style attributes to html various
-- | elements.
-- |
-- | ```purescript
-- | import Oak.Html.Attribute
-- | import Oak.Css
-- |
-- | view _ =
-- |   div [ style [ backgroundColor "red" ] ]
-- |    [ text "hi" ]
-- | ```

module Oak.Css where


data StyleAttribute
  = StyleAttribute String String


azimuth :: String -> StyleAttribute
azimuth val = StyleAttribute "azimuth" val


backgroundAttachment :: String -> StyleAttribute
backgroundAttachment val = StyleAttribute "background-attachment" val


backgroundColor :: String -> StyleAttribute
backgroundColor val = StyleAttribute "background-color" val


backgroundImage :: String -> StyleAttribute
backgroundImage val = StyleAttribute "background-image" val


backgroundPosition :: String -> StyleAttribute
backgroundPosition val = StyleAttribute "background-position" val


backgroundRepeat :: String -> StyleAttribute
backgroundRepeat val = StyleAttribute "background-repeat" val


backgroundSize :: String -> StyleAttribute
backgroundSize val = StyleAttribute "background-size" val


background :: String -> StyleAttribute
background val = StyleAttribute "background" val


borderCollapse :: String -> StyleAttribute
borderCollapse val = StyleAttribute "border-collapse" val


borderColor :: String -> StyleAttribute
borderColor val = StyleAttribute "border-color" val


borderSpacing :: String -> StyleAttribute
borderSpacing val = StyleAttribute "border-spacing" val


borderStyle :: String -> StyleAttribute
borderStyle val = StyleAttribute "border-style" val


borderTop :: String -> StyleAttribute
borderTop val = StyleAttribute "border-top" val


borderRight :: String -> StyleAttribute
borderRight val = StyleAttribute "border-right" val


borderBottom :: String -> StyleAttribute
borderBottom val = StyleAttribute "border-bottom" val


borderLeft :: String -> StyleAttribute
borderLeft val = StyleAttribute "border-left" val


borderTopColor :: String -> StyleAttribute
borderTopColor val = StyleAttribute "border-top-color" val


borderRightColor :: String -> StyleAttribute
borderRightColor val = StyleAttribute "border-right-color" val


borderBottomColor :: String -> StyleAttribute
borderBottomColor val = StyleAttribute "border-bottom-color" val


borderLeftColor :: String -> StyleAttribute
borderLeftColor val = StyleAttribute "border-left-color" val


borderTopStyle :: String -> StyleAttribute
borderTopStyle val = StyleAttribute "border-top-style" val


borderRightStyle :: String -> StyleAttribute
borderRightStyle val = StyleAttribute "border-right-style" val


borderBottomStyle :: String -> StyleAttribute
borderBottomStyle val = StyleAttribute "border-bottom-style" val


borderLeftStyle :: String -> StyleAttribute
borderLeftStyle val = StyleAttribute "border-left-style" val


borderTopWidth :: String -> StyleAttribute
borderTopWidth val = StyleAttribute "border-top-width" val


borderRightWidth :: String -> StyleAttribute
borderRightWidth val = StyleAttribute "border-right-width" val


borderBottomWidth :: String -> StyleAttribute
borderBottomWidth val = StyleAttribute "border-bottom-width" val


borderLeftWidth :: String -> StyleAttribute
borderLeftWidth val = StyleAttribute "border-left-width" val


borderWidth :: String -> StyleAttribute
borderWidth val = StyleAttribute "border-width" val


border :: String -> StyleAttribute
border val = StyleAttribute "border" val


bottom :: String -> StyleAttribute
bottom val = StyleAttribute "bottom" val


captionSide :: String -> StyleAttribute
captionSide val = StyleAttribute "caption-side" val


clear :: String -> StyleAttribute
clear val = StyleAttribute "clear" val


clip :: String -> StyleAttribute
clip val = StyleAttribute "clip" val


color :: String -> StyleAttribute
color val = StyleAttribute "color" val


content :: String -> StyleAttribute
content val = StyleAttribute "content" val


counterIncrement :: String -> StyleAttribute
counterIncrement val = StyleAttribute "counter-increment" val


counterReset :: String -> StyleAttribute
counterReset val = StyleAttribute "counter-reset" val


cueAfter :: String -> StyleAttribute
cueAfter val = StyleAttribute "cue-after" val


cueBefore :: String -> StyleAttribute
cueBefore val = StyleAttribute "cue-before" val


cue :: String -> StyleAttribute
cue val = StyleAttribute "cue" val


cursor :: String -> StyleAttribute
cursor val = StyleAttribute "cursor" val


direction :: String -> StyleAttribute
direction val = StyleAttribute "direction" val


display :: String -> StyleAttribute
display val = StyleAttribute "display" val


elevation :: String -> StyleAttribute
elevation val = StyleAttribute "elevation" val


emptyCells :: String -> StyleAttribute
emptyCells val = StyleAttribute "empty-cells" val


float :: String -> StyleAttribute
float val = StyleAttribute "float" val


fontFamily :: String -> StyleAttribute
fontFamily val = StyleAttribute "font-family" val


fontSize :: String -> StyleAttribute
fontSize val = StyleAttribute "font-size" val


fontStyle :: String -> StyleAttribute
fontStyle val = StyleAttribute "font-style" val


fontVariant :: String -> StyleAttribute
fontVariant val = StyleAttribute "font-variant" val


fontWeight :: String -> StyleAttribute
fontWeight val = StyleAttribute "font-weight" val


font :: String -> StyleAttribute
font val = StyleAttribute "font" val


height :: String -> StyleAttribute
height val = StyleAttribute "height" val


left :: String -> StyleAttribute
left val = StyleAttribute "left" val


letterSpacing :: String -> StyleAttribute
letterSpacing val = StyleAttribute "letter-spacing" val


lineHeight :: String -> StyleAttribute
lineHeight val = StyleAttribute "line-height" val


listStyleImage :: String -> StyleAttribute
listStyleImage val = StyleAttribute "list-style-image" val


listStylePosition :: String -> StyleAttribute
listStylePosition val = StyleAttribute "list-style-position" val


listStyleType :: String -> StyleAttribute
listStyleType val = StyleAttribute "list-style-type" val


listStyle :: String -> StyleAttribute
listStyle val = StyleAttribute "list-style" val


marginRight :: String -> StyleAttribute
marginRight val = StyleAttribute "margin-right" val


marginLeft :: String -> StyleAttribute
marginLeft val = StyleAttribute "margin-left" val


marginTop :: String -> StyleAttribute
marginTop val = StyleAttribute "margin-top" val


marginBottom :: String -> StyleAttribute
marginBottom val = StyleAttribute "margin-bottom" val


margin :: String -> StyleAttribute
margin val = StyleAttribute "margin" val


maxHeight :: String -> StyleAttribute
maxHeight val = StyleAttribute "max-height" val


maxWidth :: String -> StyleAttribute
maxWidth val = StyleAttribute "max-width" val


minHeight :: String -> StyleAttribute
minHeight val = StyleAttribute "min-height" val


minWidth :: String -> StyleAttribute
minWidth val = StyleAttribute "min-width" val


orphans :: String -> StyleAttribute
orphans val = StyleAttribute "orphans" val


outlineColor :: String -> StyleAttribute
outlineColor val = StyleAttribute "outline-color" val


outlineStyle :: String -> StyleAttribute
outlineStyle val = StyleAttribute "outline-style" val


outlineWidth :: String -> StyleAttribute
outlineWidth val = StyleAttribute "outline-width" val


outline :: String -> StyleAttribute
outline val = StyleAttribute "outline" val


overflow :: String -> StyleAttribute
overflow val = StyleAttribute "overflow" val


paddingTop :: String -> StyleAttribute
paddingTop val = StyleAttribute "padding-top" val


paddingRight :: String -> StyleAttribute
paddingRight val = StyleAttribute "padding-right" val


paddingBottom :: String -> StyleAttribute
paddingBottom val = StyleAttribute "padding-bottom" val


paddingLeft :: String -> StyleAttribute
paddingLeft val = StyleAttribute "padding-left" val


padding :: String -> StyleAttribute
padding val = StyleAttribute "padding" val


pageBreakAfter :: String -> StyleAttribute
pageBreakAfter val = StyleAttribute "page-break-after" val


pageBreakBefore :: String -> StyleAttribute
pageBreakBefore val = StyleAttribute "page-break-before" val


pageBreakInside :: String -> StyleAttribute
pageBreakInside val = StyleAttribute "page-break-inside" val


pauseAfter :: String -> StyleAttribute
pauseAfter val = StyleAttribute "pause-after" val


pauseBefore :: String -> StyleAttribute
pauseBefore val = StyleAttribute "pause-before" val


pause :: String -> StyleAttribute
pause val = StyleAttribute "pause" val


pitchRange :: String -> StyleAttribute
pitchRange val = StyleAttribute "pitch-range" val


pitch :: String -> StyleAttribute
pitch val = StyleAttribute "pitch" val


playDuring :: String -> StyleAttribute
playDuring val = StyleAttribute "play-during" val


position :: String -> StyleAttribute
position val = StyleAttribute "position" val


quotes :: String -> StyleAttribute
quotes val = StyleAttribute "quotes" val


richness :: String -> StyleAttribute
richness val = StyleAttribute "richness" val


right :: String -> StyleAttribute
right val = StyleAttribute "right" val


speakHeader :: String -> StyleAttribute
speakHeader val = StyleAttribute "speak-header" val


speakNumeral :: String -> StyleAttribute
speakNumeral val = StyleAttribute "speak-numeral" val


speakPunctuation :: String -> StyleAttribute
speakPunctuation val = StyleAttribute "speak-punctuation" val


speak :: String -> StyleAttribute
speak val = StyleAttribute "speak" val


speechRate :: String -> StyleAttribute
speechRate val = StyleAttribute "speech-rate" val


stress :: String -> StyleAttribute
stress val = StyleAttribute "stress" val


tableLayout :: String -> StyleAttribute
tableLayout val = StyleAttribute "table-layout" val


textAlign :: String -> StyleAttribute
textAlign val = StyleAttribute "text-align" val


textDecoration :: String -> StyleAttribute
textDecoration val = StyleAttribute "text-decoration" val


textIndent :: String -> StyleAttribute
textIndent val = StyleAttribute "text-indent" val


textTransform :: String -> StyleAttribute
textTransform val = StyleAttribute "text-transform" val


top :: String -> StyleAttribute
top val = StyleAttribute "top" val


unicodeBidi :: String -> StyleAttribute
unicodeBidi val = StyleAttribute "unicode-bidi" val


verticalAlign :: String -> StyleAttribute
verticalAlign val = StyleAttribute "vertical-align" val


visibility :: String -> StyleAttribute
visibility val = StyleAttribute "visibility" val


voiceFamily :: String -> StyleAttribute
voiceFamily val = StyleAttribute "voice-family" val


volume :: String -> StyleAttribute
volume val = StyleAttribute "volume" val


whiteSpace :: String -> StyleAttribute
whiteSpace val = StyleAttribute "white-space" val


widows :: String -> StyleAttribute
widows val = StyleAttribute "widows" val


width :: String -> StyleAttribute
width val = StyleAttribute "width" val


wordSpacing :: String -> StyleAttribute
wordSpacing val = StyleAttribute "word-spacing" val


zIndex :: String -> StyleAttribute
zIndex val = StyleAttribute "z-index" val

