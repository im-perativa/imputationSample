#' Membuat filter yang diinginkan
#' @param ... Daftar filter yang diinginkan (dapat dibuat sebanyak mungkin).
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' filter1 = create_filter(NAMA_PROV == "ACEH", KLASIFIKASI == "1", JenisKegiatan != 2)
#' filter2 = create_filter(NAMA_PROV == "ACEH" | NAMA_PROV == "RIAU", KLASIFIKASI == "2", JenisKegiatan %in% (1,2,3))
#' @export
create_filter <- function(...) {
  return(dplyr::quos(...))
}
