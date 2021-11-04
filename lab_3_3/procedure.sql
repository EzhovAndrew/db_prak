create or replace procedure expected_salary_update(threshold_coef float, variadic arr integer[]) as
$$
declare
	needed_teams cursor is
		select * from teams
		where array_position(arr, id) is not null;
	salary_updating varchar(200);
	revenue_coef float;
	salary_coef float;
	player_name varchar(45);
	player_info jsonb;
	addition float;
	template varchar(40);
begin
	for team in needed_teams loop
		revenue_coef = (team.financial_reports->>'total_revenue')::float / (team.financial_reports->>'total_expenses')::float;
		if revenue_coef < threshold_coef then
			continue;
		end if;
		salary_coef = (revenue_coef - 1) / 2;
		
		for player_name, player_info in select * from jsonb_each(team.active_players) loop
			addition = round(salary_coef * (player_info->>'salary')::integer);
			template = format('{"salary_update": %s}', addition);
			player_info = player_info || template::jsonb;
			salary_updating = format('{"%s": %s}', player_name, player_info);
			update teams set active_players = active_players || salary_updating::jsonb
			where id = team.id;
		end loop;
	end loop;
	
	exception
		when sqlstate '42051' then
		begin
			raise notice 'Permission denied! Insufficient access rights.';
		end;
end;
$$
language plpgsql;

call expected_salary_update(1.1, 6, 7, 8, 9, 10);
select active_players from teams where id in (6, 7, 8, 9, 10);