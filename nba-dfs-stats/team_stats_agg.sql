DROP TABLE IF EXISTS ScheduleCombined;
CREATE TABLE ScheduleCombined
(SELECT Date, HomeTeamID AS TeamID, AwayTeamID AS OppID FROM Historical_Schedule WHERE Date>='2016-10-01')
UNION ALL
(SELECT Date, AwayTeamID AS TeamID, HomeTeamID AS OppID FROM Historical_Schedule WHERE Date>='2016-10-01');

ALTER TABLE ScheduleCombined ADD INDEX (TeamID);
ALTER TABLE ScheduleCombined ADD INDEX (Date);

DROP TABLE IF EXISTS TeamStatsAgg;
CREATE TABLE TeamStatsAgg
SELECT pg.Date, 
  pg.TeamID, 
  s.OppID AS OppID, 
  pg.Date AS PrevDate,
  SUM(pg.ShotsAttempted) AS TeamShotsAttempted, 
  SUM(pg.ShotsMade) AS TeamShotsMade, 
  SUM(pg.ThreesAttempted) AS TeamThreesAttempted, 
  SUM(pg.ThreesMade) AS TeamThreesMade, 
  SUM(pg.Assists) AS TeamAssists, 
  SUM(pg.Blocks) AS TeamBlocks, 
  SUM(pg.Steals) AS TeamSteals, 
  SUM(pg.Rebounds) AS TeamRebounds, 
  SUM(pg.OffensiveRebounds) AS TeamOffensiveRebounds, 
  SUM(pg.DefensiveRebounds) AS TeamDefensiveRebounds, 
  SUM(pg.Turnovers) AS TeamTurnovers,
  0 AS OppShotsAttempted, 
  0 AS OppShotsMade, 
  0 AS OppThreesAttempted, 
  0 AS OppThreesMade, 
  0 AS OppAssists, 
  0 AS OppBlocks, 
  0 AS OppSteals, 
  0 AS OppRebounds, 
  0 AS OppOffensiveRebounds, 
  0 AS OppDefensiveRebounds, 
  0 AS OppTurnovers
FROM PlayerGames pg
INNER JOIN ScheduleCombined s
  ON pg.Date = s.Date
  AND pg.TeamID = s.TeamID
GROUP BY 1, 2, 3, 4;

UPDATE TeamStatsAgg t 
INNER JOIN TeamStatsAgg t1 
  ON t1.TeamID = t.TeamID 
  AND t1.Date < t.Date 
LEFT JOIN TeamStatsAgg t2 
  ON t2.TeamID = t1.TeamID 
  AND t2.Date > t1.Date 
  AND t2.Date < t.Date 
SET t.PrevDate = t1.Date
WHERE t2.Date IS NULL;

UPDATE TeamStatsAgg t
SET t.PrevDate = NULL
WHERE t.Date = t.PrevDate;

ALTER TABLE TeamStatsAgg ADD INDEX (TeamID);
ALTER TABLE TeamStatsAgg ADD INDEX (Date);
ALTER TABLE TeamStatsAgg ADD INDEX (PrevDate);
ALTER TABLE TeamStatsAgg ADD INDEX (OppID);

UPDATE TeamStatsAgg t
INNER JOIN TeamStatsAgg t1
  ON t.Date = t1.Date
  AND t.OppID = t1.TeamID
SET t.OppShotsAttempted = t1.TeamShotsAttempted,
t.OppShotsMade = t1.TeamShotsMade,
t.OppThreesAttempted = t1.TeamThreesAttempted,
t.OppThreesMade = t1.TeamThreesMade,
t.OppAssists = t1.TeamAssists,
t.OppBlocks = t1.TeamBlocks,
t.OppSteals = t1.TeamSteals,
t.OppRebounds = t1.TeamRebounds,
t.OppOffensiveRebounds = t1.TeamOffensiveRebounds,
t.OppDefensiveRebounds = t1.TeamDefensiveRebounds,
t.OppTurnovers = t1.TeamTurnovers;
