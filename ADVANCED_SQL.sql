SELECT 

    job_title_short,
    company_id,
    job_location

FROM job_postings_january

UNION ALL

SELECT 

    job_title_short,
    company_id,
    job_location

FROM job_postings_february

UNION ALL

SELECT 

    job_title_short,
    company_id,
    job_location

FROM job_postings_march

----------------------

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date :: DATE,
    salary_year_avg
FROM 

    (SELECT *
    FROM job_postings_january  

    UNION ALL

    SELECT *
    FROM job_postings_february 

    UNION ALL

    SELECT *
    FROM job_postings_march  ) AS quarter_job_postings

WHERE 

salary_year_avg > 70000 AND
job_title_short = 'Data Analyst'

ORDER BY salary_year_avg DESC;

------------------------

SELECT 

    job_title_short,
    EXTRACT(MONTH FROM job_posted_date) AS posted_month,
    AVG(salary_year_avg) AS Average_salary

FROM job_postings_january

WHERE 

    job_title_short = 'Data Analyst'


  GROUP BY  posted_month, job_title_short


  HAVING 
    AVG(salary_year_avg) > 70000


UNION ALL

SELECT 

   job_title_short,
   EXTRACT(MONTH FROM job_posted_date) AS posted_month,
    AVG(salary_year_avg) AS Average_salary

FROM job_postings_february

WHERE 

    job_title_short = 'Data Analyst'

GROUP BY  posted_month, job_title_short

  HAVING 
    AVG(salary_year_avg) > 70000

  

UNION ALL

SELECT 

   job_title_short,
   EXTRACT(MONTH FROM job_posted_date) AS posted_month,
    AVG(salary_year_avg) AS Average_salary

FROM job_postings_march

WHERE 

    job_title_short = 'Data Analyst'

GROUP BY  posted_month, job_title_short

  HAVING 
    AVG(salary_year_avg) > 70000

  ORDER BY posted_month DESC

----------------------------

select 

     skills_dim.skills AS Skills,
     skills_job_dim.Skill_count

FROM 

(SELECT 

skill_id,
    
COUNT(*) AS Skill_count

FROM skills_job_dim

GROUP BY skill_id

ORDER BY Skill_count DESC

LIMIT 5) skills_job_dim


LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id;

----------- New code

SELECT
    Company_id,
    job_posting_count,

CASE

WHEN job_posting_count > 50 THEN 'Large'
WHEN job_posting_count BETWEEN 10 AND 50 THEN 'Medium'
WHEN job_posting_count <10 THEN 'SMALL'

END AS size_category


FROM(

SELECT 

      company_id,
      count(*) as job_posting_count


FROM job_postings_fact

GROUP BY company_id);
    

--------------- NEW CODE ---------------------------

SELECT 

CASE 

    When job_location = 'Anywhere' THEN 'Remote'
    When job_location = 'New York,NY' THEN 'Local'
    ELSE 'On-site'
END AS Job_category,
   
job_id,

COUNT(*) as no_of_postings

FROM job_postings_fact

GROUP BY job_id

-----------------------------------------------


WITH remote_jobs_skills AS

(

SELECT 

   skill_id,
   count(job_postings.job_id) AS count_of_skills

FROM skills_job_dim AS skills_to_job

INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id 

WHERE job_work_from_home = true AND 
      job_title_short = 'Data Analyst'

GROUP BY skill_id

)

select 

skills_dim.skill_id,
skills,
count_of_skills



FROM remote_jobs_skills

INNER JOIN skills_dim ON skills_dim.skill_id = remote_jobs_skills.skill_id

ORDER BY count_of_skills DESC

LIMIT 5;

---------------------

SELECT 

company_id,
company_dim.name AS Company_name,


 FROM company_dim

------- new code for CTES




WITH no_of_company_jobs AS (
SELECT

company_id,

COUNT(*) as total_postings

FROM job_postings_fact

GROUP BY company_id
)

select company_dim.name AS company_name,
        no_of_company_jobs.total_postings


FROM company_dim

LEFT JOIN no_of_company_jobs ON no_of_company_jobs.company_id = company_dim.company_id

ORDER BY total_postings desc;


 -----------------------

 SELECT 
* 
FROM 

(SELECT *

FROM job_postings_fact

WHERE EXTRACT(MONTH FROM job_posted_date)  = 1

) as january_jobs;
       
 ------ about subqueries

 SELECT 
        company_id,
        company_dim.name as Company_name
        

 FROM  company_dim

 WHERE 
    company_id IN 

    (select   
       company_id

    FROM 
    job_postings_fact

    WHERE 
    job_no_degree_mention = true
    
    ORDER BY company_id)

---------------------------------

SELECT 
        COUNT(job_id) AS number_of_jobpostings,
        job_title_short,
        CASE
            WHEN salary_year_avg > 100000 THEN 'High'
            WHEN salary_year_avg BETWEEN 70000 AND 100000 THEN 'Medium'
            ELSE 'Low'
        END AS Salary_range
    FROM 
        job_postings_fact

        WHERE 
            job_title_short = 'Data Analyst'
    GROUP BY 
      Salary_range , job_title_short

   ORDER BY number_of_jobpostings DESC ;



      

      