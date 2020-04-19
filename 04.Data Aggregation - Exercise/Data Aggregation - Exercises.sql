#01. Records’ Count
SELECT COUNT(*) FROM wizzard_deposits;

#02. Longest Magic Wand
SELECT MAX(magic_wand_size) AS 'longest_magic_wand'
FROM wizzard_deposits;

#03. Longest Magic Wand per Deposit 
SELECT deposit_group, 
MAX(magic_wand_size) AS 'longest_magic_wand'
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand, deposit_group;

#04. Smallest Deposit Group per Magic Wand Size
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY  AVG(magic_wand_size)
LIMIT 1;

#05. Deposits Sum
SELECT deposit_group, 
SUM(deposit_amount) AS 'total_sum'
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

#06. Deposits Sum for Ollivander Family
SELECT deposit_group, 
SUM(deposit_amount)
FROM wizzard_deposits
WHERE magic_wand_creator= 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

#07. Deposits Filter
SELECT deposit_group, 
SUM(deposit_amount) AS 'total_sum'
FROM wizzard_deposits
WHERE magic_wand_creator= 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum<150000
ORDER BY total_sum DESC;

#08. Deposit Charge
SELECT deposit_group, magic_wand_creator,
MIN(deposit_charge) AS 'min_deposit_charge'
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

#09. Age Groups
SELECT 
    (CASE
        WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END) AS 'age_group',
    COUNT(*) AS 'wizard_count'
FROM
    wizzard_deposits
GROUP BY age_group
ORDER BY age_group;

#10. First Letter
SELECT LEFT(first_name, 1) AS 'first_letter'
FROM wizzard_deposits
WHERE deposit_group = 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter;

#11. Average Interest
SELECT deposit_group, is_deposit_expired, 
AVG(deposit_interest) AS 'average_interest'
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

#12. Rich Wizard, Poor Wizard
SELECT SUM(diff.next) AS 'sum_difference'
FROM (SELECT deposit_amount -
             (SELECT deposit_amount
              FROM wizzard_deposits
              WHERE id = wd.id + 1) AS 'next'
      FROM wizzard_deposits AS wd) AS diff;
      
#13. Employees Minimum Salaries
SELECT department_id, MIN(salary) AS 'minimum_salary'
FROM employees
WHERE hire_date > '2000-01-01' 
AND department_id IN (2,5,7) 
GROUP BY department_id
ORDER BY department_id;

#14. Employees Average Salaries
CREATE TABLE high_paid_employees AS 
SELECT* FROM employees
WHERE salary > 30000 AND manager_id !=42;

UPDATE high_paid_employees
SET salary=salary+5000
WHERE department_id = 1;

SELECT department_id, AVG(salary)
FROM high_paid_employees
GROUP BY department_id
ORDER BY department_id;

#15. Employees Maximum Salaries
SELECT department_id, MAX(salary) AS 'max_salary'
FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

#16. Employees Count Salaries
SELECT COUNT(*) AS ''
FROM employees
WHERE manager_id IS NULL;

#17. 3rd Highest Salary
SELECT department_id,
    (SELECT DISTINCT e2.salary
        FROM employees AS e2
        WHERE e2.department_id = e1.department_id
        ORDER BY e2.salary DESC
        LIMIT 2 , 1) AS third_highest_salary
FROM employees AS e1
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;

#18. Salary Challenge
SELECT e.first_name, e.last_name, e.department_id
FROM employees AS e
WHERE salary > (
SELECT AVG(e2.salary)
FROM employees AS e2
WHERE e2.department_id = e.department_id
GROUP BY e2.department_id
)
ORDER BY e.department_id, e.employee_id
LIMIT 10;

#19. Departments Total Salaries
SELECT department_id, SUM(salary) AS 'total_salary'
FROM employees
GROUP BY department_id
ORDER BY department_id;