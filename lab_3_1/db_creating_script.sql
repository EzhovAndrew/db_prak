drop schema if exists main cascade;
drop schema if exists public cascade;
create schema main;
set search_path to main;
create type rank_type as enum('low', 'mid', 'high');


create table Leagues(
	id serial primary key check (id > 0),
	name varchar(45) not null,
	rank rank_type not null,
	foundation_date date
);
create table Stages(
	id serial primary key check (id > 0),
	name varchar(45) not null
);
create table Teams(
	id serial primary key check (id > 0),
	name varchar(20) not null,
	description text,
	is_active boolean not null,
	--- to reduce join costs
	addition_info jsonb not null
);
create table Students(
	id serial primary key check (id > 0),
	first_name varchar(20) not null,
	last_name varchar(20) not null,
	phone varchar(11)
);
create table TeamsStudents(
	team_id integer not null,
	student_id integer not null,
	primary key (team_id, student_id)
);
create table Games(
	id serial primary key check (id > 0),
	name varchar(40) not null,
	league_id integer not null check (league_id > 0),
	--- to have quick access for important information
	statistics jsonb not null
);
create table GamesStages(
	game_id integer not null check (game_id > 0),
	stage_id integer not null check (stage_id > 0),
	max_score smallint not null check (max_score > 0),
	date timestamp not null,
	ticket_price numeric(6, 2) not null check (ticket_price > 0),
	primary key (game_id, stage_id)
);
create table Results(
	id serial primary key check (id > 0),
	team_id integer not null,
	game_id integer not null check (game_id > 0),
	stage_id integer not null check (game_id > 0),
	score smallint check (score > 0),
	place smallint check (place > 0),
	is_next_stage_participant boolean,
	unique(team_id, game_id, stage_id)
);
create table PossibleTransfers(
	id serial primary key check (id > 0),
	team_from integer not null,
	team_to integer not null,
	player integer not null,
	cost integer not null,
	best_alternatives integer[],
	created date not null
);

insert into Leagues(name, rank, foundation_date) values
('Международная', 'high', '1990-04-05'),
('Всероссийская', 'high', '1994-06-12'),
('Кавказская', 'mid', '2003-10-04'),
('Европейская', 'high', null),
('Поволжская', 'mid', '2007-09-24'),
('Московская', 'mid', '1996-09-01'),
('Премьер-лига', 'high', '1998-12-02'),
('Детская', 'low', null),
('Старт', 'low', '2012-08-17'),
('Тихоокеанская', 'mid', '2010-03-13'),
('Уральская', 'mid', null),
('Содружество', 'low', '2005-07-16'),
('Восточная', 'mid', '2006-12-12'),
('Северная', 'mid', null);

insert into Stages(name) values
('Отборочный'),
('Основной'),
('Заключительный');

insert into Students (first_name, last_name, phone)
select 'Ivan', 'Ivanov', '89059192056'
from generate_series(1, 10000);

insert into Teams (name, description, is_active, addition_info)
select 'Колобок повесился', 'Si vis vincere, disce pati', true, '{"city": "Moscow", "university":"MSU", "country":"Russia"}'
from generate_series(1, 1000000);

insert into TeamsStudents (team_id, student_id)
select k, l from generate_series(1, 100) as k, generate_series(1, 100) as l;

insert into Games (name, league_id, statistics)
select 'В здоровом теле - здоровый дух!', l, '{"viewers_number": 50000, "team_winner": 1, "total_revenue": 10000000, "total_ticket_number": 2000}'
from generate_series(1, 100000), generate_series(1, 10) as l;

insert into GamesStages(game_id, stage_id, max_score, date, ticket_price)
select k, l, 100, '2021-03-01', 1000
from generate_series(1, 100) as k, generate_series(1, 3) as l;

insert into Results(team_id, game_id, stage_id, score, place, is_next_stage_participant)
select k, l, i, null, null, null
from generate_series(1, 100) as k, generate_series(1, 10) as l, generate_series(1, 3) as i;

insert into PossibleTransfers(team_from, team_to, player, cost, best_alternatives, created)
select k, l, i, 100000, '{1, 2, 3}', '2021-03-01'
from generate_series(1, 1000) as k, generate_series(1001, 2000) as l, generate_series(1, 100) as i;

alter table teamsstudents add constraint team_fk foreign key (team_id) references teams (id) on delete cascade;
alter table teamsstudents add constraint student_fk foreign key (student_id) references students (id) on delete cascade;
alter table games add constraint league_fk foreign key (league_id) references leagues (id) on delete restrict;
alter table gamesstages add constraint stage_fk foreign key (stage_id) references stages (id) on delete cascade;
alter table gamesstages add constraint game_fk foreign key (game_id) references games (id) on delete cascade;
alter table results add constraint gs_fk foreign key (game_id, stage_id) references GamesStages (game_id, stage_id) on delete restrict;
alter table results add constraint team_fk foreign key (team_id) references teams (id) on delete restrict;
alter table possibletransfers add constraint team_from_fk foreign key (team_from) references teams (id) on delete cascade;
alter table possibletransfers add constraint team_to_fk foreign key (team_to) references teams (id) on delete cascade;
alter table possibletransfers add constraint students_fk foreign key (player) references students (id) on delete cascade;