// htmlwidgets serves this bundle from its *binding* dependency, which
// `getDependency()` builds with `all_files = FALSE` - so that directory holds
// the entry file and nothing else, while webpack's automatic publicPath
// resolves every async chunk against it. The chunks are copied, but into the
// sibling directory the yaml dependency declares (`all_files` defaults to
// TRUE there), so point publicPath at that instead.
//
// This must be imported before anything else: ES imports are evaluated in
// order, and a chunk requested during another module's evaluation would
// otherwise resolve against the wrong directory.
//
// `<name>-1.0.0` is the name and version in inst/htmlwidgets/<name>.yaml.
// Change one and you must change the other.
var src = typeof document !== "undefined" && document.currentScript?.src;
var parts = src && src.match(/^(.*\/)([^/]+)-binding-[^/]*\/[^/]*$/);

if (parts) {
  __webpack_public_path__ = parts[1] + parts[2] + "-1.0.0/";
}
