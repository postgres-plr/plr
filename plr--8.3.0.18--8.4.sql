CREATE OR REPLACE FUNCTION r_typenames()
RETURNS SETOF r_typename AS '
  within(data.frame(
    typename = ls(name = .GlobalEnv, pat = "OID"),
    stringsAsFactors = FALSE
  ),
  {
    typeoid <- sapply(typename, get)
  })
' language 'plr';
