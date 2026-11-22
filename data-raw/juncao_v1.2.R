# Confere as contagens da junção ocupações x pessoas citadas no README
pkgload::load_all(quiet = TRUE)
oc <- bocel_ler("ocupacoes", versao = "1.2")
pe <- bocel_ler("pessoas", versao = "1.2")
su <- bocel_ler("pessoas_suplentes", versao = "1.2")
fora <- !oc$id_pessoa %in% pe$id_pessoa
juntas <- oc |> dplyr::left_join(dplyr::bind_rows(pe, su), by = "id_pessoa")
res <- c(ocupacoes = nrow(oc), fora_pessoas = sum(fora),
         em_suplentes = sum(fora & oc$id_pessoa %in% su$id_pessoa),
         sem_cadastro = sum(fora & !oc$id_pessoa %in% su$id_pessoa),
         ids_comuns = length(intersect(pe$id_pessoa, su$id_pessoa)),
         linhas_juncao = nrow(juntas))
stopifnot(res["ids_comuns"] == 0, res["linhas_juncao"] == res["ocupacoes"])
print(res)
