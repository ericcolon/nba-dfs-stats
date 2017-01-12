(SELECT d.Position, p.PlayerID, g.DraftkingsPoints AS Points, d.Salary AS Dollars

FROM Primetime s

INNER JOIN Players p ON (p.TeamID=s.HomeTeamID OR p.TeamID=s.AwayTeamID)
INNER JOIN Salaries d ON d.PlayerID=p.PlayerID
INNER JOIN Projections pr ON pr.PlayerID=d.PlayerID
INNER JOIN PlayerGames g ON g.PlayerID=pr.PlayerID AND g.Next_Game_ID is Null 

WHERE d.System='Draftkings'
AND pr.Status is Null
AND pr.Starting != 1
AND d.Date=DATE(NOW()))
;
