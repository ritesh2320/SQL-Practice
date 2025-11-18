/* 
FILE EXECUTION: Get-Content rank_value_aggregate_functions.sql | mysql -u root -p
DESCRIPTION: full_ranking_demo.sql
Complete SQL script for ALL ranking & window functions
Includes: RANK, DENSE_RANK, ROW_NUMBER, NTILE, PERCENT_RANK,
          CUME_DIST, LAG, LEAD, FIRST_VALUE, LAST_VALUE,
          NTH_VALUE, SUM() OVER, AVG() OVER, COUNT() OVER...
*/

CREATE DATABASE IF NOT EXISTS ranking_demo;
USE ranking_demo;

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

INSERT INTO employees (id, name, department, salary) VALUES
(1, 'Alice',    'Sales',    90000),
(2, 'Bob',      'Sales',    90000),
(3, 'Carol',    'Sales',    80000),
(4, 'Dave',     'HR',       75000),
(5, 'Eve',      'HR',       75000),
(6, 'Frank',    'HR',       70000),
(7, 'Grace',    'Engineering', 120000),
(8, 'Heidi',    'Engineering', 110000),
(9, 'Ivan',     'Engineering', 110000),
(10,'Judy',     'Engineering', 95000),
(11,'Karl',     'Marketing', 65000),
(12,'Leo',      'Marketing', 60000);


-- -----------------------------------------------------------
-- 1. BASIC RANKING FUNCTIONS
-- -----------------------------------------------------------
SELECT
    id, name, department, salary,
    RANK()        OVER (PARTITION BY department ORDER BY salary DESC) AS rank_salary,
    DENSE_RANK()  OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_salary,
    ROW_NUMBER()  OVER (PARTITION BY department ORDER BY salary DESC) AS row_num_salary
FROM employees
ORDER BY department, salary DESC;

/*
Sample Output:
+----+-------+-------------+--------+-------------+-------------------+----------------+
| id | name  | department  | salary | rank_salary | dense_rank_salary | row_num_salary|
+----+-------+-------------+--------+-------------+-------------------+----------------+
| 1  | Alice | Sales       | 90000  |     1       |         1         |        1       |
| 2  | Bob   | Sales       | 90000  |     1       |         1         |        2       |
| 3  | Carol | Sales       | 80000  |     3       |         2         |        3       |
...
*/

/*
-----------------------------------------------------------
-- 2. PERCENT_RANK() AND CUME_DIST()
-----------------------------------------------------------
*/

SELECT
    id, name, department, salary,
    PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS `percent_rank`,
    CUME_DIST()    OVER (PARTITION BY department ORDER BY salary DESC) AS `cume_dist`
FROM employees
ORDER BY department, salary DESC;

/*
Explanation:
PERCENT_RANK = (rank-1) / (total_rows-1)
CUME_DIST    = cumulative distribution
*/

/*
-----------------------------------------------------------
-- 3. NTILE() FUNCTION
-----------------------------------------------------------
*/
SELECT
    id, name, department, salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees
ORDER BY salary DESC;

/*
NTILE(4) divides employees into 4 salary groups (quartiles)
*/

/*
-----------------------------------------------------------
-- 4. VALUE WINDOW FUNCTIONS (LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE)
-----------------------------------------------------------
*/
SELECT
    id, name, department, salary,
    LAG(salary, 1)  OVER (ORDER BY salary DESC) AS prev_salary,
    LEAD(salary, 1) OVER (ORDER BY salary DESC) AS next_salary,
    FIRST_VALUE(salary) OVER (ORDER BY salary DESC) AS highest_salary,
    LAST_VALUE(salary)  OVER (ORDER BY salary DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_salary,
    NTH_VALUE(salary, 3) OVER (ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS third_highest_salary
FROM employees
ORDER BY salary DESC;

/*
-----------------------------------------------------------
-- 5. AGGREGATE WINDOW FUNCTIONS (RUNNING TOTALS)
-----------------------------------------------------------
*/
SELECT
    id, name, department, salary,
    SUM(salary)  OVER (ORDER BY salary DESC) AS running_total_salary,
    AVG(salary)  OVER (ORDER BY salary DESC) AS running_avg_salary,
    COUNT(*)     OVER (ORDER BY salary DESC) AS running_count,
    MIN(salary)  OVER (ORDER BY salary DESC) AS running_min,
    MAX(salary)  OVER (ORDER BY salary DESC) AS running_max
FROM employees
ORDER BY salary DESC;

/*
-------------------------------------------------------------
-- 6. TOP-N Query Example (Top 2 per department)
-------------------------------------------------------------
-- This example demonstrates how to find the top N rows within each group.
-- Use ROW_NUMBER() to assign sequential numbers within each department,
-- then filter for rows where rn <= 2 to get top 2 employees per department.
-- ROW_NUMBER() ensures exactly 2 rows per department (no ties).
-- If you have salary ties, ROW_NUMBER() will still pick only 2 rows based on order.
*/
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT id, name, department, salary
FROM ranked
WHERE rn <= 2
ORDER BY department, rn;
/*
Output Example:
- Alice (Sales, 90000) - rank 1
- Bob (Sales, 90000) - rank 2
- Grace (Engineering, 120000) - rank 1
- Heidi (Engineering, 110000) - rank 2
...and so on for each department
*/

/*
-------------------------------------------------------------
-- 7. RANK() For Ties Example
-------------------------------------------------------------
-- This example shows how RANK() differs from ROW_NUMBER() when handling ties.
-- RANK() assigns the same rank to employees with equal salaries within a department.
-- If two employees share rank 1, the next employee gets rank 3 (not rank 2).
-- Use this when you want to include all employees with tied ranks <= 2.
-- Note: This may return more than 2 rows per department if there are salary ties.

*/
WITH r AS (
    SELECT *,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT id, name, department, salary
FROM r
WHERE rnk <= 2
ORDER BY department, rnk;
/*
Output Example (with ties):
- Alice (Sales, 90000) - rank 1
- Bob (Sales, 90000) - rank 1 (tied with Alice)
- Carol (Sales, 80000) - rank 3 (not 2, because two people shared rank 1)
- Grace (Engineering, 120000) - rank 1
- Heidi (Engineering, 110000) - rank 2
- Ivan (Engineering, 110000) - rank 2 (tied with Heidi)
*/

