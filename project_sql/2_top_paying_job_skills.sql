
WITH top_paying_jobs AS (

         SELECT 
        company_dim.name as Company_name,
        job_id,
        job_title,
        salary_year_avg

    FROM

        job_postings_fact

    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id

    WHERE job_title_short= 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL

    ORDER BY salary_year_avg DESC
    LIMIT 10
   )

select 
    top_paying_jobs.*,
    skills


 from 
    top_paying_jobs

INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
order by salary_year_avg DESC