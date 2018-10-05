# imputationSample

## Deskripsi
`imputationSample` merupakan package dalam bahasa pemrograman **R** yang dapat digunakan untuk memilih sampel imputasi dengan weight yang telah ditentukan.

## Instalasi
```
install.packages("devtools")
devtools::install_github("imperativa/imputationSample")
```

## Penggunaan
Terdapat dua fungsi utama dalam package ini:
* `create_filter()` digunakan untuk membuat filter yang diinginkan
* `imputation_sample()` digunakan untuk memilih sampel imputasi dari filter yang telah dibuat dengan total weight tertentu
* `mutate_sample()` digunakan untuk mengubah nilai atribut-atribut tertentu dari sampel yang telah dipilh yang teridentifikasi dengan flag tertentu

## Implementasi
```r
library(imputationSample)

sakernas_dummy
#> # A tibble: 3,727 x 225
#>   urutan tahun Weight_R SMT   KODE_PROV NAMA_PROV KODE_KAB NAMA_KAB KLASIFIKASI NO_DSRT KRT_DSRT ALAMAT NBANGS NBF  
#>    <dbl> <dbl>    <dbl> <chr> <dbl+lbl> <chr>        <dbl> <chr>    <dbl+lbl>     <dbl> <chr>    <chr>  <chr>  <chr>
#> 1     12 20182     1078 1     11        ACEH             1 SIMEULUE 2                 4 ARISUDIN JLN T~ 042    042  
#> 2     22 20182      666 1     11        ACEH             1 SIMEULUE 2                 6 SURIADIN JL TG~ 070    070  
#> 3     27 20182      508 1     11        ACEH             1 SIMEULUE 2                 7 EDI SAH~ JL TG~ 081    081  
#> 4     47 20182      694 1     11        ACEH             1 SIMEULUE 2                 2 AFRIZAL  KAMPU~ 023    006  
#> 5     57 20182      516 1     11        ACEH             1 SIMEULUE 2                 4 MUHAMMAD KAMPU~ 047    019  
#> 6     63 20182      677 1     11        ACEH             1 SIMEULUE 2                 7 JOHN VA~ KAMPU~ 099    024  
#> 7    111 20182      621 1     11        ACEH             1 SIMEULUE 2                 1 JAKRIL   DUSUN~ 004    004  
#> 8    125 20182      718 1     11        ACEH             1 SIMEULUE 2                 4 SARIFUD~ DUSUN~ 045    042  
#> 9    150 20182      859 1     11        ACEH             1 SIMEULUE 2                10 SULDANI  DUSUN~ 021    019  
#> 10    169 20182      910 1     11        ACEH             1 SIMEULUE 2                 3 SULRAHM~ DUSUN~ 016    016  
#> # ... with 3,717 more rows, and 211 more variables: STATUS_DOK <chr>, USERNAME <chr>, NAMA <chr>, B1_R9 <chr>,
#>#   B1_R10 <dbl>, B1_R11 <dbl+lbl>, B2_R1 <dbl>, B2_R2 <dbl>, B4_K1 <dbl>, B4_K2 <chr>, B4_K3 <dbl+lbl>,
#> #   B4_K4 <dbl+lbl>, B4_K5_BL <dbl>, B4_K5_TH <dbl>, B4_K6 <dbl>, B4_K7 <dbl+lbl>, B4_K8 <dbl+lbl>, B5_RINFO <dbl>,
#> #   B5_RNAMA <chr>, B5_R1A <dbl+lbl>, B5_R1B0 <dbl>, B5_R1B <dbl>, B5_R1BB <dbl+lbl>, B5_R1C <dbl+lbl>,
#> #   B5_R1D <dbl+lbl>, B5_R1E <dbl+lbl>, B5_R2A <dbl+lbl>, B5_R2B <dbl>, B5_R2BB <dbl+lbl>, B5_R3A <dbl+lbl>,
#> #   B5_R3B <dbl>, B5_R3BB <dbl+lbl>, B5_R4A <dbl+lbl>, B5_R4B <dbl+lbl>, B5_R4C <dbl+lbl>, B5_R4D <dbl+lbl>,
#> #   B5_R4E <dbl+lbl>, B5_R4F <dbl+lbl>, B5_R5A1 <dbl+lbl>, B5_R5A2 <dbl+lbl>, B5_R5A3 <dbl+lbl>, B5_R5A4 <dbl+lbl>,
#> #   B5_R5B <dbl+lbl>, B5_R6 <dbl+lbl>, B5_R7A <dbl+lbl>, B5_R7B <dbl+lbl>, B5_R8 <dbl+lbl>, B5_R9 <dbl+lbl>,
#> #   B5_R10 <dbl+lbl>, B5_R11 <dbl+lbl>, B5_R12 <dbl+lbl>, B5_R13A <dbl+lbl>, B5_R13B <dbl+lbl>, B5_R13C <dbl+lbl>,
#> #   B5_R13D <dbl+lbl>, B5_R14 <dbl+lbl>, B5_R131 <dbl>, B5_R132 <dbl>, B5_R133 <dbl>, B5_R134 <dbl>, B5_R135 <dbl>,
#> #   B5_R136 <dbl>, B5_R137 <dbl>, B5_R138 <dbl>, B5_R139 <dbl>, B5_R15A <dbl+lbl>, B5_R15B <dbl+lbl>, B5_R16A <dbl+lbl>,
#> #   B5_R16B <dbl+lbl>, B5_R17 <dbl>, B5_R18 <dbl+lbl>, B5_R19A <dbl+lbl>, B5_R19B <dbl+lbl>, B5_R19C <dbl+lbl>,
#> #   B5_R19D <dbl+lbl>, B5_R19E <dbl+lbl>, B5_R19F <dbl+lbl>, B5_R19G <dbl+lbl>, B5_R19H <dbl+lbl>, B5_R19I <dbl+lbl>,
#> #   B5_R20A <dbl+lbl>, B5_R20B <dbl+lbl>, B5_R21A <dbl+lbl>, B5_R21B <dbl+lbl>, B5_R22 <dbl+lbl>, B5_R221 <dbl>,
#> #   B5_R222 <dbl>, B5_R223 <dbl>, B5_R224 <dbl>, B5_R23 <dbl+lbl>, B5_R24 <dbl+lbl>, B5_R25A <dbl+lbl>, B5_R25A1 <dbl>,
#> #   B5_R25A2I <dbl>, B5_R25A2II <dbl>, B5_R25B <dbl>, B5_R26A1 <dbl>, B5_R26A2 <dbl>, B5_R26A3 <dbl>, B5_R26A4 <dbl>,
#> #   ...

#> Buat filter untuk memilih sampel acak dari provinsi ACEH atau SUMATERA BARAT dengan klasifikasi Perkotaan 
my_filter <- create_filter(NAMA_PROV == "ACEH" | NAMA_PROV == "SUMATERA BARAT", KLASIFIKASI == 1)

#> Memilih sampel acak dari filter yang telah dibuat
sakernas_dummy <- imputation_sample(x = sakernas_dummy, filters = my_filter, weight_aggregate = 45000, weight_col = Weight_R, iter = 10, flag = "aceh_sumbar_1")

#> Mengubah kategori sampel terpilih menjadi "Mencari Pekerjaan" dan jenis kegiatan menjadi "Mempersiapkan Usaha"
sakernas_dummy <- mutate_sample(x = sakernas_dummy, flag = "aceh_sumbar_1", kategori = 1, jenisKegiatan = 2)
```
## Bantuan
Apabila ditemukan bug atau masalah lainnya, silakan kontak 14.8261@stis.ac.id

