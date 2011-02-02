\set ON_ERROR_STOP 1
BEGIN;
set search_path=cimis4km,public;

create table cimis:r ( CHECK ( y = :r ) ) INHERITS (cimis4km.cimis);

END;