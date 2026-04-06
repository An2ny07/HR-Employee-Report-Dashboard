-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT 
    gender, 
    COUNT(*) AS count
FROM hr
WHERE age >= 18 
  AND (termdate IS NULL OR termdate = '')
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT 
    race AS Race,
    COUNT(*) AS Count
FROM hr
WHERE age >= 18
  AND race IS NOT NULL
GROUP BY race
ORDER BY Count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
    CASE        
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    gender,
    COUNT(*) AS count
FROM hr 
WHERE age >= 18
GROUP BY age_group, gender
ORDER BY 
    CASE 
        WHEN age_group = '18-24' THEN 1
        WHEN age_group = '25-34' THEN 2
        WHEN age_group = '35-44' THEN 3
        WHEN age_group = '45-54' THEN 4
        WHEN age_group = '55-64' THEN 5
        ELSE 6
    END,
    gender;
    
-- 4. How many employees work at headquarters versus remote locations?
SELECT 
    location,
    COUNT(*) AS count
FROM hr
GROUP BY location
ORDER BY count DESC;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
    ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_length_employment
FROM hr
WHERE termdate IS NOT NULL
  AND termdate <= CURDATE()
  AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT 
    department, 
    gender, 
    COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department, gender;

-- 7. What is the distribution of job titles across the company?
SELECT 
    jobtitle, 
    COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY count DESC; 

-- 8. Which department has the highest turnover rate?
SELECT 
    department, 
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate
FROM (
    SELECT 
        department,
        COUNT(*) AS total_count,
        SUM(
            CASE 
                WHEN termdate IS NOT NULL 
                     AND termdate <= CURDATE() 
                THEN 1 
                ELSE 0 
            END
        ) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT 
    location_state, 
    COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY location_state 
ORDER BY count DESC;	

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM (
    SELECT    
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(
            CASE 
                WHEN termdate IS NOT NULL 
                     AND termdate <= CURDATE()
                THEN 1 
                ELSE 0 
            END
        ) AS terminations
    FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT 
    department, 
    ROUND(
        AVG(
            DATEDIFF(
                COALESCE(termdate, CURDATE()), 
                hire_date
            ) / 365
        ), 
    0) AS avg_tenure
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY avg_tenure DESC;