-- Using DISTINCT + ORDER BY + LIMIT/OFFSET

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;


/*
Logic:

Sort salaries in descending order

Skip the highest (OFFSET 1)

Take the next one (LIMIT 1)
*/