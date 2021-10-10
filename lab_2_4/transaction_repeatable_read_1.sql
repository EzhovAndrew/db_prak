begin transaction isolation level repeatable read;
	select score from results where team_id = 2;
	select pg_sleep(10);
	update results set score = score * 0.5 where team_id = 2;
	select sum(score) from results where team_id = 2;
commit;