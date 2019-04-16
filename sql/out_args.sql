-- this is non-SRF returning record
--create or replace function out_float8(out x float8, in a float8, out y float8[]) as $$
create or replace function out_float8(out x anyelement, in a anyelement, out y anyarray) as $$
  list(a, rep(a, 3))
$$ language plr;
select * from out_float8(42.5); -- NUMERICOID
select * from out_float8(42.5::float8);
select * from out_float8(42.5::int2);

-- SRF
create or replace function out__float8(out x float8, in a float8[], out y float8) returns setof record as $$
  data.frame(a, a*2)
$$ language plr;
select * from out__float8(ARRAY[123,NULL,42.5]);

-- window function can't return setof
create or replace function out_fun_win(out x2 float8, in a float8, out p2 float8) AS $$
  list(x=a*2, y=a+2)
$$ window language plr;

select s, bar.*
from (
  select s, row_to_json(out_fun_win(s) over ()) j
    from generate_series(1,2) s
) foo
, lateral json_to_record(j) as bar(x2 float8, p2 float8);
