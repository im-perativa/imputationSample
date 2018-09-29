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
#' filter_list = create_filter(mpg > 15, gear == 4, between(hp, 100, 110))
#' imputation_sample(x = mtcars, filters = filter_list, size = 4)
#' imputation_sample(x = mtcars, filters = filter_list, size = 4, weight_col = disp, flag = "sampelku")
#' @export
imputation_sample <- function(x, filters, size, weight_col = NULL, flag = 1) {
  weight_col <- dplyr::enquo(weight_col)
  original <- x
  filtered <- x %>%
    dplyr::filter(!!!filters) %>%
    dplyr::sample_n(size, weight = !!weight_col) %>%
    dplyr::mutate(flag = flag)

  result <- dplyr::left_join(original, filtered)
  return(result)
}
