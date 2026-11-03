# a parquet layer needs exactly one geometry column

    Code
      add_layer(arc_map(), data.frame(a = 1), format = "parquet")
    Condition
      Error in `add_layer()`:
      ! `.data` must have exactly one geometry column.
      x Found none.
      i A geometry column is anything wk can read, such as <sfc> or <geoarrow_vctr>.

---

    Code
      add_layer(arc_map(), two, format = "parquet")
    Condition
      Error in `add_layer()`:
      ! `.data` must have exactly one geometry column.
      x Found here and there.
      i A geometry column is anything wk can read, such as <sfc> or <geoarrow_vctr>.

# a parquet layer refuses mixed geometry types

    Code
      add_layer(arc_map(), mixed, format = "parquet")
    Condition
      Error in `add_layer()`:
      ! `.data` must hold one supported geometry type.
      i Points, lines, and polygons can each be multi-part, but not mixed with one another.

# a parquet layer is not yet available on a proxy

    Code
      add_layer(proxy, parquet_points(), name = "pts", format = "parquet")
    Condition
      Error in `add_layer()`:
      ! `format = "parquet"` is not yet supported on an <ArcMapProxy>.

