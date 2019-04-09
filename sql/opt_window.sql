create or replace function fast_win(a int4, b bigint) returns bool AS $$
  is.null(farg2) || pg.throwerror('Constants shall not be passes with the frame')
  identical(parent.frame(), .GlobalEnv) && pg.throwerror('Parent env is global')
  exists('plr_window_frame', parent.frame(), inherits=FALSE) || pg.throwerror('No window frame data found')
  a == farg1[prownum]
$$ window language plr;

select s, p, fast_win(NULLIF(s, 4), 123) over w
from (
  select s, s % 2 as p
  from generate_series(1,10) s
) foo
window w as (partition by p order by s rows between unbounded preceding and unbounded following)
order by s;
