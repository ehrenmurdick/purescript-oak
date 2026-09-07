// Same arrangement as entry.js: spago's bundler only sees modules reachable
// from src/**, so `spago build` compiles this app into output/ and esbuild
// bundles it from there.
import { main } from "../output/Test.RouterApp/index.js";

main();
