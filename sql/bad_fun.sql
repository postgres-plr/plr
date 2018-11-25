-- should error out but should not crash PG
CREATE OR REPLACE
FUNCTION r_bad_fun()
RETURNS int4 AS
$BODY$
  deadbeef <- function(,bad) {}
  42
$BODY$
LANGUAGE plr;

SELECT r_bad_fun();
