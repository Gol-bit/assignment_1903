WITH wines AS (
  SELECT * FROM wine_t1
  UNION ALL
  SELECT * FROM wine_t2
)
SELECT variety, COUNT(variety) AS total_wines, percentile_cont(0.5) WITHIN GROUP (ORDER BY price) AS median_price
FROM wines
GROUP BY variety
ORDER BY total_wines DESC;