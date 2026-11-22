#' Tabelas do BOCEL
#'
#' Lista as tabelas que [bocel_ler()] aceita, com o número de variáveis e de
#' linhas registrado no livro de códigos da versão 1.2. As variáveis de
#' cada tabela, com descrição, tipo e fonte, estão em [dicionario].
#'
#' @return Um tibble com as colunas `tabela`, `variaveis` e `linhas`.
#' @examples
#' bocel_tabelas()
#' @export
bocel_tabelas <- function() {
  dic <- bocel::dicionario
  contagem <- table(dic$arquivo)
  tibble::tibble(
    tabela = sub("\\.csv$", "", names(contagem)),
    variaveis = as.integer(contagem),
    linhas = dic$linhas[match(names(contagem), dic$arquivo)]
  )
}
