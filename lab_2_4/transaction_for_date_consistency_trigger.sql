begin;
update gamesstages set date = '2050-01-01 17:00:00' where game_id = 6 and stage_id = 1;
--- update gamesstages set date = '2040-01-08 17:00:00' where game_id = 6 and stage_id = 2;
commit;