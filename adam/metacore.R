##############################################################
# PROGRAM: metacore.R
# PURPOSE: Create metacore object
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Model from https://atorus-research.github.io/metacore/
# Example from https://atorus-research.github.io/metacore/articles/Example.html
# Tutorial from https://posit.co/blog/creating-adsl-with-the-pharmaverse-part-1

# ds_spec: Contains dataset level information
## dataset: The abbreviated name of the dataset (e.g. AE)
## structure: Value structure of the dataset as a string
## label: Dataset label

ds_spec =
  tribble( 
    ~dataset, ~structure, ~label,
    "ADSL", "one record per subject", 
      "Subject-Level Analysis Dataset",
    
    "ADAE", "one record per subject per adverse event", 
      "Adverse Events Analysis Dataset",
    
    "ADLB", "one record per subject per parameter per timepoint", 
      "Laboratory Test Result Analysis Dataset",
    
    "ADVS", "one record per subject per parameter per timepoint", 
      "Vital Signs Analysis Dataset",
    
    "ADEX", "one record per subject per exposure", 
      "Exposure Analysis Dataset"
  )

# ds_vars: Bridges the dataset and variable level information
## dataset: The abbreviated name of the dataset. This will match to the name in ds_spec
## variable: Variable name
## key_seq: Sequence key, which are the variables used to order a dataset. This is a column of integers, where 1 is the first sorting variable and 2 is the second etc. If the variable is not used in sorting it will be left NA
## order: Order sets the order of the columns to appear in the dataset. This is also a numeric value
## mandatory (previously keep): Boolean specifying whether a variable can have blank values. From the CDISC Define-XML v2.1 documentation: Required items that have Mandatory set to “Yes” cannot have blank values. Variables in SDTM domains that have core = "Required" should have mandatory = TRUE. Note that keep was deprecated in v0.3.0 in favour of mandatory to better align the package and CDISC terminology.
## core: ADaM core, which should be one of the following values: “Expected”, “Required”, “Permissible”, “Conditionally Required”, “Conditionally Expected”, or NA. For more information about core see CDISC
## supp_flag: Logical to determine if the variable is in the supplemental datasets

# reference for 'core' definitions: https://usermanual.wiki/Document/adamimplementationguidev10.485401059/html?utm
# https://www.cdisc.org/system/files/members/standard/foundational/ADaM_Data_Structure_for_Adverse_Event_Analysis_v1.0.pdf

ds_vars =
  tribble( 
    ~dataset, ~variable, ~key_seq, ~order, ~mandatory, ~core, ~supp_flag,
    
    # Study identifier
    "ADSL", "STUDYID",   NA,       1,      TRUE,  "Required",  NA,
    # Unique subject identifier
    "ADSL", "USUBJID",   1,        2,      TRUE,  "Required",  NA,
    # Start Date/Time (randomization date)
    "ADSL", "RFSTDTC",   NA,       3,      TRUE,  "Permissible", NA,
    # Reference End Date/Time
    "ADSL", "RFENDTC",   NA,       4,      TRUE,  "Permissible", NA,
    # Subject identifier
    "ADSL", "SUBJID",    NA,       5,      TRUE,  "Required",  NA,
    # Sex
    "ADSL", "SEX",       NA,       6,      TRUE,  "Required",  NA,
    # Age
    "ADSL", "AGE",       NA,       7,      TRUE,  "Required",  NA,
    
    # Subject identifier
    "ADAE", "SUBJID",    NA,       1,      TRUE, "Permissible",  NA,
    # Reported term for the adverse event
    "ADAE", "AETERM",    NA,       2,      TRUE, "Required",   NA,
    # Seriousness of the adverse event
    "ADAE", "AESER",     NA,       3,      TRUE, "Required",   NA,
    # Severity of the adverse event
    "ADAE", "AESEV",     NA,       4,      TRUE, "Permissible",  NA,
    # Study identifier
    "ADAE", "STUDYID",   NA,       5,      TRUE, "Required",   NA,
    # Unique subject identifier
    "ADAE", "USUBJID",   1,        6,      TRUE, "Required",   NA,
    # Start date/time of the adverse event
    "ADAE", "AESTDTC",   NA,       7,      TRUE, "Permissible",  NA,
    # End date/time of the adverse event
    "ADAE", "AEENDTC",   NA,       8,      TRUE, "Permissible",  NA,
    # Adverse event sequence number
    "ADAE", "AESEQ",     2,        9,      TRUE, "Required",   NA,
    
    # Subject identifier
    "ADLB", "SUBJID",    NA,       1,      TRUE, "Required",   NA, 
    # Visit as collected in the source data
    "ADLB", "VISIT",     NA,       2,      TRUE, "Conditionally Required",  NA,
    # Analysis visit
    "ADLB", "AVISIT",    NA,       3,      TRUE, "Conditionally Required",  NA,
    # Numeric analysis visit
    "ADLB", "AVISITN",   3,        4,      TRUE, "Conditionally Required",  NA,
    # Analysis parameter
    "ADLB", "PARAM",     NA,       5,      TRUE, "Required",   NA,
    # Analysis parameter code
    "ADLB", "PARAMCD",   2,        6,      TRUE, "Required",   NA,   
    # Analysis value
    "ADLB", "AVAL",      NA,       7,      TRUE, "Required",   NA,
    # Unit of the analysis value
    "ADLB", "AVALU",     NA,       8,      TRUE, "Required",   NA, 
    # Study identifier
    "ADLB", "STUDYID",   NA,       9,      TRUE, "Required",   NA,
    # Unique subject identifier
    "ADLB", "USUBJID",   1,        10,     TRUE, "Required",   NA,
    # Baseline analysis value
    "ADLB", "BASE",      NA,       12,     TRUE, "Conditionally Required",  NA,
    # Baseline record flag
    "ADLB", "ABLFL",     NA,       13,     FALSE,"Conditionally Required",  NA,
    # Change from baseline
    "ADLB", "CHG",       NA,       14,     TRUE, "Permissible",  NA,
    # Analysis Date - in this case, Lab test date
    "ADLB", "ADT",       NA,        15,     TRUE,  "Required",  NA,
    
    
    # Study identifier
    "ADVS", "STUDYID",   NA,       1,      TRUE, "Required",   NA,
    # Unique subject identifier
    "ADVS", "USUBJID",   1,        2,      TRUE, "Required",   NA,
    # Subject identifier
    "ADVS", "SUBJID",    NA,       3,      TRUE, "Required",   NA, 
    # Analysis parameter code
    "ADVS", "PARAMCD",   2,       4,      TRUE, "Required",   NA, 
    # Analysis parameter
    "ADVS", "PARAM",     NA,       5,      TRUE, "Required",   NA,
    # Analysis value
    "ADVS", "AVAL",      NA,       6,      TRUE, "Required",   NA,
    # Unit of the analysis value
    "ADVS", "AVALU",     NA,       7,      TRUE, "Required",   NA,
    # Analysis visit
    "ADVS", "AVISIT",    NA,       8,      TRUE, "Conditionally Required",  NA,
    # Numeric analysis visit
    "ADVS", "AVISITN",   3,        9,      TRUE, "Conditionally Required",  NA,
    # Baseline record flag
    "ADVS", "ABLFL",     NA,       10,     FALSE,"Conditionally Required",  NA,
    # Baseline analysis value
    "ADVS", "BASE",      NA,       11,     TRUE, "Conditionally Required",  NA,
    # Change from baseline
    "ADVS", "CHG",       NA,       12,     TRUE, "Permissible",  NA,
    # Analysis Date - in this case, vital sign measure date
    "ADVS", "ADT",       NA,       13,     TRUE,  "Required",  NA,
    
    # Study identifier
    "ADEX", "STUDYID",   NA,       1,      TRUE, "Required",   NA,
    # Unique subject identifier
    "ADEX", "USUBJID",   1,        2,      TRUE, "Required",   NA,
    # Subject identifier
    "ADEX", "SUBJID",    NA,       3,      TRUE, "Required",   NA, 
    # Name of the treatment administered
    "ADEX", "EXTRT",     NA,       4,      TRUE, "Required",   NA,
    # Start date/time of exposure
    "ADEX", "EXSTDTC",   NA,       5,      TRUE, "Required",   NA,
    # End date/time of exposure
    "ADEX", "EXENDTC",   NA,       6,      TRUE, "Required",   NA,
    # Dose
    "ADEX", "EXDOSE",    NA,       7,      TRUE, "Required", NA,
    # Dose (unit)
    "ADEX", "EXDOSU",    NA,       8,      TRUE, "Required", NA,
  )

# var_spec: Contains variable level information
## variable: Variable name, which should match the name in ds_spec. Unless the variable needs to be duplicated, then the name will be a combination of the the dataset name and variable name from ds_spec (dataset.variable)
## type: Variable class
## length: Variable length (while not relevant to R datasets, this is important for when creating XPT files)
## label: Variable label
## common: Common across ADaM datasets
## format: Variable format

var_spec =
  tribble( 
    ~variable, ~type, ~length, ~label,       ~format, ~common,
    "STUDYID", "text",     8,  "Study Identifier", NA, NA,     
    "USUBJID", "text",     12, "Unique Subject Identifier", NA, NA,
    "RFSTDTC", "date",     8,  "Subject Reference Start Date/Time", NA, NA,	
    "RFENDTC", "date",     8,  "Subject Reference End Date/Time", NA, NA,
    "SUBJID",  "text",     3,  "Subject Identifier for the Study", NA, NA,
    "SEX",     "text",     1,  "Sex", NA, NA,
    "AGE",     "integer",  8,  "Age", NA, NA,
    "AETERM",  "text",     20, "Reported Term for the Adverse Event", NA, NA,
    "AESER",   "text",     1,  "Seriousness of the Adverse Event", NA, NA,
    "AESEV",   "text",     20, "Severity of the Adverse Event", NA, NA,
    "AESTDTC", "date",     8,  "Start Date/Time of Adverse Event", NA, NA,
    "AEENDTC", "date",     8,  "End Date/Time of Adverse Event", NA, NA,
    "VISIT",   "text",     20,  "Visit Name", NA, NA,
    "AVISIT",  "text",     20,  "Analysis Visit", NA, NA,
    "AVISITN", "integer",  8,   "Analysis Visit Number", NA,     NA,
    "PARAM",   "text",     20, "Analysis Parameter",  NA, NA, 
    "PARAMCD", "text",     6,  "Analysis Code", NA, NA,  
    "AVAL",    "numeric",  8,  "Analysis Value", NA, NA,
    "AVALU",   "text",     2,  "Analysis Value Unit", NA, NA,
    "BASE",    "numeric",  8,  "Baseline Value", NA, NA,
    "ABLFL",   "text",     1,  "Baseline Record Flag", NA, NA, 
    "CHG",     "numeric",  8,  "Change from Baseline", NA, NA,
    "EXTRT",   "text",     20, "Treatment", NA, NA,
    "EXSTDTC", "date",     8,  "Start Date/Time of Treatment", NA, NA,
    "EXENDTC", "date",     8,  "End Date/Time of Treatment", NA, NA,
    "ADT",     "date",     8,   "Analysis Date", NA, NA,
    "AESEQ",   "integer",  8, "Adverse Event Sequence", NA, NA,
    "EXDOSE", "numeric",   8, "Dose", NA, NA,
    "EXDOSU", "text",      2, "Dose Unit", NA, NA
  )


# value_spec: Contains value level information
## dataset: The abbreviated name of the dataset. This will match to the name in ds_spec
## variable: Variable name. This will match to the name in ds_vars
## type: String of the value type
## origin: Origin of the value
### PREDECESSOR: comes from previous dataset
### DERIVED: needs to be calculated now
### ASSIGNED: directly assigned now
## sig_dig: Significant digits of the value
## code_id: ID for the code list to match the id in the codelist table (categories)
## where: Value of the variable
## derivation_id: ID for the derivation to match with the derivation table

value_spec = 
  tribble( 
    ~dataset, ~variable, ~type, ~origin, ~sig_dig, ~code_id, ~where, ~derivation_id,
    "ADSL", "STUDYID", "text", "PREDECESSOR", NA_integer_, NA, NA, "PRED.ADSL.STUDYID",
    "ADSL", "USUBJID", "text", "PREDECESSOR", NA_integer_, NA, NA, "PRED.ADSL.USUBJID",
    "ADSL", "RFSTDTC", "date", "PREDECESSOR", NA_integer_, NA, NA, "PRED.ADSL.RFSTDTC",
    "ADSL", "RFENDTC", "date", "PREDECESSOR", NA_integer_, NA, NA, "PRED.ADSL.RFENDTC",
    "ADSL", "SUBJID", "text", "PREDECESSOR",  NA_integer_, NA, NA, "PRED.ADSL.SUBJID",
    "ADSL", "SEX", "text", "PREDECESSOR",     NA_integer_, "CL.SEX", NA, "PRED.ADSL.SEX",
    "ADSL", "AGE", "integer", "PREDECESSOR",  0L, NA, NA, "PRED.ADSL.AGE",
        
    "ADAE", "SUBJID",   "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "AETERM",   "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "AESER",    "text",    "PREDECESSOR", NA_integer_, "CL.AESER", NA, NA,
    "ADAE", "AESEV",    "text",    "PREDECESSOR", NA_integer_, "CL.AESEV", NA, NA,
    "ADAE", "STUDYID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "USUBJID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "AESTDTC",  "date",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "AEENDTC",  "date",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADAE", "AESEQ",    "integer", "PREDECESSOR", NA_integer_, NA, NA, NA,
    
    "ADLB", "SUBJID",   "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADLB", "VISIT",    "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADLB", "AVISIT",   "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADLB.AVISIT",
    "ADLB", "AVISITN",  "integer", "DERIVED",     0L, NA, NA, "DER.ADLB.AVISITN",
    "ADLB", "PARAM",    "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADLB.PARAM",
    "ADLB", "PARAMCD",  "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADLB.PARAMCD",
    "ADLB", "AVAL",     "numeric", "PREDECESSOR", 1L, NA, NA, NA,
    "ADLB", "AVALU",    "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADLB", "STUDYID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADLB", "USUBJID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADLB", "BASE",     "numeric", "DERIVED",     1L, NA, NA, "DER.ADLB.BASE",
    "ADLB", "ABLFL",    "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADLB.ABLFL",
    "ADLB", "CHG",      "numeric", "DERIVED",     1L, NA, NA, "DER.ADLB.CHG",
    "ADLB", "ADT",      "date",    "DERIVED",     NA_integer_, NA, NA, "DER.ADLB.ADT",
    
    "ADVS", "STUDYID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADVS", "USUBJID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADVS", "SUBJID",   "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADVS", "PARAMCD",  "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADVS.PARAMCD",
    "ADVS", "PARAM",    "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADVS.PARAM",
    "ADVS", "AVAL",     "numeric", "PREDECESSOR", 1L, NA, NA, NA,
    "ADVS", "AVALU",    "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADVS", "AVISIT",   "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADVS.AVISIT",
    "ADVS", "AVISITN",  "integer", "DERIVED",     0L, NA, NA, "DER.ADVS.AVISITN",
    "ADVS", "ABLFL",    "text",    "DERIVED",     NA_integer_, NA, NA, "DER.ADVS.ABLFL",
    "ADVS", "BASE",     "numeric", "DERIVED",     1L, NA, NA, "DER.ADVS.BASE",
    "ADVS", "CHG",      "numeric", "DERIVED",     1L, NA, NA, "DER.ADVS.CHG",
    "ADVS", "ADT",      "date",    "DERIVED",     NA_integer_, NA, NA, "DER.ADVS.ADT",
    
    "ADEX", "STUDYID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADEX", "USUBJID",  "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADEX", "SUBJID",   "text",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADEX", "EXTRT",    "text",    "PREDECESSOR", NA_integer_, "CL.ARM", NA, NA,
    "ADEX", "EXSTDTC",  "date",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADEX", "EXENDTC",  "date",    "PREDECESSOR", NA_integer_, NA, NA, NA,
    "ADEX", "EXDOSE",   "numeric", "PREDECESSOR", 1L, NA, NA, NA,
    "ADEX", "EXDOSU",   "text",    "PREDECESSOR", NA_integer_, "CL.EXDOSU", NA, NA
  )
    

# derivations: Contains all derivations
## derivation_id: The ID, which should match to value_spec
## derivation: Text describing the derivation

derivations = 
  tribble( 
    ~derivation_id, ~derivation,
    "PRED.ADSL.STUDYID", "DM.STUDYID",
    "PRED.ADSL.USUBJID", "DM.USUBJID",
    "PRED.ADSL.RFSTDTC", "DM.RFSTDTC",
    "PRED.ADSL.RFENDTC", "DM.RFENDTC",
    "PRED.ADSL.SUBJID",  "DM.SUBJID",
    "PRED.ADSL.SEX",     "DM.SEX",
    "PRED.ADSL.AGE",     "DM.AGE",
    
    "DER.ADLB.AVISIT",
    "Derive analysis visit (AVISIT) from the source visit (VISIT).",
    "DER.ADLB.AVISITN",
    "Assign numeric analysis visit number (AVISITN) according to the analysis visit mapping.",
    "DER.ADLB.PARAM",
    "Assign analysis parameter (PARAM) from the corresponding SDTM laboratory test (LBTEST).",
    "DER.ADLB.PARAMCD",
    "Assign analysis parameter code (PARAMCD) from the corresponding SDTM laboratory test code (LBTESTCD).",
    "DER.ADLB.BASE",
    "Derive baseline analysis value (BASE) from the analysis value (AVAL) of the baseline record for each subject and parameter.",
    "DER.ADLB.ABLFL",
    "Set baseline record flag (ABLFL) to Y for the selected baseline record for each subject and parameter.",
    "DER.ADLB.CHG",
    "Calculate change from baseline (CHG) as AVAL minus BASE.",
    "DER.ADLB.ADT",
    "Derive analysis date (ADT) from the SDTM laboratory test date (LBDTC).",
    
    "DER.ADVS.PARAMCD",
    "Derive analysis parameter code (PARAMCD) from the corresponding SDTM vital signs test code (VSTESTCD).",
    "DER.ADVS.PARAM",
    "Derive analysis parameter (PARAM) from the corresponding SDTM vital signs test (VSTEST).",
    "DER.ADVS.AVISIT",
    "Derive analysis visit (AVISIT) from the source visit (VISIT).",
    "DER.ADVS.AVISITN",
    "Assign numeric analysis visit number (AVISITN) according to the analysis visit mapping.",
    "DER.ADVS.ABLFL",
    "Set baseline record flag (ABLFL) to Y for the selected baseline record for each subject and parameter.",
    "DER.ADVS.BASE",
    "Derive baseline analysis value (BASE) from the analysis value (AVAL) of the baseline record for each subject and parameter.",
    "DER.ADVS.CHG",
    "Calculate change from baseline (CHG) as AVAL minus BASE.",
    "DER.ADVS.ADT",
    "Derive analysis date (ADT) from the SDTM vital signs date (VSDTC)."
  )

# codelist: Contains information about code/decodes, permitted values and external libraries
## code_id: the ID used to identify the code list. This should be the same as the code_id in val_spec
## name: Name of the code list
## type: An indicator of if the information in the code column is a code/decode table, permitted value, or external library
## codes: A list of tibbles (for code / decode combinations) and vectors (for permitted values and libraries), which contain all the codes

codelist =
  tribble(
    ~code_id, ~name, ~type,  ~codes,

    "CL.SEX", "Sex", "CODE_DECODE",
    tibble(code = c("F", "M"), decode = c("Female", "Male")),

    "CL.AESER", "Adverse Event Seriousness", "CODE_DECODE",
    tibble(code = c("N", "Y"), decode = c("No", "Yes")),

    "CL.AESEV", "Adverse Event Severity", "CODE_DECODE",
    tibble(code = c("MILD", "MODERATE", "SEVERE"),
           decode = c("Mild", "Moderate", "Severe")),

    "CL.ARM", "Treatment Group", "CODE_DECODE",
    tibble(code = c("A", "B"), decode = c("Treatment A", "Placebo")),

    "CL.EXDOSU", "Exposure Dose Unit", "PERMITTED_VALUE", "mL"
  )

# supp: Contains information specific to supplemental variables
## dataset: The abbreviated name of the dataset. This will match to the name in ds_spec
## variable: Variable name. This will match to the name in ds_spec
## idvar: ID variable used for the supplemental variable. Can be left missing if not needed
## qeval: Evaluator for the supplemental variable
##### Not necessary for this dataset!

mt = metacore(
  ds_spec = ds_spec,
  ds_vars = ds_vars,
  var_spec = var_spec,
  value_spec = value_spec,
  derivations = derivations,
  codelist = codelist
)
