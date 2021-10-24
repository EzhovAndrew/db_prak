drop schema if exists main cascade;
drop schema if exists public cascade;
create schema main;
set search_path to main;


create table Teams(
	id serial primary key check(id > 0),
	name varchar(40) not null,
	additional_info jsonb not null,
	active_players jsonb not null,
	sponsors varchar(40)[] not null,
	financial_reports jsonb not null
);
create table Games(
	id serial primary key check(id > 0),
	name varchar(40) not null,
	statistics jsonb not null,
	stages jsonb not null,
	teams jsonb not null,
	sponsors varchar(40)[] not null,
	best_players varchar(40)[] not null,
	league jsonb not null
);
create table Reports(
	id serial primary key check(id > 0),
	team_id integer not null,
	game_id integer not null,
	report text not null,
	journalistic_score float not null,
	viewers_score float not null,
	team_info jsonb not null,
	game_info jsonb not null
);

copy teams(name, additional_info, active_players, sponsors, financial_reports)
from '/home/andrew/db_prak/lab_3_1/teams.csv' with (format text, delimiter '|');

copy games(name, statistics, stages, teams, sponsors, best_players, league)
from '/home/andrew/db_prak/lab_3_1/games.csv' with (format text, delimiter '|');

copy reports(team_id, game_id, report, journalistic_score, viewers_score, team_info, game_info)
from '/home/andrew/db_prak/lab_3_1/reports.csv' with (format text, delimiter '|')

alter table Reports add constraint team_fk foreign key (team_id) references Teams(id) on delete cascade;
alter table Reports add constraint game_fk foreign key (game_id) references Games(id) on delete cascade;