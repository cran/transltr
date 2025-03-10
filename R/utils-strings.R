#' Character String Utilities
#'
#' @description
#' [str_to()] converts an \R object to a character string. It is a slightly
#' more flexible alternative to [base::toString()].
#'
#' [str_trim()] wraps [base::strtrim()] and further adds a `...` suffix to
#' each trimmed element.
#'
#' [str_wrap()] wraps [base::strwrap()] and ensures a character string is
#' returned.
#'
#' @details
#' [str_to()] concatenates all elements with `", "`, except for the last
#' one. See argument `last_sep`.
#'
#' [str_wrap()] preserves existing paragraph separators (`"\n\n"`).
#'
#' @param x Any \R object for [str_to()]. A character vector otherwise.
#'
#' @param quote_values A non-NA logical value. Should elements of `x` be quoted?
#'
#' @param last_sep A non-empty and non-NA character string separating the last
#'   and penultimate elements.
#'
#' @param ... Further arguments passed to, or from other methods.
#'
#' @param width A non-NA integer value. The target width for individual
#'   elements of `x`. [str_trim()] takes 3 more characters into account for the
#'   suffix it inserts (`...`).
#'
#' @returns
#' [str_to()] and [str_wrap()] return a character string.
#'
#' [str_trim()] returns a character vector having the same length as `x`.
#'
#' @rdname utils-strings
#' @family utility functions
#' @keywords internal
str_to <- function(x, ...) {
    UseMethod("str_to")
}

#' @rdname utils-strings
#' @keywords internal
#' @export
str_to.default <- function(x, quote_values = FALSE, last_sep = ", or ", ...) {
    assert_lgl1(quote_values)
    assert_chr1(last_sep)

    x <- as.character(x, ...)

    if (quote_values) {
        x <- sprintf("'%s'", x)
    }
    if (length(x) < 2L) {
        return(x)
    }

    return(
        paste0(
            paste0(utils::head(x, -1L), collapse = ", "),
            last_sep,
            utils::tail(x, 1L)))
}

#' @rdname utils-strings
#' @keywords internal
str_trim <- function(x = character(), width = 80L) {
    assert_chr(x, TRUE)
    assert_int1(width)
    assert_between(width, 3L)

    if (!length(x)) {
        return(character())
    }

    to_trim    <- nchar(x) > width
    x[to_trim] <- paste0(strtrim(x[to_trim], width - 3L), "...")
    return(x)
}

#' @rdname utils-strings
#' @keywords internal
str_wrap <- function(x = character(), width = 80L) {
    assert_chr(x, TRUE)
    assert_int1(width)
    assert_between(width, 1L)
    return(paste0(strwrap(x, width), collapse = "\n"))
}
