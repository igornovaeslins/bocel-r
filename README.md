# bocel

Pacote R de acesso ao Banco de Ocupação de Cargos Eletivos (BOCEL), depositado
no Zenodo sob o DOI de conceito
[10.5281/zenodo.22896271](https://doi.org/10.5281/zenodo.22896271). O pacote
baixa as tabelas do registro de cada versão, guarda os arquivos no cache do
usuário e devolve cada tabela com os tipos do livro de códigos.

## Instalação

```r
# install.packages("remotes")
remotes::install_github("igornovaeslins/bocel-r")
```

## Uso

```r
library(bocel)

bocel_versoes()   # versões publicadas, com registro e DOI
bocel_tabelas()   # tabelas disponíveis, com variáveis e linhas
dicionario        # livro de códigos, uma linha por variável

mandatos <- bocel_ler("mandatos", versao = "1.2")
```

A primeira leitura de cada tabela baixa o arquivo do Zenodo, e as seguintes
usam a cópia guardada em `tools::R_user_dir("bocel", "cache")`. Sem o
argumento `versao`, o pacote lê a versão mais recente, por isso o script de
uma análise deve fixar a versão para que o resultado se reproduza quando sair
uma versão nova do banco.

As colunas de CPF, título eleitoral e sequencial do TSE chegam como texto,
mesmo quando o livro de códigos as registra como inteiro, porque passam do
limite de inteiro do R e perderiam o zero à esquerda.

## Junção de ocupações e pessoas

Nas versões 1.1 e 1.2, 658 das 6.287 linhas de `ocupacoes` trazem um
`id_pessoa` que
não está em `pessoas`, quase todas de suplentes e vices que assumiram o cargo.
A tabela `pessoas_suplentes` cobre 513 dessas linhas, e as 145 restantes não
têm cadastro em nenhuma das duas tabelas. As duas tabelas não repetem
`id_pessoa`, e a junção completa empilha as duas antes de cruzar.

```r
ocupacoes <- bocel_ler("ocupacoes", versao = "1.2")
cadastro <- dplyr::bind_rows(
  bocel_ler("pessoas", versao = "1.2"),
  bocel_ler("pessoas_suplentes", versao = "1.2")
)

ocupacoes |>
  dplyr::left_join(cadastro, by = "id_pessoa")
```

## Citação

`citation("bocel")` devolve a referência do banco. Cite também o DOI da
versão usada, que `bocel_versoes()` informa.

## Contato

Igor Novaes Lins (CEBRAP), igornovaeslins@gmail.com e
igor.lins@cebrap.org.br. Erros e sugestões podem entrar também como
[issue](https://github.com/igornovaeslins/bocel-r/issues).

## Licença

O código do pacote é distribuído sob a licença MIT. Os dados do BOCEL são
distribuídos pelo Zenodo sob a licença CC BY 4.0.
