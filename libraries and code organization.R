
# libraries (install packages if needed)
library(sdtm.oak)
library(tidyverse)
library(metacore)
library(metatools)
library(writexl)
library(xportr)
library(admiral)
# codes to run, in order

## Specify directories as needed
dir_raw = "rawdata/"
dir_sdtm = "sdtm/"
dir_adam = "adam/"

source(paste0(dir_raw, "Raw data.R"))
source(paste0(dir_sdtm, "Controlled terminology.R"))
source(paste0(dir_sdtm, "dm.R"))
source(paste0(dir_sdtm, "ex.R"))
source(paste0(dir_sdtm, "lb.R"))
source(paste0(dir_sdtm, "ae.R"))
source(paste0(dir_sdtm, "vs.R"))
source(paste0(dir_adam, "metacore.R"))
