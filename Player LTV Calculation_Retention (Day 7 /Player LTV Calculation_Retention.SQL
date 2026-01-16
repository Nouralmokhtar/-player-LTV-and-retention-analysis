##Player LTV Calculation
SELECT
    p.player_id,
    SUM(d.amount) AS total_deposits,
    SUM(b.bet_amount) AS total_bets,
    SUM(b.bet_amount - b.win_amount) AS gross_gaming_revenue,
    DATE_DIFF(MAX(b.bet_date), p.registration_date, DAY) AS lifetime_days
FROM players p
LEFT JOIN deposits d ON p.player_id = d.player_id
LEFT JOIN bets b ON p.player_id = b.player_id
GROUP BY p.player_id, p.registration_date;

## Retention (Day 7 / Day 30)
WITH first_bet AS (
    SELECT player_id, MIN(bet_date) AS first_bet_date
    FROM bets
    GROUP BY player_id
)
SELECT
    COUNT(DISTINCT CASE WHEN DATE_DIFF(b.bet_date, f.first_bet_date, DAY) = 7 THEN b.player_id END)
        * 1.0 / COUNT(DISTINCT f.player_id) AS day_7_retention,
    COUNT(DISTINCT CASE WHEN DATE_DIFF(b.bet_date, f.first_bet_date, DAY) = 30 THEN b.player_id END)
        * 1.0 / COUNT(DISTINCT f.player_id) AS day_30_retention
FROM first_bet f
LEFT JOIN bets b ON f.player_id = b.player_id;
