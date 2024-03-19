WITH monthly_active_users AS (
    SELECT
        DATE_TRUNC('month', created_at)::date AS month,
        COUNT(client_id) AS active_users
    FROM
        clients
    WHERE
        deleted_at IS NULL OR deleted_at > DATE_TRUNC('month', created_at)
    GROUP BY
        month
), revenue_with_running_sum AS (
    SELECT
        Month,
        Revenue,
        SUM(Revenue) OVER (ORDER BY Month) AS running_sum_revenue
    FROM
        revenue
)
SELECT
    mau.month,
    mau.active_users,
    rws.Revenue,
    rws.running_sum_revenue
FROM
    monthly_active_users mau
LEFT JOIN
    revenue_with_running_sum rws ON mau.month = rws.Month
ORDER BY
    mau.month;
