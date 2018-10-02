#' @title Memilih sampel imputasi
#' @description Memilih sampel imputasi dari filter yang telah dibuat dengan total weight tertentu
#' @import dplyr
#' @import foreign
#' @import magrittr
#' @param x Dataset yang digunakan.
#' @param filters Filter yang telah dibuat dengan fungsi \code{\link{create_filter}}.
#' @param weight_aggregate Besaran agregat weight dari sampel terpilih yang diinginkan.
#' @param weight_col Kolom yang digunakan sebagai weight dalam pemilihan sampel apabila tersedia.
#' @param flag Identitas dari sampel yang dihasilkan
#' @return Filter yang dapat digunakan untuk memfilter data dalam fungsi \code{\link{imputation_sample}}.
#' @examples
#' filter_1 = create_filter(NAMA_PROV == "ACEH", KLASIFIKASI == 1)
#' filter_2 = create_filter(NAMA_PROV == "RIAU", KLASIFIKASI == 2)
#' imputation_sample(x = sakernas_dummy, filters = filter_1, weight_aggregate = 10000, flag = "aceh_1")
#' imputation_sample(x = sakernas_dummy, filters = filter_2, weight_aggregate = 5000, weight_col = Weight_R, flag = "riau_2")
#' @export
imputation_sample <- function(x, filters, weight_aggregate, weight_col, flag = 1) {
  weight_col <- dplyr::enquo(weight_col)

  if (!"temp_id" %in% colnames(x)) {
    x$temp_id <- 1:nrow(x)
  }

  if (!"flag" %in% colnames(x)) {
    x$flag <- NA
  }

  x_filtered <- x %>%
    dplyr::filter(!!!filters) %>%
    dplyr::sample_frac() %>%
    select(!!weight_col, temp_id)

  # Tambahan
  if (weight_aggregate < x_filtered %>% select(!!weight_col) %>% min()) {
    stop("Total weight yang dimasukan terlalu kecil")
  }

  n_all <- nrow(x)
  n_filtered <- nrow(x_filtered)
  left <- n_filtered
  groups <- list()
  limit <- weight_aggregate
  i <- 1

  while (left > 0) {
    cums <- cumsum(x_filtered[[1]]) # Weight column
    indexes <- cums <= limit
    last <- sum(indexes)

    group <- x_filtered[[2]][indexes] # Temporary id column
    group_sum <- cums[last]

    if (last != 0) {
      x_filtered <- x_filtered[!indexes,]
      groups[[i]] <- list(member = group, n = length(group), sum = group_sum)
      i <- i + 1
    } else {
      x_filtered <- x_filtered[-1, ]
    }

    left <- nrow(x_filtered)
  }

  final = min(which(sapply(groups, "[[", "sum") == max(sapply(groups, "[[", "sum"))))

  x[x$temp_id %in% groups[[final]]$member, "flag"] <- flag
  x$temp_id <- NULL

  message(paste(n_filtered, "data berhasil difilter dari", n_all, "data yang ada"))
  message(paste(groups[[final]]$n, " sampel terpilih dengan total weight: ", groups[[final]]$sum,
                " (", round(groups[[final]]$sum / weight_aggregate * 100, 4), "%)", sep = ""))
  message(paste("Sampel terpilih telah ditandai dengan flag: ", flag, ". Silakan periksa kolom flag", sep = ""))
  return(x)
}
