set enable_seqscan to on;

explain analyze
select * from reports join teams on reports.team_id = teams.id
where to_tsvector('english', report) @@ to_tsquery('english', 'movie');
-- "Gather  (cost=181063.00..14040388.54 rows=475000 width=1156) (actual time=1343573.144..2016876.453 rows=21573800 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Hash Join  (cost=180063.00..13991888.54 rows=197917 width=1156) (actual time=1343189.717..1768784.839 rows=7191267 loops=3)"
-- "        Hash Cond: (reports.team_id = teams.id)"
-- "        ->  Parallel Seq Scan on reports  (cost=0.00..13750554.00 rows=197917 width=247) (actual time=61.050..1307743.811 rows=7191267 loops=3)"
-- "              Filter: (to_tsvector('english'::regconfig, report) @@ '''movi'''::tsquery)"
-- "              Rows Removed by Filter: 24475400"
-- "        ->  Parallel Hash  (cost=127246.67..127246.67 rows=416667 width=909) (actual time=27394.401..27394.403 rows=333334 loops=3)"
-- "              Buckets: 8192  Batches: 256  Memory Usage: 3936kB"
-- "              ->  Parallel Seq Scan on teams  (cost=0.00..127246.67 rows=416667 width=909) (actual time=0.009..24950.219 rows=333334 loops=3)"
-- "Planning Time: 568.211 ms"
-- "JIT:"
-- "  Functions: 36"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
-- "  Timing: Generation 5.776 ms, Inlining 993.925 ms, Optimization 746.799 ms, Emission 481.677 ms, Total 2228.177 ms"
-- "Execution Time: 2019630.128 ms"


create index full_text_index on reports using gin(to_tsvector('english', report));
-- Query returned successfully in 1 hr 20 min.

explain analyze
select * from reports join teams on reports.team_id = teams.id
where to_tsvector('english', report) @@ to_tsquery('english', 'movie');

-- "Gather  (cost=185456.25..11212166.94 rows=475000 width=1156) (actual time=1668395.668..2402000.308 rows=21573800 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Hash Join  (cost=184456.25..11163666.94 rows=197917 width=1156) (actual time=1664829.250..2123705.483 rows=7191267 loops=3)"
-- "        Hash Cond: (reports.team_id = teams.id)"
-- "        ->  Parallel Bitmap Heap Scan on reports  (cost=4393.25..10922332.41 rows=197917 width=247) (actual time=2794.645..1578897.753 rows=7191267 loops=3)"
-- "              Recheck Cond: (to_tsvector('english'::regconfig, report) @@ '''movi'''::tsquery)"
-- "              Rows Removed by Index Recheck: 24239602"
-- "              Heap Blocks: exact=9725 lossy=1090333"
-- "              ->  Bitmap Index Scan on full_text_index  (cost=0.00..4274.50 rows=475000 width=0) (actual time=2493.495..2493.497 rows=21573800 loops=1)"
-- "                    Index Cond: (to_tsvector('english'::regconfig, report) @@ '''movi'''::tsquery)"
-- "        ->  Parallel Hash  (cost=127246.67..127246.67 rows=416667 width=909) (actual time=77368.627..77368.629 rows=333334 loops=3)"
-- "              Buckets: 8192  Batches: 256  Memory Usage: 3936kB"
-- "              ->  Parallel Seq Scan on teams  (cost=0.00..127246.67 rows=416667 width=909) (actual time=10.708..72937.956 rows=333334 loops=3)"
-- "Planning Time: 307.943 ms"
-- "JIT:"
-- "  Functions: 36"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
-- "  Timing: Generation 431.556 ms, Inlining 1188.694 ms, Optimization 3302.974 ms, Emission 1702.663 ms, Total 6625.887 ms"
-- "Execution Time: 2404597.896 ms"