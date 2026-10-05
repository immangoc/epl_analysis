-- ============================================================
-- EPL DATA ANALYTICS
-- 01 - CREATE DATABASE & SCHEMA
-- Engine: DuckDB
-- ============================================================

-- DuckDB creates the database automatically when you connect.
-- Run this file to set up the schema from scratch.

-- ============================================================
-- DROP TABLES (clean slate)
-- ============================================================

DROP TABLE IF EXISTS FactPlayers;
DROP TABLE IF EXISTS FactMatches;
DROP TABLE IF EXISTS FactStandings;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimTeam;


-- ============================================================
-- DIM TEAM
-- ============================================================

CREATE TABLE DimTeam (
    TeamID      INTEGER PRIMARY KEY,
    TeamName    VARCHAR NOT NULL
);


-- ============================================================
-- DIM DATE
-- ============================================================

CREATE TABLE DimDate (
    Date        DATE    PRIMARY KEY,
    Year        INTEGER NOT NULL,
    Month       INTEGER NOT NULL,
    MonthName   VARCHAR NOT NULL,
    Day         INTEGER NOT NULL,
    DayName     VARCHAR NOT NULL,
    Matchweek   DOUBLE
);


-- ============================================================
-- FACT STANDINGS
-- Final league table for the season
-- ============================================================

CREATE TABLE FactStandings (
    TeamID      INTEGER PRIMARY KEY REFERENCES DimTeam(TeamID),
    TeamName    VARCHAR NOT NULL,
    Rank        INTEGER NOT NULL,
    MP          INTEGER NOT NULL,   -- Matches Played
    W           INTEGER NOT NULL,   -- Wins
    D           INTEGER NOT NULL,   -- Draws
    L           INTEGER NOT NULL,   -- Losses
    GF          INTEGER NOT NULL,   -- Goals For
    GA          INTEGER NOT NULL,   -- Goals Against
    GD          INTEGER NOT NULL,   -- Goal Difference
    Pts         INTEGER NOT NULL    -- Points
);


-- ============================================================
-- FACT MATCHES
-- One row per team per match (team-match perspective)
-- ============================================================

CREATE TABLE FactMatches (
    MatchID         VARCHAR  NOT NULL,
    Date            DATE     NOT NULL REFERENCES DimDate(Date),
    TeamID          INTEGER  NOT NULL REFERENCES DimTeam(TeamID),
    team            VARCHAR  NOT NULL,
    opponent        VARCHAR  NOT NULL,
    venue           VARCHAR  NOT NULL,  -- 'Home' or 'Away'
    result          VARCHAR  NOT NULL,  -- 'W', 'D', or 'L'
    points          INTEGER  NOT NULL,
    goals_for       INTEGER  NOT NULL,
    goals_against   INTEGER  NOT NULL,
    xg_for          DOUBLE,
    xg_against      DOUBLE,
    goal_diff       INTEGER,
    xg_diff         DOUBLE,
    matchweek       INTEGER  NOT NULL,
    cum_points      DOUBLE,
    form_pts_last5  DOUBLE,
    PRIMARY KEY (MatchID, TeamID)
);


-- ============================================================
-- FACT PLAYERS
-- Season-level player statistics
-- ============================================================

CREATE TABLE FactPlayers (
    PlayerID    VARCHAR  PRIMARY KEY,
    TeamID      INTEGER  NOT NULL REFERENCES DimTeam(TeamID),
    Player      VARCHAR  NOT NULL,
    Nation      VARCHAR,
    Pos         VARCHAR,
    Squad       VARCHAR,
    Age         INTEGER,
    MP          INTEGER,    -- Matches Played
    Starts      INTEGER,
    Min         INTEGER,    -- Minutes played
    Gls         INTEGER,    -- Goals
    Ast         INTEGER,    -- Assists
    Sh          INTEGER,    -- Shots
    SoT         INTEGER,    -- Shots on Target
    CrdY        INTEGER,    -- Yellow Cards
    CrdR        INTEGER,    -- Red Cards
    Gls_per90   DOUBLE,
    Ast_per90   DOUBLE,
    Sh_per90    DOUBLE
);
