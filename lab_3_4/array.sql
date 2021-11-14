set enable_seqscan to on;

drop index if exists gin_array_sponsors_index;

explain analyze
select * from teams
where sponsors = array['Лукойл', 'НЛМК', 'Новатэк']::varchar(40)[]

-- "Gather  (cost=1000.00..129312.63 rows=243 width=909) (actual time=595.479..19620.340 rows=255 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on teams  (cost=0.00..128288.33 rows=101 width=909) (actual time=959.158..19295.126 rows=85 loops=3)"
-- "        Filter: (sponsors = '{Лукойл,НЛМК,Новатэк}'::character varying(40)[])"
-- "        Rows Removed by Filter: 333249"
-- "Planning Time: 0.690 ms"
-- "JIT:"
-- "  Functions: 6"
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 3.750 ms, Inlining 0.000 ms, Optimization 336.745 ms, Emission 891.501 ms, Total 1231.996 ms"
-- "Execution Time: 21365.591 ms"


create index gin_array_sponsors_index on teams using gin(sponsors);
-- Query returned successfully in 4 secs 206 msec.

explain analyze
select * from teams
where sponsors = array['Лукойл', 'НЛМК', 'Новатэк']::varchar(40)[]

-- "Bitmap Heap Scan on teams  (cost=457.89..1400.53 rows=243 width=909) (actual time=33.643..44.214 rows=255 loops=1)"
-- "  Recheck Cond: (sponsors = '{Лукойл,НЛМК,Новатэк}'::character varying(40)[])"
-- "  Rows Removed by Index Recheck: 1175"
-- "  Heap Blocks: exact=1424"
-- "  ->  Bitmap Index Scan on gin_array_sponsors_index  (cost=0.00..457.83 rows=243 width=0) (actual time=33.437..33.438 rows=1430 loops=1)"
-- "        Index Cond: (sponsors = '{Лукойл,НЛМК,Новатэк}'::character varying(40)[])"
-- "Planning Time: 0.349 ms"
-- "Execution Time: 72.667 ms"