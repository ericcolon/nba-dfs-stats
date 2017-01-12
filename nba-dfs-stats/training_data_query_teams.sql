DROP TABLE IF EXISTS TrainingDataWithTeams;
CREATE TABLE TrainingDataWithTeams
SELECT t1.*,
IF(t1.HomeTeam = 1, home5.TeamRebounds5Game/away5.TeamRebounds5Game, away5.TeamRebounds5Game/home5.TeamRebounds5Game) AS ReboundRatio5Game,
IF(t1.HomeTeam = 1, away5.TeamBlocks5Game, home5.TeamBlocks5Game) AS OppBlocks5Game,
IF(t1.HomeTeam = 1, home5.TeamDefensiveRebounds5Game/away5.TeamOffensiveRebounds5Game, away5.TeamDefensiveRebounds5Game/home5.TeamOffensiveRebounds5Game) AS DefensiveReboundRatio,
IF(t1.HomeTeam = 1, home5.TeamOffensiveRebounds5Game/away5.TeamDefensiveRebounds5Game, away5.TeamOffensiveRebounds5Game/home5.TeamDefensiveRebounds5Game) AS OffensiveReboundRatio,
IF(t1.HomeTeam = 1, (away5.TeamShotsAttempted5Game - away5.TeamShotsMade5Game)*t1.FiveGameDefensiveRebounds, (home5.TeamShotsAttempted5Game - home5.TeamShotsMade5Game)*t1.FiveGameDefensiveRebounds) AS MissedShotsDefensiveRebounds,
IF(t1.HomeTeam = 1, away5.TeamShotsMade5Game, home5.TeamShotsMade5Game) AS OppShotsMade,
IF(t1.HomeTeam = 1, away5.TeamShotsMade5Game/away5.TeamShotsAttempted5Game, home5.TeamShotsMade5Game/home5.TeamShotsAttempted5Game) AS OppShotsPct,
IF(t1.HomeTeam = 1, home5.TeamPoints5Game, away5.TeamPoints5Game) AS TeamPoints,
IF(t1.HomeTeam = 1, away5.OppPoints5Game, home5.OppPoints5Game) AS OppPointsAllowed,
IF(t1.HomeTeam = 1, home5.TeamPoints5Game*away5.OppPoints5Game, away5.TeamPoints5Game*home5.OppPoints5Game) AS ExpectedPointTotal,
IF(t1.HomeTeam = 1, away5.TeamTurnovers5Game, home5.TeamTurnovers5Game) AS OppTurnovers,
IF(t1.HomeTeam = 1, away5.OppPoints5Game, home5.OppPoints5Game) AS OppPointsAgainst,
IF(t1.HomeTeam = 1, away5.OppRebounds5Game, home5.OppRebounds5Game) AS OppReboundsAgainst,
IF(t1.HomeTeam = 1, away5.OppAssists5Game, home5.OppAssists5Game) AS OppAssistsAgainst,
IF(t1.HomeTeam = 1, away5.OppSteals5Game, home5.OppSteals5Game) AS OppStealsAgainst
FROM TrainingData t1
INNER JOIN TeamStatsAgg home
  ON t1.HomeTeamID = home.TeamID
  AND t1.CurrDate = home.Date
INNER JOIN TeamStatsAgg away
  ON t1.AwayTeamID = away.TeamID
  AND t1.CurrDate = away.Date
INNER JOIN TeamStatsAgg5Game home5
  ON t1.HomeTeamID = home5.TeamID
  AND home.PrevDate = home5.Date
INNER JOIN TeamStatsAgg5Game away5
  ON t1.AwayTeamID = away5.TeamID
  AND away.PrevDate = away5.Date
;
