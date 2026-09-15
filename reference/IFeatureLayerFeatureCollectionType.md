# IFeatureLayerFeatureCollectionType

One of `"markup"`, `"notes"`, `"route"`, `NA`.

## Usage

``` r
IFeatureLayerFeatureCollectionType(value = NA_character_)
```

## Arguments

- value:

  String. One of `"markup"`, `"notes"`, `"route"`, `NA`.

## Value

An object of class `IFeatureLayerFeatureCollectionType`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IFeatureLayerFeatureCollectionType("markup")
#> <arcgisviz::IFeatureLayerFeatureCollectionType>
#>  @ value   : chr "markup"
#>  @ variants: chr [1:3] "markup" "notes" "route"
#>  @ allow_na: logi TRUE
```
