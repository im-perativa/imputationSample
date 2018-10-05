#' Mengubah nilai atribut-atribut sampel
#' @description Mengubah nilai atribut-atribut sampel dengan flag tertentu
#' @param x Dataset yang digunakan.
#' @param sample_flag Flag dari sampel imputasi yang ingin diubah atribut-atributnya
#' @param ... Daftar mapping atribut dan nilai baru yang diinginkan (dapat dibuat sebanyak mungkin).
#' @return Data yang telah diubah nilai atribut-atributnya.
#' @examples
#' sakernas_dummy = mutate_sample(x = sakernas_dummy, flag = "aceh_desa", status6 = NA, kategori = 1)
#' @export
mutate_sample <- function(x, sample_flag, ...) {
  all_flags <- unique(x$flag)
  if (!sample_flag %in% all_flags ){
    stop(paste("Sampel terpilih dengan flag:", sample_flag, "tidak ditemukan"))
  }

  mutation <- dplyr::quos(...)
  mutation_col <- names(mutation)

  x$temp_id <- 1:nrow(x)

  x_modified <- x %>%
    dplyr::filter(flag == sample_flag) %>%
    dplyr::mutate(!!!mutation)

  # Edit
  x <- x %>%
    dplyr::filter(flag != sample_flag | is.na(flag)) %>%
    rbind(x_modified) %>%
    dplyr::arrange(temp_id)

  # x <- rbind(x[x$flag != sample_flag, ], x_modified)
  # x <- x %>% arrange(temp_id)
  x$temp_id <- NULL

  for (name in mutation_col) {
    message(paste("Nilai atribut ", name, " dari sampel terpilih dengan flag: ", sample_flag,
                  " telah diubah menjadi: ", x_modified[1, name], sep = ""))
  }

  return(x)
}
