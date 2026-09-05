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
