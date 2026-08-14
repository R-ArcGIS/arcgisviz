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
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, outputPath),
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
