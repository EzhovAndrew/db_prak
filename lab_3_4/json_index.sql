set enable_seqscan to on;

drop index if exists json_team_index;

explain analyze
select * from reports
where team_info->>'name' = 'Кефир (команда КВН)';

-- "Gather  (cost=1000.00..4002179.00 rows=475000 width=247) (actual time=566.555..1331038.683 rows=1557362 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on reports  (cost=0.00..3953679.00 rows=197917 width=247) (actual time=356.392..1329786.467 rows=519121 loops=3)"
-- "        Filter: ((team_info ->> 'name'::text) = 'Кефир (команда КВН)'::text)"
-- "        Rows Removed by Filter: 31147546"
-- "Planning Time: 680.042 ms"
-- "JIT:"
-- "  Functions: 6"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
-- "  Timing: Generation 35.216 ms, Inlining 818.907 ms, Optimization 153.193 ms, Emission 20.080 ms, Total 1027.397 ms"
-- "Execution Time: 1331908.985 ms"


create index json_team_index on reports ((team_info->>'name'));
-- Query returned successfully in 41 min 23 secs.

explain analyze
select * from reports
where team_info->>'name' = 'Кефир (команда КВН)';
-- "Index Scan using json_team_index on reports  (cost=0.69..1797101.19 rows=475000 width=247) (actual time=91.913..1080738.723 rows=1557362 loops=1)"
-- "  Index Cond: ((team_info ->> 'name'::text) = 'Кефир (команда КВН)'::text)"
-- "Planning Time: 71.107 ms"
-- "JIT:"
-- "  Functions: 2"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
-- "  Timing: Generation 290.681 ms, Inlining 0.000 ms, Optimization 0.000 ms, Emission 0.000 ms, Total 290.681 ms"
-- "Execution Time: 1081922.182 ms"