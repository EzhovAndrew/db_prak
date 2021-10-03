select aft.aircraft_code,
	   sum(total_amount) as aircraft_amount,
	   count(flt.flight_id) as flights_count
from aircrafts as aft
join flights as flt on flt.aircraft_code = aft.aircraft_code
join ticket_flights as tck_flt on tck_flt.flight_id = flt.flight_id
join tickets as tck on tck.ticket_no = tck_flt.ticket_no
join bookings as bks on bks.book_ref = tck.book_ref
where aft.range > 1000
group by aft.aircraft_code
order by aircraft_amount desc