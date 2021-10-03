with airports_business_arrivals as (
	select airport_name, count(tck.ticket_no) as tickets
	from airports as aps
		join flights as flt on flt.arrival_airport = aps.airport_code
		join ticket_flights as tck_flt on flt.flight_id = tck_flt.flight_id
		join tickets as tck on tck.ticket_no = tck_flt.ticket_no
	where tck_flt.fare_conditions like '%Business%'
	group by airport_name
), top_business_airports_arrivals as (
	select * from airports_business_arrivals
	where tickets > (select AVG(tickets) from airports_business_arrivals)
)
select left(timezone, position('/' in timezone) - 1) as tmz,
	   count(city)
from airports
where airport_name in (select airport_name from top_business_airports_arrivals)
group by tmz