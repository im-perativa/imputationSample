#' @title Memilih sampel imputasi
#' @description Memilih sampel imputasi dari filter yang telah dibuat dengan total weight tertentu
#' @import dplyr
#' @import foreign
#' @import magrittr
#' @param x Dataset yang digunakan.
#' @param filters Filter yang telah dibuat dengan fungsi \code{\link{create_filter}}.
#' @param weight_aggregate Besaran agregat weight dari sampel terpilih yang diinginkan.
#' @param weight_col Kolom yang digunakan sebagai weight dalam pemilihan sampel apabila tersedia.
#' @param iter Jumlah iterasi pengacakan dan pengambilan sampel yang diinginkan (semakin tinggi maka weight akan semakin sesuai).
#' @param flag Identitas dari sampel yang dihasilkan.
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' # Membuat filter berbeda
#' filter_1 = create_filter(NAMA_PROV == "ACEH", KLASIFIKASI == 1)
#' filter_2 = create_filter(NAMA_PROV == "RIAU" | NAMA_PROV == "SUMATERA BARAT", KLASIFIKASI == 2)
#' imputation_sample(x = sakernas_dummy, filters = filter_1, weight_aggregate = 10000, weight_col = Weight_R, flag = "aceh_1")
#' imputation_sample(x = sakernas_dummy, filters = filter_2, weight_aggregate = 5000, weight_col = Weight_R, flag = "riau_sumbar_2")
#'
#' # Membandingkan hasil sampel dengan jumlah iterasi berbeda
#' my_filter = create_filter(NAMA_PROV == "SUMATERA BARAT", KLASIFIKASI == 2)
#' imputation_sample(x = sakernas_dummy, filters = my_filter, weight_aggregate = 73955, weight_col = Weight_R, iter = 1)
#' imputation_sample(x = sakernas_dummy, filters = my_filter, weight_aggregate = 73955, weight_col = Weight_R, iter = 100)
#' @export
imputation_sample <- function(x, filters, weight_aggregate, weight_col, iter = 1, flag = 1) {
  weight_col <- dplyr::enquo(weight_col)

  if (!"temp_id" %in% colnames(x)) {
    x$temp_id <- 1:nrow(x)
  }

  if (!"flag" %in% colnames(x)) {
    x$flag <- NA
  }

  x_filtered <- x %>%
    dplyr::filter(!!!filters)

  if (weight_aggregate < x_filtered %>% select(!!weight_col) %>% min()) {
    stop("Total weight yang dimasukan terlalu kecil")
  }

  n_all <- nrow(x)
  n_filtered <- nrow(x_filtered)
  limit <- weight_aggregate
  candidates <- list()

  for (i in 1:iter) {
    x_iter <- x_filtered %>%
      dplyr::sample_frac() %>%
      select(!!weight_col, temp_id)

    left <- n_filtered
    groups <- list()
    j <- 1

    while (left > 0) {
      cums <- cumsum(x_iter[[1]]) # Weight column
      indexes <- cums <= limit
      last <- sum(indexes)

      group <- x_iter[[2]][indexes] # Temporary id column
      group_sum <- cums[last]

      if (last != 0) {
        x_iter <- x_iter[!indexes,]
        groups[[j]] <- list(member = group, n = length(group), sum = group_sum)
        j <- j + 1
      } else {
        x_iter <- x_iter[-1, ]
      }

      left <- nrow(x_iter)
    }

    groups_final = min(which(sapply(groups, "[[", "sum") == max(sapply(groups, "[[", "sum"))))
    candidates[[i]] <- groups[[groups_final]]
  }

  candidates_final = min(which(sapply(candidates, "[[", "sum") == max(sapply(candidates, "[[", "sum"))))

  x[x$temp_id %in% candidates[[candidates_final]]$member, "flag"] <- flag
  x$temp_id <- NULL

  message(paste(n_filtered, "data berhasil difilter dari", n_all, "data yang ada"))
  message(paste(candidates[[candidates_final]]$n, " sampel terpilih dari ", iter, " iterasi dengan total weight: ",
                candidates[[candidates_final]]$sum, " (", round(candidates[[candidates_final]]$sum / weight_aggregate * 100, 4),
                "%)", sep = ""))
  message(paste("Sampel terpilih telah ditandai dengan flag: ", flag, ". Silakan periksa kolom flag", sep = ""))
  return(x)
}
