-- CHECK 1 & 2: Row counts and Primary Key Null Audits
SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN SK_ID_CURR IS NULL THEN 1 END) AS missing_primary_keys
FROM application_train;

-- CHECK 3: Asserting Primary Key Uniqueness / Deduplication Check
SELECT 
    COUNT(DISTINCT SK_ID_CURR) AS unique_applicant_ids,
    COUNT(*) AS total_rows
FROM application_train;