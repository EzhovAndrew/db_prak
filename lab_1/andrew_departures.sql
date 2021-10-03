select SUM(flights) as total_departures from (
	select passenger_name, count(flt.flight_id) as flights
	from tickets as tck
		join ticket_flights as tck_flt on tck.ticket_no = tck_flt.ticket_no
		join flights as flt on flt.flight_id = tck_flt.flight_id
		join airports as aps on aps.airport_code = flt.departure_airport
	where aps.city = 'Оренбург'
	group by passenger_name
	order by flights desc
) as passangers_flights
where passenger_name like '%ANDREY%' or passenger_name like '%EZHOV%'