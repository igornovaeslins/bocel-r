## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Notes for the reviewer

* Function names and documentation are in Portuguese, the language of the
  intended users (Brazilian researchers). The DESCRIPTION declares
  `Language: pt-BR`.
* `bocel_ler()` downloads tables from Zenodo. Examples that download are
  wrapped in `\donttest{}` and use `cache = FALSE`, which writes only to
  `tempdir()`. Tests that download are skipped on CRAN. If Zenodo is
  unreachable, the function returns `NULL` with an informative message.
* The default cache lives in `tools::R_user_dir("bocel", "cache")`, and
  `bocel_limpar_cache()` removes it.
