\set ON_ERROR_STOP 1
BEGIN;
set search_path=:dailySchema,public;

create table daily:r ( CHECK ( y = :r ) ) INHERITS (:dailySchema.daily);

END;