set search_path to main;

select s.id, s.first_name, s.last_name, count(distinct game_id) as game_number_participant
from students as s
join teamsstudents as ts on ts.student_id = s.id
join teams as t on t.id = ts.team_id
join results as r on r.team_id = t.id
where s.is_leader = true
group by s.id
order by game_number_participant desc