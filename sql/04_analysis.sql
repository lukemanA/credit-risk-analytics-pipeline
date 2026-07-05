-- Portfolio performance aggregation metrics by risk segment
SELECT 
    TARGET,
    COUNT(*) AS total_applications_evaluated,
    SUM(TARGET) AS total_portfolio_defaulters,
    ROUND((SUM(TARGET) * 100.0 / COUNT(*)), 2) AS overall_default_rate_ratio
FROM application_train
GROUP BY TARGET;