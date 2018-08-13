#' Write tikz drawing
#'
#' Creates a tikz drawing from a simple document based on the `standalone` LaTeX
#' document class. Optionally converts to an image in the format specified by
#' the `path` extension.
#'
#' @examples
#' write_tikz("\\draw [step=0.5] (-1.4,-1.4) grid (1.4,1.4);",
#'            tempfile(fileext = ".pdf"))
#'
#' @param tikz_text <chr> Character string of tikz commands
#' @param path <chr> File name for drawing output
#' @param tikz_library <chr> A vector or character string of tikz libraries that
#'   are required to compile the tikz drawing. Ex.
#'   `c("calc", "fit", "shapes", "arrows")`
#' @param tikz_style <list> A named list of tikz style definitions, e.g.
#'   `list(circle = "draw, ellipse")` will be converted to
#'   `\\tikzstyle{cloud} = [draw, ellipse]`.
#' @param tikz_picture <chr> A vector or character string of options to be
#'   passed to the `\\begin{tikzpicture}[...]` command.
#' @param class_options <chr> A vector of character string of options to be
#'   passed to the `standalone` document class.
#' @inheritDotParams tinytex::latexmk
#' @param density resolution to render raster image output via
#'   [magick::image_write]
#' @export
write_tikz <- function(
  tikz_text,
  path,
  tikz_library = NULL,
  tikz_style = NULL,
  tikz_picture = NULL,
  class_options = NULL,
  ...,
  density = 72
) {
  tikz_text <- collapse_line(tikz_text)
  tikz_library <- tikz_library %??%
    wrap(collapse_comma(tikz_library), "\\usetikzlibrary{", "}")
  class_options <- class_options %??%
    wrap(collapse_comma(class_options), "[", "]")
  tikz_style <- tikz_style %??%
    tikz_style %>%
      purrr::imap_chr(~ glue::glue("\\tikzstyle{{{.y}}} = [{.x}]")) %>%
      paste(collapse = "\n")

  tikz_picture <- tikz_picture %??% collapse_comma(tikz_picture)

  x <- readLines(system.file("base_tikz.tex", package = "consoRt"))
  x <- glue::glue(collapse_line(x), .open = "{{", .close = "}}")

  write_latex(x, path, ..., density = density)
}

#' @title Write LaTeX File and Compile to PDF or Image
#' @param x LaTeX document as character string
#' @inheritParams write_tikz
#' @export
write_latex <- function(x, path, ..., density = 72) {
  out_format <- get_out_format(path)

  tmpfile <- if (out_format == "tex") path else tempfile(fileext = ".tex")
  message("writing temp tex file to: ", tmpfile)
  cat(x, file = tmpfile)

  if (out_format == "tex") return(path)

  tex_path <- if (out_format == "pdf") path else tempfile(fileext = ".pdf")
  tinytex::latexmk(tmpfile, pdf_file = tex_path, ...)

  if (out_format %in% c("png", "jpeg", "gif")) {
    message("converting to ", out_format, ": ", tex_path)
    magick::image_write(
      magick::image_read_pdf(tex_path),
      path,
      format = out_format,
      density = density
    )
  }

  if (interactive()) utils::browseURL(path)
  path
}

get_out_format <- function(path) {
  out_format <- tools::file_ext(tolower(path))
  if (!out_format %in% c("pdf", "png", "jpeg", "gif", "tex")) {
    rlang::abort(
      glue::glue("'{out_format}' is not a supported extension of `write_tikz()`")
    )
  }
  out_format
}

#' @title Write CONSORT Diagram
#' @param study_data Study data data frame (see [study_data] for information)
#' @inheritParams write_tikz
#' @export
write_consort <- function(study_data, path, ..., density = 72) {
  n_assessed <- nrow(study_data)

  # Excluded ----
  excluded <- study_data %>% dplyr::filter(eligible != "Eligible")
  n_excluded <- nrow(excluded)
  t_excluded <- excluded %>%
    dplyr::group_by(eligible) %>%
    dplyr::count()

  # Randomized ---
  n_randomized <- study_data %>% dplyr::filter(eligible == "Eligible") %>% nrow()

  # Allocation ---
  # Allocation: Intervention ----
  alloc_intervention <- study_data %>% dplyr::filter(allocation == "Intervention")
  n_intervention <- nrow(alloc_intervention)
  n_intervention_yes <- sum(alloc_intervention$intervention)
  n_intervention_no <- sum(!alloc_intervention$intervention)
  t_intervention_excl_reason <- alloc_intervention %>%
    dplyr::filter(!is.na(intervention_excl_reason)) %>%
    dplyr::group_by(intervention_excl_reason) %>%
    dplyr::count(sort = TRUE)

  # Allocation: Placebo ----
  alloc_placebo <- dplyr::filter(study_data, allocation == "Placebo")
  n_placebo <- nrow(alloc_placebo)
  n_placebo_yes <- sum(alloc_placebo$placebo)
  n_placebo_no <- sum(!alloc_placebo$placebo)
  t_placebo_excl_reason <- alloc_placebo %>%
    dplyr::filter(!is.na(placebo_excl_reason)) %>%
    dplyr::group_by(placebo_excl_reason) %>%
    dplyr::count(sort = TRUE)

  # Follow-Up ----
  # Follow-Up: Intervention ----
  fu_intervention <- dplyr::filter(study_data, intervention)
  t_intervention_lost <- fu_intervention %>%
    dplyr::filter(!is.na(lost_reason)) %>%
    dplyr::group_by(lost_reason) %>%
    dplyr::count(sort = TRUE)
  n_intervention_lost <- sum(t_intervention_lost$n)
  t_intervention_discontinued <- fu_intervention %>%
    dplyr::filter(!is.na(discontinued_reason)) %>%
    dplyr::group_by(discontinued_reason) %>%
    dplyr::count(sort = TRUE)
  n_intervention_discontinued <- sum(t_intervention_discontinued$n)

  # Follow-Up: Placebo ----
  fu_placebo <- dplyr::filter(study_data, placebo)
  t_placebo_lost <- fu_placebo %>%
    dplyr::filter(!is.na(lost_reason)) %>%
    dplyr::group_by(lost_reason) %>%
    dplyr::count(sort = TRUE)
  n_placebo_lost <- sum(t_placebo_lost$n)
  t_placebo_discontinued <- fu_placebo %>%
    dplyr::filter(!is.na(discontinued_reason)) %>%
    dplyr::group_by(discontinued_reason) %>%
    dplyr::count(sort = TRUE)
  n_placebo_discontinued <- sum(t_placebo_discontinued$n)

  # Analyzed ----
  # Analyzed: Intervention ----
  a_intervention <- dplyr::filter(study_data, allocation == "Intervention", !is.na(analyzed))
  n_intervention_analyzed <- sum(a_intervention$analyzed)
  n_intervention_analyzed_excl <- sum(!a_intervention$analyzed)
  t_intervention_analyzed_excl_reason <- a_intervention %>%
    dplyr::filter(!analyzed) %>%
    dplyr::group_by(analyzed_excl_reason) %>%
    dplyr::count(sort = TRUE)

  # Analyzed: Placebo ----
  a_placebo <- dplyr::filter(study_data, allocation == "Placebo", !is.na(analyzed))
  n_placebo_analyzed <- sum(a_placebo$analyzed)
  n_placebo_analyzed_excl <- sum(!a_placebo$analyzed)
  t_placebo_analyzed_excl_reason <- a_placebo %>%
    dplyr::filter(!analyzed) %>%
    dplyr::group_by(analyzed_excl_reason) %>%
    dplyr::count(sort = TRUE)

  # Load template
  template <- readLines(system.file("consort_template.whisker", package = "consoRt"))

  # Prep for glue ----
  t_excluded                          <- latex_count_reason(t_excluded)
  t_intervention_excl_reason          <- latex_count_reason(t_intervention_excl_reason)
  t_placebo_excl_reason               <- latex_count_reason(t_placebo_excl_reason)
  t_intervention_lost                 <- latex_count_reason(t_intervention_lost)
  t_intervention_discontinued         <- latex_count_reason(t_intervention_discontinued)
  t_placebo_lost                      <- latex_count_reason(t_placebo_lost)
  t_placebo_discontinued              <- latex_count_reason(t_placebo_discontinued)
  t_intervention_analyzed_excl_reason <- latex_count_reason(t_intervention_analyzed_excl_reason)
  t_placebo_analyzed_excl_reason      <- latex_count_reason(t_placebo_analyzed_excl_reason)

  # Write tex file ----
  # x <- glue::glue(paste(template, collapse = "\n"), .open = "<<", .close = ">>")
  x <- whisker::whisker.render(template)
  write_latex(x, path, ..., density = density)
}

remove_section <- function(x, section_name) {
  idx <- grep(paste0("^\\s*%%", section_name, "%%$"), x)
  if (!length(idx)) return(x)
  x[-seq(min(idx), max(idx))]
}

latex_count_reason <- function(x) {
  if (!nrow(x)) return(NULL)
  names(x) <- c("reason", "n")
  escape_latex <- getFromNamespace("escape_latex", "knitr")
  x$reason <- escape_latex(x$reason)
  y <- glue::glue_data(x, "{n} & {reason} \\\\")
  paste(as.character(y), collapse = "\n")
}
