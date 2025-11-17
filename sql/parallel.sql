CREATE TABLE my_table (my_column text);
INSERT INTO my_table (my_column) SELECT md5(generate_series(1, 1000000, 1)::text);
CREATE OR REPLACE FUNCTION my_value()
    RETURNS numeric
    LANGUAGE 'plr'
AS $BODY$
    return(1000)
$BODY$;
SELECT * FROM my_table WHERE my_column LIKE '%12345%' order by my_column;
