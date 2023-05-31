{ name = "purescript-oak"
, dependencies =
  [ "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "functions"
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
