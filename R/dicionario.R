#' Livro de códigos do BOCEL
#'
#' Uma linha por variável de cada tabela do banco, copiada do
#' `LIVRO_DE_CODIGOS.csv` da versão 1.2 depositada no Zenodo. O tipo de
#' armazenamento é o que [bocel_ler()] usa para converter as colunas. As
#' versões anteriores do banco têm as mesmas tabelas e tipos, e a 1.2
#' acrescentou `origem_partido_ocupante` e `sg_partido_candidatura` a
#' `ocupacoes.csv`.
#'
#' @format Um tibble com 373 linhas e 9 colunas.
#' \describe{
#'   \item{arquivo}{Tabela a que a variável pertence, com extensão.}
#'   \item{variavel}{Nome da coluna.}
#'   \item{descricao}{O que a coluna registra.}
#'   \item{tipo_armazenamento}{texto, inteiro, logico, data ISO ou
#'     data dd/mm/aaaa.}
#'   \item{nivel_medida}{Binario, Categorico, Data, Numerico ou Ordinal.}
#'   \item{fonte}{Origem da informação.}
#'   \item{preenchimento}{Proporção de linhas preenchidas.}
#'   \item{cobertura_temporal}{Anos cobertos pela variável.}
#'   \item{linhas}{Número de linhas da tabela.}
#' }
#' @source <https://doi.org/10.5281/zenodo.24432652>
#' @examples
#' subset(dicionario, arquivo == "mandatos.csv", c(variavel, descricao))
"dicionario"
