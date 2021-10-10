set search_path to main;

select distinct t.name,
	c1.name as hometown,
	s.first_name as leader_first_name,
	s.last_name as leader_last_name
from teams as t
join teamsstudents as ts on ts.team_id = t.id
join students as s on s.id  = ts.student_id
join universities as u on u.id = t.university_id
join cities as c1 on c1.id = u.city_id
join results as r on r.team_id = t.id
join gamesstages as gs on (r.game_id = gs.game_id and r.stage_id = gs.stage_id)
join games as g on g.id = gs.game_id
join cities as c2 on c2.id = g.city_id
where s.is_leader = true and c1.name = c2.name
