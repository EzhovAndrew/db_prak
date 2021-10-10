begin transaction isolation level repeatable read;
	insert into results (team_id, game_id, stage_id, score)
	values (2, 1, 1, 10);
commit;

select * from results where team_id = 2;