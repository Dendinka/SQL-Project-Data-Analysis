/*
 * 3. Ktera kategorie potravin zdrazuje nejpomaleji (je u ni nejnizsi percentualni mezirocni narust)?
 */

WITH food_prices_average AS (
    -- KROK 1: Prumerne ceny pro kazdou kategorii a rok
    SELECT 
        food_category,
        payroll_year,
        ROUND(AVG(food_price / price_value)::numeric, 2) AS avg_price
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY food_category, payroll_year
),
food_price_shifts AS (
    -- KROK 2: Vypocet predchozi ceny pomoci funkce LAG
    SELECT 
        food_category,
        payroll_year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY food_category ORDER BY payroll_year) AS prev_price
    FROM food_prices_average
),
annual_changes AS (
    -- KROK 3: Vypocet procentualni zmeny mezi lety
    SELECT 
        food_category,
        payroll_year,
        avg_price,
        prev_price,
        ROUND(((avg_price / prev_price) - 1) * 100, 2) AS year_percentage_change
    FROM food_price_shifts
    WHERE prev_price IS NOT NULL
)
-- FINALNI KROK: Prumerna mezirocni zmena za cele obdobi pro kazdou potravinu
SELECT 
    food_category,
    ROUND(AVG(year_percentage_change), 2) AS avg_annual_change_percentage
FROM annual_changes
GROUP BY food_category
ORDER BY avg_annual_change_percentage ASC; 


WITH food_prices_average AS (
    -- KROK 1: Prumerne ceny pro kazdou kategorii a rok
    SELECT 
        food_category,
        payroll_year,
        ROUND(AVG(food_price / price_value)::numeric, 2) AS avg_price
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY food_category, payroll_year
),
food_price_shifts AS (
    -- KROK 2: Vypocet predchozi ceny pomoci funkce LAG
    SELECT 
        food_category,
        payroll_year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY food_category ORDER BY payroll_year) AS prev_price
    FROM food_prices_average
)
-- FINALNI KROK: Zobrazeni zmen rok po roce pro kazdou potravinu
SELECT 
    food_category,
    payroll_year AS year,
    prev_price AS price_prev_year,
    avg_price AS price_current_year,
    ROUND(((avg_price / prev_price::numeric) - 1) * 100, 2) AS year_percentage_change
FROM food_price_shifts
WHERE prev_price IS NOT NULL
ORDER BY food_category, payroll_year;