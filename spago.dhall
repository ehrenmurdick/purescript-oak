{ name = "purescript-oak"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "functions"
  , "maybe"
  , "partial"
  , "prelude"
  , "refs"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ehrenmurdick/purescript-oak"
}
