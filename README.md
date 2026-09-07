### Introduction

Welcome to Oak - The Functional Frontend Framework that makes building elegant
and robust applications a breeze!

Oak is a functional programming framework designed with one primary goal in
mind: to provide developers with an unparalleled level of ease of use without
sacrificing the power and flexibility of functional programming paradigms. Gone
are the days of complex and convoluted syntax - Oak streamlines the development
process, empowering you to create sophisticated applications with clarity and
simplicity.

Whether you're a seasoned functional programming enthusiast or just dipping your
toes into the world of functional programming, Oak is your ideal companion. It
abstracts away the complexities of traditional functional languages, making it
accessible to developers of all skill levels. With Oak, you can leverage the
full potential of functional programming without facing the steep learning curve
associated with other frameworks.

Our vision for Oak is to foster a community of developers who embrace the
elegance and expressiveness of functional programming. We believe that
programming should be intuitive, fun, and allow you to focus on bringing your
ideas to life, rather than getting bogged down in intricate syntax and
boilerplate code.

Join us on this journey as we explore the power and joy of functional
programming with Oak. This README will guide you through the framework's
installation, core concepts, and a plethora of examples that showcase the
fluidity and beauty of Oak's design. If you're building web applications, Oak
will be your steadfast companion, providing an enjoyable and productive
development experience. 

If you have used Elm before, much of Oak will look familiar to you and that is
no accident! We first created Oak because we love Elm, but as functional
programmers we really felt the restrictions from not having higher level
functional concepts available. Oak is designed to be as close as easy to use as
Elm, but without sacrificing the more powerful features of modern functional
languages!

Let's embark on this adventure together and unlock the true potential of functional programming with Oak! Happy coding!

Documentation is published on [pursuit](https://pursuit.purescript.org/packages/purescript-oak/).

### Getting started

First, create a purescript project. You'll need npm (or yarn).
```sh
# Maybe take a coffee break while this installs, it can take a few minutes.
npm install -g purescript spago

# Create your project's directory
mkdir my-oak-app
cd my-oak-app

# Bootstrap purescript
spago init

# Install Oak
spago install oak

# We will also have a plain js dependency, so initialize npm as well
npm init

# Create an index.html to be the entry point
cat > index.html << EOF
<html>
<body><div id="app"></div></body>
<script src="index.js"></script>
</html>
EOF

# Build your app
spago bundle
```


Start writing your Oak application! Open index.html in a browser to see the app
running. Here's a bit of starter boilerplate or see the src/examples directory
to see some examples of how to do common tasks.
```purescript
module Main (main) where

import Oak
import Oak.Subscription (Subscription)

import Prelude hiding (div)
import Effect

type Model = { number :: Int }

data Msg
  = Inc
  | Dec

-- `runApp` reconciles subscriptions by comparing messages, so every message
-- type needs an Eq instance, even in an app that subscribes to nothing.
derive instance eqMsg :: Eq Msg

view :: Model -> Html Msg
view model = div []
  [ div []
      [ button [ onClick Inc ] [ text "+" ]
      , text $ show model.number
      ]
  , div []
      [ button [ onClick Dec ] [ text "-" ]
      , text $ show model.number
      ]
  ]

next :: Msg -> Model -> (Msg -> Effect Unit) -> Effect Unit
next msg mod h = mempty

update :: Msg -> Model -> Model
update msg model = case msg of
  Inc -> model { number = model.number + 1 }
  Dec -> model { number = model.number - 1 }

init :: Model
init = { number: 0 }

-- this app doesn't listen to anything outside its own view
subscriptions :: Model -> Array (Subscription Msg)
subscriptions _ = []

app :: App Msg Model
app = createApp { init, view, update, next, subscriptions }

main :: Effect Unit
main = do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
```

### Routing

Oak can put your app's screens on real URLs, so they can be bookmarked,
deep-linked and moved between with the browser's own back button. Build the
app with `createRoutedApp` instead of `createApp` and give it two extra
fields:

```purescript
import Oak
import Oak.Navigation as Nav
import Data.Int as Int

data Route = Home | Notes | Note Int | NotFound

-- Oak ships no route matcher of its own: `segments` is the URL split up and
-- percent-decoded, and you match on it however you like.
parse :: Url -> Route
parse url = case url.segments of
  []            -> Home
  [ "notes" ]   -> Notes
  [ "notes", n ] -> maybe NotFound Note (Int.fromString n)
  _             -> NotFound

-- The single place that decides what lands in someone's URL bar.
print :: Route -> String
print = case _ of
  Home     -> "/"
  Notes    -> "/notes"
  Note n   -> "/notes/" <> show n
  NotFound -> "/404"

app :: App Msg Model
app = createRoutedApp
  { init, view, update, next, subscriptions
  , mode: Hash
  , onNavigate: \url -> RouteChanged (parse url)
  }
```

Keep the route in your model, and switch on it in `view`. `onNavigate` is
called for the initial URL *before the first render*, so the first paint is
already the right screen, and again for every navigation afterwards. To the
rest of your app a navigation is just another message, which means `update`
stays pure and `next` gets to run a screen's entry effects.

#### Links

Ordinary anchors work. The runtime intercepts same-origin clicks, so

```purescript
a [ href "/notes" ] [ text "Notes" ]
```

navigates without a page load, while middle-click, cmd-click and "copy link
address" still do what anyone would expect. Give an anchor `target`,
`download` or `rel="external"` to opt out and get plain browser behaviour
back.

To navigate from code, call `Oak.Navigation` from `next`:

```purescript
next msg _ _ = case msg of
  Save         -> Nav.push (print Notes)      -- adds a history entry
  Redirect     -> Nav.replace (print Home)    -- rewrites the current one
  Cancel       -> Nav.back
  LogOut       -> Nav.load "/goodbye"         -- leaves the app entirely
  _            -> mempty
```

Paths are always written the way your app thinks of them -- `"/notes/42"`,
never `"#/notes/42"`. In `Hash` mode Oak adds the `#` for you, so changing
the mode never means rewriting navigation code or anchors.

#### Hash or Path

| | `Hash` | `Path` |
| --- | --- | --- |
| URL | `/index.html#/notes/42` | `/notes/42` |
| Server setup | none | must serve the app for every path |
| Works from `file://` | yes | no -- `pushState` throws there |

`Path` is nicer to look at and `Hash` works everywhere. If you pick `Path`,
your server needs a catch-all that returns `index.html` for any route, or a
deep link 404s. Oak warns in the console if you ask for `Path` from a
`file://` URL rather than failing at your first navigation.

#### Query strings

`Url` carries the query already parsed:

```purescript
[ "notes" ] -> NoteList (queryParam "tag" url)   -- Just "ideas", for /notes?tag=ideas
```

#### Bigger route tables

`parse` and `print` are written independently, so they can drift. A
round-trip test over your routes catches that:

```purescript
parse (parseUrl Hash ("/index.html#" <> print route)) == route
```

Past a handful of routes it's worth reaching for
[`routing-duplex`](https://github.com/natefaubion/purescript-routing-duplex),
which derives both directions from one description and turns drift into a
compile error. It needs nothing from Oak -- `onNavigate` closes over
whatever parser you hand it, and `url.raw` is exactly what it wants:

```purescript
onNavigate: \url -> RouteChanged (hush (parse route url.raw))
```

Note that `purescript-routing`'s `Routing.Match` is *not* a substitute: it
parses but does not print, so you would still be hand-writing `print` and
still be exposed to drift.

#### A worked example

`test/RouterApp.purs` is a small multi-screen app using all of the above.
Run it with:

```sh
npm run router-app
```
