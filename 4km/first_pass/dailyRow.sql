set search_path="4km_y",public;

CREATE TABLE daily_$Y$ (
    CHECK ( y = $Y$ )
) INHERITS (daily);

create index daily_$Y$_xy on daily_$Y$(x,y);
create index daily_$Y$_x on daily_$Y$(x);
create index daily_$Y$_ymd on daily_$Y$(ymd);
create index daily_$Y$_year on daily_$Y$(year);
create index daily_$Y$_month on daily_$Y$(month);
