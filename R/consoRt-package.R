#' @keywords internal
"_PACKAGE"

#' Example Study Data
#'
#' A dataset of 500 study participants with columns tracking their participation
#' in a randomized trial.
#'
#' @format A data frame with 500 rows and 12 variables:
#' \describe{
#'   \item{`id`}{integer. Participant ID}
#'   \item{`metadata`}{character. Name of participant, representative of
#'   metadata associated with the participant but unrelated to trial design.}
#'   \item{`eligible`}{character. Eligibility status of the participant, where
#'   `"Eligible"` indicates the participant was eligible and any other value
#'   describes the ineligibility group.}
#'   \item{`allocation`}{character. Allocation of the trial participant into
#'   the `"Intervention"` or `"Placebo"` group.}
#'   \item{`intervention`}{logical. Did the participant receive the
#'   intervention? `TRUE` or `FALSE` if the participant was allocated to the
#'   intervention group, `NA` otherwise.}
#'   \item{`intervention_excl_reason`}{character. Reasons describing the
#'   circumstances leading to the exclusion of the participant from the
#'   intervention group, `NA` if not excluded or in the intervention group.}
#'   \item{`placebo`}{logical. Did the participant receive the placebo? `TRUE`
#'   or `FALSE` if the participant was allocated to the placebo group, `NA`
#'   otherwise.}
#'   \item{`placebo_excl_reason`}{character. Reasons describing the
#'   circumstances leading to the exclusion of the participant from the
#'   placebo group, `NA` if not excluded or in the intervention group.}
#'   \item{`lost_reason`}{character. Reasons describing the circumstances by
#'   which the participant was lost to follow-up, or `NA` if the participant
#'   did not receive the intervention or placebo.}
#'   \item{`discontinued_reason`}{character. Reasons describing the
#'   circumstances by which the participant discontinued their participant,
#'   or `NA` if the participant did not receive the intervention or placebo.}
#'   \item{`analyzed`}{logical. Was the participant's data analyzed? `NA` if
#'   the participant was excluded prior to this stage.}
#'   \item{`analyzed_excl_reason`}{character. Reasons describing the exclusion
#'   of a participant from analysis if they otherwise reached this stage of the
#'   trial.}
#' }
"study_data"
