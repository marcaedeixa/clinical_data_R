##############################################################
# PROGRAM: dm.R
# PURPOSE: Create SDTM dataset DM
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Step-by-step from https://pharmaverse.github.io/examples/sdtm/dm.html

# Read in data

raw_dm = read_delim(paste0(dir_raw, "raw_dm.txt"))

# Create oak_id_vars

raw_dm = raw_dm |>
  mutate(    
    RANDDT = as.character(RANDDT),
    RFENDTC = as.character(RFENDTC)) |>
  generate_oak_id_vars(
    pat_var = "SUBJID",
    raw_src = "raw_dm"
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
  # Subject Reference Start Date/Time
  "raw_dm",          "RANDDT",  NA_character_,  "yyyy-mm-dd", NA_character_, "RFSTDTC", 
  # Subject Reference End Date/Time
  "raw_dm",          "RFENDTC", NA_character_,  "yyyy-mm-dd", NA_character_, "RFENDTC"
)

# Map Topic Variable - specify the focus of the observation
# SUBJID is the topic variable in Demographics 
# (https://www.cdisc.org/standards/foundational/sdtm/sdtm-v1-6)

dm = raw_dm |>
  mutate(
    SUBJID = as.character(SUBJID)
  ) |>
  select(
    oak_id,
    raw_source,
    patient_number,
    SUBJID
  )

# Map rest of the variables (except dates)

dm = dm |>
  # Map SEX using assign_ct - variable has CT
  assign_ct(
    raw_dat = raw_dm,
    raw_var = "SEX",
    tgt_var = "SEX",
    ct_spec = sdtm_ct,
    ct_clst = "C66731",
    id_vars = oak_id_vars()
  ) |>
  # Map AGE using assign_no_ct - CT doesn't apply
  assign_no_ct(
    raw_dat = raw_dm,
    raw_var = "AGE",
    tgt_var = "AGE",
    id_vars = oak_id_vars()
  ) |> # Map AGEU using assign_ct - variable has CT
  assign_ct(
    raw_dat = raw_dm,
    raw_var = "AGE_UNIT",
    tgt_var = "AGEU",
    ct_spec = sdtm_ct,
    ct_clst = "C66781",
    id_vars = oak_id_vars()
  )

# Map Reference Date Variables
# # (consider the possibility of multiple dates)

dm = dm |>
  # Map RFENDTC according to ref_date_conf_df (ISO 8601 format)
  oak_cal_ref_dates(
    der_var = "RFENDTC",
    min_max = "max",
    ref_date_config_df = ref_date_conf_df,
    raw_source = list(
      raw_dm = raw_dm
    )
  ) |>
  # Map RFSTDTC according to ref_date_conf_df (ISO 8601 format)
  oak_cal_ref_dates(
    der_var = "RFSTDTC",
    min_max = "min",
    ref_date_config_df = ref_date_conf_df,
    raw_source = list(
      raw_dm = raw_dm
    )
  )

# Create SDTM derived variables

dm = dm |>
  mutate(
    STUDYID = "STUDY001", # informing study id
    DOMAIN = "DM",
    USUBJID = paste0(STUDYID, "-", SUBJID)
  )


write.csv(dm, file = paste0(dir_sdtm, "dm.csv"), row.names = FALSE)
