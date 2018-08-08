#' @title Null or Default
#' @description Null or default infix function borrowed from [purrr].
#' @param x,y If `x` is NULL, will return `y`; otherwise returns `x`.
#' @name null-default
#' @examples
#' 1 %||% 2
#' NULL %||% 2
#' @family utilities
`%||%` <- function(x, y) if (is.null(x)) y else x

if_not_missing <- function(x, show = NULL, .na = "") {
  if (is.null(x) || is.na(x) || length(x) == 0 || x == "") {
    .na
  } else { show %||% x }
}

collapse_line <- function(x) paste(x, collapse = "\n")

collapse_comma <- function(x) paste(x, collapse = ", ")

wrap <- function(x, open, close = open) paste0(open, x, close)
