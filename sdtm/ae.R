##############################################################
# PROGRAM: ae.R
# PURPOSE: Create SDTM dataset AE
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Read in data

raw_ae = read_delim(paste0(dir_raw, "raw_ae.txt"))

# Create oak_id_vars

raw_ae = raw_ae |>
  mutate(    
    AESTDT = as.character(AESTDT),
    AEENDT = as.character(AEENDT)) |>
  generate_oak_id_vars(
    pat_var = "SUBJID",
    raw_src = "raw_ae"
  )

# Read CT

sdtm_ct = read.csv(paste0(dir_sdtm, "sdtm_ct.csv"))

# Map Topic Variable - specify the focus of the observation
# AETERM is the topic variable in Events Observation Class
# (https://www.cdisc.org/standards/foundational/sdtm/sdtm-v1-6)

ae = raw_ae |>
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
ae = ae |>
  # Map AETERM using assign_no_ct - CT doesn't apply
assign_no_ct(
  raw_dat = raw_ae,
  raw_var = "AETERM",
  tgt_var = "AETERM",
  id_vars = oak_id_vars() 
  ) |>
  # Map AESEV using assign_ct - variable has CT
  assign_ct( 
    raw_dat = raw_ae, 
    raw_var = "AESEV", 
    tgt_var = "AESEV", 
    ct_spec = sdtm_ct, 
    ct_clst = "C66769", 
    id_vars = oak_id_vars() ) |>
  # Map AESER using assign_ct - variable has CT
  assign_ct( 
    raw_dat = raw_ae, 
    raw_var = "AESER", 
    tgt_var = "AESER", 
    ct_spec = sdtm_ct, 
    ct_clst = "C66742", 
    id_vars = oak_id_vars() )

# Map Reference Date Variables
# (don't consider the possibility of multiple dates)

ae = ae |>
  assign_datetime( 
    raw_dat = raw_ae, 
    raw_var = "AESTDT", 
    tgt_var = "AESTDTC", 
    raw_fmt = c("yyyy-mm-dd"), 
    id_vars = oak_id_vars() ) |> 
  assign_datetime( 
    raw_dat = raw_ae, 
    raw_var = "AEENDT", 
    tgt_var = "AEENDTC", 
    raw_fmt = c("yyyy-mm-dd"), 
    id_vars = oak_id_vars() )

# Create SDTM derived variables

ae = ae |>
  mutate(
    STUDYID = "STUDY001", # informing study id
    DOMAIN = "AE",
    USUBJID = paste0(STUDYID, "-", SUBJID)
  )

write.csv(ae, file = paste0(dir_sdtm, "ae.csv"), row.names = FALSE)

