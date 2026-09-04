// spago's `bundle` command only considers modules reachable from src/**,
// so it can't see this app under test/. `spago build` (run first) compiles
// test/**/*.purs into output/ same as src/, so we bundle straight from
// there with esbuild instead.
import { main } from "../output/Test.TodoApp/index.js";

main();
