-- sql/01_staging.sql
-- ==============================================================================
-- STEP 3 & 4: STAGING MODEL & FEATURE AGGREGATION
-- This script rolls up child tables to the applicant grain using CTEs and Joins.
-- ==============================================================================

CREATE OR REPLACE TABLE mart_applicant_features AS
WITH bureau_aggregated AS (
    SELECT 
        SK_ID_CURR,
        COUNT(SK_ID_BUREAU) AS total_bureau_records,
        AVG(DAYS_CREDIT_ENDDATE) AS avg_days_credit_enddate
    FROM bureau
    GROUP BY SK_ID_CURR
),

prev_app_aggregated AS (
    SELECT 
        SK_ID_CURR,
        COUNT(SK_ID_PREV) AS total_previous_loans_applied
    FROM previous_application
    GROUP BY SK_ID_CURR
)

SELECT 
    app.SK_ID_CURR,
    app.TARGET,
    app.AMT_CREDIT,
    app.AMT_INCOME_TOTAL,
    
    -- Safe division ratios
    app.AMT_CREDIT / NULLIF(app.AMT_INCOME_TOTAL, 0) AS credit_income_ratio,
    app.AMT_ANNUITY / NULLIF(app.AMT_INCOME_TOTAL, 0) AS annuity_income_ratio,
    
    -- Flattened child features
    COALESCE(b.total_bureau_records, 0) AS total_bureau_records,
    b.avg_days_credit_enddate,
    COALESCE(p.total_previous_loans_applied, 0) AS total_previous_loans_applied

FROM application_train app
LEFT JOIN bureau_aggregated b ON app.SK_ID_CURR = b.SK_ID_CURR
LEFT JOIN prev_app_aggregated p ON app.SK_ID_CURR = p.SK_ID_CURR;