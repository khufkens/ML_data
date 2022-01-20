# load libraries
library(tidyverse)
library(ingestr)
library(here)

site <- ingestr::siteinfo_fluxnet2015

# create a site list
bundles <- c(
  #"modis_lst_terra",
  "modis_lst_aqua",
  "modis_refl_1",
  "modis_refl_2",
  "modis_refl_3",
  "modis_refl_4",
  "modis_refl_5",
  "modis_refl_6",
  "modis_refl_7"
)

all_data <- lapply(bundles, function(bundle){

  # use GEE to download raw GEE data
  settings_gee <- get_settings_gee(
    bundle            = bundle,
    python_path       = "/usr/bin/python3",
    gee_path          = "~/gee_subset/src/gee_subset/",
    data_path         = here::here("data-raw"),
    method_interpol   = "none",
    keep              = FALSE,
    overwrite_raw     = TRUE,
    overwrite_interpol= FALSE
  )

  df <- ingest(
    siteinfo = site,
    source  = "gee",
    settings = settings_gee,
    verbose = FALSE
  )

  return(df)
})
