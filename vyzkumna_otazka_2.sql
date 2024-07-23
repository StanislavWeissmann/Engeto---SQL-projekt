
/*
 * Výzkumná otázka č. 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první 
 * a poslední srovnatelné období v dostupných datech cen a mezd?
 */




SELECT 
	sel_1.at_year,
	sel_1.name_of_product,
	sel_1.avg_price,
	sel_2.avg_wages,
	round(sel_2.avg_wages/sel_1.avg_price,0) AS quantity
FROM
(SELECT 
	prwa.at_year,
	prwa.name_of_product, 
	prwa.avg_price
	FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.at_year IN (2006, 2018) AND (prwa.name_of_product LIKE '%mléko%' OR prwa.name_of_product LIKE 'chléb%'))
AS sel_1
LEFT JOIN
(SELECT 
	prwa.at_year,
	round(avg(avg_wages)) AS avg_wages 
	FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.at_year IN (2006, 2018)
GROUP BY prwa.at_year) AS sel_2
ON sel_1.at_year = sel_2.at_year;

