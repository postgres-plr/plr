CREATE TABLE test1 (a int, b text);


CREATE PROCEDURE transaction_test1()
LANGUAGE plr
AS $$
for(i in 0:9){
  pg.spi.exec(paste("INSERT INTO test1 (a) VALUES (", i, ")"))
  if (i %% 2 == 0) {
    pg.spi.commit()
  } else {
    pg.spi.rollback()
  }
}
$$;

CALL transaction_test1();

SELECT * FROM test1;


TRUNCATE test1;
