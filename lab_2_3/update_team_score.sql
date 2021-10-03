set search_path to main;

update results
set score = score - 15
where team_id in (
	select t.id from teams as t
	join teamsstudents as ts on ts.team_id = t.id
	join students as s on s.id = ts.student_id
	where s.first_name = 'Лето' and s.last_name = 'Атрейдес'
)