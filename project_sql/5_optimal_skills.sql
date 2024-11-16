
WITH skills_demand AS
(
   select 
   skills_dim.skill_id,
   skills_dim.skills,
   count(skills_job_dim.job_id) AS demand_count

   from 
      job_postings_fact

   INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
   INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id

   WHERE 
      job_title_short = 'Data Analyst' AND
      salary_year_avg IS NOT NULL AND
      job_work_from_home IS TRUE 
   GROUP BY skills_dim.skill_id  
),

 Average_sal AS (

   select 
      skills_dim.skill_id,
      skills_dim.skills,
      Round(AVG(salary_year_avg),0) AS Average_salary

   from 
      job_postings_fact

   INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
   INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id

   WHERE 
      job_title_short = 'Data Analyst' AND
      salary_year_avg IS NOT NULL AND
      job_work_from_home is TRUE
   GROUP BY skills_dim.skill_id


)

SELECT 
      skills_demand.skill_id,
      skills_demand.skills,
      demand_count,
      Average_salary

FROM 
      skills_demand

INNER JOIN Average_sal ON skills_demand.skill_id = average_sal.skill_id

WHERE demand_count > 10
ORDER BY 

Average_salary DESC,
demand_count DESC
         
LIMIT 25


-- more precise coding 

SELECT

skills_dim.skill_id,
skills_dim.skills,
COUNT(skills_job_dim.job_id) AS demand_count,
ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary

FROM job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim. job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
   job_title_short = 'Data Analyst'
   AND salary_year_avg IS NOT NULL
   AND job_work_from_home = True

GROUP BY
   skills_dim.skill_id
HAVING
   COUNT(skills_job_dim.job_id) > 10
ORDER BY
   avg_salary DESC,
demand_count DESC
LIMIT 25;