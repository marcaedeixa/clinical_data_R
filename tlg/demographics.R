##############################################################
# PROGRAM: demographics.R
# PURPOSE: Create demographic table
# AUTHOR:  Carolina Peçaibes
# DATE: 26/aug/2026
##############################################################

# Reference: https://pharmaverse.github.io/examples/tlg/demographic.html#gtsummary-cards

# Read in ADaM
adsl = read_xpt(paste0(dir_adam, "adsl.xpt"))

theme_gtsummary_compact() # reduce default padding and font size for a gt table

# build the ARD with the needed summary statistics using {cards}
ard =
  ard_stack(
    adsl,
    ard_continuous(variables = AGE),
    ard_categorical(variables = c(AGEGR1, SEX)),
    .attributes = TRUE # optionally include column labels in the ARD
  )

# use the ARD to create a demographics table using {gtsummary}
tbl = 
  tbl_ard_summary(
  cards = ard,
  include = c(AGE, AGEGR1, SEX),
  type = AGE ~ "continuous2",
  statistic = AGE ~ c("{N}", "{mean} ({sd})", "{median} ({p25}, {p75})", "{min}, {max}")
) |>
  bold_labels() |>
  modify_footnote(everything() ~ NA) # remove default footnote

tbl |>
  as_gt() |>
  gtsave(filename = paste0(dir_tlg, "demographics.html"))
