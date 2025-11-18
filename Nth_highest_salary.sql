CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    Declare offset_val INT;
    SET offset_val = N-1;
RETURN (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET offset_val
);
END;

-- another approach
-- SELECT (
--     SELECT DISTINCT salary
--     FROM Employee
--     ORDER BY salary DESC
--     LIMIT 1 OFFSET N-1
-- ) AS nth_highest_salary;

-- OR

-- SELECT (
--     SELECT DISTINCT salary
--     FROM Employee
--     ORDER BY salary DESC
--     LIMIT (N-1), 1
-- ) AS nth_highest_salary;


/* 

177. Nth Highest Salary
Attempted
Medium
Topics
premium lock icon
Companies
SQL Schema
Pandas Schema
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the nth highest distinct salary from the Employee table. If there are less than n distinct salaries, return null.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| null                   |
+------------------------+

*/