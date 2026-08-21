-- Seed Dashboard KPI Metrics
IF NOT EXISTS (SELECT 1 FROM DashboardKpiMetrics WHERE MetricKey = 'TOTAL_FARMERS')
BEGIN
    INSERT INTO DashboardKpiMetrics (MetricKey, Title, CurrentValue, PreviousValue, Unit, Category, LastCalculatedAt)
    VALUES ('TOTAL_FARMERS', 'Total Registered Farmers', 12450, 11800, '', 'Demographics', GETUTCDATE());
END

IF NOT EXISTS (SELECT 1 FROM DashboardKpiMetrics WHERE MetricKey = 'ACTIVE_CROPS')
BEGIN
    INSERT INTO DashboardKpiMetrics (MetricKey, Title, CurrentValue, PreviousValue, Unit, Category, LastCalculatedAt)
    VALUES ('ACTIVE_CROPS', 'Active Crop Varieties', 42, 38, '', 'Agriculture', GETUTCDATE());
END

IF NOT EXISTS (SELECT 1 FROM DashboardKpiMetrics WHERE MetricKey = 'SYSTEM_HEALTH')
BEGIN
    INSERT INTO DashboardKpiMetrics (MetricKey, Title, CurrentValue, PreviousValue, Unit, Category, LastCalculatedAt)
    VALUES ('SYSTEM_HEALTH', 'System Health Score', 98.5, 99.2, '%', 'Infrastructure', GETUTCDATE());
END

IF NOT EXISTS (SELECT 1 FROM DashboardKpiMetrics WHERE MetricKey = 'TOTAL_ALERTS')
BEGIN
    INSERT INTO DashboardKpiMetrics (MetricKey, Title, CurrentValue, PreviousValue, Unit, Category, LastCalculatedAt)
    VALUES ('TOTAL_ALERTS', 'Critical Alerts (24h)', 15, 22, '', 'Security', GETUTCDATE());
END

-- Ensure at least one admin user exists for testing if not already there
-- (Assuming standard identity table names)
-- INSERT INTO AspNetUsers (...) VALUES (...)
GO
