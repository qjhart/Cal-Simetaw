\set ON_ERROR_STOP 1
BEGIN;
set search_path=prism4km,public;

create table prism:r ( CHECK ( y = :r ) ) INHERITS (prism4km.prism);

END;