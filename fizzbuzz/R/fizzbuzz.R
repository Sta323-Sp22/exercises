#' @title Fizzbuzz
#'
#' @description Implements fizzbuzz
#'
#' @param x *Numeric* vector to run the fizzbuzz algorithm on
#'
#' @returns A character vector containing numbers, `fizz`, `buzz` or `fizzbuzz`
#'
#' @examples
#' fizzbuzz(1:10)
#' fizzbuzz(1)
#'
#'
#' @export
fizzbuzz = function(x) {
  stopifnot(all(x>=0))
  stopifnot(all(is.finite(x)))
  stopifnot(is.numeric(x))

  dplyr::case_when(
    x %% 3 == 0 & x %% 5 == 0 ~ "fizzbuzz",
    x %% 3 == 0~ "fizz",
    x %% 5 == 0  ~ "buzz",
    TRUE ~ as.character(x)
  )
}


