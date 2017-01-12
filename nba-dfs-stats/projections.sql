UPDATE Projections SET BaseProj=0;

UPDATE Projections pr
INNER JOIN PlayerGames g ON g.PlayerID=pr.PlayerID AND g.AvgPoints2Game is not Null AND g.Next_Game_ID is Null AND g.Date>=DATE(NOW()-INTERVAL 10 DAY)
INNER JOIN Players p ON p.PlayerID=pr.PlayerID
SET pr.BaseProj= .4*p.FantasyPoints +.6*g.AvgPoints2Game;

UPDATE Projections pr
INNER JOIN PlayerGames g ON g.PlayerID=pr.PlayerID AND g.AvgPoints4Game is not Null AND g.Next_Game_ID is Null AND g.Date>=DATE(NOW()-INTERVAL 10 DAY)
INNER JOIN Players p ON p.PlayerID=pr.PlayerID
SET pr.BaseProj= .3*p.FantasyPoints +.4*g.AvgPoints4Game + .3*g.AvgPoints2Game;

UPDATE Projections pr
INNER JOIN PlayerGames g ON g.PlayerID=pr.PlayerID AND g.AvgPoints10Game is not Null AND g.Next_Game_ID is Null AND g.Date>=DATE(NOW()-INTERVAL 10 DAY)
SET pr.BaseProj= .4*g.AvgPoints10Game +.3*g.AvgPoints4Game + .3*g.AvgPoints2Game;

UPDATE Projections pr
INNER JOIN Players p ON p.PlayerID = pr.PlayerID
INNER JOIN Schedule s ON s.GameID=pr.GameID AND s.HomeTeamID = pr.TeamID
SET
pr.OddsProj = pr.BaseProj * (s.OverUnder - s.Spread) / 200;

UPDATE Projections pr
INNER JOIN Players p ON p.PlayerID = pr.PlayerID
INNER JOIN Schedule s ON s.GameID=pr.GameID AND s.AwayTeamID = pr.TeamID
SET
pr.OddsProj = pr.BaseProj * (s.OverUnder - s.Spread) / 200;

UPDATE Projections p
LEFT JOIN Model m ON p.PlayerID=m.PlayerID
SET p.CombProj = m.Points;

UPDATE Projections p
LEFT JOIN Old_Model m ON p.PlayerID=m.PlayerID
SET p.OppProj = m.Points;

UPDATE Projections p 
INNER JOIN Roto m ON p.PlayerId=m.PlayerID
SET p.RotoProj=m.Points WHERE m.Date=p.Date;

CREATE INDEX GameID ON Projections (GameID);
CREATE INDEX Date ON Projections (Date);
CREATE INDEX PlayerID ON Projections (PlayerID);



