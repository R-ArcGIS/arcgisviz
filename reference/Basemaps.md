# Basemaps

The basemap ids `<arcgis-map>` accepts, from `@arcgis/core`'s own
`basemapDefinitions.js`. The `-3d` variants are built for scenes.

## Usage

``` r
Basemaps(value = NA_character_)
```

## Arguments

- value:

  String. One of `"topo-vector"`, `"streets-vector"`,
  `"streets-night-vector"`, `"streets-relief-vector"`,
  `"streets-navigation-vector"`, `"gray-vector"`, `"dark-gray-vector"`,
  `"hybrid"`, `"satellite"`, `"oceans"`, `"osm"`, `"terrain"`,
  `"topo-3d"`, `"streets-3d"`, `"streets-dark-3d"`, `"navigation-3d"`,
  `"navigation-dark-3d"`, `"gray-3d"`, `"dark-gray-3d"`, `"osm-3d"`,
  `NA`.

## Value

An object of class `Basemaps`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.
