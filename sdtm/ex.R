##############################################################
# PROGRAM: ex.R
# PURPOSE: Create SDTM dataset EX
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# example from https://pharmaverse.github.io/examples/sdtm/ae.html

# Read in data

raw_ex = read_delim(paste0(dir_raw, "raw_ex.txt"))

# Create oak_id_vars

raw_ex = raw_ex |>
  mutate(    
    EXSTDAT = as.character(EXSTDAT),
    EXENDAT = as.character(EXENDAT)) |>
  generate_oak_id_vars(
    pat_var = "SUBJID",
    raw_src = "raw_ex"
  )

# Read CT

sdtm_ct = read.csv(paste0(dir_sdtm, "sdtm_ct.csv"))

# Create reference dates configuration file
# raw_dataset_name: Name of the raw dataset.
# date_var: Date variable name from the raw dataset.
# time_var: Time variable name from the raw dataset.
# dformat: Format of the date collected in raw data.
# tformat: Format of the time collected in raw data.
# sdtm_var_name: Reference date variable name in DM domain where the raw variable is used.

ref_date_conf_df = tibble::tribble(
  ~raw_dataset_name, ~date_var, ~time_var,      ~dformat,     ~tformat,      ~sdtm_var_name,
  # Start Date/Time of Treatment
  "raw_ex",          "EXSTDAT",  NA_character_,  "yyyy-mm-dd", NA_character_, "EXSTDTC", 
  # End Date/Time of Treatment
  "raw_ex",          "EXENDAT",  NA_character_,  "yyyy-mm-dd", NA_character_, "EXENDTC" 
)

# Map Topic Variable - specify the focus of the observation
# EXTRT is the topic variable in Interventions Observations Classes
# (https://www.cdisc.org/standards/foundational/sdtm/sdtm-v1-6)

ex = raw_ex |>
  select(
    oak_id,
    raw_source,
    patient_number,
    SUBJID
  ) |>
  mutate(
    SUBJID = as.character(SUBJID)
  ) |>
  assign_ct(
    raw_dat = raw_ex,
    raw_var = "EXTRT_RAW",
    tgt_var = "EXTRT",
    ct_spec = sdtm_ct,
    ct_clst = "ARM",
    id_vars = oak_id_vars()
  ) 

# Map rest of the variables (except dates)

ex = ex |>
  # Map EXDOSE using assign_no_ct - CT doesn't apply
  assign_no_ct(
    raw_dat = raw_ex,
    raw_var = "DOSE",
    tgt_var = "EXDOSE",
    id_vars = oak_id_vars()
    ) |>
  # Map EXDOSU using hardcode_ct - specify CT now
  hardcode_ct(
    raw_dat = raw_ex,
    raw_var = "DOSE",
    tgt_var = "EXDOSU",
    tgt_val = "mL",
    ct_spec = sdtm_ct,
    ct_clst = "C71620",
    id_vars = oak_id_vars() 
    )

# Map Reference Date Variables
# (consider the possibility of multiple dates)

ex = ex |>
  # Map EXSTDTC according to ref_date_conf_df (ISO 8601 format)
  oak_cal_ref_dates(
    der_var = "EXSTDTC",
    min_max = "min",
    ref_date_config_df = ref_date_conf_df,
    raw_source = list(
      raw_ex = raw_ex
    )
  ) |>
  # Map EXENDTC according to ref_date_conf_df (ISO 8601 format)
  oak_cal_ref_dates( 
    der_var = "EXENDTC", 
    min_max = "max", 
    ref_date_config_df = ref_date_conf_df, 
    raw_source = list( 
      raw_ex = raw_ex 
      ))


# Create SDTM derived variables

ex = ex |>
  mutate(
    STUDYID = "STUDY001", # informing study id
    DOMAIN = "EX",
    USUBJID = paste0(STUDYID, "-", SUBJID)
  )


write.csv(ex, file = paste0(dir_sdtm, "ex.csv"), row.names = FALSE)
