create table if not exists reports_parted(
	id serial,
	team_id integer not null,
	game_id integer not null,
	report text not null,
	journalistic_score float not null,
	viewers_score float not null,
	team_info jsonb not null,
	game_info jsonb not null,
	primary key(id, journalistic_score)
) partition by range (journalistic_score);


create table if not exists reports_parted_1
partition of reports_parted for values from (0.0) to (3.0);

create table if not exists reports_parted_2
partition of reports_parted for values from (3.0) to (5.0);

create table if not exists reports_parted_3
partition of reports_parted for values from (5.0) to (7.0);

create table if not exists reports_parted_4
partition of reports_parted for values from (7.0) to (9.0);

create table if not exists reports_parted_5
partition of reports_parted for values from (9.0) to (10.1);

insert into reports_parted (id, team_id, game_id, report, journalistic_score, viewers_score, team_info, game_info)
	select * from reports limit 10000000;
	
select * from reports limit 10000000;
-- Successfully run. Total query runtime: 56 sec 72 msec .
	
explain analyze 
select * from reports_parted where journalistic_score > 9.5 and journalistic_score < 10.0;

-- "Gather  (cost=1000.00..50881.06 rows=9736 width=124) (actual time=29.145..13897.095 rows=400269 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on reports_parted_5  (cost=0.00..48907.46 rows=4057 width=124) (actual time=27.579..11381.898 rows=133423 loops=3)"
-- "        Filter: ((journalistic_score > '9.5'::double precision) AND (journalistic_score < '10'::double precision))"
-- "        Rows Removed by Filter: 216894"
-- "Planning Time: 281.760 ms"
-- "Execution Time: 13931.842 ms"