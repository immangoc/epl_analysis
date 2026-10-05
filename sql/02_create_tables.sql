-- ============================================================
-- EPL DATA ANALYTICS
-- 02 - CREATE TABLES (alternative: using CSV auto-schema)
-- Engine: DuckDB
-- ============================================================

-- DuckDB can also infer schema automatically from CSV files.
-- Use this approach for quick prototyping.

-- ============================================================
-- AUTO-CREATE FROM CSV (schema inference)
-- ============================================================

-- Base path for CSV files
-- Update this path to match your local environment.

CREATE OR REPLACE TABLE DimTeam AS
    SELECT * FROM read_csv_auto(
        'data/clean/dim_team.csv',
        header = true
    );

CREATE OR REPLACE TABLE DimDate AS
    SELECT * FROM read_csv_auto(
        'data/clean/dim_date.csv',
        header = true
    );

CREATE OR REPLACE TABLE FactStandings AS
    SELECT * FROM read_csv_auto(
        'data/clean/fact_standings.csv',
        header = true
    );

CREATE OR REPLACE TABLE FactMatches AS
    SELECT * FROM read_csv_auto(
        'data/clean/fact_matches.csv',
        header = true
    );

CREATE OR REPLACE TABLE FactPlayers AS
    SELECT * FROM read_csv_auto(
        'data/clean/fact_players.csv',
        header = true
    );


-- ============================================================
-- VERIFY SCHEMA
-- ============================================================

DESCRIBE DimTeam;
DESCRIBE DimDate;
DESCRIBE FactStandings;
DESCRIBE FactMatches;
DESCRIBE FactPlayers;
