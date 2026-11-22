#' Versões publicadas do BOCEL
#'
#' Lista as versões do banco depositadas no Zenodo, com o registro e o DOI
#' de cada uma. Todas pertencem ao mesmo DOI de conceito,
#' 10.5281/zenodo.22896271, que aponta sempre para a mais recente.
#'
#' @return Um tibble com as colunas `versao`, `registro`, `data` e `doi`,
#'   da mais antiga para a mais recente.
#' @examples
#' bocel_versoes()
#' @export
bocel_versoes <- function() {
  # Versão nova do banco entra aqui, na última posição de cada vetor
  registro <- c(22896272L, 23035176L)
  tibble::tibble(
    versao = c("1.0", "1.1"),
    registro = registro,
    data = as.Date(c("2026-09-22", "2026-09-29")),
    doi = paste0("10.5281/zenodo.", registro)
  )
}
