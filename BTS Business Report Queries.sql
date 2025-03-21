-- This query shows customer feeback based on the city
SELECT:
    customer.city, 
    AVG(customer_feedback.rating) AS average_rating, 
    COUNT(customer_feedback.feedback_id) AS total_feedbacks
FROM customer
INNER JOIN customer_feedback ON customer.customer_id = customer_feedback.customer_id
GROUP BY customer.city
ORDER BY average_rating ASC;

-- This query shows employee availability to track their workload
SELECT e.employee_id AS [Employee ID], e.f_name AS Employee, e.work_hours_per_week AS [Working Hours], NZ(SUM(et.hours_allocated_per_week), 0) AS [Total Workload], (e.work_hours_per_week - NZ(SUM(et.hours_allocated_per_week), 0)) AS [Remaining Available Hours]
FROM employee AS e LEFT JOIN (employee_task AS et LEFT JOIN project_task AS pt ON et.task_id = pt.task_id) ON e.employee_id = et.employee_id
WHERE et.completion_date IS NULL
GROUP BY e.employee_id, e.f_name, e.work_hours_per_week;

-- This query pulls employess, their office location, and their skills in order to know which employees at each office
-- have the proper skills for a particular project
SELECT e.employee_id AS [Employee ID], e.f_name AS Employee, e.office_id AS [Office ID], s.skill_name AS [Skill], es.proficiency_level AS [Proficiency Level]
FROM (employee AS e 
      INNER JOIN 
      (SELECT * FROM employee_skill) AS es 
      ON e.employee_id = es.employee_id) 
INNER JOIN 
(SELECT * FROM skill) AS s 
ON es.skill_id = s.skill_id
WHERE s.skill_name = 'Python';

-- This query pulls customer information, including their location, customer rating, associated projects, and number of projects. This report can
-- tell us both how locations ar eperfomrong with their customers as well as how busy each location is and where there may be rooms for 
-- improvement
SELECT 
customer.company_name, customer.city, customer.state, customer_feedback.rating, customer_feedback.feedback_date, project.project_name, employee.f_name, employee.l_name, project_task.task_description
FROM
 ((customer INNER JOIN customer_feedback ON customer.customer_id = customer_feedback.customer_id) 
INNER JOIN 
project ON (project.[project_id (PK)] = customer_feedback.project_id) AND (customer.customer_id = project.[customer_id (FK)])) 
INNER JOIN 
((project_task INNER JOIN (employee INNER JOIN employee_task ON employee.employee_id = employee_task.employee_id) ON project_task.task_id = employee_task.task_id) 
INNER JOIN task_project_association ON project_task.task_id = task_project_association.task_id) ON project.[project_id (PK)] = task_project_association.project_id
GROUP BY
 customer.company_name, customer.city, customer.state, customer_feedback.rating, customer_feedback.feedback_date, project.project_name, employee.f_name, employee.l_name, project_task.task_description
ORDER BY 
Customer.company_name;



