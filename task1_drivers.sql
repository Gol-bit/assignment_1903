WITH driver_exits AS (
  SELECT
    EXTRACT(YEAR FROM end_date::date) AS exit_year,
    COUNT(*) AS drivers_count
  FROM
    drivers
  WHERE
    end_date IS NOT NULL
  GROUP BY
    exit_year
), driver_exits_with_prev_year AS (
  SELECT
    exit_year,
    drivers_count,
    LAG(drivers_count) OVER (ORDER BY exit_year) AS prev_year_drivers_left_count
  FROM
    driver_exits
)
SELECT
  exit_year AS year,
  drivers_count AS drivers_left_count,
  prev_year_drivers_left_count,
  CASE
    WHEN drivers_count > prev_year_drivers_left_count THEN 'increase'
    WHEN drivers_count < prev_year_drivers_left_count THEN 'decrease'
    ELSE 'no change'
  END AS driver_change_status
FROM
  driver_exits_with_prev_year
ORDER BY
  exit_year;
