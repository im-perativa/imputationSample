#' Membuat filter yang diinginkan
#' @import dplyr
#' @import foreign
#' @import magrittr
#' @param ... Daftar filter yang diinginkan (dapat dibuat sebanyak mungkin).
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' filter_list = create_filter(NAMA_PROV == "ACEH", KLASIFIKASI == "1", JenisKegiatan != 2)
#' @export
create_filter <- function(...) {
  return(dplyr::quos(...))
}
