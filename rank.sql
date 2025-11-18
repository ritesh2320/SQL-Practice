-- rank.sql
-- Sample SQL demonstrating ranking/window functions
-- Creates a table, inserts sample data, and shows RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()

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

-- Compare ranking functions partitioned by department (highest salary = rank 1)
SELECT
    id,
    name,
    department,
    salary,
    RANK()      OVER (PARTITION BY department ORDER BY salary DESC) AS rank_by_salary,
    DENSE_RANK()OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_by_salary,
    ROW_NUMBER()OVER (PARTITION BY department ORDER BY salary DESC, id) AS row_number_in_dept
FROM employees
ORDER BY department, salary DESC, id;

-- Example: top 2 employees per department using ROW_NUMBER()
WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC, id) AS rn
    FROM employees
)
SELECT id, name, department, salary
FROM ranked
WHERE rn <= 2
ORDER BY department, rn;

-- Using RANK() to include ties (top 2 ranks per department, may return more than 2 rows if ties)
WITH r AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT id, name, department, salary
FROM r
WHERE rnk <= 2
ORDER BY department, rnk;

-- NTILE example: split all employees into 3 buckets by salary (1 = highest salaries)
SELECT
    id, name, department, salary,
    NTILE(3) OVER (ORDER BY salary DESC) AS salary_bucket
FROM employees
ORDER BY salary DESC;