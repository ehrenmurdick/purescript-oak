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
npm install -g purescript

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
spago bundle-app
```


Start writing your Oak application! Open index.html in a browser to see the app
running. Here's a bit of starter boilerplate or see the src/examples directory
to see some examples of how to do common tasks.
```purescript
module Main (main) where

import Oak

import Prelude hiding (div)
import Effect

type Model = { number :: Int }

data Msg
  = Inc
  | Dec

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

app :: App Msg Model
app = createApp { init, view, update, next }

main :: Effect Unit
main = do
  rootNode <- runApp app Nothing
  container <- getElementById "app"
  appendChildNode container rootNode
```

