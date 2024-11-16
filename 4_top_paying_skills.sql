select 
   skills,
   Round(AVG(salary_year_avg),0) AS Average_salary

 from 
    job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id

WHERE 
     job_title_short = 'Data Analyst' AND
     salary_year_avg IS NOT NULL
     -- job_work_from_home is TRUE
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25