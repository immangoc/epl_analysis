-- ============================================================
-- EPL DATA ANALYTICS
-- 03 - LOAD DATA FROM CSV
-- Engine: DuckDB
-- ============================================================

-- Run after 01_create_database.sql to populate all tables.
-- Update the base path if needed.

-- ============================================================
-- LOAD DIM TEAM
-- ============================================================

INSERT INTO DimTeam
SELECT
    CAST(TeamID   AS INTEGER),
    TeamName
FROM read_csv_auto('data/clean/dim_team.csv', header = true);


-- ============================================================
-- LOAD DIM DATE
-- ============================================================

INSERT INTO DimDate
SELECT
    CAST(Date      AS DATE),
    CAST(Year      AS INTEGER),
    CAST(Month     AS INTEGER),
    MonthName,
    CAST(Day       AS INTEGER),
    DayName,
    CAST(Matchweek AS DOUBLE)
FROM read_csv_auto('data/clean/dim_date.csv', header = true);


-- ============================================================
-- LOAD FACT STANDINGS
-- ============================================================

INSERT INTO FactStandings
SELECT
    CAST(TeamID AS INTEGER),
    TeamName,
    CAST(Rank   AS INTEGER),
    CAST(MP     AS INTEGER),
    CAST(W      AS INTEGER),
    CAST(D      AS INTEGER),
    CAST(L      AS INTEGER),
    CAST(GF     AS INTEGER),
    CAST(GA     AS INTEGER),
    CAST(GD     AS INTEGER),
    CAST(Pts    AS INTEGER)
FROM read_csv_auto('data/clean/fact_standings.csv', header = true);


-- ============================================================
-- LOAD FACT MATCHES
-- ============================================================

INSERT INTO FactMatches
SELECT
    MatchID,
    CAST("Date"         AS DATE),
    CAST(TeamID         AS INTEGER),
    team,
    opponent,
    venue,
    result,
    CAST(points         AS INTEGER),
    CAST(goals_for      AS INTEGER),
    CAST(goals_against  AS INTEGER),
    CAST(xg_for         AS DOUBLE),
    CAST(xg_against     AS DOUBLE),
    CAST(goal_diff      AS INTEGER),
    CAST(xg_diff        AS DOUBLE),
    CAST(matchweek      AS INTEGER),
    CAST(cum_points     AS DOUBLE),
    CAST(form_pts_last5 AS DOUBLE)
FROM read_csv_auto('data/clean/fact_matches.csv', header = true);


-- ============================================================
-- LOAD FACT PLAYERS
-- ============================================================

INSERT INTO FactPlayers
SELECT
    PlayerID,
    CAST(TeamID     AS INTEGER),
    Player,
    Nation,
    Pos,
    Squad,
    CAST(Age        AS INTEGER),
    CAST(MP         AS INTEGER),
    CAST(Starts     AS INTEGER),
    CAST(Min        AS INTEGER),
    CAST(Gls        AS INTEGER),
    CAST(Ast        AS INTEGER),
    CAST(Sh         AS INTEGER),
    CAST(SoT        AS INTEGER),
    CAST(CrdY       AS INTEGER),
    CAST(CrdR       AS INTEGER),
    CAST(Gls_per90  AS DOUBLE),
    CAST(Ast_per90  AS DOUBLE),
    CAST(Sh_per90   AS DOUBLE)
FROM read_csv_auto('data/clean/fact_players.csv', header = true);


-- ============================================================
-- VERIFY ROW COUNTS
-- ============================================================

SELECT 'DimTeam'      AS table_name, COUNT(*) AS rows FROM DimTeam
UNION ALL
SELECT 'DimDate',      COUNT(*) FROM DimDate
UNION ALL
SELECT 'FactStandings',COUNT(*) FROM FactStandings
UNION ALL
SELECT 'FactMatches',  COUNT(*) FROM FactMatches
UNION ALL
SELECT 'FactPlayers',  COUNT(*) FROM FactPlayers;
