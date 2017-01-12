DROP TABLE IF EXISTS TrainingData;
CREATE TABLE TrainingData
SELECT 
1.0*curr.Points + 0.5*curr.ThreesMade + 1.25*curr.Rebounds + 1.5*curr.Assists + 2.0*curr.Steals + 2.0*curr.Blocks + 1.5*IF(curr.DoubleDigitCategories >= 2, 1, 0) + 3.0*IF(curr.DoubleDigitCategories >= 3, 1, 0) - 0.5*curr.Turnovers AS DraftkingsPoints,
prev.*,IF(prev.PrevGameDoubleDigitCategories >= 2, 1, 0) AS PrevGameDoubleDouble,
IF(prev.PrevGameDoubleDigitCategories >= 3, 1, 0) AS PrevGameTripleDouble,
1.0*prev.PrevGamePoints + 0.5*prev.PrevGameThreesMade + 1.25*PrevGameRebounds + 1.5*PrevGameAssists + 2.0*PrevGameSteals + 2.0*PrevGameBlocks + 1.5*IF(prev.PrevGameDoubleDigitCategories >= 2, 1, 0) 
+ 3.0*IF(prev.PrevGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.PrevGameTurnovers AS PrevGameDraftkingsPoints,
IF(prev.TwoGameDoubleDigitCategories >= 2, 1, 0) AS TwoGameDoubleDouble,
IF(prev.TwoGameDoubleDigitCategories >= 3, 1, 0) AS TwoGameTripleDouble,
1.0*prev.TwoGamePoints + 0.5*prev.TwoGameThreesMade + 1.25*TwoGameRebounds + 1.5*TwoGameAssists + 2.0*TwoGameSteals + 2.0*TwoGameBlocks + 1.5*IF(prev.TwoGameDoubleDigitCategories >= 2, 1, 0)  
+ 3.0*IF(prev.TwoGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.TwoGameTurnovers AS TwoGameDraftkingsPoints,
IF(prev.ThreeGameDoubleDigitCategories >= 2, 1, 0) AS ThreeGameDoubleDouble,
IF(prev.ThreeGameDoubleDigitCategories >= 3, 1, 0) AS ThreeGameTripleDouble,  1.0*prev.ThreeGamePoints + 0.5*prev.ThreeGameThreesMade + 1.25*ThreeGameRebounds + 1.5*ThreeGameAssists + 2.0*ThreeGameSteals + 2.0*ThreeGameBlocks + 1.5*IF(prev.ThreeGameDoubleDigitCategories >= 2, 1, 0)
+ 3.0*IF(prev.ThreeGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.ThreeGameTurnovers AS ThreeGameDraftkingsPoints,
IF(prev.FourGameDoubleDigitCategories >= 2, 1, 0) AS FourGameDoubleDouble,
IF(prev.FourGameDoubleDigitCategories >= 3, 1, 0) AS FourGameTripleDouble,
1.0*prev.FourGamePoints + 0.5*prev.FourGameThreesMade + 1.25*FourGameRebounds + 1.5*FourGameAssists + 2.0*FourGameSteals + 2.0*FourGameBlocks + 1.5*IF(prev.FourGameDoubleDigitCategories >= 2, 1, 0)
+ 3.0*IF(prev.FourGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.FourGameTurnovers AS FourGameDraftkingsPoints,
IF(prev.FiveGameDoubleDigitCategories >= 2, 1, 0) AS FiveGameDoubleDouble,
IF(prev.FiveGameDoubleDigitCategories >= 3, 1, 0) AS FiveGameTripleDouble,
1.0*prev.FiveGamePoints + 0.5*prev.FiveGameThreesMade + 1.25*FiveGameRebounds + 1.5*FiveGameAssists + 2.0*FiveGameSteals + 2.0*FiveGameBlocks + 1.5*IF(prev.FiveGameDoubleDigitCategories >= 2, 1, 0) 
+ 3.0*IF(prev.FiveGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.FiveGameTurnovers AS FiveGameDraftkingsPoints,
(1.0*prev.PrevGamePoints + 0.5*prev.PrevGameThreesMade + 1.25*PrevGameRebounds + 1.5*PrevGameAssists + 2.0*PrevGameSteals + 2.0*PrevGameBlocks + 1.5*IF(prev.PrevGameDoubleDigitCategories >= 2, 1, 0) 
+ 3.0*IF(prev.PrevGameDoubleDigitCategories >= 3, 1, 0) - 0.5*prev.PrevGameTurnovers)*1.0/PrevGameDollars AS PrevGameDKPointsPerDollar
FROM
(SELECT a.Date AS CurrDate,
a.PlayerID,
a.GameID,
a.TeamID AS HomeTeamID,
h.AwayTeamID,
c.Position,
b.Points AS PrevGamePoints,
b.ShotsAttempted AS PrevGameShotsAttempted,
b.ShotsMade AS PrevGameShotsMade,
IF(b.ShotsMade = 0, 0.0, b.ShotsMade*1.0/b.ShotsAttempted) AS PrevGameShotPct,
b.ThreesAttempted AS PrevGameThreesAttempted,
b.ThreesMade AS PrevGameThreesMade,
IF(b.ThreesMade = 0, 0.0, b.ThreesMade*1.0/b.ThreesAttempted) AS PrevGameThreesPct,
b.Assists AS PrevGameAssists,
b.Blocks AS PrevGameBlocks,
b.Steals AS PrevGameSteals,
b.Rebounds AS PrevGameRebounds,
b.OffensiveRebounds AS PrevGameOffensiveRebounds,
b.DefensiveRebounds AS PrevGameDefensiveRebounds,
b.Turnovers AS PrevGameTurnovers,
b.Plus_Minus AS PrevGamePlusMinus,
b.Seconds_Played*1.0/60 AS PrevGameMinutes,
IF(b.Points >= 10, 1, 0) AS PrevGameDoubleDigitPoints,
IF(b.Points >= 20, 1, 0) AS PrevGameTwentyPoints,
IF(b.Rebounds >= 10, 1, 0) AS PrevGameDoubleDigitRebounds,
IF(b.Assists >= 10, 1, 0) AS PrevGameDoubleDigitAssists,
IF(b.Blocks >= 10, 1, 0) AS PrevGameDoubleDigitBlocks,
IF(b.Steals >= 10, 1, 0) AS PrevGameDoubleDigitSteals,  IF(b.Points >= 10, 1, 0) + IF(b.Rebounds >= 10, 1, 0) + IF(b.Assists >= 10, 1, 0) + IF(b.Blocks >=
10, 1, 0) + IF(b.Steals >= 10, 1, 0) AS PrevGameDoubleDigitCategories,
b.Points + d.Points AS TwoGamePoints,
b.ShotsAttempted + d.ShotsAttempted AS TwoGameShotsAttempted,
b.ShotsMade + d.ShotsMade AS TwoGameShotsMade,
IF((b.ShotsMade + d.ShotsMade) = 0, 0.0, (b.ShotsMade + d.ShotsMade)*1.0/(b.ShotsAttempted + d.ShotsAttempted)) AS TwoGameShotPct,
  b.ThreesAttempted + d.ThreesAttempted AS TwoGameThreesAttempted,
b.ThreesMade + d.ThreesMade AS TwoGameThreesMade,
IF((b.ThreesMade + d.ThreesMade) = 0, 0.0, (b.ThreesMade + d.ThreesMade)*1.0/(b.ThreesAttempted + d.ThreesAttempted)) AS TwoGameThreesPct,
b.Assists + d.Assists AS TwoGameAssists,
b.Blocks + d.Blocks AS TwoGameBlocks,
b.Steals + d.Steals AS TwoGameSteals,
b.Rebounds + d.Rebounds AS TwoGameRebounds,
b.OffensiveRebounds + d.OffensiveRebounds AS TwoGameOffensiveRebounds,
b.DefensiveRebounds + d.DefensiveRebounds AS TwoGameDefensiveRebounds,
b.Turnovers + d.Turnovers AS TwoGameTurnovers,
b.Plus_Minus + d.Plus_Minus AS TwoGamePlusMinus,
(b.Seconds_Played + d.Seconds_Played)*1.0/60 AS TwoGameMinutes,
IF(b.Points >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) AS TwoGameDoubleDigitPoints,
IF(b.Points >= 20, 1, 0) + IF(d.Points >= 20, 1, 0) AS TwoGameTwentyPoints,
IF(b.Rebounds >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) AS TwoGameDoubleDigitRebounds,
IF(b.Assists >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) AS TwoGameDoubleDigitAssists,
IF(b.Blocks >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) AS TwoGameDoubleDigitBlocks,
IF(b.Steals >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) AS TwoGameDoubleDigitSteals,
IF(b.Points >= 10, 1, 0) + IF(b.Rebounds >= 10, 1, 0) + IF(b.Assists >= 10, 1, 0) + IF(b.Blocks >= 10, 1, 0) + IF(b.Steals >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) AS TwoGameDoubleDigitCategories,
b.Points + d.Points + e.Points AS ThreeGamePoints,
b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted AS ThreeGameShotsAttempted,
b.ShotsMade + d.ShotsMade + e.ShotsMade AS ThreeGameShotsMade,
IF((b.ShotsMade + d.ShotsMade + e.ShotsMade) = 0, 0.0, (b.ShotsMade + d.ShotsMade + e.ShotsMade)*1.0/(b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted)) AS ThreeGameShotPct,
b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted AS ThreeGameThreesAttempted,
b.ThreesMade + d.ThreesMade + e.ThreesMade AS ThreeGameThreesMade,
IF((b.ThreesMade + d.ThreesMade + e.ThreesMade) = 0, 0.0, (b.ThreesMade + d.ThreesMade + e.ThreesMade)*1.0/(b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted)) AS ThreeGameThreesPct,
b.Assists + d.Assists + e.Assists AS ThreeGameAssists,
b.Blocks + d.Blocks + e.Blocks AS ThreeGameBlocks,
b.Steals + d.Steals + e.Steals AS ThreeGameSteals,
b.Rebounds + d.Rebounds + e.Rebounds AS ThreeGameRebounds,
b.OffensiveRebounds + d.OffensiveRebounds + e.OffensiveRebounds AS ThreeGameOffensiveRebounds,
b.DefensiveRebounds + d.DefensiveRebounds + e.DefensiveRebounds AS ThreeGameDefensiveRebounds,
b.Turnovers + d.Turnovers + e.Turnovers AS ThreeGameTurnovers,
b.Plus_Minus + d.Plus_Minus + e.Plus_Minus AS ThreeGamePlusMinus,
(b.Seconds_Played + d.Seconds_Played + e.Seconds_Played)*1.0/60 AS ThreeGameMinutes,
IF(b.Points >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) AS ThreeGameDoubleDigitPoints,
IF(b.Points >= 20, 1, 0) + IF(d.Points >= 20, 1, 0) + IF(e.Points >= 20, 1, 0) AS ThreeGameTwentyPoints,
IF(b.Rebounds >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) AS ThreeGameDoubleDigitRebounds,
IF(b.Assists >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) AS ThreeGameDoubleDigitAssists,
IF(b.Blocks >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) AS ThreeGameDoubleDigitBlocks,
IF(b.Steals >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) AS ThreeGameDoubleDigitSteals,
IF(b.Points >= 10, 1, 0) + IF(b.Rebounds >= 10, 1, 0) + IF(b.Assists >= 10, 1, 0) + IF(b.Blocks >= 10, 1, 0) + IF(b.Steals >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) AS ThreeGameDoubleDigitCategories,
b.Points + d.Points + e.Points + f.Points AS FourGamePoints,
b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted + f.ShotsAttempted AS FourGameShotsAttempted,
b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade AS FourGameShotsMade,
  IF((b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade) = 0, 0.0, (b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade)*1.0/(b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted + f.ShotsAttempted)) AS FourGameShotPct,
  b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted + f.ThreesAttempted AS FourGameThreesAttempted,
b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade AS FourGameThreesMade,
IF((b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade) = 0, 0.0, (b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade)*1.0/(b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted + f.ThreesMade)) AS FourGameThreesPct,
b.Assists + d.Assists + e.Assists + f.Assists AS FourGameAssists,
b.Blocks + d.Blocks + e.Blocks + f.Blocks AS FourGameBlocks,
b.Steals + d.Steals + e.Steals + f.Steals AS FourGameSteals,
b.Rebounds + d.Rebounds + e.Rebounds + f.Rebounds AS FourGameRebounds,
b.OffensiveRebounds + d.OffensiveRebounds + e.OffensiveRebounds + f.OffensiveRebounds AS FourGameOffensiveRebounds,
b.DefensiveRebounds + d.DefensiveRebounds + e.DefensiveRebounds + f.DefensiveRebounds AS FourGameDefensiveRebounds,
b.Turnovers + d.Turnovers + e.Turnovers + f.Turnovers AS FourGameTurnovers,
b.Plus_Minus + d.Plus_Minus + e.Plus_Minus + f.Plus_Minus AS FourGamePlusMinus,
(b.Seconds_Played + d.Seconds_Played + e.Seconds_Played + f.Seconds_Played)*1.0/60 AS FourGameMinutes,
IF(b.Points >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) + IF(f.Points >= 10, 1, 0) AS FourGameDoubleDigitPoints,
IF(b.Points >= 20, 1, 0) + IF(d.Points >= 20, 1, 0) + IF(e.Points >= 20, 1, 0) + IF(f.Points >= 20, 1, 0) AS FourGameTwentyPoints,
IF(b.Rebounds >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) + IF(f.Rebounds >= 10, 1, 0) AS FourGameDoubleDigitRebounds,
IF(b.Assists >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) + IF(f.Assists >= 10, 1, 0) AS FourGameDoubleDigitAssists,
IF(b.Blocks >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) + IF(f.Blocks >= 10, 1, 0) AS FourGameDoubleDigitBlocks,
IF(b.Steals >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) + IF(f.Steals >= 10, 1, 0) AS FourGameDoubleDigitSteals,
IF(b.Points >= 10, 1, 0) + IF(b.Rebounds >= 10, 1, 0) + IF(b.Assists >= 10, 1, 0) + IF(b.Blocks >= 10, 1, 0) + IF(b.Steals >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) + IF(f.Points >= 10, 1, 0) + IF(f.Rebounds >= 10, 1, 0) + IF(f.Assists >= 10, 1, 0) + IF(f.Blocks >= 10, 1, 0) + IF(f.Steals >= 10, 1, 0) AS FourGameDoubleDigitCategories,
b.Points + d.Points + e.Points + f.Points + g.Points AS FiveGamePoints,
b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted + f.ShotsAttempted + g.ShotsAttempted AS FiveGameShotsAttempted,
b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade + g.ShotsMade AS FiveGameShotsMade,
  IF((b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade+ g.ShotsMade) = 0, 0.0, (b.ShotsMade + d.ShotsMade + e.ShotsMade + f.ShotsMade + g.ShotsMade)*1.0/(b.ShotsAttempted + d.ShotsAttempted + e.ShotsAttempted + f.ShotsAttempted + g.ShotsAttempted)) AS FiveGameShotPct,
  b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted + f.ThreesAttempted + g.ThreesAttempted AS FiveGameThreesAttempted,
b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade + g.ThreesMade AS FiveGameThreesMade,
IF((b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade + g.ThreesMade ) = 0, 0.0, (b.ThreesMade + d.ThreesMade + e.ThreesMade + f.ThreesMade + g.ThreesMade)*1.0/(b.ThreesAttempted + d.ThreesAttempted + e.ThreesAttempted + f.ThreesAttempted + g.ThreesAttempted)) AS FiveGameThreesPct,
b.Assists + d.Assists + e.Assists + f.Assists + g.Assists AS FiveGameAssists,
b.Blocks + d.Blocks + e.Blocks + f.Blocks + g.Blocks AS FiveGameBlocks,
b.Steals + d.Steals + e.Steals + f.Steals + g.Steals AS FiveGameSteals,
b.Rebounds + d.Rebounds + e.Rebounds + f.Rebounds + g.Rebounds AS FiveGameRebounds,
b.OffensiveRebounds + d.OffensiveRebounds + e.OffensiveRebounds + f.OffensiveRebounds + g.OffensiveRebounds AS FiveGameOffensiveRebounds,
b.DefensiveRebounds + d.DefensiveRebounds + e.DefensiveRebounds + f.DefensiveRebounds + g.DefensiveRebounds AS FiveGameDefensiveRebounds,
b.Turnovers + d.Turnovers + e.Turnovers + f.Turnovers + g.Turnovers AS FiveGameTurnovers,
b.Plus_Minus + d.Plus_Minus + e.Plus_Minus + f.Plus_Minus + g.Plus_Minus AS FiveGamePlusMinus,
(b.Seconds_Played + d.Seconds_Played + e.Seconds_Played + f.Seconds_Played + g.Seconds_Played)*1.0/60 AS FiveGameMinutes,
IF(b.Points >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) + IF(f.Points >= 10, 1, 0) + IF(g.Points >= 10, 1, 0) AS FiveGameDoubleDigitPoints,
IF(b.Points >= 20, 1, 0) + IF(d.Points >= 20, 1, 0) + IF(e.Points >= 20, 1, 0) + IF(f.Points >= 20, 1, 0) + IF(g.Points >= 20, 1, 0) AS FiveGameTwentyPoints,
IF(b.Rebounds >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) + IF(f.Rebounds >= 10, 1, 0) + IF(g.Rebounds >= 10, 1, 0) AS FiveGameDoubleDigitRebounds,
IF(b.Assists >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) + IF(f.Assists >= 10, 1, 0) + IF(g.Assists >= 10, 1, 0) AS FiveGameDoubleDigitAssists,
IF(b.Blocks >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) + IF(f.Blocks >= 10, 1, 0) + IF(g.Blocks >= 10, 1, 0) AS FiveGameDoubleDigitBlocks,
IF(b.Steals >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) + IF(f.Steals >= 10, 1, 0) + IF(g.Steals >= 10, 1, 0) AS FiveGameDoubleDigitSteals,
IF(b.Points >= 10, 1, 0) + IF(b.Rebounds >= 10, 1, 0) + IF(b.Assists >= 10, 1, 0) + IF(b.Blocks >= 10, 1, 0) + IF(b.Steals >= 10, 1, 0) + IF(d.Points >= 10, 1, 0) + IF(d.Rebounds >= 10, 1, 0) + IF(d.Assists >= 10, 1, 0) + IF(d.Blocks >= 10, 1, 0) + IF(d.Steals >= 10, 1, 0) + IF(e.Points >= 10, 1, 0) + IF(e.Rebounds >= 10, 1, 0) + IF(e.Assists >= 10, 1, 0) + IF(e.Blocks >= 10, 1, 0) + IF(e.Steals >= 10, 1, 0) + IF(f.Points >= 10, 1, 0) + IF(f.Rebounds >= 10, 1, 0) + IF(f.Assists >= 10, 1, 0) + IF(f.Blocks >= 10, 1, 0) + IF(f.Steals >= 10, 1, 0) + IF(g.Points >= 10, 1, 0) + IF(g.Rebounds >= 10, 1, 0) + IF(g.Assists >= 10, 1, 0) + IF(g.Blocks >= 10, 1, 0) + IF(g.Steals >= 10, 1, 0) AS FiveGameDoubleDigitCategories,
IF(a.TeamID = h.HomeTeamID, 1, 0) AS HomeTeam,
IF(a.TeamID = h.HomeTeamID, 1, -1)*h.Spread AS TeamSpread,
h.OverUnder,
IF(a.TeamID = h.HomeTeamID, -h.Spread, h.Spread) + h.OverUnder/2.0 AS ExpectedTeamPoints,
(IF(a.TeamID = h.HomeTeamID, -h.Spread, h.Spread) + h.OverUnder/2.0)*(b.Points + d.Points + e.Points + f.Points + g.Points) AS ExpectedPlayerPoints,
(1.0/h.OverUnder)*(b.Rebounds + d.Rebounds + e.Rebounds + f.Rebounds + g.Rebounds) AS ExpectedPlayerRebounds,
(IF(a.TeamID = h.HomeTeamID, -h.Spread, h.Spread) + h.OverUnder/2.0)*(b.Assists + d.Assists + e.Assists + f.Assists + g.Assists) AS ExpectedPlayerAssists,
i.Salary AS Dollars,
j.Salary AS PrevGameDollars
FROM PlayerGames a
INNER JOIN PlayerGames b
ON a.PlayerID = b.PlayerID
AND a.Prev_Game_ID = b.GameID
INNER JOIN Players c
ON a.PlayerID = c.PlayerID
INNER JOIN PlayerGames d
ON a.PlayerID = d.PlayerID
AND b.Prev_Game_ID = d.GameID
INNER JOIN PlayerGames e
ON a.PlayerID = e.PlayerID
AND d.Prev_Game_ID = e.GameID
INNER JOIN PlayerGames f
ON a.PlayerID = f.PlayerID
AND e.Prev_Game_ID = f.GameID
INNER JOIN PlayerGames g
ON a.PlayerID = g.PlayerID
AND f.Prev_Game_ID = g.GameID
INNER JOIN
(SELECT GameID, Date, HomeTeamID, AwayTeamID, OverUnder, Spread 
 FROM Historical_Schedule 
 WHERE Date >= '2015-10-17' 
 GROUP BY 1, 2, 3, 4, 5) h
  ON a.Date = h.Date
  AND (a.TeamID = h.HomeTeamID OR a.TeamID = h.AwayTeamID)
INNER JOIN Salaries i
  ON a.Date = i.Date
  AND a.PlayerID = i.PlayerID
  AND i.System = 'Draftkings'
INNER JOIN Salaries j
  ON b.Date = j.Date
  AND b.PlayerID = j.PlayerID
  AND j.System = 'Draftkings'
WHERE a.FantasyPoints > 0
  AND a.Date >= '2015-10-27') prev
INNER JOIN
(SELECT a.Date AS CurrDate,
a.PlayerID,
a.Points AS Points,
a.ThreesMade AS ThreesMade,
a.Assists AS Assists,
a.Blocks AS Blocks,
  a.Steals AS Steals,
  a.Rebounds AS Rebounds,
a.Turnovers AS Turnovers,
IF(a.Points >= 10, 1, 0) AS DoubleDigitPoints,
IF(a.Rebounds >= 10, 1, 0) AS DoubleDigitRebounds,
IF(a.Assists >= 10, 1, 0) AS DoubleDigitAssists,
IF(a.Blocks >= 10, 1, 0) AS DoubleDigitBlocks,
IF(a.Steals >= 10, 1, 0) AS DoubleDigitSteals,
IF(a.Points >= 10, 1, 0) + IF(a.Rebounds >= 10, 1, 0) + IF(a.Assists >= 10, 1, 0) + IF(a.Blocks >= 10, 1, 0) + IF(a.Steals >= 10, 1, 0) AS DoubleDigitCategories
FROM PlayerGames a
WHERE a.FantasyPoints > 0
  AND a.Date >= '2015-10-27') curr
ON prev.CurrDate = curr.CurrDate
AND prev.PlayerID = curr.PlayerID
;

ALTER TABLE TrainingData ADD INDEX (HomeTeamID);
ALTER TABLE TrainingData ADD INDEX (AwayTeamID);
ALTER TABLE TrainingData ADD INDEX (CurrDate);
