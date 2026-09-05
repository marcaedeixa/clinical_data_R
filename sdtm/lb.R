##############################################################
# PROGRAM: lb.R
# PURPOSE: Create SDTM dataset LB
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Read in data

raw_lb = read_delim(paste0(dir_raw, "raw_lb.txt"))

# Create oak_id_vars

raw_lb = raw_lb |>
  mutate(    
    LBDT = as.character(LBDT)) |>
  generate_oak_id_vars(
    pat_var = "SUBJID",
    raw_src = "raw_lb"
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
  ~raw_dataset_name, ~date_var, ~time_var,      ~dformat,     ~tformat,     ~sdtm_var_name,
  # Date/Time of Specimen Collection
  "raw_lb",          "LBDT",  NA_character_,  "yyyy-mm-dd", NA_character_, "LBDTC" 
)


# Map Topic Variable - specify the focus of the observation
# LBTESTCD is the topic variable in Findings Observation Class
# (https://www.cdisc.org/standards/foundational/sdtm/sdtm-v1-6)

lb = raw_lb |>
  select(
    oak_id,
    raw_source,
    patient_number,
    SUBJID
  ) |> assign_ct( 
    raw_dat = raw_lb, 
    raw_var = "PARAM", 
    tgt_var = "LBTESTCD", 
    ct_spec = sdtm_ct, 
    ct_clst = "C65047", 
    id_vars = oak_id_vars() )

# Map rest of the variables (except dates)

lb = lb |> 
  # Map LBTEST using assign_ct - variable has CT
  assign_ct( 
    raw_dat = raw_lb, 
    raw_var = "PARAM", 
    tgt_var = "LBTEST", 
    ct_spec = sdtm_ct,
    ct_clst = "C67154", 
    id_vars = oak_id_vars() ) |>
  # Map VISIT using assign_no_ct - CT doesn't apply
  assign_no_ct( 
    raw_dat = raw_lb, 
    raw_var = "VISIT", 
    tgt_var = "VISIT", 
    id_vars = oak_id_vars() ) |> 
  # Map related variables to test result as recommended to LB
  # Original result
  assign_no_ct( 
    raw_dat = raw_lb, 
    raw_var = "AVAL", 
    tgt_var = "LBORRES", 
    id_vars = oak_id_vars()) |>
  # Standard numeric result
  assign_no_ct( 
    raw_dat = raw_lb, 
    raw_var = "AVAL", 
    tgt_var = "LBSTRESN", 
    id_vars = oak_id_vars() ) |>
  # Standard character result
  assign_no_ct( 
    raw_dat = raw_lb, 
    raw_var = "AVAL", 
    tgt_var = "LBSTRESC", 
    id_vars = oak_id_vars() ) |>
  # Result original unit
  hardcode_ct( 
    raw_dat = raw_lb, 
    raw_var = "AVAL", 
    tgt_var = "LBORRESU", 
    tgt_val = "%", 
    ct_spec = sdtm_ct, 
    ct_clst = "C71620", 
    id_vars = oak_id_vars() ) |>
  # Result standard unit
  hardcode_ct( 
    raw_dat = raw_lb, 
    raw_var = "AVAL", 
    tgt_var = "LBSTRESU", 
    tgt_val = "%", 
    ct_spec = sdtm_ct, 
    ct_clst = "C71620", 
    id_vars = oak_id_vars() )

# Map Reference Date Variables
# (consider the possibility of multiple dates)

lb = lb |>
  # Map LBDTC according to ref_date_conf_df (ISO 8601 format)
  oak_cal_ref_dates(
    der_var = "LBDTC",
    min_max = "max",
    ref_date_config_df = ref_date_conf_df,
    raw_source = list(
      raw_lb = raw_lb
    )
  )

# Create SDTM derived variables

lb = lb |>
  mutate(
    STUDYID = "STUDY001", # informing study id
    DOMAIN = "LB",
    USUBJID = paste0(STUDYID, "-", SUBJID)
  )

write.csv(lb, file = paste0(dir_sdtm, "lb.csv"), row.names = FALSE)
  