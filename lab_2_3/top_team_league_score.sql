set search_path to main;

with leagues_with_scores_and_teams as (
	select leagues.*, score, team_id from leagues
	join games on games.league_id = leagues.id
	join gamesstages on gamesstages.game_id = games.id
	join results on (results.game_id = gamesstages.game_id and results.stage_id = gamesstages.stage_id)
),
top_score_leagues_teams as (
	select name as league_name, team_id, sum(score) as league_team_score
	from leagues_with_scores_and_teams
	group by name, team_id
	order by league_team_score desc
	limit 3
)
select tsl.league_name, teams.name as team_name, tsl.league_team_score
from top_score_leagues_teams as tsl
join teams on teams.id = tsl.team_id
order by league_team_score desc
