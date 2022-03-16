{ name = "purescript-oak"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "functions"
  , "maybe"
  , "prelude"
  , "refs"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
