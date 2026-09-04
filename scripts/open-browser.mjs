import open from "open";

const target = process.argv[2];

if (!target) {
  console.error("Usage: node open-browser.mjs <path-or-url>");
  process.exit(1);
}

await open(target);
