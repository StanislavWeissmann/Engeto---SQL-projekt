
/*
 * Výzkumná otázka č. 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd
 * (větší než 10 %)?
 */




-- tabulka vývoje mezd celkem


CREATE TABLE t_stanislav_weissmann_progress_of_wages_all AS
SELECT 
	*,
	round((sel_1.avg_wages_current - sel_2.avg_wages_previous)/sel_2.avg_wages_previous * 100, 2) AS wages_growth_percent
FROM 
(SELECT 
	prwa.at_year AS year_current,
	(avg(avg_wages)) AS avg_wages_current
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL 
GROUP BY prwa.at_year) AS sel_1 
JOIN 
(SELECT 
	prwa.at_year AS year_previous,
	round(avg(avg_wages)) AS avg_wages_previous
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL
GROUP BY prwa.at_year) AS sel_2
ON sel_1.year_current = sel_2.year_previous + 1;

SELECT *
FROM t_stanislav_weissmann_progress_of_wages_all tswpowa ;




-- tabulka vývoje cen celkem

CREATE TABLE t_stanislav_weissmann_progress_of_prices_all AS
SELECT 
	*,
	round((sel_1.avg_price_current - sel_2.avg_price_previous)/sel_2.avg_price_previous * 100, 2) AS price_growth_percent
FROM 
(SELECT 
	prwa.at_year AS year_current,
	round(avg(avg_price),2) AS avg_price_current
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_product IS NOT NULL 
GROUP BY prwa.at_year) AS sel_1 
JOIN 
(SELECT 
	prwa.at_year AS year_previous,
	round(avg(avg_price),2) AS avg_price_previous
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_product IS NOT NULL
GROUP BY prwa.at_year) AS sel_2
ON sel_1.year_current = sel_2.year_previous + 1;




-- dotaz na rozdíl vývoje cen a mezd


SELECT 
	pall.year_current ,
	pall.price_growth_percent,
	wall.wages_growth_percent,
	pall.price_growth_percent - wall.wages_growth_percent AS difference
FROM t_stanislav_weissmann_progress_of_prices_all AS pall
JOIN t_stanislav_weissmann_progress_of_wages_all AS wall
ON wall.year_current = pall.year_current
ORDER BY difference DESC ; 






