set search_path to main;

update students
set phone = concat(8, substring(phone from 2))
where id in (
	select s.id from students as s
	join teamsstudents as ts on ts.student_id = s.id
	join teams as t on ts.team_id = t.id
	join universities as u on t.university_id = u.id
	join cities as c on u.city_id = c.id
	join countries as ct on c.country_id = ct.id
	where ct.name = 'Россия'
) and phone is not null
returning first_name, last_name, phone