####################################################################
# PROGRAM: Raw Clinical Trial Data Creation
# PURPOSE: Raw Clinical Trial Data for portfolio demonstration
# AUTHOR:  Carolina Peçaibes
# DATE:    26/aug/2026
####################################################################

# Demographics - RAW
raw_dm =
  tribble( 
    # SUBJID = Subject identifier
    # SEX = Sex
    # AGE = Age (years)
    # AGE_UNIT = Unit of measure for age
    # TRTGRP = Group Treatment
    # RANDDT = Subject Randomization Date/Time
    # RFENDTC = Subject Reference End Date/Time
  ~SUBJID, ~SEX, ~AGE, ~AGE_UNIT, ~RANDDT,      ~RFENDTC,
  101,     "M",  55,   "Year",    "2022-01-10", "2022-06-30",
  102,     "F",  62,   "Year",    "2022-01-12", "2022-06-28",
  103,     "M",  48,   "Year",    "2022-01-15", "2022-06-29",
  104,     "F",  59,   "Year",    "2022-01-18", "2022-06-27"
  )

write_delim(raw_dm, file = paste0(dir_raw, "raw_dm.txt"), delim = ",")

# Exposure
raw_ex = 
  tribble(
    # SUBJID = Subject identifier
    # EXTRT_RAW = Group Treatment
    # EXSTDAT = Start Date of Treatment 
    # EXENDAT = End Date of Treatment 
    # DOSE = Treatment dose
  ~SUBJID, ~EXTRT_RAW, ~EXSTDAT,     ~EXENDAT,     ~DOSE,
  101,     "A",        "2022-01-11", "2022-06-30", 10,
  102,     "B",        "2022-01-13", "2022-06-28", 10,
  103,     "A",        "2022-01-16", "2022-06-29", 10,
  104,     "B",        "2022-01-19", "2022-06-27", 10
  )

write_delim(raw_ex, file = paste0(dir_raw, "raw_ex.txt"), delim = ",")

# Laboratory Test Results
raw_lb = 
  tribble(
    # SUBJID = Subject identifier
    # VISIT = 
    # LBDT = 
    # PARAM =
    # AVAL =
  ~SUBJID, ~VISIT,      ~LBDT,        ~PARAM,  ~AVAL,
  101,     "Screening", "2021-12-28", "HbA1c", 8.2,
  101,     "Baseline",  "2022-01-10", "HbA1c", 8.1,
  101,     "Week12",    "2022-04-04", "HbA1c", 7.4,
  101,     "Week24",    "2022-06-28", "HbA1c", 6.9,
  102,     "Screening", "2021-12-30", "HbA1c", 8.5,
  102,     "Baseline",  "2022-01-12", "HbA1c", 8.4,
  102,     "Week12",    "2022-04-06", "HbA1c", 8.1,
  102,     "Week24",    "2022-06-26", "HbA1c", 7.9,
  103,     "Screening", "2021-12-29", "HbA1c", 7.9,
  103,     "Baseline",  "2022-01-15", "HbA1c", 7.8,
  103,     "Week24",    "2022-06-27", "HbA1c", 7.0,
  104,     "Screening", "2021-12-31", "HbA1c", 8.3,
  104,     "Baseline",  "2022-01-18", "HbA1c", 8.2,
  104,     "Week24",    "2022-06-25", "HbA1c", 8.0
)

write_delim(raw_lb, file = paste0(dir_raw, "raw_lb.txt"), delim = ",")

# Adverse Events
raw_ae = 
  tribble(
    # SUBJID = Subject identifier
    # AETERM
    # AESER
    # AESEV
    # AESTDT
    # AEENDT
  ~SUBJID, ~AETERM,     ~AESER, ~AESEV,     ~AESTDT,      ~AEENDT,
  101,     "Headache",  "N",    "MILD",     "2022-02-01", "2022-02-03",
  101,     "Nausea",    "N",    "MODERATE", "2022-03-15", "2022-03-18",
  102,     "Dizziness", "Y",    "SEVERE",   "2022-04-10", "2022-04-15",
  103,     "Fatigue",   "N",    "MILD",     "2022-02-20", "2022-02-22"
)

write_delim(raw_ae, file = paste0(dir_raw, "raw_ae.txt"), delim = ",")


raw_vs = # Vital Signs
  tribble(
  ~SUBJID, ~VISIT,     ~VSDT,        ~PARAM,   ~AVAL,
  101,     "Baseline", "2022-01-10", "WEIGHT", 82,
  101,     "Week24",   "2022-06-28", "WEIGHT", 78,
  102,     "Baseline", "2022-01-12", "WEIGHT", 75,
  102,     "Week24",   "2022-06-26", "WEIGHT", 74
) 

write_delim(raw_vs, file = paste0(dir_raw, "raw_vs.txt"), delim = ",") 
