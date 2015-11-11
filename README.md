# Halcyon

Compare blast results between high-accuracy-low-coverage and low-accuracy-high-coverage databases

# Installation

```r
# If you don't have devtools installed run:
# install.packages("devtools")
library(devtools)
install_github("seankross/halcyon")
```

# Demo

```r
library(halcyon)
read_outfmt10(system.file("data-raw", "silva_blast_result.csv",  package="halcyon")) %>%
	calc_m_scores() %>%
	halcyon_app()
```
