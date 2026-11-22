#' Limpa o cache do BOCEL
#'
#' Apaga as tabelas que [bocel_ler()] guardou na pasta de cache do R. A
#' leitura seguinte de cada tabela volta a baixar o arquivo do Zenodo.
#'
#' @param versao Versão cujo cache será apagado. O padrão `NULL` apaga o
#'   cache de todas as versões.
#' @return O caminho da pasta apagada, de modo invisível.
#' @examples
#' \donttest{
#' bocel_limpar_cache()
#' }
#' @export
bocel_limpar_cache <- function(versao = NULL) {
  pasta <- tools::R_user_dir("bocel", "cache")
  if (!is.null(versao)) pasta <- file.path(pasta, versao)
  unlink(pasta, recursive = TRUE)
  invisible(pasta)
}
