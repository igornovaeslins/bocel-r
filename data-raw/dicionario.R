# Gera data/dicionario.rda a partir do livro de códigos da v1.1, baixado de
# https://zenodo.org/records/23035176/files/LIVRO_DE_CODIGOS.csv
# Rodar da raiz do pacote: Rscript --vanilla data-raw/dicionario.R

dicionario <- read.csv("data-raw/LIVRO_DE_CODIGOS_v1.1.csv",
                       encoding = "UTF-8", stringsAsFactors = FALSE) |>
  tibble::as_tibble()

stopifnot(
  nrow(dicionario) == 371,
  !anyDuplicated(dicionario[c("arquivo", "variavel")])
)

save(dicionario, file = "data/dicionario.rda", compress = "xz")
