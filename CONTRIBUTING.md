Oak is an implementation of the Elm architecture in Purescript.

Currently the easiest way to start contributing is to create an example app inside the oak repository itself.

Warning: Purescript still uses bower (hopefully not for long). Also there is no dependency namespacing yet so modules are global and transitive dependencies must not conflict. Change versions at your own risk.

The first thing you'll want to do after cloning the oak repo is:
```
bower install
```
Then you'll want the purescript compiler, a build tool, and virtual-dom:
```
npm install -g purescript@0.11.7 pulp@12.0.1
npm install virtual-dom
```

Now how about a small oak app to see how this thing works? Put this in `src/Main.purs`: 
```
module Main (main) where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Exception

import Oak
import Oak.Html ( Html, div, text, button )
import Oak.Html.Events
import Oak.Document
import Oak.Cmd


type Model =
  { number :: Int
  }


data Msg
  = Inc
  | Dec


view :: Model -> Html Msg
view model =
  div []
    [ button [ onClick Inc ] [ text "+" ]
    , div [] [ text model.number ]
    , button [ onClick Dec ] [ text "-" ]
    ]


next :: Msg -> Model -> Cmd () Msg
next _ _ = none

update :: Msg -> Model -> Model
update Inc model =
  model { number = model.number + 1 }
update Dec model =
  model { number = model.number - 1 }


init :: Model
init =
  { number: 0
  }

app :: App () Model Msg
app = createApp
  { init: init
  , view: view
  , update: update
  , next: next
  }

main :: Eff (exception :: EXCEPTION, dom :: DOM) Unit
main = do
  rootNode <- runApp app
  container <- getElementById "app"
  appendChildNode container rootNode
```

Purescript is a civilized language so you need to compile your app with:
```
pulp build
```

Ok, you have some compiled code but it isn't ready to run in the browser. For that you need:
```
pulp browserify -O > app.js
```

Serve the js cold on an html platter. Put this in `index.html`:
```
<html>
<body>
  <div id="app">
  </div>

  <script src="app.js"/></script>
</body>
</html>
```

Now just `open index.html` and behold a magnificent counter.
