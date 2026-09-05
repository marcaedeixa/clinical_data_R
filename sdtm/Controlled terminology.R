####################################################################
# PROGRAM: Controlled Terminology Creation
# PURPOSE: CT for portfolio demonstration
# AUTHOR:  Carolina Peçaibes
# DATE:    26/aug/2026
####################################################################

# CT
# controlled terminology for categorical responses, unit measures, etc
# https://evs.nci.nih.gov/ftp1/CDISC/SDTM/SDTM%20Terminology.pdf

# codelist_code = CDISC/NCI identifier
# term_code = NCI specific term identifier
# term_value = standard SDTM value
# collected_value = collected value
# term_preferred_term = preferred value according to NCI
# term_synonyms = synonyms according to NCI

sdtm_ct = 
  tribble(~codelist_code, ~term_code, ~term_value, 
          ~collected_value, ~term_preferred_term, ~term_synonyms,
          "C66731", "C16576", "F", # Sex (F)
          "F", "Female", "Female",
          "C66731", "C20197", "M", # Sex (M)
          "M", "Male", "Male",
          "C66781", "C29848", "YEAR", # Age measure unit
          "Year", "Year", "Year",
          "ARM", "A", "Treatment A", # Group (Treatment A)
          "A", "Treatment A", "Treatment A",
          "ARM", "B", "Placebo", # Group (Placebo)
          "B", "Placebo", "Placebo",
          "C71620", "C28254", "mL", # Treatment measure unit
          "mL", "Milliliter", "Milliliter",
          "C71620", "C25613", "%", # Lab test unit
          "%", "Percent", "Percent", 
          "C65047", "C64849", "HBA1C", # Lab test code
          "HbA1c", "Hemoglobin A1C", "HbA1c", 
          "C67154", "C64849", "Hemoglobin A1C", # Lab test name
          "HbA1c", "Hemoglobin A1C", "HbA1c", 
          "C66769", "C41338", "MILD", # Severity adv. event (Mild)
          "MILD", "Mild Adverse Event", "1;Grade 1",
          "C66769", "C41339", "MODERATE", # Severity adv. event (Moderate)
          "MODERATE", "Moderate Adverse Event", "2;Grade 2", 
          "C66769", "C41340", "SEVERE", # Severity adv. event (Severe)
          "SEVERE", "Severe Adverse Event", "3;Grade 3", 
          "C66742", "C49487", "N",  # Seriousness adv. event (No)
          "N", "No", "No", 
          "C66742", "C49488", "Y", # Seriousness adv. event (Yes)
          "Y", "Yes", "Yes", 
          "C66741", "C25208", "WEIGHT", # Weight as test code
          "WEIGHT", "Weight", "Weight", 
          "C67153", "C25208", "Weight", # Weight as test name
          "WEIGHT", "Weight", "Weight",
          "C66770", "C28252", "kg", # Weight measure unit
          "kg", "Kilogram", "Kilogram"
  )

write.csv(sdtm_ct, file = paste0(dir_sdtm, "sdtm_ct.csv"))
