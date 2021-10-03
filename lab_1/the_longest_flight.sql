with max_time as (
	select max(actual_arrival - actual_departure) as max_time
	from flights
	where status like 'Arrived'
)
select aps.city as departure_city,
	   aps_1.city as arrival_city,
	   to_char(actual_departure, 'DD.MM.YYYY HH24:MI:SS') as departure,
	   to_char(actual_arrival, 'DD.MM.YYYY HH24:MI:SS') as arrival
from flights as flt
join airports as aps on aps.airport_code = flt.departure_airport
join airports as aps_1 on aps_1.airport_code = flt.arrival_airport
where status like 'Arrived' and (actual_arrival - actual_departure) = (select max_time from max_time)