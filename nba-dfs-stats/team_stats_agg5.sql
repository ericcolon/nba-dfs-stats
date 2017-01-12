DROP TABLE IF EXISTS TeamStatsAgg5Game;
CREATE TABLE TeamStatsAgg5Game
SELECT 
a.TeamID,
a.Date,
a.TeamAssists AS TeamAssists1Game,
a.TeamBlocks AS TeamBlocks1Game,
a.TeamDefensiveRebounds AS TeamDefensiveRebounds1Game,
a.TeamOffensiveRebounds AS TeamOffensiveRebounds1Game,
a.TeamRebounds AS TeamRebounds1Game,
a.TeamShotsAttempted AS TeamShotsAttempted1Game,
a.TeamShotsMade AS TeamShotsMade1Game,
a.TeamSteals AS TeamSteals1Game,
a.TeamThreesAttempted AS TeamThreesAttempted1Game,
a.TeamThreesMade AS TeamThreesMade1Game,
a.TeamTurnovers AS TeamTurnovers1Game,
a.TeamAssists + b.TeamAssists AS TeamAssists2Game,
a.TeamBlocks + b.TeamBlocks AS TeamBlocks2Game,
a.TeamDefensiveRebounds + b.TeamDefensiveRebounds AS TeamDefensiveRebounds2Game,
a.TeamOffensiveRebounds + b.TeamOffensiveRebounds AS TeamOffensiveRebounds2Game,
a.TeamRebounds + b.TeamRebounds AS TeamRebounds2Game,
a.TeamShotsAttempted + b.TeamShotsAttempted AS TeamShotsAttempted2Game,
a.TeamShotsMade + b.TeamShotsMade AS TeamShotsMade2Game,
a.TeamSteals + b.TeamSteals AS TeamSteals2Game,
a.TeamThreesAttempted + b.TeamThreesAttempted AS TeamThreesAttempted2Game,
a.TeamThreesMade + b.TeamThreesMade AS TeamThreesMade2Game,
a.TeamTurnovers + b.TeamTurnovers AS TeamTurnovers2Game,
a.TeamAssists + b.TeamAssists + c.TeamAssists AS TeamAssists3Game,
a.TeamBlocks + b.TeamBlocks + c.TeamBlocks AS TeamBlocks3Game,
a.TeamDefensiveRebounds + b.TeamDefensiveRebounds + c.TeamDefensiveRebounds AS TeamDefensiveRebounds3Game,
a.TeamOffensiveRebounds + b.TeamOffensiveRebounds + c.TeamOffensiveRebounds AS TeamOffensiveRebounds3Game,
a.TeamRebounds + b.TeamRebounds + c.TeamRebounds AS TeamRebounds3Game,
a.TeamShotsAttempted + b.TeamShotsAttempted + c.TeamShotsAttempted AS TeamShotsAttempted3Game,
a.TeamShotsMade + b.TeamShotsMade + c.TeamShotsMade AS TeamShotsMade3Game,
a.TeamSteals + b.TeamSteals + c.TeamSteals AS TeamSteals3Game,
a.TeamThreesAttempted + b.TeamThreesAttempted + c.TeamThreesAttempted AS TeamThreesAttempted3Game,
a.TeamThreesMade + b.TeamThreesMade + c.TeamThreesMade AS TeamThreesMade3Game,
a.TeamTurnovers + b.TeamTurnovers + c.TeamTurnovers AS TeamTurnovers3Game,
a.TeamAssists + b.TeamAssists + c.TeamAssists + e.TeamAssists AS TeamAssists4Game,
a.TeamBlocks + b.TeamBlocks + c.TeamBlocks + e.TeamBlocks AS TeamBlocks4Game,
a.TeamDefensiveRebounds + b.TeamDefensiveRebounds + c.TeamDefensiveRebounds + e.TeamDefensiveRebounds AS TeamDefensiveRebounds4Game,
a.TeamOffensiveRebounds + b.TeamOffensiveRebounds + c.TeamOffensiveRebounds + e.TeamOffensiveRebounds AS TeamOffensiveRebounds4Game,
a.TeamRebounds + b.TeamRebounds + c.TeamRebounds + e.TeamRebounds AS TeamRebounds4Game,
a.TeamShotsAttempted + b.TeamShotsAttempted + c.TeamShotsAttempted + e.TeamShotsAttempted AS TeamShotsAttempted4Game,
a.TeamShotsMade + b.TeamShotsMade + c.TeamShotsMade + e.TeamShotsMade AS TeamShotsMade4Game,
a.TeamSteals + b.TeamSteals + c.TeamSteals + e.TeamSteals AS TeamSteals4Game,
a.TeamThreesAttempted + b.TeamThreesAttempted + c.TeamThreesAttempted + e.TeamThreesAttempted AS TeamThreesAttempted4Game,
a.TeamThreesMade + b.TeamThreesMade + c.TeamThreesMade + e.TeamThreesMade AS TeamThreesMade4Game,
a.TeamTurnovers + b.TeamTurnovers + c.TeamTurnovers + e.TeamTurnovers AS TeamTurnovers4Game,
a.TeamAssists + b.TeamAssists + c.TeamAssists + e.TeamAssists + f.TeamAssists AS TeamAssists5Game,
a.TeamBlocks + b.TeamBlocks + c.TeamBlocks + e.TeamBlocks + f.TeamBlocks AS TeamBlocks5Game,
a.TeamDefensiveRebounds + b.TeamDefensiveRebounds + c.TeamDefensiveRebounds + e.TeamDefensiveRebounds + f.TeamDefensiveRebounds AS TeamDefensiveRebounds5Game,
a.TeamOffensiveRebounds + b.TeamOffensiveRebounds + c.TeamOffensiveRebounds + e.TeamOffensiveRebounds + f.TeamOffensiveRebounds AS TeamOffensiveRebounds5Game,
a.TeamRebounds + b.TeamRebounds + c.TeamRebounds + e.TeamRebounds + f.TeamRebounds AS TeamRebounds5Game,
a.TeamShotsAttempted + b.TeamShotsAttempted + c.TeamShotsAttempted + e.TeamShotsAttempted + f.TeamShotsAttempted AS TeamShotsAttempted5Game,
a.TeamShotsMade + b.TeamShotsMade + c.TeamShotsMade + e.TeamShotsMade + f.TeamShotsMade AS TeamShotsMade5Game,
a.TeamSteals + b.TeamSteals + c.TeamSteals + e.TeamSteals + f.TeamSteals AS TeamSteals5Game,
a.TeamThreesAttempted + b.TeamThreesAttempted + c.TeamThreesAttempted + e.TeamThreesAttempted + f.TeamThreesAttempted AS TeamThreesAttempted5Game,
a.TeamThreesMade + b.TeamThreesMade + c.TeamThreesMade + e.TeamThreesMade + f.TeamThreesMade AS TeamThreesMade5Game,
a.TeamTurnovers + b.TeamTurnovers + c.TeamTurnovers + e.TeamTurnovers + f.TeamTurnovers AS TeamTurnovers5Game,
2.0*(a.TeamShotsMade + b.TeamShotsMade + c.TeamShotsMade + e.TeamShotsMade + f.TeamShotsMade) + 3.0*(a.TeamThreesMade + b.TeamThreesMade + c.TeamThreesMade + e.TeamThreesMade + f.TeamThreesMade) AS TeamPoints5Game,
a.OppAssists + b.OppAssists + c.OppAssists + e.OppAssists + f.OppAssists AS OppAssists5Game,
a.OppBlocks + b.OppBlocks + c.OppBlocks + e.OppBlocks + f.OppBlocks AS OppBlocks5Game,
a.OppDefensiveRebounds + b.OppDefensiveRebounds + c.OppDefensiveRebounds + e.OppDefensiveRebounds + f.OppDefensiveRebounds AS OppDefensiveRebounds5Game,
a.OppOffensiveRebounds + b.OppOffensiveRebounds + c.OppOffensiveRebounds + e.OppOffensiveRebounds + f.OppOffensiveRebounds AS OppOffensiveRebounds5Game,
a.OppRebounds + b.OppRebounds + c.OppRebounds + e.OppRebounds + f.OppRebounds AS OppRebounds5Game,
a.OppShotsAttempted + b.OppShotsAttempted + c.OppShotsAttempted + e.OppShotsAttempted + f.OppShotsAttempted AS OppShotsAttempted5Game,
a.OppShotsMade + b.OppShotsMade + c.OppShotsMade + e.OppShotsMade + f.OppShotsMade AS OppShotsMade5Game,
a.OppSteals + b.OppSteals + c.OppSteals + e.OppSteals + f.OppSteals AS OppSteals5Game,
a.OppThreesAttempted + b.OppThreesAttempted + c.OppThreesAttempted + e.OppThreesAttempted + f.OppThreesAttempted AS OppThreesAttempted5Game,
a.OppThreesMade + b.OppThreesMade + c.OppThreesMade + e.OppThreesMade + f.OppThreesMade AS OppThreesMade5Game,
a.OppTurnovers + b.OppTurnovers + c.OppTurnovers + e.OppTurnovers + f.OppTurnovers AS OppTurnovers5Game,
2.0*(a.OppShotsMade + b.OppShotsMade + c.OppShotsMade + e.OppShotsMade + f.OppShotsMade) + 3.0*(a.OppThreesMade + b.OppThreesMade + c.OppThreesMade + e.OppThreesMade + f.OppThreesMade) AS OppPoints5Game

FROM TeamStatsAgg a
INNER JOIN TeamStatsAgg b
  ON a.TeamID = b.TeamID
  AND a.PrevDate = b.Date
INNER JOIN TeamStatsAgg c
  ON b.TeamID = c.TeamID
  AND b.PrevDate = c.Date
INNER JOIN TeamStatsAgg e
  ON c.TeamID = e.TeamID
  AND c.PrevDate = e.Date
INNER JOIN TeamStatsAgg f
  ON e.TeamID = f.TeamID
  AND e.PrevDate = f.Date
;

ALTER TABLE TeamStatsAgg5Game ADD INDEX (TeamID);
ALTER TABLE TeamStatsAgg5Game ADD INDEX (Date);

DROP TABLE IF EXISTS TeamStatsMostRecent;
CREATE TABLE TeamStatsMostRecent
SELECT b.*
FROM (
SELECT TeamID, 
  MAX(Date) AS Date
FROM TeamStatsAgg5Game 
GROUP BY 1) a
INNER JOIN 
(SELECT 
  TeamID,
  Date,
  TeamAssists5Game,
  TeamBlocks5Game,
  TeamDefensiveRebounds5Game,
  TeamOffensiveRebounds5Game,
  TeamRebounds5Game,
  TeamShotsAttempted5Game,
  TeamShotsMade5Game,
  TeamSteals5Game,
  TeamThreesAttempted5Game,
  TeamThreesMade5Game,
  TeamTurnovers5Game
FROM TeamStatsAgg5Game) b
  ON a.Date = b.Date
  AND a.TeamID = b.TeamID;
ALTER TABLE TeamStatsMostRecent ADD INDEX (TeamID);
ALTER TABLE TeamStatsMostRecent ADD INDEX (Date);
