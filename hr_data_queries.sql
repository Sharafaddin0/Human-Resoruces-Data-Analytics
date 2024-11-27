-- Create a table and import the raw data
CREATE TABLE IF NOT EXISTS hr_table(
	employee_num INT8 PRIMARY KEY,
	gender VARCHAR(30) NOT NULL,
	marital_status VARCHAR(30),
	age_band VARCHAR(30),
	age INT8,
	department VARCHAR(30),
	education VARCHAR(30),
	education_field VARCHAR(30),
	job_role VARCHAR(30),
	business_travel VARCHAR(30),
	employee_count INT8,
	attrition VARCHAR(30),
	attrition_label VARCHAR(30),
	job_satisfaction INT8, 
	active_employee INT8	
);

-- Check the data again
SELECT *
FROM hr_table;

-- ------------------------------------------------------------------------------------------------------ --
-- ----------------------------------------KPI's Requirements-------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------ --

-- 1. Employee Count
SELECT COUNT(*) AS total_num_of_employees
FROM hr_table;

-- 2. Attrition Count
SELECT COUNT(attrition) AS num_of_attritions
FROM hr_table
WHERE attrition = 'Yes';

-- 3. Attrition Rate
SELECT ROUND(((
	SELECT CAST(COUNT(attrition) AS numeric)
	FROM hr_table
	WHERE attrition = 'Yes' )/ SUM(employee_count)) * 100, 2)  AS attrition_rate	
FROM hr_table;

-- 4. Active Employees
SELECT COUNT(employee_count) AS active_employees
FROM hr_table
WHERE active_employee = 1;

-- 5. Average Age
SELECT ROUND(AVG(age), 0)
FROM hr_table;

-- ------------------------------------------------------------------------------------------------------ --
-- --------------------------------------CHART's Requirements-------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------ --

-- 1. Attrition by Gender
SELECT gender,
	COUNT(attrition) AS attrition
FROM hr_table
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY attrition DESC;

-- 2. Department-wise Attrition
SELECT department, COUNT(attrition), 
	round((CAST (COUNT(attrition) AS numeric) / 
	(SELECT COUNT(attrition) FROM hr_table WHERE attrition= 'Yes')) * 100, 2) AS pct FROM hr_table
WHERE attrition='Yes'
GROUP BY department 
ORDER BY COUNT(attrition) DESC;

-- 3. Number of Employees by Age Group
SELECT 
	age_band,
	COUNT(employee_count) AS num_employees
FROM hr_table
GROUP BY age_band
ORDER BY num_employees DESC;

-- 4. Job Satisfaction Ratings
SELECT *
FROM crosstab(
	'SELECT job_role, job_satisfaction, sum(employee_count)
	FROM hr_table
	GROUP BY job_role, job_satisfaction
	ORDER BY job_role, job_satisfaction'
   	) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;
-- If crosstab is not working we must insert following:
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- 5. Education Field-wise Attrition
SELECT education_field,
	COUNT(attrition) AS num_attrition
FROM hr_table
GROUP BY education_field
ORDER BY num_attrition DESC;

-- 6. Attrition Rate by Gender for Different Age Groups
SELECT age_band, gender, 
	COUNT(attrition) AS num_attrition,
	ROUND((CAST(COUNT(attrition) AS numeric) / (
	SELECT COUNT(attrition)
	FROM hr_table
	WHERE attrition = 'Yes')) * 100, 2) AS percentage
FROM hr_table
GROUP BY age_band, gender
ORDER BY age_band DESC;
FROM hr_table
