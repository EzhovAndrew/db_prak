set search_path to main;

delete from teams
where university_id in (select id from universities where city_id in (select id from cities where name = 'Москва'))