module Oak.Html.Events where

import Oak.Html.Attribute

onClick :: ∀ msg.  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg

onInput :: ∀ msg.  (String -> msg) -> Attribute msg
onInput f = StringEventHandler "oninput" f


-- onabort :: ∀ msg. String -> Attribute msg
-- onabort val = SimpleAttribute "onabort" val


-- onafterprint :: ∀ msg. String -> Attribute msg
-- onafterprint val = SimpleAttribute "onafterprint" val


-- onbeforeprint :: ∀ msg. String -> Attribute msg
-- onbeforeprint val = SimpleAttribute "onbeforeprint" val


-- onbeforeunload :: ∀ msg. String -> Attribute msg
-- onbeforeunload val = SimpleAttribute "onbeforeunload" val


-- onblur :: ∀ msg. String -> Attribute msg
-- onblur val = SimpleAttribute "onblur" val


-- oncanplay :: ∀ msg. String -> Attribute msg
-- oncanplay val = SimpleAttribute "oncanplay" val


-- oncanplaythrough :: ∀ msg. String -> Attribute msg
-- oncanplaythrough val = SimpleAttribute "oncanplaythrough" val


-- onchange :: ∀ msg. String -> Attribute msg
-- onchange val = SimpleAttribute "onchange" val


-- onclick :: ∀ msg. String -> Attribute msg
-- onclick val = SimpleAttribute "onclick" val


-- oncontextmenu :: ∀ msg. String -> Attribute msg
-- oncontextmenu val = SimpleAttribute "oncontextmenu" val


-- oncopy :: ∀ msg. String -> Attribute msg
-- oncopy val = SimpleAttribute "oncopy" val


-- oncuechange :: ∀ msg. String -> Attribute msg
-- oncuechange val = SimpleAttribute "oncuechange" val


-- oncut :: ∀ msg. String -> Attribute msg
-- oncut val = SimpleAttribute "oncut" val


-- ondblclick :: ∀ msg. String -> Attribute msg
-- ondblclick val = SimpleAttribute "ondblclick" val


-- ondrag :: ∀ msg. String -> Attribute msg
-- ondrag val = SimpleAttribute "ondrag" val


-- ondragend :: ∀ msg. String -> Attribute msg
-- ondragend val = SimpleAttribute "ondragend" val


-- ondragenter :: ∀ msg. String -> Attribute msg
-- ondragenter val = SimpleAttribute "ondragenter" val


-- ondragleave :: ∀ msg. String -> Attribute msg
-- ondragleave val = SimpleAttribute "ondragleave" val


-- ondragover :: ∀ msg. String -> Attribute msg
-- ondragover val = SimpleAttribute "ondragover" val


-- ondragstart :: ∀ msg. String -> Attribute msg
-- ondragstart val = SimpleAttribute "ondragstart" val


-- ondrop :: ∀ msg. String -> Attribute msg
-- ondrop val = SimpleAttribute "ondrop" val


-- ondurationchange :: ∀ msg. String -> Attribute msg
-- ondurationchange val = SimpleAttribute "ondurationchange" val


-- onemptied :: ∀ msg. String -> Attribute msg
-- onemptied val = SimpleAttribute "onemptied" val


-- onended :: ∀ msg. String -> Attribute msg
-- onended val = SimpleAttribute "onended" val


-- onerror :: ∀ msg. String -> Attribute msg
-- onerror val = SimpleAttribute "onerror" val


-- onfocus :: ∀ msg. String -> Attribute msg
-- onfocus val = SimpleAttribute "onfocus" val


-- onhashchange :: ∀ msg. String -> Attribute msg
-- onhashchange val = SimpleAttribute "onhashchange" val


-- oninput :: ∀ msg. String -> Attribute msg
-- oninput val = SimpleAttribute "oninput" val


-- oninvalid :: ∀ msg. String -> Attribute msg
-- oninvalid val = SimpleAttribute "oninvalid" val


-- onkeydown :: ∀ msg. String -> Attribute msg
-- onkeydown val = SimpleAttribute "onkeydown" val


-- onkeypress :: ∀ msg. String -> Attribute msg
-- onkeypress val = SimpleAttribute "onkeypress" val


-- onkeyup :: ∀ msg. String -> Attribute msg
-- onkeyup val = SimpleAttribute "onkeyup" val


-- onload :: ∀ msg. String -> Attribute msg
-- onload val = SimpleAttribute "onload" val


-- onloadeddata :: ∀ msg. String -> Attribute msg
-- onloadeddata val = SimpleAttribute "onloadeddata" val


-- onloadedmetadata :: ∀ msg. String -> Attribute msg
-- onloadedmetadata val = SimpleAttribute "onloadedmetadata" val


-- onloadstart :: ∀ msg. String -> Attribute msg
-- onloadstart val = SimpleAttribute "onloadstart" val


-- onmousedown :: ∀ msg. String -> Attribute msg
-- onmousedown val = SimpleAttribute "onmousedown" val


-- onmousemove :: ∀ msg. String -> Attribute msg
-- onmousemove val = SimpleAttribute "onmousemove" val


-- onmouseout :: ∀ msg. String -> Attribute msg
-- onmouseout val = SimpleAttribute "onmouseout" val


-- onmouseover :: ∀ msg. String -> Attribute msg
-- onmouseover val = SimpleAttribute "onmouseover" val


-- onmouseup :: ∀ msg. String -> Attribute msg
-- onmouseup val = SimpleAttribute "onmouseup" val


-- onmousewheel :: ∀ msg. String -> Attribute msg
-- onmousewheel val = SimpleAttribute "onmousewheel" val


-- onoffline :: ∀ msg. String -> Attribute msg
-- onoffline val = SimpleAttribute "onoffline" val


-- ononline :: ∀ msg. String -> Attribute msg
-- ononline val = SimpleAttribute "ononline" val


-- onpagehide :: ∀ msg. String -> Attribute msg
-- onpagehide val = SimpleAttribute "onpagehide" val


-- onpageshow :: ∀ msg. String -> Attribute msg
-- onpageshow val = SimpleAttribute "onpageshow" val


-- onpaste :: ∀ msg. String -> Attribute msg
-- onpaste val = SimpleAttribute "onpaste" val


-- onpause :: ∀ msg. String -> Attribute msg
-- onpause val = SimpleAttribute "onpause" val


-- onplay :: ∀ msg. String -> Attribute msg
-- onplay val = SimpleAttribute "onplay" val


-- onplaying :: ∀ msg. String -> Attribute msg
-- onplaying val = SimpleAttribute "onplaying" val


-- onpopstate :: ∀ msg. String -> Attribute msg
-- onpopstate val = SimpleAttribute "onpopstate" val


-- onprogress :: ∀ msg. String -> Attribute msg
-- onprogress val = SimpleAttribute "onprogress" val


-- onratechange :: ∀ msg. String -> Attribute msg
-- onratechange val = SimpleAttribute "onratechange" val


-- onreset :: ∀ msg. String -> Attribute msg
-- onreset val = SimpleAttribute "onreset" val


-- onresize :: ∀ msg. String -> Attribute msg
-- onresize val = SimpleAttribute "onresize" val


-- onscroll :: ∀ msg. String -> Attribute msg
-- onscroll val = SimpleAttribute "onscroll" val


-- onsearch :: ∀ msg. String -> Attribute msg
-- onsearch val = SimpleAttribute "onsearch" val


-- onseeked :: ∀ msg. String -> Attribute msg
-- onseeked val = SimpleAttribute "onseeked" val


-- onseeking :: ∀ msg. String -> Attribute msg
-- onseeking val = SimpleAttribute "onseeking" val


-- onselect :: ∀ msg. String -> Attribute msg
-- onselect val = SimpleAttribute "onselect" val


-- onstalled :: ∀ msg. String -> Attribute msg
-- onstalled val = SimpleAttribute "onstalled" val


-- onstorage :: ∀ msg. String -> Attribute msg
-- onstorage val = SimpleAttribute "onstorage" val


-- onsubmit :: ∀ msg. String -> Attribute msg
-- onsubmit val = SimpleAttribute "onsubmit" val


-- onsuspend :: ∀ msg. String -> Attribute msg
-- onsuspend val = SimpleAttribute "onsuspend" val


-- ontimeupdate :: ∀ msg. String -> Attribute msg
-- ontimeupdate val = SimpleAttribute "ontimeupdate" val


-- ontoggle :: ∀ msg. String -> Attribute msg
-- ontoggle val = SimpleAttribute "ontoggle" val


-- onunload :: ∀ msg. String -> Attribute msg
-- onunload val = SimpleAttribute "onunload" val


-- onvolumechange :: ∀ msg. String -> Attribute msg
-- onvolumechange val = SimpleAttribute "onvolumechange" val


-- onwaiting :: ∀ msg. String -> Attribute msg
-- onwaiting val = SimpleAttribute "onwaiting" val


-- onwheel :: ∀ msg. String -> Attribute msg
-- onwheel val = SimpleAttribute "onwheel" val
