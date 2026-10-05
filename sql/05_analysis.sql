-- ============================================================
-- EPL DATA ANALYTICS
-- 05 - ANALYSIS QUERIES
-- Engine: DuckDB
-- ============================================================


-- ============================================================
-- 1. FINAL LEAGUE STANDINGS
-- ============================================================

SELECT
    s.Rank,
    t.TeamName,
    s.MP,
    s.W,
    s.D,
    s.L,
    s.GF,
    s.GA,
    s.GD,
    s.Pts,
    ROUND(s.W * 100.0 / s.MP, 1) AS WinPct
FROM FactStandings s
JOIN DimTeam t ON s.TeamID = t.TeamID
ORDER BY s.Rank;


-- ============================================================
-- 2. TEAM PERFORMANCE SUMMARY (from FactMatches)
-- ============================================================

SELECT
    t.TeamName,
    COUNT(*)                               AS Matches,
    SUM(f.points)                          AS Points,
    SUM(f.goals_for)                       AS GF,
    SUM(f.goals_against)                   AS GA,
    SUM(f.goals_for - f.goals_against)     AS GD,
    ROUND(AVG(f.xg_for), 2)               AS AvgXGFor,
    ROUND(AVG(f.xg_against), 2)           AS AvgXGAgainst,
    ROUND(AVG(f.form_pts_last5), 2)       AS AvgForm5
FROM FactMatches f
JOIN DimTeam t ON f.TeamID = t.TeamID
GROUP BY t.TeamID, t.TeamName
ORDER BY Points DESC, GD DESC;


-- ============================================================
-- 3. HOME vs AWAY PERFORMANCE
-- ============================================================

SELECT
    t.TeamName,
    f.venue                                AS Venue,
    COUNT(*)                               AS Matches,
    SUM(f.points)                          AS Points,
    SUM(f.goals_for)                       AS GF,
    SUM(f.goals_against)                   AS GA,
    ROUND(AVG(f.xg_for), 2)               AS AvgXGFor,
    ROUND(AVG(f.xg_against), 2)           AS AvgXGAgainst
FROM FactMatches f
JOIN DimTeam t ON f.TeamID = t.TeamID
GROUP BY t.TeamName, f.venue
ORDER BY t.TeamName, f.venue;


-- ============================================================
-- 4. ACTUAL GOALS vs EXPECTED GOALS (xG)
-- ============================================================

SELECT
    t.TeamName,
    SUM(f.goals_for)                               AS ActualGoals,
    ROUND(SUM(f.xg_for), 2)                        AS ExpectedGoals,
    ROUND(SUM(f.goals_for) - SUM(f.xg_for), 2)    AS GoalsOverXG,
    SUM(f.goals_against)                           AS ActualConceded,
    ROUND(SUM(f.xg_against), 2)                    AS ExpectedConceded,
    ROUND(SUM(f.xg_against) - SUM(f.goals_against), 2) AS GoalsSaved
FROM FactMatches f
JOIN DimTeam t ON f.TeamID = t.TeamID
GROUP BY t.TeamID, t.TeamName
ORDER BY GoalsOverXG DESC;


-- ============================================================
-- 5. FORM - POINTS PER MATCHWEEK (rolling trend)
-- ============================================================

SELECT
    t.TeamName,
    f.matchweek,
    SUM(f.points)               AS PointsInWeek,
    MAX(f.cum_points)           AS CumulativePoints,
    ROUND(AVG(f.xg_for), 2)    AS AvgXGWeek
FROM FactMatches f
JOIN DimTeam t ON f.TeamID = t.TeamID
GROUP BY t.TeamName, f.matchweek
ORDER BY t.TeamName, f.matchweek;


-- ============================================================
-- 6. TOP SCORERS
-- ============================================================

SELECT
    p.Player,
    t.TeamName,
    p.Pos,
    p.Gls                                  AS Goals,
    p.Ast                                  AS Assists,
    p.Gls + p.Ast                          AS GoalContributions,
    p.Sh                                   AS Shots,
    p.SoT                                  AS ShotsOnTarget,
    ROUND(p.Gls * 100.0 / NULLIF(p.Sh, 0), 1) AS ConversionRate,
    ROUND(p.Gls_per90, 2)                  AS GlsPer90
FROM FactPlayers p
JOIN DimTeam t ON p.TeamID = t.TeamID
WHERE p.Gls > 0
ORDER BY Goals DESC, Assists DESC
LIMIT 20;


-- ============================================================
-- 7. TOP ASSISTERS
-- ============================================================

SELECT
    p.Player,
    t.TeamName,
    p.Pos,
    p.Ast                   AS Assists,
    p.Gls                   AS Goals,
    ROUND(p.Ast_per90, 2)  AS AstPer90
FROM FactPlayers p
JOIN DimTeam t ON p.TeamID = t.TeamID
WHERE p.Ast > 0
ORDER BY Assists DESC
LIMIT 20;


-- ============================================================
-- 8. DISCIPLINE - CARDS PER TEAM
-- ============================================================

SELECT
    t.TeamName,
    SUM(p.CrdY)                     AS YellowCards,
    SUM(p.CrdR)                     AS RedCards,
    SUM(p.CrdY) + SUM(p.CrdR) * 2  AS DisciplinaryPoints
FROM FactPlayers p
JOIN DimTeam t ON p.TeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY DisciplinaryPoints DESC;


-- ============================================================
-- 9. SQUAD DEPTH & PLAYING TIME
-- ============================================================

SELECT
    t.TeamName,
    COUNT(p.PlayerID)              AS SquadSize,
    SUM(p.MP)                      AS TotalAppearances,
    ROUND(AVG(p.Min), 0)           AS AvgMinutesPerPlayer,
    ROUND(AVG(p.Age), 1)           AS AvgAge,
    MIN(p.Age)                     AS YoungestAge,
    MAX(p.Age)                     AS OldestAge
FROM FactPlayers p
JOIN DimTeam t ON p.TeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY t.TeamName;


-- ============================================================
-- 10. HEAD-TO-HEAD - TOP CLASHES
-- ============================================================

SELECT
    f.team              AS Team,
    f.opponent          AS Opponent,
    f.Date,
    f.matchweek         AS Matchweek,
    f.venue             AS Venue,
    f.result            AS Result,
    f.goals_for         AS GF,
    f.goals_against     AS GA,
    ROUND(f.xg_for, 2)  AS xGFor,
    ROUND(f.xg_against, 2) AS xGAgainst
FROM FactMatches f
ORDER BY f.goals_for + f.goals_against DESC   -- most goals first
LIMIT 20;


-- ============================================================
-- 11. MONTHLY GOAL TRENDS
-- ============================================================

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    SUM(f.goals_for)                    AS TotalGoals,
    COUNT(DISTINCT f.MatchID)           AS Matches,
    ROUND(AVG(f.goals_for), 2)          AS AvgGoalsPerTeamPerMatch,
    ROUND(AVG(f.xg_for), 2)            AS AvgXGPerTeamPerMatch
FROM FactMatches f
JOIN DimDate d ON f.Date = d.Date
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;


-- ============================================================
-- 12. TITLE RACE - TOP 4 & RELEGATION BATTLE
-- ============================================================

-- Top 4 (Champions League places)
SELECT 'Champions League' AS Zone, t.TeamName, s.Rank, s.Pts, s.GD
FROM FactStandings s
JOIN DimTeam t ON s.TeamID = t.TeamID
WHERE s.Rank <= 4

UNION ALL

-- Europa League (5th-6th)
SELECT 'Europa League', t.TeamName, s.Rank, s.Pts, s.GD
FROM FactStandings s
JOIN DimTeam t ON s.TeamID = t.TeamID
WHERE s.Rank IN (5, 6)

UNION ALL

-- Relegation zone (18th-20th)
SELECT 'Relegation', t.TeamName, s.Rank, s.Pts, s.GD
FROM FactStandings s
JOIN DimTeam t ON s.TeamID = t.TeamID
WHERE s.Rank >= 18

ORDER BY Rank;
