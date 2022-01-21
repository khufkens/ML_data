# load libraries
library(tidyverse)
library(ingestr)
library(here)

# read in sites from Beni's paper
df <- read.table("data/flue_stocker18nphyt.csv", header = TRUE, sep = ",")
sites_beni <- unique(df$site)

# take a subset of the included ingestr fluxnet meta-data
sites <- ingestr::siteinfo_fluxnet2015 %>%
  filter(sitename %in% sites_beni)

# create a site list
bundles <- c(
  "modis_lst_terra",
  "modis_lst_aqua",
  "modis_refl_1",
  "modis_refl_2",
  "modis_refl_3",
  "modis_refl_4",
  "modis_refl_5",
  "modis_refl_6",
  "modis_refl_7",
  "modis_refl_8",
  "modis_refl_9",
  "modis_refl_10",
  "modis_refl_11",
  "modis_refl_12",
  "modis_refl_13",
  "modis_refl_14",
  "modis_refl_15"
)

# loop over all bundles
# loop over all sites is internal to ingest()
all_data <- lapply(bundles, function(bundle){

  # use GEE to download raw GEE data
  settings_gee <- get_settings_gee(
    bundle            = bundle,
    python_path       = "/usr/bin/python3",
    gee_path          = "~/gee_subset/src/gee_subset/",
    data_path         = here::here("data-raw"),
    method_interpol   = "none",
    keep              = FALSE,
    overwrite_raw     = FALSE,
    overwrite_interpol= FALSE
  )

  df <- ingest(
    siteinfo = sites,
    source  = "gee",
    settings = settings_gee,
    verbose = FALSE
  )

  return(df)
})

# name list items
names(all_data) <- bundles

# save as a serialized object
saveRDS(all_data, "data/remote_sensing_data.rda", compress = "xz")


