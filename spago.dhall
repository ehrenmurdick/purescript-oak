{ name = "oak"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "control"
  , "effect"
  , "either"
  , "fetch"
  , "foldable-traversable"
  , "functions"
  , "integers"
  , "maybe"
  , "partial"
  , "prelude"
  , "refs"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ehrenmurdick/purescript-oak"
}
