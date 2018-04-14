const path = require("path");

module.exports = {
  entry: "./entry",

  mode: "production",

  output: {
    path: path.join(__dirname, "dist"),
    filename: "bundle.js",
  },

  resolve: { extensions: [".js", ".purs"] },

  module: {
    rules: [{
      test: /\.purs$/,
      loader: 'purs-loader',
      exclude: /node_modules/,
      query: {
        psc: 'node_modules/.bin/psa',
        src: ['bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs']
      }
    }]
  }
}

