import csv
import random
from typing import Any, List

import pandas as pd

import config


def generate_teams_csv(config: Any) -> None:
    with open('teams.csv', 'w') as f:
        csvwriter = csv.writer(f, delimiter='|')
        for _ in range(1_000_000):
            name = random.choice(config.TEAM_NAMES)
            additional_info = {
                "university": random.choice(config.UNIVERSITIES),
                "city": random.choice(config.CITIES),
                "country": "Россия",
                "max_win_number": random.randint(0, config.MAX_WIN_NUMBER)
            }

            active_players = {}
            for _ in range(random.randint(4, 5)):
                team_time = random.randint(1, config.MAX_YEARS_IN_TEAM)
                total_time = random.randint(team_time, config.MAX_TOTAL_TIME)
                active_players[random.choice(config.PLAYERS_NAMES)] = {
                    "salary": random.randint(config.MIN_PLAYER_SALARY, config.MAX_PLAYER_SALARY),
                    "time_in_team": team_time,
                    "total_time": total_time
                }

            sponsors_list = random.choices(config.SPONSORS, k=3)
            sponsors = '{' + f'{sponsors_list[0]}, {sponsors_list[1]}, {sponsors_list[2]}' + '}'

            team_revenue = random.randint(
                random.randint(100_000, config.MAX_SPONSORS_REVENUE),
                config.MAX_TEAM_REVENUE
            )
            financial_reports = {
                "total_revenue": team_revenue,
                "total_expenses": random.randint(team_revenue // 2, team_revenue)
            }
            csvwriter.writerow([
                name,
                additional_info,
                active_players,
                sponsors,
                financial_reports,
            ])


def generate_games_csv(config: Any) -> None:
    with open('games.csv', 'w') as f:
        csvwriter = csv.writer(f, delimiter='|')
        for _ in range(1_000_000):
            name = random.choice(config.GAMES_NAMES)

            statistics = {
                "total_tickets_number": random.randint(config.MAX_TICKET_NUMBER // 2, config.MAX_TICKET_NUMBER),
                "total_game_revenue": random.randint(config.MAX_GAME_REVENUE // 2, config.MAX_GAME_REVENUE),
                "total_tv_viewers_number": random.randint(config.MAX_TV_VIEWERS // 2, config.MAX_TV_VIEWERS)
            }
            stages = {
                "Отборочный": {
                    "max_points": random.choice(config.FIRST_STAGE_MAX_POINTS),
                    "winners_number": random.randint(10, 20),
                },
                "Основной": {
                    "max_points": random.choice(config.SECOND_STAGE_MAX_POINTS),
                    "winners_number": random.randint(5, 9),
                },
                "Заключительный": {
                    "max_points": random.choice(config.THIRD_STAGE_MAX_POINTS),
                    "winners_number": 1,
                },
            }
            teams_list = random.choices(config.TEAM_NAMES, k=3)
            teams = {
                "winner": random.choice(config.TEAM_NAMES),
                "participants": '{' + f'{teams_list[0]}, {teams_list[1]}, {teams_list[2]}' + '}'
            }
            sponsors_list = random.choices(config.SPONSORS, k=3)
            sponsors = '{' + f'{sponsors_list[0]}, {sponsors_list[1]}, {sponsors_list[2]}' + '}'

            players_list = random.choices(config.PLAYERS_NAMES, k=3)
            best_players = '{' + f'{players_list[0]}, {players_list[1]}, {players_list[2]}' + '}'

            league = {
                "name": random.choice(config.LEAGUE_NAMES),
                "rank": random.choice(config.LEAGUE_RANK_TYPES)
            }
            csvwriter.writerow([
                name,
                statistics,
                stages,
                teams,
                sponsors,
                best_players,
                league,
            ])


def generate_reports_csv(config: Any, reports: List) -> None:
    with open('reports.csv', 'w') as f:
        csvwriter = csv.writer(f, delimiter='|')
        for i in range(1, 10_001):
            for j in range(1, 10_001):
                team_id = i
                game_id = j
                report = random.choice(reports)[:50].replace('|', '')
                journalistic_score = round(random.uniform(0, config.MAX_JOURNALISTIC_SCORE), 1)
                viewers_score = round(random.uniform(0, config.MAX_VIEWERS_SCORE), 1)
                team_info = {
                    "name": random.choice(config.TEAM_NAMES),
                    "place": random.randint(2, 4)
                }
                game_info = {
                    "name": random.choice(config.GAMES_NAMES),
                    "rating": random.randint(1, 10)
                }
                csvwriter.writerow([
                    team_id,
                    game_id,
                    report,
                    journalistic_score,
                    viewers_score,
                    team_info,
                    game_info
                ])

def edit_csv(filename: str) -> None:
    s = []
    with open(filename, 'r') as f:
        for line in f:
            s.append(line)

    with open(filename, 'w') as f:
        for line in s:
            f.write(line.replace("'", '"'))


def main() -> None:
    reviews = pd.read_csv('IMDB_Dataset.csv')['review'].values

    generate_teams_csv(config)
    generate_games_csv(config)
    generate_reports_csv(config, reviews)
    edit_csv('/home/andrew/db_prak/lab_3_1/teams.csv')
    edit_csv('/home/andrew/db_prak/lab_3_1/games.csv')
    edit_csv('/home/andrew/db_prak/lab_3_1/reports.csv')

if __name__ == '__main__':
    main()
