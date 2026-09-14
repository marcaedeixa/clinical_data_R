##############################################################
# PROGRAM: adsl.R
# PURPOSE: Create ADSL dataset
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Step-by-step from https://pharmaverse.github.io/examples/adam/adsl.html

# Read in input SDTM data
dm = read_csv(paste0(dir_sdtm, "dm.csv"))
ex = read_csv(paste0(dir_sdtm, "ex.csv"))

# Read in metacore object
metacore = mt |>
  select_dataset("ADSL")

# Create derivation 1:
## Dataset has all the columns and any columns that needed renaming between SDTM and ADaM are renamed.

adsl_preds =
  build_from_derived(
    metacore,
    ds_list = list("dm" = dm),
    predecessor_only = TRUE, 
    keep = FALSE
)

head(adsl_preds)

# Create derivation 2:
## Include grouping variable for AGE

agegr1_lookup = 
  rlang::exprs(
  ~condition,  ~AGEGR1, ~AGEGR1N,
  is.na(AGE),  "Missing",    4,
  AGE < 60,    "<60",        1,
  AGE >= 60,   "60+",        2)

adsl_cat = derive_vars_cat(
  dataset = adsl_preds,
  definition = agegr1_lookup
)

head(adsl_cat)

# Apply Metadata to Create an eSub XPT and Perform Associated Checks

adsl = adsl_cat |>
  check_variables(metacore) |> # Check all variables specified are present and no more
  check_ct_data(metacore, na_acceptable = TRUE) |> # Checks all variables with CT only contain values within the CT
  order_cols(metacore) |> # Orders the columns according to the spec
  sort_by_key(metacore) |> # Sorts the rows by the sort keys
  xportr_type(metacore, domain = "ADSL") |> # Coerce variable type to match spec
  xportr_length(metacore) |> # Assigns SAS length from a variable level metadata
  xportr_label(metacore) |> # Assigns variable label from metacore specifications
  xportr_df_label(metacore) |> # Assigns dataset label from metacore specifications
  xportr_write(file.path(dir_adam, "adsl.xpt"), metadata = metacore, domain = "ADSL")
