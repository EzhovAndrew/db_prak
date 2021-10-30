reassign owned by test to postgres;
drop owned by test;
drop role if exists test;

reassign owned by top_games_manager to postgres;
drop owned by top_games_manager;
drop role if exists top_games_manager;

create user test;
grant all on database kvn_db_big to test;
grant usage on schema main to test;

grant select, update, insert on Games to test;
grant select(id, report, team_info, game_info), update(game_info) on Reports to test;
grant select on Teams to test;

create or replace view high_rank_leagues_games as
	select * from Games
	where league->>'rank' like '%high%'
with local check option;
create or replace view mid_rank_leagues_games as
	select * from Games
	where league->>'rank' like '%mid%'
with local check option;
create or replace view most_important_team_info as
	select name, (additional_info->>'max_win_number')::integer as max_win_number, active_players
	from Teams
with local check option;

grant select on most_important_team_info to test;

create role top_games_manager;
grant all on database kvn_db_big to top_games_manager;
grant usage on schema main to top_games_manager;
grant select, update(name, statistics, sponsors) on high_rank_leagues_games to top_games_manager;
grant top_games_manager to test;