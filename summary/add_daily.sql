\set ON_ERROR_STOP 1
BEGIN;
set search_path=summary,public;

create table daily:r ( CHECK ( y = :r ) ) INHERITS (summary.daily);

END;