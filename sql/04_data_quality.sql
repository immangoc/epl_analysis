-- ============================================================
-- EPL DATA ANALYTICS
-- 04 - DATA QUALITY CHECKS
-- Engine: DuckDB
-- ============================================================


-- ============================================================
-- 1. ROW COUNT PER TABLE
-- ============================================================

SELECT 'DimTeam'       AS table_name, COUNT(*) AS row_count FROM DimTeam
UNION ALL
SELECT 'DimDate',       COUNT(*) FROM DimDate
UNION ALL
SELECT 'FactStandings', COUNT(*) FROM FactStandings
UNION ALL
SELECT 'FactMatches',   COUNT(*) FROM FactMatches
UNION ALL
SELECT 'FactPlayers',   COUNT(*) FROM FactPlayers;


-- ============================================================
-- 2. DUPLICATE CHECKS
-- ============================================================

-- DimTeam: expect 20 unique teams
SELECT
    COUNT(*)              AS total_rows,
    COUNT(DISTINCT TeamID)   AS unique_team_ids,
    COUNT(DISTINCT TeamName) AS unique_team_names
FROM DimTeam;

-- DimDate: expect no duplicate dates
SELECT
    COUNT(*)           AS total_rows,
    COUNT(DISTINCT Date) AS unique_dates
FROM DimDate;

-- FactStandings: one row per team
SELECT
    COUNT(*)             AS total_rows,
    COUNT(DISTINCT TeamID) AS unique_teams,
    COUNT(DISTINCT Rank)   AS unique_ranks
FROM FactStandings;

-- FactMatches: unique team-match combinations
SELECT
    COUNT(*)              AS total_rows,
    COUNT(DISTINCT MatchID) AS unique_match_ids,
    COUNT(DISTINCT TeamID)  AS unique_teams
FROM FactMatches;

-- FactPlayers: unique player IDs
SELECT
    COUNT(*)               AS total_rows,
    COUNT(DISTINCT PlayerID) AS unique_player_ids
FROM FactPlayers;


-- ============================================================
-- 3. NULL CHECKS
-- ============================================================

-- FactMatches key fields
SELECT
    COUNT(*) FILTER (WHERE MatchID IS NULL)   AS missing_match_id,
    COUNT(*) FILTER (WHERE TeamID IS NULL)    AS missing_team_id,
    COUNT(*) FILTER (WHERE Date IS NULL)      AS missing_date,
    COUNT(*) FILTER (WHERE goals_for IS NULL) AS missing_goals_for,
    COUNT(*) FILTER (WHERE xg_for IS NULL)    AS missing_xg_for
FROM FactMatches;

-- FactPlayers key fields
SELECT
    COUNT(*) FILTER (WHERE PlayerID IS NULL) AS missing_player_id,
    COUNT(*) FILTER (WHERE TeamID IS NULL)   AS missing_team_id,
    COUNT(*) FILTER (WHERE Gls IS NULL)      AS missing_goals,
    COUNT(*) FILTER (WHERE Ast IS NULL)      AS missing_assists
FROM FactPlayers;


-- ============================================================
-- 4. BUSINESS RULE VALIDATION - FACT STANDINGS
-- ============================================================

-- Points must equal W*3 + D
SELECT
    TeamName,
    Pts                AS reported_points,
    W * 3 + D          AS calculated_points,
    Pts - (W * 3 + D)  AS discrepancy
FROM FactStandings
WHERE Pts <> W * 3 + D;

-- Goal difference must equal GF - GA
SELECT
    TeamName,
    GD          AS reported_gd,
    GF - GA     AS calculated_gd
FROM FactStandings
WHERE GD <> GF - GA;

-- Rank must be 1-20 with no gaps
SELECT
    MIN(Rank) AS min_rank,
    MAX(Rank) AS max_rank,
    COUNT(DISTINCT Rank) AS unique_ranks   -- expect 20
FROM FactStandings;

-- Matches played must equal W + D + L
SELECT
    TeamName,
    MP,
    W + D + L   AS calculated_mp
FROM FactStandings
WHERE MP <> W + D + L;


-- ============================================================
-- 5. REFERENTIAL INTEGRITY
-- ============================================================

-- FactMatches → DimTeam
SELECT COUNT(*) AS orphan_team_ids
FROM FactMatches f
LEFT JOIN DimTeam t ON f.TeamID = t.TeamID
WHERE t.TeamID IS NULL;

-- FactMatches → DimDate
SELECT COUNT(*) AS orphan_dates
FROM FactMatches f
LEFT JOIN DimDate d ON f.Date = d.Date
WHERE d.Date IS NULL;

-- FactPlayers → DimTeam
SELECT COUNT(*) AS orphan_player_teams
FROM FactPlayers p
LEFT JOIN DimTeam t ON p.TeamID = t.TeamID
WHERE t.TeamID IS NULL;

-- FactStandings → DimTeam
SELECT COUNT(*) AS orphan_standing_teams
FROM FactStandings s
LEFT JOIN DimTeam t ON s.TeamID = t.TeamID
WHERE t.TeamID IS NULL;


-- ============================================================
-- 6. RANGE / SANITY CHECKS
-- ============================================================

-- goals_for and goals_against must be >= 0
SELECT COUNT(*) AS negative_goals
FROM FactMatches
WHERE goals_for < 0 OR goals_against < 0;

-- xg values should be between 0 and 10 per match
SELECT COUNT(*) AS suspicious_xg
FROM FactMatches
WHERE xg_for < 0 OR xg_for > 10
   OR xg_against < 0 OR xg_against > 10;

-- result must be W, D, or L
SELECT result, COUNT(*) AS cnt
FROM FactMatches
GROUP BY result;

-- venue must be Home or Away
SELECT venue, COUNT(*) AS cnt
FROM FactMatches
GROUP BY venue;

-- Player age should be between 15 and 45
SELECT COUNT(*) AS suspicious_ages
FROM FactPlayers
WHERE Age < 15 OR Age > 45;
