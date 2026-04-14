/*
 * 2. Kolik je mozne si koupit litru mleka a kilogramu chleba za prvni a posledni srovnatelne obdobi v dostupnych datech cen a mezd?
 */

WITH milk_bread_2006_2018 AS (
    -- Data pro konkretni potraviny a roky 
    SELECT 
        food_category,
        price_unit,
        payroll_year,
        food_price,
        average_salary
    FROM t_denisa_bartonova_project_SQL_primary_final
    WHERE payroll_year IN (2006, 2018)
      AND food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
),
aggregated_data AS (
    -- Vypocet prumernych hodnot a kupni sily 
    SELECT 
        food_category,
        price_unit,
        payroll_year,
        ROUND(AVG(food_price)::numeric, 2) AS avg_price,
        ROUND(AVG(average_salary)::numeric, 2) AS avg_salary
    FROM milk_bread_2006_2018
    GROUP BY food_category, price_unit, payroll_year
)
SELECT 
    *,
    ROUND(avg_salary / avg_price, 2) AS purchasing_power
FROM aggregated_data
ORDER BY food_category, payroll_year;