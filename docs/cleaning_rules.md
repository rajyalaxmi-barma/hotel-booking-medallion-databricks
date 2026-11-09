# Cleaning Rules

| Problem | Rule applied | Why |
|---|---|---|
| Duplicate bookings (26) | SELECT DISTINCT | The same booking must be counted only once |
| Extra spaces / mixed case | INITCAP(TRIM(col)) | "  goa" and "DELUXE" become "Goa" and "Deluxe", so groups match |
| Blank city or booking channel | COALESCE(col, 'Unknown') | Keeps the row instead of losing it |
| Blank nights | COALESCE(nights, DATEDIFF(check_out_date, check_in_date)) | Can be calculated from the dates |
| Blank total amount | COALESCE(total_amount, nights x room_rate) | Can be calculated from the rate |
| Blank guest rating or guest ID | Left as NULL | AVG skips NULL, while 0 would lower the average |
| Check-out on or before check-in (12 rows) | Rejected, with a reason | Impossible stay |
| Negative room rate (9 rows) | Rejected, with a reason | Impossible price |
| Cancelled bookings | Kept in Silver, excluded from revenue and room nights in Gold | A normal business event, not bad data |

## Reconciliation

Bronze rows 1,316 = Clean rows 1,269 + Rejected rows 21 + Duplicates removed 26