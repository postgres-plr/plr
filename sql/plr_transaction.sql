CREATE TABLE test1 (a int, b text);

CREATE OR REPLACE FUNCTION test_create_procedure_transaction() RETURNS void
  AS
$BODY$
  version_11plus  <- pg.spi.exec("SELECT current_setting('server_version_num')::integer >= 110000;")
  if(version_11plus[[1]])
  {
    pg.spi.exec("
      CREATE OR REPLACE PROCEDURE transaction_test1()
        AS
      $$
        for(i in 0:9){
          pg.spi.exec(paste('INSERT INTO test1 (a) VALUES (', i, ');'))
          if (i %% 2 == 0) {
            pg.spi.commit()
          } else {
            pg.spi.rollback()
          }
        }
      $$ LANGUAGE plr;
      ")
  }
  else
  {
    pg.spi.exec("INSERT INTO test1 (a) VALUES (0);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (2);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (4);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (6);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (8);")
  }
$BODY$
LANGUAGE plr;

SELECT test_create_procedure_transaction();

\o out.txt
SELECT current_setting('server_version_num')::integer server_version_num;
\o
\gset

\o out.txt
SELECT CASE WHEN :server_version_num >= 110000 THEN 'CALL transaction_test1();' ELSE '' END thecall;
\o
\gset

:thecall

SELECT * FROM test1;
