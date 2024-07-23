
/*
 * Výzkumná otázka č. 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */




-- průměrná mzda na přepočtený a fyzický počet zaměstnanců - ukázka pro odvětví A a rok 2000


SELECT 
	industry_branch_code, 
	calculation_code ,
	payroll_year ,
	payroll_quarter,
	value 
FROM czechia_payroll cp 
WHERE value_type_code = 5958 AND industry_branch_code = 'A' AND payroll_year = 2000
ORDER BY 
	payroll_quarter ;



-- primární tabulka pro mzdy a ceny - roky 2006 až 2018


CREATE TABLE t_stanislav_weissmann__project_SQL_primary_final AS
SELECT  
	YEAR(cp.date_from) AS at_year,
    cpc.name AS name_of_product,
    ROUND(AVG(cp.value), 2) AS avg_price,
    NULL AS name_of_industry_branch,
    NULL AS avg_wages
FROM 
    czechia_price cp
LEFT JOIN 
    czechia_price_category cpc 
ON 
    cp.category_code = cpc.code
WHERE 
    cp.region_code IS NOT NULL 
GROUP BY 
    cp.category_code,
    YEAR(cp.date_from)
UNION
SELECT
	cp.payroll_year, 
	NULL AS name_of_product,
	NULL AS avg_price,
	cpib.name AS name_of_industry_branch,
	round(avg(cp.value)) AS avg_wages	
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib 
ON cp.industry_branch_code = cpib.code 
WHERE cp.value_type_code = 5958 AND cp.calculation_code = 200 AND cp.payroll_year BETWEEN 2006 AND 2018
AND cp.industry_branch_code IS NOT NULL 
GROUP BY 
	cp.industry_branch_code,
	cp.payroll_year;




-- vývoj ve všech odvětvích 


SELECT 
	sel_1.name_of_industry_branch,
	sel_1.year_current,
	sel_1.avg_wages_current,
	sel_2.year_previous,
	sel_2.avg_wages_previous,
	round((sel_1.avg_wages_current - sel_2.avg_wages_previous)/sel_2.avg_wages_previous * 100, 2) AS wages_growth_percent
FROM 
(SELECT 												
	prwa.at_year AS year_current,
	prwa.name_of_industry_branch,
	prwa.avg_wages AS avg_wages_current
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL) AS sel_1
JOIN 
(SELECT 
	prwa.at_year AS year_previous,
	prwa.name_of_industry_branch,
	prwa.avg_wages AS avg_wages_previous
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL) AS sel_2
ON sel_1.year_current = sel_2.year_previous + 1 AND 
	sel_1.name_of_industry_branch = sel_2.name_of_industry_branch;




-- případy, kdy pokles mezd 


SELECT 
	sel_1.name_of_industry_branch,
	sel_1.year_current,
	round((sel_1.avg_wages_current - sel_2.avg_wages_previous)/sel_2.avg_wages_previous * 100, 2) AS wages_growth_percent
FROM 
(SELECT 
	prwa.at_year AS year_current,
	prwa.name_of_industry_branch,
	prwa.avg_wages AS avg_wages_current
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL) AS sel_1
JOIN 
(SELECT 
	prwa.at_year AS year_previous,
	prwa.name_of_industry_branch,
	prwa.avg_wages AS avg_wages_previous
FROM t_stanislav_weissmann__project_sql_primary_final AS prwa
WHERE prwa.name_of_industry_branch IS NOT NULL) AS sel_2
ON sel_1.year_current = sel_2.year_previous + 1 AND 
	sel_1.name_of_industry_branch = sel_2.name_of_industry_branch
WHERE (sel_1.avg_wages_current - sel_2.avg_wages_previous)/sel_2.avg_wages_previous < 0			--	pokles mezd
ORDER BY
	(sel_1.avg_wages_current - sel_2.avg_wages_previous)/sel_2.avg_wages_previous * 100 ASC ;




