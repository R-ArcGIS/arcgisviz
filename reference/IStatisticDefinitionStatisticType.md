# IStatisticDefinitionStatisticType

One of `"avg"`, `"centroid-aggregate"`, `"convex-hull-aggregate"`,
`"count"`, `"envelope-aggregate"`, `"max"`, `"min"`,
`"percentile-continuous"`, `"percentile-discrete"`, `"stddev"`, `"sum"`,
`"var"`, `NA`.

## Usage

``` r
IStatisticDefinitionStatisticType(value = NA_character_)
```

## Arguments

- value:

  String. One of `"avg"`, `"centroid-aggregate"`,
  `"convex-hull-aggregate"`, `"count"`, `"envelope-aggregate"`, `"max"`,
  `"min"`, `"percentile-continuous"`, `"percentile-discrete"`,
  `"stddev"`, `"sum"`, `"var"`, `NA`.

## Value

An object of class `IStatisticDefinitionStatisticType`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.
