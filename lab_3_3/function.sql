create or replace function get_info_about_mean_ticket_price_game(
	rank varchar(4),
	num_games integer,
	statistic_param varchar(40),
	help bool default false
) returns setof float as
$$
declare
	needed_games cursor is
		select * from games
		where league->>'rank' like rank
		order by statistics->>statistic_param desc
		limit num_games;
	counter integer = 0;
	sum_ integer = 0;
	mean float;
	std_dev float;
begin
	if help then
		raise notice 'This function calculates the mathematical expectation and standard \
			deviation for the average ticket price in games with certain parameters';
	end if;
	for game in needed_games loop
		sum_ = sum_ + (game.statistics->>'total_game_revenue')::integer / (game.statistics->>'total_tickets_number')::integer;
		counter = counter + 1;
	end loop;
	mean = sum_ / counter;
	return next mean;
	
	sum_ = 0;
	for game in needed_games loop
		sum_ = sum_ + power(
			(game.statistics->>'total_game_revenue')::integer / (game.statistics->>'total_tickets_number')::integer - mean, 2
		);
		counter = counter + 1;
	end loop;
	std_dev = round(power(sum_ / (counter - 1), 0.5), 2);
	return next std_dev;
	
	exception
		when sqlstate '42051' then
		begin
			raise notice 'Permission denied! Insufficient access rights.';
		end;
end;
$$
language plpgsql;

select get_info_about_mean_ticket_price_game('high', 100, 'total_game_revenue');