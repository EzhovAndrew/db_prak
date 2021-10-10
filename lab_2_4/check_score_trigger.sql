drop trigger if exists check_score on results;

create or replace function check_score() returns trigger as $check_score$
	declare max_score smallint;
	begin
		if new.score is null then
			return new;
		end if;
		select gs.max_score from gamesstages as gs
		where game_id = new.game_id and stage_id = new.stage_id
		into max_score;
		
		if new.score > max_score then
			raise exception 'Score is too big!'
			using hint = 'Score can not exceed maximum score for this game and this stage, max score = ' || max_score;
		end if ;
		return new;
	end;
$check_score$ language plpgsql;

create trigger check_score before insert or update of score on results
	for each row execute function check_score();
	
	
insert into results(team_id, game_id, stage_id, score)
values (1, 1, 1, 10000);