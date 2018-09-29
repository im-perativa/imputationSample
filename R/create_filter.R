#' Membuat filter yang diinginkan.
#' @import dplyr
#' @import foreign
#' @import magrittr
#' @param ... Daftar filter yang diinginkan.
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' filter_list = create_filter(mpg > 15, gear == 4, between(hp, 100, 110))
#' @export
create_filter <- function(...) {
  return(dplyr::quos(...))
}
