##############################################################
# PROGRAM: vs.R
# PURPOSE: Create SDTM dataset VS
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# example from https://pharmaverse.github.io/examples/sdtm/vs.html

# Read in data

raw_vs = read_delim(paste0(dir_raw, "raw_vs.txt"))

# Create oak_id_vars

raw_vs = raw_vs |>
  mutate(    
    VSDT = as.character(VSDT)) |>
  generate_oak_id_vars(
    pat_var = "SUBJID",
    raw_src = "raw_vs"
  )

# Read CT

sdtm_ct = read.csv(paste0(dir_sdtm, "sdtm_ct.csv"))

# Map Topic Variable - specify the focus of the observation
# VSTESTCD is the topic variable in Finding Observations Classes
# (https://www.cdisc.org/standards/foundational/sdtm/sdtm-v1-6)

vs = raw_vs |>
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
    raw_dat = raw_vs,
    raw_var = "PARAM",
    tgt_var = "VSTESTCD",
    ct_spec = sdtm_ct,
    ct_clst = "C66741",
    id_vars = oak_id_vars()
  ) 

# Map rest of the variables (except dates)

vs = vs |>
  # Map VISIT using assign_no_ct - CT doesn't apply
  assign_no_ct( 
    raw_dat = raw_vs, 
    raw_var = "VISIT", 
    tgt_var = "VISIT", 
    id_vars = oak_id_vars() ) |> 
  # Map VSTEST using assign_ct - variable has CT
  assign_ct(
    raw_dat = raw_vs,
    raw_var = "PARAM",
    tgt_var = "VSTEST",
    ct_spec = sdtm_ct,
    ct_clst = "C67153",
    id_vars = oak_id_vars()) |>
  # Map related variables to test result as recommended to VS
  # Original result
  assign_no_ct( 
    raw_dat = raw_vs, 
    raw_var = "AVAL", 
    tgt_var = "VSORRES", 
    id_vars = oak_id_vars() ) |>
  # Result original unit
  hardcode_ct( 
    raw_dat = raw_vs, 
    raw_var = "PARAM", 
    tgt_var = "VSORRESU", 
    tgt_val = "kg", 
    ct_spec = sdtm_ct, 
    ct_clst = "C66770", 
    id_vars = oak_id_vars() ) |>
  # Standard character result
  # Standard numeric result
  # Result standard unit
  mutate(
    VSSTRESC = as.character(VSORRES),
    VSSTRESN = as.numeric(VSORRES),
    VSSTRESU = VSORRESU
  )

# Map Reference Date Variables
# (don't consider the possibility of multiple dates)

vs = vs |>
  assign_datetime( 
    raw_dat = raw_vs, 
    raw_var = "VSDT", 
    tgt_var = "VSDTC", 
    raw_fmt = c("yyyy-mm-dd"), 
    id_vars = oak_id_vars() )

# Create SDTM derived variables

vs = vs |>
  mutate(
    STUDYID = "STUDY001", # informing study id
    DOMAIN = "VS",
    USUBJID = paste0(STUDYID, "-", SUBJID)
  )


write.csv(vs, file = paste0(dir_sdtm, "vs.csv"), row.names = FALSE)
