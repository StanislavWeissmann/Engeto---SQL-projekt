
/*
 * Dodatečný materiál - tabulka s HDP, GINI koeficientem a populací dalších evropských států
 * ve stejném období jako primární přehled pro ČR.
 */


-- dotaz - ve kterých letech má ČR nenulové hodnoty

SELECT 
	e.country,
	e.`year`,
	e.GDP,
	e.population,
	e.gini
FROM economies e
WHERE country = 'Czech Republic' AND e.GDP IS NOT NULL AND e.population IS NOT NULL AND e.gini IS NOT NULL
ORDER BY `year` DESC ;




-- tabulka pro evropské země v letech 2004 až 2018


CREATE TABLE t_stanislav_weissmann_project_SQL_secondary_final AS
SELECT 
	e.country,
	e.`year` ,
	round(e.GDP) AS total_GDP,
	e.population,
	e.gini,
	round(e.GDP/e.population)  AS GDP_per_1_inhabitant
FROM economies e 
JOIN countries c 
ON e.country = c.country 
WHERE c.continent = 'Europe' AND e.`year` BETWEEN 2004 AND 2018 
	AND e.GDP IS NOT NULL AND e.population IS NOT NULL;


-- počet všech řádků v tabulce - 632

SELECT 
	count(*) 
FROM t_stanislav_weissmann_project_sql_secondary_final tswpssf;


-- počet všech řádků v tabulce - gini koeficient IS NULL - 111

SELECT 
	count(*) 
FROM t_stanislav_weissmann_project_sql_secondary_final 
WHERE gini IS NULL;



-- dotazy k HDP/1 obyvatele


SELECT 
	country,
	`year`,
	GDP_per_1_inhabitant
FROM t_stanislav_weissmann_project_sql_secondary_final
ORDER BY 
	GDP_per_1_inhabitant  DESC;


SELECT 
	country,
	`year`,
	GDP_per_1_inhabitant
FROM t_stanislav_weissmann_project_sql_secondary_final
WHERE `year` = 2018
ORDER BY 
	GDP_per_1_inhabitant  DESC;


SELECT 
	country,
	`year`,
	GDP_per_1_inhabitant
FROM t_stanislav_weissmann_project_sql_secondary_final
WHERE `year` = 2018 AND country LIKE 'Czech Republic';

