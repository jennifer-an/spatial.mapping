# spatial.mapping

## how to use
Install R package:
```R
> devtools::install_github("jennifer-an/spatial.mapping")
> library(spatial.mapping)
```

Read shape files:
```R
> postcode_dat <- rgdal::readOGR(".../POA_2016_AUST")
> sa2_dat <- rgdal::readOGR(".../SA2_2016_AUST")
```

Run code:
```R
> res <- run_spatial_mapping(sp1 = postcode_dat
                          , sp2 = sa2_dat
                          , sp1_name = "POA_CODE16"
                          , sp2_name = "SA2_MAIN16")
```
