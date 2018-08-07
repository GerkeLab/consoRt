#' Null coallesce something operator
#'
#' @keywords internal
`%||%` <- function(x, y) if (is.null(x)) y else x

if_not_missing <- function(x, show = NULL, .na = "") {
  if (is.null(x) || is.na(x) || length(x) == 0 || x == "") {
    .na
  } else { show %||% x }
}

collapse_line <- function(x) paste(x, collapse = "\n")

collapse_comma <- function(x) paste(x, collapse = ", ")

wrap <- function(x, open, close = open) paste0(open, x, close)
