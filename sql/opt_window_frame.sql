create or replace function fast_win_frame(r int, t record) returns bool AS $$
  identical(parent.frame(), .GlobalEnv) && pg.throwerror('Parent env is global')
  exists('plr_window_frame', parent.frame(), inherits=FALSE) || pg.throwerror('No window frame data found')
  r == farg2[[prownum,2]][3]
$$ window language plr;
select s.r, s.p, fast_win_frame(NULLIF(r,4), (s.r, s.q)) over w
from (select r, r % 2 as p, array_fill(case when r=7 then 77 else r end, ARRAY[3]) as q from  generate_series(1,10) r) s
window w as (partition by p order by r rows between unbounded preceding and unbounded following)
order by s.r;