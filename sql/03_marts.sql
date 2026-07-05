SELECT 
    SK_ID_CURR,
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    -- Feature engineering: credit to income ratio mapping
    (AMT_CREDIT / NULLIF(AMT_INCOME_TOTAL, 0)) AS credit_income_ratio,
    TARGET
FROM application_train;