
/*
 * Výzkumná otázka č. 3 - Která kategorie potravin zdražuje nejpomaleji 
 * (je u ní nejnižší percentuální meziroční nárůst)?
 */


-- tabulka vývoje cen jednotlivých kategorií zboží v jednotlivých letech

CREATE TABLE t_stanislav_weissmann_progress_of_prices_products AS
SELECT 
	sel_1.name_of_product,
	sel_1.year_current,
	sel_1.avg_price_current,
	sel_2.year_previous,
	sel_2.avg_price_previous,
	round((sel_1.avg_price_current - sel_2.avg_price_previous)/sel_2.avg_price_previous * 100, 2) AS price_growth_percent
FROM 
(SELECT 
	prwa.at_year AS year_current,
	prwa.name_of_product,
	prwa.avg_price AS avg_price_current
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_product IS NOT NULL) AS sel_1
JOIN 
(SELECT 
	prwa.at_year AS year_previous,
	prwa.name_of_product,
	prwa.avg_price AS avg_price_previous
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_product IS NOT NULL) AS sel_2
ON sel_1.year_current = sel_2.year_previous + 1 AND 
	sel_1.name_of_product = sel_2.name_of_product;




-- průměr vývoje cen jednotlivých kategorií zboží

SELECT 
	name_of_product , 
	round(avg(price_growth_percent),2) AS avg_growth_percent
FROM t_stanislav_weissmann_progress_of_prices_products
GROUP BY 
	name_of_product 
ORDER BY 
	avg(price_growth_percent) ASC;



-- kontrola vývoje průměrných cen cukru

SELECT 
	prwa.name_of_product,
	prwa.at_year,
	prwa.avg_price 
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE name_of_product = 'cukr krystalový' AND at_year IN (2006, 2018);