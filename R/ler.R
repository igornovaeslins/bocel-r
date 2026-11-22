#' Lê uma tabela do BOCEL
#'
#' Baixa a tabela do registro da versão pedida no Zenodo, guarda o arquivo
#' no cache do usuário e devolve a tabela com os tipos do livro de códigos
#' (inteiro, lógico e data). As demais colunas, e os identificadores, chegam
#' como texto, o que preserva os zeros à esquerda de CPF, título eleitoral
#' e códigos do TSE.
#'
#' @param tabela Nome da tabela, sem extensão. A lista está em
#'   [bocel_tabelas()].
#' @param versao Versão do banco, entre as de [bocel_versoes()]. O padrão
#'   é a mais recente. Fixar a versão no script mantém a análise
#'   reproduzível quando sair uma versão nova.
#' @param cache Se `TRUE`, guarda o arquivo na pasta de cache do R
#'   ([tools::R_user_dir()]) e o reaproveita nas leituras seguintes da mesma
#'   versão. Se `FALSE`, baixa a cada chamada.
#' @return Um tibble. Se o Zenodo não responder, a função avisa por
#'   mensagem e devolve `NULL`.
#' @examples
#' \donttest{
#' suplementares <- bocel_ler("eleicoes_suplementares", versao = "1.2",
#'                           cache = FALSE)
#' }
#' @export
bocel_ler <- function(tabela, versao = NULL, cache = TRUE) {
  versoes <- bocel_versoes()
  if (is.null(versao)) versao <- versoes$versao[nrow(versoes)]
  if (!versao %in% versoes$versao)
    stop("Vers\u00e3o '", versao, "' n\u00e3o existe. Veja bocel_versoes().")
  if (!tabela %in% bocel_tabelas()$tabela)
    stop("Tabela '", tabela, "' n\u00e3o existe. Veja bocel_tabelas().")
  arquivo <- file.path(tools::R_user_dir("bocel", "cache"), versao,
                       paste0(tabela, ".csv"))
  if (!cache) arquivo <- tempfile(fileext = ".csv")
  if (!file.exists(arquivo)) {
    url <- sprintf("https://zenodo.org/records/%s/files/%s.csv?download=1",
                   versoes$registro[versoes$versao == versao], tabela)
    dir.create(dirname(arquivo), recursive = TRUE, showWarnings = FALSE)
    # O limite de 60 segundos do R corta a tabela maior em conexão lenta
    antigo <- options(timeout = max(600, getOption("timeout")))
    on.exit(options(antigo), add = TRUE)
    baixou <- tryCatch(
      utils::download.file(url, arquivo, mode = "wb", quiet = TRUE) == 0,
      error = function(e) FALSE, warning = function(w) FALSE)
    if (!baixou) unlink(arquivo)
    if (!baixou) return(message("Falha ao baixar ", url, "."))
  }
  dados <- readr::read_csv(arquivo, col_types = readr::cols(.default = "c"),
                           progress = FALSE)
  tipos <- bocel::dicionario
  tipos <- tipos[tipos$arquivo == paste0(tabela, ".csv") &
                   tipos$variavel %in% names(dados), ]
  # CPF, título e sequencial do TSE passam do limite de inteiro do R
  tipos$tipo_armazenamento[grepl("cpf|titulo|^sq_", tipos$variavel)] <- "texto"
  for (v in tipos$variavel) {
    dados[[v]] <- switch(tipos$tipo_armazenamento[tipos$variavel == v],
      "inteiro" = as.integer(dados[[v]]),
      "logico" = as.logical(dados[[v]]),
      "data ISO" = as.Date(dados[[v]]),
      "data dd/mm/aaaa" = as.Date(dados[[v]], format = "%d/%m/%Y"),
      dados[[v]])
  }
  dados
}
