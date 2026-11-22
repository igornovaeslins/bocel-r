test_that("versões têm registro e DOI únicos", {
  v <- bocel_versoes()
  expect_false(anyDuplicated(v$versao) > 0)
  expect_false(anyDuplicated(v$registro) > 0)
  expect_match(v$doi, "^10\\.5281/zenodo\\.[0-9]+$")
  expect_true(all(diff(v$data) > 0))
})

test_that("dicionário só usa tipos que bocel_ler() converte", {
  tipos <- c("texto", "inteiro", "logico", "data ISO", "data dd/mm/aaaa")
  expect_true(all(dicionario$tipo_armazenamento %in% tipos))
})

test_that("as cinco tabelas centrais estão listadas", {
  centrais <- c("pessoas", "mandatos", "ocupacoes", "filiacoes",
                "posicoes_ano")
  expect_true(all(centrais %in% bocel_tabelas()$tabela))
})

test_that("tabela ou versão inexistente para com mensagem clara", {
  expect_error(bocel_ler("prefeitos"), "bocel_tabelas")
  expect_error(bocel_ler("mandatos", versao = "9.9"), "bocel_versoes")
})

# Os testes abaixo baixam do Zenodo e ficam fora do CRAN
for (tabela in c("pessoas", "mandatos", "ocupacoes", "filiacoes",
                 "posicoes_ano", "pessoas_suplentes")) {
  test_that(paste(tabela, "chega inteira e sem NA criado na conversão"), {
    skip_on_cran()
    skip_if_offline("zenodo.org")
    dados <- bocel_ler(tabela, versao = "1.1")
    arquivo <- file.path(tools::R_user_dir("bocel", "cache"), "1.1",
                         paste0(tabela, ".csv"))
    bruto <- readr::read_csv(arquivo, col_types = readr::cols(.default = "c"),
                             progress = FALSE)
    dic <- dicionario[dicionario$arquivo == paste0(tabela, ".csv"), ]
    expect_equal(nrow(dados), dic$linhas[1])
    expect_setequal(names(dados), dic$variavel)
    expect_equal(colSums(is.na(dados)), colSums(is.na(bruto)))
    ids <- grep("cpf|titulo", names(dados), value = TRUE)
    for (id in ids) expect_identical(dados[[id]], bruto[[id]])
  })
}

test_that("segunda leitura usa o cache sem baixar de novo", {
  skip_on_cran()
  skip_if_offline("zenodo.org")
  bocel_ler("pessoas", versao = "1.1")
  arquivo <- file.path(tools::R_user_dir("bocel", "cache"), "1.1",
                       "pessoas.csv")
  antes <- file.mtime(arquivo)
  bocel_ler("pessoas", versao = "1.1")
  expect_equal(file.mtime(arquivo), antes)
})
