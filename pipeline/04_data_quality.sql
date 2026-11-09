CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality AS
SELECT *,
       CASE WHEN bronze_rows = clean_rows + rejected_rows + duplicate_rows
            THEN 'Yes' ELSE 'No' END AS reconciliation_passed
FROM (
  SELECT COUNT(*) AS bronze_rows,
         COUNT(*) - COUNT(DISTINCT booking_id) AS duplicate_rows,
         SUM(CASE WHEN check_out_date <= check_in_date THEN 1 ELSE 0 END) AS invalid_date_rows,
         SUM(CASE WHEN room_rate < 0 THEN 1 ELSE 0 END)                   AS negative_rate_rows,
         SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END)                    AS missing_city_rows,
         SUM(CASE WHEN booking_channel IS NULL THEN 1 ELSE 0 END)         AS missing_channel_rows,
         SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END)            AS missing_amount_rows,
         SUM(CASE WHEN nights IS NULL THEN 1 ELSE 0 END)                  AS missing_nights_rows,
         (SELECT COUNT(*) FROM silver_bookings_clean)    AS clean_rows,
         (SELECT COUNT(*) FROM silver_bookings_rejected) AS rejected_rows
  FROM bronze_hotel_bookings
);