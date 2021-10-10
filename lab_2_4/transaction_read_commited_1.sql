begin transaction isolation level read committed;
	select score from results where team_id = 2;
	select pg_sleep(10);
	select sum(score) from results where team_id = 2;
commit;