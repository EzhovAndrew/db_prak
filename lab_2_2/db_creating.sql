drop schema if exists main cascade;
drop schema if exists public cascade;
create schema main;
set search_path to main;
create type rank_type as enum('low', 'mid', 'high');

create table Countries(
	id serial primary key check (id > 0),
	name varchar(45) not null,
	unique(name)
);
create table Cities(
	id serial primary key check (id > 0),
	name varchar(45) not null,
	country_id integer check (country_id > 0) references Countries on delete set null,
	residents_number integer not null check (residents_number > 0)
);
create table Universities(
	id serial primary key check (id > 0),
	name varchar(45) not null,
	city_id integer check (city_id > 0) references Cities on delete set null,
	students_number integer check (students_number > 0)
);
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
	id serial primary key,
	name varchar(45) not null,
	university_id integer not null references Universities on delete restrict,
	slogan text,
	is_active boolean not null
);
create table Students(
	id serial primary key,
	first_name varchar(45) not null,
	last_name varchar(45) not null,
	email varchar(200) not null,
	phone varchar(11),
	is_leader boolean not null
);
create table TeamsStudents(
	team_id integer not null references Teams on delete cascade,
	student_id integer not null references Students on delete cascade,
	primary key (team_id, student_id)
);
create table Games(
	id serial primary key check (id > 0),
	name varchar(45) not null,
	league_id integer not null check (league_id > 0) references Leagues on delete restrict,
	city_id integer not null check (city_id > 0) references Cities on delete restrict,
	viewers_number integer
);
create table GamesStages(
	game_id integer not null check (game_id > 0) references Games,
	stage_id integer not null check (stage_id > 0) references Stages,
	max_score smallint not null check (max_score > 0),
	date timestamp not null,
	ticket_price numeric(7, 2) not null check (ticket_price > 0),
	primary key (game_id, stage_id)
);
create table Results(
	id serial primary key,
	team_id integer not null references Teams on delete restrict,
	game_id integer not null check (game_id > 0),
	stage_id integer not null check (game_id > 0),
	score smallint check (score > 0),
	place smallint check (place > 0),
	is_next_stage_participant boolean,
	unique(team_id, game_id, stage_id),
	foreign key (game_id, stage_id) references GamesStages (game_id, stage_id) on delete restrict
);

insert into countries (name) values
('Россия'),
('Украина'),
('Литва'),
('Латвия'),
('Эстония'),
('Белоруссия'),
('Грузия'),
('Казахстан'),
('Туркменистан'),
('Узбекистан'),
('Азербайджан'),
('Армения'),
('Молдавия'),
('Нигерия'),
('Ангола'),
('ЦАР'),
('Эфиопия'),
('Судан'),
('Киргизия'),
('Израиль');

insert into Cities (name, country_id, residents_number) values
('Москва', 1, 12655050),
('Санкт-Петербург', 1, 5384342),
('Казань', 1, 1257341),
('Вильнюс', 3, 588410),
('Рига', 4, 614618),
('Ташкент', 10, 2571668),
('Ереван', 12, 1075800),
('Аддис-Абеба', 17, 3041002),
('Нижний Новгород', 1, 1244254),
('Екатеринбург', 1, 1495066),
('Новосибирск', 1, 1620162),
('Оренбург', 1, 572819),
('Тбилиси', 7, 1154314),
('Минск', 6, 2009786),
('Киев', 2, 2963199),
('Днепропетровск', 2, 980948),
('Нурсултан', 8, 1184469),
('Владивосток', 1, 600871),
('Могилев', 6, 357100),
('Кишинев', 13, 639000);

insert into Universities (name, city_id, students_number) values
('МГУ', 1, 40000),
('ВШЭ', 1, 30000),
('ННГУ', 9, 15000),
('БГУ', 14, 25000),
('СПбГУ', 2, 30000),
('КПИ', 15, 27000),
('МАИ', 1, 12000),
('УрФУ', 10, 17000),
('ОГУ', 12, 7000),
('НГУ', 11, 16000),
('ЛУ', 5, 28000),
('ВУ', 4, 24000),
('Jethro Leadership & Management Institute', 8, 13000),
('ДВГУ', 18, 20000),
('КБТУ', 17, 30000);

insert into Teams (name, university_id, slogan, is_active) values
('Лунные волки', 1, 'Быть первым!', false),
('Несущие слово', 2, 'С нами Бог', false),
('Черные храмовники', 3, 'Без пощады, без сожалений, без страха!', true),
('Ультрамарины', 4, 'Любим книги, суп и все синее', true),
('Колобок повесился', 5, 'Юмор - наше призвание', true),
('Буратино утонул', 6, 'si vis pacem para bellus', true),
('Геральт из Ливии', 7, 'Одолеем любую заразу!', true),
('Саламандры', 8, 'Рождены в пламени!', true),
('Фримены', 9, 'Свобода, сплочение, общность', true),
('Адептус программус', 10, 'Всегда рады поработать со священными текстами духов машин!', true),
('Короли подземелий', 11, 'Докопаемся до любой сути', true),
('Ангелы гор', 12, 'взлетаем выше Эвереста', true);

insert into Students(first_name, last_name, email, phone, is_leader) values
('Артем', 'Самосборов', 'samosbor@gmail.com', '74955744187', false),
('Андрей', 'Рублев', 'rubkart@gmail.com', '74951728807', false),
('Александр', 'Белый', 'belsan@gmail.com', '74959175701', false),
('Виктор', 'Цой', 'zhiv@gmail.com', null, true),
('Карен', 'Шахназаров', 'kshah@gmail.com', '74958957503', false),
('Торнике', 'Квитатиани', 'tokoroko@gmail.com', '74958849614', true),
('Гурни', 'Халек', 'gurni@gmail.com', '74959667743', true),
('Лето', 'Атрейдес', 'atreides@gmail.com', '74955013136', true),
('Соломон', 'Игнатов', 'solign@gmail.com', null, true),
('Платон', 'Павлов', 'platonpavlov@gmail.com', '74952177208', false),
('Борис', 'Харитонов', 'boriskharitonov@gmail.com', '74958205454', true),
('Степан', 'Лапин', 'stepanlapin@gmail.com', '74951018445', false),
('Лукьян', 'Королев', 'korol@gmail.com', null, false),
('Ефим', 'Новиков', 'novikov2000@gmail.com', '74954069254', false),
('Овидий', 'Горшков', 'bestmanever@gmail.com', '74953945648', false),
('Наум', 'Лобанов', 'iamaliveguys@gmail.com', '74951939582', false),
('Модест', 'Зуев', 'modestzuev@gmail.com', null, false),
('Михаил', 'Зубенко', 'nukaktamsdengami@gmail.com', '74958854241', false),
('Алексей', 'Никитенко', 'matan@gmail.com', null, false),
('Мартин', 'Иден', 'martiniden@gmail.com', null, false);

insert into TeamsStudents(team_id, student_id) values
(1, 2),
(2, 1),
(3, 4),
(4, 3),
(5, 6),
(6, 5),
(1, 8),
(2, 7),
(3, 10),
(4, 9),
(5, 12),
(6, 11),
(1, 14),
(2, 13),
(3, 16),
(4, 15),
(5, 18),
(6, 17),
(1, 20),
(2, 19);

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

insert into Games(name, league_id, city_id, viewers_number) values
('Жизнь прекрасна!', 1, 2, null),
('В здоровом теле - здоровый юмор!', 2, 1, 479666),
('Декабрьский позитив!', 5, 1, 744289),
('Молодо-зелено', 6, 9, 181906),
('Здравствуйте, я ваша тетя', 7, 4, null),
('Юмор согревает', 5, 15, 185707),
('Летняя сказка', 3, 9, 615451),
('Старичок боровичок', 7, 8, null),
('Кому на Руси жить хорошо', 14, 1, 508266),
('Солнце в ладонях', 13, 7, 291479),
('Выйду ночью в поле с конем...', 12, 20, 310942),
('Веселье и любовь', 3, 9, 50260),
('Приключения кивина', 11, 12, 110717),
('Уральские мастера', 11, 10, 97042),
('Видимо невидимо', 9, 12, null),
('Дорога домой', 1, 1, 753980),
('Родные берега', 2, 3, 321628),
('Белый теплоход', 7, 1, null),
('Подзарядись!', 10, 18, null),
('Выше крыши', 3, 7, null);

insert into GamesStages(game_id, stage_id, max_score, date, ticket_price) values
(1, 1, 40, '2002-09-14 17:00:00', 1500),
(2, 1, 20, '2013-06-02 18:00:00', 1000),
(3, 1, 20, '2018-12-07 18:00:00', 1000),
(4, 1, 20, '2010-03-05 17:00:00', 1000),
(5, 1, 20, '2003-07-12 17:00:00', 1000),
(6, 1, 20, '2020-11-23 19:00:00', 1000),
(7, 1, 20, '2005-06-22 17:00:00', 1000),
(8, 1, 20, '2012-04-08 17:00:00', 1000),
(1, 2, 100, '2002-09-21 17:00:00', 3000),
(2, 2, 80, '2013-06-09 18:00:00', 2000),
(3, 2, 80, '2018-12-14 18:00:00', 2000),
(4, 2, 80, '2010-03-12 17:00:00', 2000),
(5, 2, 80, '2003-07-19 17:00:00', 2000),
(6, 2, 80, '2020-11-30 19:00:00', 2000),
(7, 2, 80, '2005-06-29 17:00:00', 2000),
(8, 2, 80, '2012-04-15 17:00:00', 2000),
(1, 3, 200, '2002-09-28 17:00:00', 6000),
(2, 3, 150, '2013-06-16 18:00:00', 4000),
(3, 3, 150, '2018-12-21 18:00:00', 4000),
(4, 3, 150, '2010-03-19 17:00:00', 4000);

insert into Results(team_id, game_id, stage_id, score, place, is_next_stage_participant) values
(1, 1, 1, 40, 1, true),
(2, 2, 1, 20, 1, true),
(3, 2, 1, 19, 2, true),
(7, 1, 2, 15, 11, false),
(8, 4, 3, 150, 1, false),
(9, 8, 1, 1, 8, false),
(1, 1, 2, 60, 4, false),
(2, 2, 2, 80, 1, true),
(3, 2, 2, 80, 2, true),
(7, 1, 1, 30, 3, true),
(9, 4, 1, 3, 10, false),
(8, 4, 1, 20, 1, true),
(1, 2, 1, 2, 9, false),
(2, 2, 3, 100, 2, false),
(3, 2, 3, 150, 1, false),
(7, 6, 1, 1, 14, false),
(8, 4, 2, 80, 1, true),
(9, 1, 1, 5, 11, false),
(10, 1, 1, 35, 2, true),
(10, 1, 2, 2, 12, false);