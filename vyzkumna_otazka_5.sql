
/*
 *  Výzkumná otázka č. 5 -  Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách 
 * ve stejném nebo následujícím roce výraznějším růstem?
 */


-- tabulka vývoje GDP v ČR

CREATE TABLE t_stanislav_weissmann_progress_of_GDP AS
SELECT
	sel_1.year_current,
	sel_1.GDP_current,
	sel_2.year_previous,
	sel_2.GDP_previous,
	round((sel_1.GDP_current - sel_2.GDP_previous)/sel_2.GDP_previous * 100,2) AS GDP_growth_percent
FROM 
(SELECT																		
e.`year` AS year_current,
round(e.GDP) AS GDP_current
FROM economies e
WHERE e.country = 'Czech Republic' AND e.GDP IS NOT NULL) 
	AS sel_1
JOIN
(SELECT																	
e.`year` AS year_previous,
round(e.GDP) AS GDP_previous
FROM economies e 
WHERE e.country = 'Czech Republic' AND e.GDP IS NOT NULL) 
	AS sel_2
ON sel_1.year_current = sel_2.year_previous+1 ;




-- porovnání vývoje GDP, mezd a cen

SELECT 
	GDP.year_current AS GDP_year,
	GDP.GDP_growth_percent ,
	PRI.year_current AS price_year,
	PRI.price_growth_percent ,
	WAY.year_current AS wages_year,
	WAY.wages_growth_percent 
FROM t_stanislav_weissmann_progress_of_gdp AS GDP
LEFT JOIN t_stanislav_weissmann_progress_of_prices_all AS PRI
ON GDP.year_current = PRI.year_current 
LEFT JOIN t_stanislav_weissmann_progress_of_wages_all AS WAY
ON GDP.year_current = WAY.year_current 
WHERE (GDP.GDP_growth_percent > 5 AND PRI.price_growth_percent > 5) OR (GDP.GDP_growth_percent > 5 
AND WAY.wages_growth_percent > 5)
UNION
SELECT 
	GDP.year_current AS GDP_year,
	GDP.GDP_growth_percent ,
	PRI.year_current AS price_year,
	PRI.price_growth_percent ,
	WAY.year_current AS wages_year,
	WAY.wages_growth_percent 
FROM t_stanislav_weissmann_progress_of_gdp AS GDP
LEFT JOIN t_stanislav_weissmann_progress_of_prices_all AS PRI
ON GDP.year_current = PRI.year_current - 1
LEFT JOIN t_stanislav_weissmann_progress_of_wages_all AS WAY
ON GDP.year_current = WAY.year_current - 1
WHERE (GDP.GDP_growth_percent > 5 AND PRI.price_growth_percent > 5) OR (GDP.GDP_growth_percent > 5 
	AND WAY.wages_growth_percent > 5);



-- růst GDP > 5 %

SELECT *	
FROM t_stanislav_weissmann_progress_of_GDP
WHERE GDP_growth_percent > 5 AND year_current BETWEEN 2006 AND 2018 ;