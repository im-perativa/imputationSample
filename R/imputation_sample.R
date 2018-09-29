#' Memilih sampel imputasi dari filter yang telah dibuat.
#' @import dplyr
#' @import foreign
#' @import magrittr
#' @param x Dataset yang digunakan.
#' @param filters Filter yang telah dibuat dengan fungsi \code{\link{create_filter}}.
#' @param size Besaran sampel yang diinginkan.
#' @param weight_col Kolom yang digunakan sebagai weight dalam pemilihan sampel apabila tersedia.
#' @param flag Identitas dari sampel yang dihasilkan
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' filter_1 = create_filter(NAMA_PROV == "ACEH", KLASIFIKASI == 1)
#' filter_2 = create_filter(NAMA_PROV == "RIAU", KLASIFIKASI == 2)
#' imputation_sample(x = sakernas_dummy, filters = filter_1, size = 4, flag = "aceh_1")
#' imputation_sample(x = sakernas_dummy, filters = filter_2, size = 10, weight_col = Weight_R, flag = "riau_2_weighted")
#' @export
imputation_sample <- function(x, filters, size, weight_col = NULL, flag = 1) {
  weight_col <- dplyr::enquo(weight_col)

  if (!"temp_id" %in% colnames(x)) {
    x$temp_id <- 1:nrow(x)
  }

  if (!"flag" %in% colnames(x)) {
    x$flag <- NA
  }

  filtered <- x %>%
    dplyr::filter(!!!filters) %>%
    dplyr::sample_n(size, weight = !!weight_col) %>%
    select(temp_id)

  x[filtered$temp_id, "flag"] <- flag
  x$temp_id <- NULL
  return(x)
}
