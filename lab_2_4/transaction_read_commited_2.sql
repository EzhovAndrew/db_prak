begin transaction isolation level read committed;
	update results set score = 20 where team_id = 2 and game_id = 1;
commit;