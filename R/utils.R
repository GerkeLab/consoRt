#' @title Null or Default
#' @description Null or default infix function borrowed from [purrr].
#' @param x,y If `x` is NULL, will return `y`; otherwise returns `x`.
#' @name null-default
#' @examples
#' 1 %||% 2
#' NULL %||% 2
#' @family utilities
`%||%` <- function(x, y) if (is.null(x)) y else x

#' @title Empty string if missing
#' @description If the LHS is missing, replaces with "". If the LHS is not
#'   missing, replaces with the RHS (or the LHS if RHS is `NULL`).
#' @param x,y If `x` is missing, returns ""; otherwise returns `y` or `x` if `y`
#'   is `NULL`.
#' @name missing-strings
#' @examples
#' NULL %??% "other"
#' "apple" %??% "other"
#' "apple" %??% NULL
#' @family utilities
`%??%` <- function(x, y) if_not_missing(x, y, "")

if_not_missing <- function(x, y = NULL, .na = "") {
  if (is.null(x) || is.na(x) || length(x) == 0 || x == "") {
    .na
  } else { y %||% x }
}

collapse_line <- function(x) paste(x, collapse = "\n")

collapse_comma <- function(x) paste(x, collapse = ", ")

wrap <- function(x, open, close = open) paste0(open, x, close)
