# spatial.mapping

## Example

```R
library(spatial.mapping)

#read files
postcode_dat <- readOGR(".../POA_2016_AUST")
sa2_dat <- readOGR(".../SA2_2016_AUST")

#run code
run_spatial_mapping(sp1=postcode_dat, sp2=sa2_dat, sp1_name=POA_CODE16, sp2_name=SA2_MAIN16)

```
