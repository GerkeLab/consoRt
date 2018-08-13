library(dplyr)
Sample <- function(x, n = 500) sample(x, n, replace = TRUE)

study_data <- tibble::tibble(
  id = 1:500,
  metadata = charlatan::ch_name(500),
  eligible = Sample(c(rep("Eligible", 50), rep("Ineligible", 3), "Declined", "Other"))
)

study_data <- study_data %>%
  mutate(
    allocation = ifelse(eligible == "Eligible", Sample(c("Intervention", "Placebo")), NA),
    intervention = ifelse(
      allocation == "Intervention",
      Sample(c(rep(TRUE, 10), FALSE)), NA),
    intervention_excl_reason = ifelse(
      allocation == "Intervention" & !intervention,
      Sample(paste("No intervention reason", LETTERS[1:3])), NA),
    placebo = ifelse(
      allocation == "Placebo",
      Sample(c(rep(TRUE, 10), FALSE)), NA),
    placebo_excl_reason = ifelse(
      allocation == "Placebo" & !placebo,
      Sample(paste("No placebo reason", LETTERS[4:5])), NA),
    lost_reason = ifelse(
      eligible == "Eligible" & (ifelse(is.na(intervention), FALSE, intervention) | ifelse(is.na(placebo), FALSE, placebo)),
      paste("Lost follow up:", LETTERS[6:10])[Sample(1:25)], NA),
    discontinued_reason = ifelse(
      eligible == "Eligible" & ((!is.na(intervention) & intervention) | (!is.na(placebo) & placebo)),
      paste("Discontinued:", LETTERS[11:15])[Sample(1:30)], NA),
    analyzed = eligible == "Eligible" &
      ifelse(is.na(intervention), TRUE, intervention) &
      ifelse(is.na(placebo), TRUE, placebo) &
      is.na(lost_reason) & is.na(discontinued_reason),
    analyzed = ifelse(
      eligible != "Eligible" |
        !is.na(intervention_excl_reason) |
        !is.na(placebo_excl_reason) |
        !is.na(lost_reason) |
        !is.na(discontinued_reason),
      NA, analyzed),
    analyzed = ifelse(analyzed, Sample(c(rep(TRUE, 15), FALSE)), NA),
    analyzed_excl_reason = ifelse(!analyzed, Sample(paste("Not analyzed because", LETTERS[16:25])), NA)
  )

use_data(study_data, overwrite = TRUE)
