DROP TRIGGER IF EXISTS CHECK_DATE_CONSISTENCY ON GAMESSTAGES;


CREATE OR REPLACE FUNCTION CHECK_DATE_CONSISTENCY() RETURNS TRIGGER AS $cdc$
	declare counter integer;
	begin
		with this_game_stages_info as (
			select date from gamesstages
			where game_id = new.game_id
			  and stage_id > new.stage_id
			  and date <= new.date
		)
		select count(*)::integer from this_game_stages_info into counter;
		if counter != 0 then
			raise exception 'The previous stage cannot be carried out after the next one';
		end if;
		return new;
	end;
$cdc$ LANGUAGE PLPGSQL;


CREATE CONSTRAINT TRIGGER CHECK_DATE_CONSISTENCY AFTER
INSERT
OR
UPDATE OF date ON GAMESSTAGES DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION CHECK_DATE_CONSISTENCY();