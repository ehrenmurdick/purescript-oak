module Oak.Html.Events where

import Oak.Html.Attribute


-- events with assoc string data, e.g. oninput
---------------------------------------

onInput :: ∀ msg.  (String -> msg) -> Attribute msg
onInput f = StringEventHandler "oninput" f


-- keypress events
------------------

onKeydown :: ∀ msg. (KeyPressEvent -> msg) -> Attribute msg
onKeydown f = KeyPressEventHandler "onkeydown" f


onKeypress :: ∀ msg.  (KeyPressEvent -> msg) -> Attribute msg
onKeypress f = KeyPressEventHandler "onkeypress" f


onKeyup :: ∀ msg.  (KeyPressEvent -> msg) -> Attribute msg
onKeyup f = KeyPressEventHandler "onkeyup" f



-- events with no assoc data, e.g. onclick
------------------------------------------


onAbort :: ∀ msg.  msg -> Attribute msg
onAbort msg = EventHandler "onabort" msg


onAfterprint :: ∀ msg.  msg -> Attribute msg
onAfterprint msg = EventHandler "onafterprint" msg


onBeforeprint :: ∀ msg.  msg -> Attribute msg
onBeforeprint msg = EventHandler "onbeforeprint" msg


onBeforeunload :: ∀ msg.  msg -> Attribute msg
onBeforeunload msg = EventHandler "onbeforeunload" msg


onBlur :: ∀ msg.  msg -> Attribute msg
onBlur msg = EventHandler "onblur" msg


onCanplay :: ∀ msg.  msg -> Attribute msg
onCanplay msg = EventHandler "oncanplay" msg


onCanplaythrough :: ∀ msg.  msg -> Attribute msg
onCanplaythrough msg = EventHandler "oncanplaythrough" msg


onChange :: ∀ msg.  msg -> Attribute msg
onChange msg = EventHandler "onchange" msg


onClick :: ∀ msg.  msg -> Attribute msg
onClick msg = EventHandler "onclick" msg


onContextmenu :: ∀ msg.  msg -> Attribute msg
onContextmenu msg = EventHandler "oncontextmenu" msg


onCopy :: ∀ msg.  msg -> Attribute msg
onCopy msg = EventHandler "oncopy" msg


onCuechange :: ∀ msg.  msg -> Attribute msg
onCuechange msg = EventHandler "oncuechange" msg


onCut :: ∀ msg.  msg -> Attribute msg
onCut msg = EventHandler "oncut" msg


onDblclick :: ∀ msg.  msg -> Attribute msg
onDblclick msg = EventHandler "ondblclick" msg


onDrag :: ∀ msg.  msg -> Attribute msg
onDrag msg = EventHandler "ondrag" msg


onDragend :: ∀ msg.  msg -> Attribute msg
onDragend msg = EventHandler "ondragend" msg


onDragenter :: ∀ msg.  msg -> Attribute msg
onDragenter msg = EventHandler "ondragenter" msg


onDragleave :: ∀ msg.  msg -> Attribute msg
onDragleave msg = EventHandler "ondragleave" msg


onDragover :: ∀ msg.  msg -> Attribute msg
onDragover msg = EventHandler "ondragover" msg


onDragstart :: ∀ msg.  msg -> Attribute msg
onDragstart msg = EventHandler "ondragstart" msg


onDrop :: ∀ msg.  msg -> Attribute msg
onDrop msg = EventHandler "ondrop" msg


onDurationchange :: ∀ msg.  msg -> Attribute msg
onDurationchange msg = EventHandler "ondurationchange" msg


onEmptied :: ∀ msg.  msg -> Attribute msg
onEmptied msg = EventHandler "onemptied" msg


onEnded :: ∀ msg.  msg -> Attribute msg
onEnded msg = EventHandler "onended" msg


onError :: ∀ msg.  msg -> Attribute msg
onError msg = EventHandler "onerror" msg


onFocus :: ∀ msg.  msg -> Attribute msg
onFocus msg = EventHandler "onfocus" msg


onHashchange :: ∀ msg.  msg -> Attribute msg
onHashchange msg = EventHandler "onhashchange" msg


onInvalid :: ∀ msg.  msg -> Attribute msg
onInvalid msg = EventHandler "oninvalid" msg


onLoad :: ∀ msg.  msg -> Attribute msg
onLoad msg = EventHandler "onload" msg


onLoadeddata :: ∀ msg.  msg -> Attribute msg
onLoadeddata msg = EventHandler "onloadeddata" msg


onLoadedmetadata :: ∀ msg.  msg -> Attribute msg
onLoadedmetadata msg = EventHandler "onloadedmetadata" msg


onLoadstart :: ∀ msg.  msg -> Attribute msg
onLoadstart msg = EventHandler "onloadstart" msg


onMousedown :: ∀ msg.  msg -> Attribute msg
onMousedown msg = EventHandler "onmousedown" msg


onMousemove :: ∀ msg.  msg -> Attribute msg
onMousemove msg = EventHandler "onmousemove" msg


onMouseout :: ∀ msg.  msg -> Attribute msg
onMouseout msg = EventHandler "onmouseout" msg


onMouseover :: ∀ msg.  msg -> Attribute msg
onMouseover msg = EventHandler "onmouseover" msg


onMouseup :: ∀ msg.  msg -> Attribute msg
onMouseup msg = EventHandler "onmouseup" msg


onMousewheel :: ∀ msg.  msg -> Attribute msg
onMousewheel msg = EventHandler "onmousewheel" msg


onOffline :: ∀ msg.  msg -> Attribute msg
onOffline msg = EventHandler "onoffline" msg


onOnline :: ∀ msg.  msg -> Attribute msg
onOnline msg = EventHandler "ononline" msg


onPagehide :: ∀ msg.  msg -> Attribute msg
onPagehide msg = EventHandler "onpagehide" msg


onPageshow :: ∀ msg.  msg -> Attribute msg
onPageshow msg = EventHandler "onpageshow" msg


onPaste :: ∀ msg.  msg -> Attribute msg
onPaste msg = EventHandler "onpaste" msg


onPause :: ∀ msg.  msg -> Attribute msg
onPause msg = EventHandler "onpause" msg


onPlay :: ∀ msg.  msg -> Attribute msg
onPlay msg = EventHandler "onplay" msg


onPlaying :: ∀ msg.  msg -> Attribute msg
onPlaying msg = EventHandler "onplaying" msg


onPopstate :: ∀ msg.  msg -> Attribute msg
onPopstate msg = EventHandler "onpopstate" msg


onProgress :: ∀ msg.  msg -> Attribute msg
onProgress msg = EventHandler "onprogress" msg


onRatechange :: ∀ msg.  msg -> Attribute msg
onRatechange msg = EventHandler "onratechange" msg


onReset :: ∀ msg.  msg -> Attribute msg
onReset msg = EventHandler "onreset" msg


onResize :: ∀ msg.  msg -> Attribute msg
onResize msg = EventHandler "onresize" msg


onScroll :: ∀ msg.  msg -> Attribute msg
onScroll msg = EventHandler "onscroll" msg


onSearch :: ∀ msg.  msg -> Attribute msg
onSearch msg = EventHandler "onsearch" msg


onSeeked :: ∀ msg.  msg -> Attribute msg
onSeeked msg = EventHandler "onseeked" msg


onSeeking :: ∀ msg.  msg -> Attribute msg
onSeeking msg = EventHandler "onseeking" msg


onSelect :: ∀ msg.  msg -> Attribute msg
onSelect msg = EventHandler "onselect" msg


onStalled :: ∀ msg.  msg -> Attribute msg
onStalled msg = EventHandler "onstalled" msg


onStorage :: ∀ msg.  msg -> Attribute msg
onStorage msg = EventHandler "onstorage" msg


onSubmit :: ∀ msg.  msg -> Attribute msg
onSubmit msg = EventHandler "onsubmit" msg


onSuspend :: ∀ msg.  msg -> Attribute msg
onSuspend msg = EventHandler "onsuspend" msg


onTimeupdate :: ∀ msg.  msg -> Attribute msg
onTimeupdate msg = EventHandler "ontimeupdate" msg


onToggle :: ∀ msg.  msg -> Attribute msg
onToggle msg = EventHandler "ontoggle" msg


onUnload :: ∀ msg.  msg -> Attribute msg
onUnload msg = EventHandler "onunload" msg


onVolumechange :: ∀ msg.  msg -> Attribute msg
onVolumechange msg = EventHandler "onvolumechange" msg


onWaiting :: ∀ msg.  msg -> Attribute msg
onWaiting msg = EventHandler "onwaiting" msg


onWheel :: ∀ msg.  msg -> Attribute msg
onWheel msg = EventHandler "onwheel" msg

