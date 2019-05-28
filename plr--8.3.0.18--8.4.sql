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

CREATE FUNCTION plr_inline_handler(internal)
RETURNS VOID
AS 'MODULE_PATHNAME' LANGUAGE C STRICT;

CREATE FUNCTION plr_validator(oid)
RETURNS VOID
AS 'MODULE_PATHNAME' LANGUAGE C STRICT;

CREATE OR REPLACE LANGUAGE plr
HANDLER plr_call_handler
INLINE plr_inline_handler
VALIDATOR plr_validator;
