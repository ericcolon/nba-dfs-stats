(SELECT d.Position, p.PlayerID, pr.CombProj AS Points, d.Salary AS Dollars

FROM Primetime s

INNER JOIN Players p ON (p.TeamID=s.HomeTeamID OR p.TeamID=s.AwayTeamID)
INNER JOIN Salaries d ON d.PlayerID=p.PlayerID
INNER JOIN Projections pr ON pr.PlayerID=d.PlayerID

WHERE d.System='Draftkings'
AND pr.Status is Null
AND pr.Starting != 1
AND d.Date=DATE(NOW()))
;
