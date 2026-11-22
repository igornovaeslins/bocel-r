# Os testes baixam para uma pasta temporária, sem tocar no cache do usuário
Sys.setenv(R_USER_CACHE_DIR = file.path(tempdir(), "cache_bocel"))
