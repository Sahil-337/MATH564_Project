-- ============================================================================
-- linthurst_sql_appendix.sql
-- ----------------------------------------------------------------------------
-- SUPPLEMENTARY APPENDIX — NOT the main analysis.
--
-- The substantive analysis for this project is the Python notebook
-- (regression, collinearity diagnostics, PCR, ridge, model selection).
-- This file is an APPENDIX that demonstrates SQL-style data review of the
-- SAME dataset: table definition, data-quality checks, summary statistics,
-- and basic filtering/grouping queries.
--
-- Dialect: standard SQL, written/tested against PostgreSQL. Minor adjustments
-- (e.g. STDDEV functions, COPY/import syntax) may be needed for other engines.
-- Dataset: Linthurst — Cape Fear Estuary salt marsh, 45 sampling sites.
-- Response: bio (aboveground biomass). Predictors: soil/water chemistry.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. TABLE CREATION
--    Schema for the full 14-predictor Linthurst dataset (LINTHALL).
--    The three identifier columns are named generically; adjust to match the
--    exact headers in the source file if needed.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS linthurst;

CREATE TABLE linthurst (
    obs_id      INTEGER PRIMARY KEY,   -- observation / row identifier
    location    VARCHAR(20),           -- sampling location label
    veg_type    VARCHAR(20),           -- vegetation type
    bio         NUMERIC,               -- RESPONSE: aboveground biomass
    h2s         NUMERIC,               -- hydrogen sulfide
    sal         NUMERIC,               -- salinity
    eh7         NUMERIC,               -- redox potential at pH 7
    ph          NUMERIC,               -- soil acidity
    buf         NUMERIC,               -- buffer acidity
    p           NUMERIC,               -- phosphorus
    k           NUMERIC,               -- potassium
    ca          NUMERIC,               -- calcium
    mg          NUMERIC,               -- magnesium
    na          NUMERIC,               -- sodium
    mn          NUMERIC,               -- manganese
    zn          NUMERIC,               -- zinc
    cu          NUMERIC,               -- copper
    nh4         NUMERIC                -- ammonium
);

-- Load the raw data (PostgreSQL example; the source file is whitespace-delimited
-- and may need to be converted to a delimited format first):
-- \copy linthurst FROM 'data/LINTHALL.csv' WITH (FORMAT csv, HEADER true);


-- ----------------------------------------------------------------------------
-- 2. NULL / DATA-QUALITY CHECKS
--    Confirm completeness before any analysis.
-- ----------------------------------------------------------------------------

-- 2a. Row count (expected: 45 sampling sites).
SELECT COUNT(*) AS total_rows
FROM linthurst;

-- 2b. Null count per column. Every value should be 0 for a clean load.
SELECT
    COUNT(*) - COUNT(bio)  AS bio_nulls,
    COUNT(*) - COUNT(h2s)  AS h2s_nulls,
    COUNT(*) - COUNT(sal)  AS sal_nulls,
    COUNT(*) - COUNT(eh7)  AS eh7_nulls,
    COUNT(*) - COUNT(ph)   AS ph_nulls,
    COUNT(*) - COUNT(buf)  AS buf_nulls,
    COUNT(*) - COUNT(p)    AS p_nulls,
    COUNT(*) - COUNT(k)    AS k_nulls,
    COUNT(*) - COUNT(ca)   AS ca_nulls,
    COUNT(*) - COUNT(mg)   AS mg_nulls,
    COUNT(*) - COUNT(na)   AS na_nulls,
    COUNT(*) - COUNT(mn)   AS mn_nulls,
    COUNT(*) - COUNT(zn)   AS zn_nulls,
    COUNT(*) - COUNT(cu)   AS cu_nulls,
    COUNT(*) - COUNT(nh4)  AS nh4_nulls
FROM linthurst;

-- 2c. Duplicate-identifier check (should return no rows).
SELECT obs_id, COUNT(*) AS occurrences
FROM linthurst
GROUP BY obs_id
HAVING COUNT(*) > 1;

-- 2d. Range / plausibility check — flag non-positive biomass or out-of-range pH.
SELECT obs_id, bio, ph
FROM linthurst
WHERE bio <= 0
   OR ph NOT BETWEEN 0 AND 14;


-- ----------------------------------------------------------------------------
-- 3. SUMMARY STATISTICS
--    Distribution of the response and selected predictors.
-- ----------------------------------------------------------------------------

-- 3a. Summary statistics for the response variable (biomass).
SELECT
    COUNT(bio)       AS n,
    MIN(bio)         AS bio_min,
    MAX(bio)         AS bio_max,
    ROUND(AVG(bio), 2)        AS bio_mean,
    ROUND(STDDEV_SAMP(bio), 2) AS bio_stddev
FROM linthurst;

-- 3b. Summary statistics for the five reduced-model predictors
--     (sal, ph, k, na, zn), one row per variable, via UNION ALL.
SELECT 'SAL' AS variable, ROUND(AVG(sal),2) AS mean, MIN(sal) AS min_val,
       MAX(sal) AS max_val, ROUND(STDDEV_SAMP(sal),2) AS stddev FROM linthurst
UNION ALL
SELECT 'pH', ROUND(AVG(ph),2), MIN(ph), MAX(ph), ROUND(STDDEV_SAMP(ph),2) FROM linthurst
UNION ALL
SELECT 'K',  ROUND(AVG(k),2),  MIN(k),  MAX(k),  ROUND(STDDEV_SAMP(k),2)  FROM linthurst
UNION ALL
SELECT 'Na', ROUND(AVG(na),2), MIN(na), MAX(na), ROUND(STDDEV_SAMP(na),2) FROM linthurst
UNION ALL
SELECT 'Zn', ROUND(AVG(zn),2), MIN(zn), MAX(zn), ROUND(STDDEV_SAMP(zn),2) FROM linthurst;


-- ----------------------------------------------------------------------------
-- 4. FILTERING AND GROUPING
--    Basic exploratory slices of the data.
-- ----------------------------------------------------------------------------

-- 4a. High-biomass sites: above the overall mean, highest first.
SELECT obs_id, location, bio, ph, sal
FROM linthurst
WHERE bio > (SELECT AVG(bio) FROM linthurst)
ORDER BY bio DESC;

-- 4b. Mean biomass and pH grouped by vegetation type.
SELECT
    veg_type,
    COUNT(*)              AS n_sites,
    ROUND(AVG(bio), 2)    AS mean_biomass,
    ROUND(AVG(ph), 2)     AS mean_ph
FROM linthurst
GROUP BY veg_type
ORDER BY mean_biomass DESC;

-- 4c. Mean biomass grouped by sampling location, restricted to locations
--     with at least three sites.
SELECT
    location,
    COUNT(*)              AS n_sites,
    ROUND(AVG(bio), 2)    AS mean_biomass
FROM linthurst
GROUP BY location
HAVING COUNT(*) >= 3
ORDER BY mean_biomass DESC;

-- 4d. Relationship check on the strongest predictor: bucket sites by pH band
--     and compare mean biomass. The Python analysis finds pH to be the dominant
--     positive driver of biomass — this query offers a quick SQL-side view of it.
SELECT
    CASE
        WHEN ph < 4   THEN 'pH < 4'
        WHEN ph < 5   THEN '4 <= pH < 5'
        WHEN ph < 6   THEN '5 <= pH < 6'
        ELSE               'pH >= 6'
    END                   AS ph_band,
    COUNT(*)              AS n_sites,
    ROUND(AVG(bio), 2)    AS mean_biomass
FROM linthurst
GROUP BY ph_band
ORDER BY ph_band;

-- ============================================================================
-- End of SQL appendix.
-- ============================================================================
