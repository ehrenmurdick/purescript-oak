module Oak.Html.Events where

import Prelude (map)
import Oak.Html.Attribute


-- events with assoc string data, e.g. oninput
---------------------------------------

onInput :: ∀ msg.  (String -> msg) -> Attribute msg
onInput f = StringEventHandler "oninput" f


-- keypress events
------------------

onKeydown' :: ∀ msg. (KeyPressEvent -> msg) -> Attribute msg
onKeydown' f = KeyPressEventHandler "onkeydown" f


onKeydown :: ∀ msg. (Int -> msg) -> Attribute msg
onKeydown f = onKeydown' (map f \e -> e.keyCode)


onKeypress' :: ∀ msg.  (KeyPressEvent -> msg) -> Attribute msg
onKeypress' f = KeyPressEventHandler "onkeypress" f


onKeypress :: ∀ msg. (Int -> msg) -> Attribute msg
onKeypress f = onKeypress' (map f \e -> e.keyCode)


onKeyup' :: ∀ msg.  (KeyPressEvent -> msg) -> Attribute msg
onKeyup' f = KeyPressEventHandler "onkeyup" f


onKeyup :: ∀ msg. (Int -> msg) -> Attribute msg
onKeyup f = onKeyup' (map f \e -> e.keyCode)


-- drag and drop
----------------
--
-- HTML5's native drag and drop, which is a protocol rather than a set of
-- events: a drag carries a string payload, and a drop only happens if the
-- element under the pointer has been cancelling `dragover` all along. The
-- three pieces an app needs are `onDragstartWith` on the thing being
-- dragged, `allowDrop` and `onDrop'` on the thing being dropped onto.
--
-- ```purescript
-- -- the card
-- div [ draggable "true", onDragstartWith (show card.id) (Grabbed card.id) ] [ ... ]
--
-- -- somewhere it can go
-- div [ allowDrop, onDrop' \e -> Dropped e.dataTransfer slot ] [ ... ]
-- ```
--
-- Touch is the standing limitation: most mobile browsers do not fire these
-- events at all.


-- | Mark this element as a place a drop is allowed, without sending a
-- | message.
-- |
-- | An element only accepts drops if it cancels `dragover`, and `dragover`
-- | fires continuously for as long as the pointer is over it. This does the
-- | cancelling and nothing else, so a drop target costs no messages and no
-- | re-renders while a drag hovers over it. Pair it with `onDragenter` when
-- | the app wants to know it is being hovered.
allowDrop :: ∀ msg. Attribute msg
allowDrop = PreventDefault "ondragover"


-- | Start a drag carrying `payload`, and send a message.
-- |
-- | The payload is written to the event's `dataTransfer` as `text/plain` and
-- | comes back on `onDrop'` as `e.dataTransfer`. Sending one is not optional
-- | -- Firefox refuses to start a drag whose data was never set -- so this,
-- | rather than `onDragstart`, is the usual way to begin.
-- |
-- | It is a string, which means an id has to be printed here and parsed at
-- | the drop. Keeping the same id in the model alongside it is often easier
-- | than trusting the round trip.
-- |
-- | The element also needs `draggable "true"` before any of this fires.
onDragstartWith :: ∀ msg. String -> msg -> Attribute msg
onDragstartWith payload msg = DataTransferHandler "ondragstart" payload msg


onDragstart :: ∀ msg. msg -> Attribute msg
onDragstart msg = EventHandler "ondragstart" msg


onDragstart' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDragstart' f = DragEventHandler "ondragstart" f


-- | Fires continuously on the element being dragged. Firing rate is the
-- | pointer's, so turning it into a message repaints the app on every frame
-- | of the drag -- reach for it only when the app truly needs the positions.
onDrag :: ∀ msg. msg -> Attribute msg
onDrag msg = EventHandler "ondrag" msg


onDrag' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDrag' f = DragEventHandler "ondrag" f


-- | The drag is over, however it ended -- dropped, dropped somewhere that
-- | refused it, or cancelled with Escape.
-- |
-- | This fires on the element the drag *started* from, so it is the reliable
-- | place to clear whatever `onDragstartWith` set up. A drop that lands
-- | outside the window sends this and nothing else.
onDragend :: ∀ msg. msg -> Attribute msg
onDragend msg = EventHandler "ondragend" msg


onDragend' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDragend' f = DragEventHandler "ondragend" f


-- | A drag has entered this element. Cancels the default action, so an
-- | element with this on it is already a legal drop target for the moment
-- | the pointer is inside it -- but `dragover` is what keeps it one, so pair
-- | this with `allowDrop`.
-- |
-- | Note that this also fires as the pointer crosses into *child* elements,
-- | which is why highlighting a hovered target usually reads better driven
-- | from here and cleared on drop or `dragend`, rather than tracked with
-- | `onDragleave`.
onDragenter :: ∀ msg. msg -> Attribute msg
onDragenter msg = PreventingEventHandler "ondragenter" msg


onDragenter' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDragenter' f = PreventingDragEventHandler "ondragenter" f


-- | A drag has left this element -- or moved into one of its children, which
-- | the browser reports the same way. See the note on `onDragenter`.
onDragleave :: ∀ msg. msg -> Attribute msg
onDragleave msg = EventHandler "ondragleave" msg


onDragleave' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDragleave' f = DragEventHandler "ondragleave" f


-- | A drag is over this element. Cancels the default action, which is what
-- | makes the element accept drops at all.
-- |
-- | This fires every frame the pointer is inside the element, and every
-- | message is a full render and diff, so prefer `allowDrop` -- which does
-- | the same cancelling silently -- unless the app genuinely wants to hear
-- | about each frame.
onDragover :: ∀ msg. msg -> Attribute msg
onDragover msg = PreventingEventHandler "ondragover" msg


onDragover' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDragover' f = PreventingDragEventHandler "ondragover" f


-- | Something was dropped on this element. Cancels the default action, which
-- | would otherwise be the browser navigating to the dropped text or opening
-- | the dropped file.
-- |
-- | Only fires if the element was cancelling `dragover` -- see `allowDrop`.
onDrop :: ∀ msg. msg -> Attribute msg
onDrop msg = PreventingEventHandler "ondrop" msg


-- | `onDrop` with the payload the drag was carrying.
-- |
-- | ```purescript
-- | div [ allowDrop, onDrop' \e -> Dropped e.dataTransfer (EndOf column.id) ] [ ... ]
-- | ```
-- |
-- | `drop` is the only event that is allowed to read `e.dataTransfer`; every
-- | earlier one sees `""`.
onDrop' :: ∀ msg. (DragEvent -> msg) -> Attribute msg
onDrop' f = PreventingDragEventHandler "ondrop" f



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


-- | Handle a form submission, and stop the browser submitting the form.
-- |
-- | The default action is cancelled, so the page does not reload and the
-- | model survives. A form is then just a nicer way to get Enter-to-submit
-- | and a real submit button:
-- |
-- | ```purescript
-- | form [ onSubmit AddTodo ]
-- |   [ input [ value model.draft, onInput UpdateDraft ] []
-- |   , button [ type_ "submit" ] [ text "Add" ]
-- |   ]
-- | ```
-- |
-- | To let a form submit to the server the ordinary way, leave `onSubmit`
-- | off it entirely.
onSubmit :: ∀ msg.  msg -> Attribute msg
onSubmit msg = PreventingEventHandler "onsubmit" msg


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

