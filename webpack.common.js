// Structure adapted from packer's (github.com/JohnCoene/packer) webpack
// scaffold conventions, since this project uses bun (not npm/yarn, which
// is all packer's own R-side install/bundle helpers support) to drive
// install/bundle. See srcjs/config/*.json for the declarative bits
// (entry points, output path, externals, loaders) this file reads.
const path = require("path");
const fs = require("fs");

const outputPathFile = "./srcjs/config/output_path.json";
const entryPointsFile = "./srcjs/config/entry_points.json";
const externalsFile = "./srcjs/config/externals.json";
const miscFile = "./srcjs/config/misc.json";
const loadersFile = "./srcjs/config/loaders.json";

const outputPath = JSON.parse(fs.readFileSync(outputPathFile, "utf8"));
const entryPoints = JSON.parse(fs.readFileSync(entryPointsFile, "utf8"));
const externals = JSON.parse(fs.readFileSync(externalsFile, "utf8"));
const misc = JSON.parse(fs.readFileSync(miscFile, "utf8"));
const loaders = JSON.parse(fs.readFileSync(loadersFile, "utf8")).map(
  (loader) => ({ ...loader, test: RegExp(loader.test) })
);

const options = {
  entry: entryPoints,
  // The SDK is loaded from js.arcgis.com, not bundled (srcjs/config/
  // externals.json), so the entries carry real `import` statements and have
  // to be ES modules. htmlwidgets emits them with type="module" - see
  // R/arcgis-chart-widget.R.
  experiments: { outputModule: true },
  output: {
    // NOT <name>.js: htmlwidgets::getDependency() turns that filename into a
    // "binding" dependency whose script tag it hardcodes with no attributes,
    // and an ES module loaded as a classic script throws. Under any other
    // name it builds no binding dependency and the .yaml below declares the
    // script itself, with type="module".
    filename: "[name].module.js",
    path: path.resolve(__dirname, outputPath),
    module: true,
    chunkFormat: "module",
    library: { type: "module" },
    // Without this webpack leaves every chunk a previous build wrote. Dev and
    // prod name chunks differently, so one `bundle-dev` orphaned 466 files.
    // The .yaml dependency declarations live here and are source, not output.
    clean: { keep: /\.yaml$/ },
  },
  externals: externals,
  module: {
    rules: loaders,
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  plugins: [],
};

if (misc.resolve) {
  options.resolve = misc.resolve;
}

module.exports = options;
