SELECT DISTINCT num AS ConsecutiveNums
From (SELECT id,
            num,
            LEAD(num,1) OVER (ORDER BY id) AS nxt1,
            LEAD(num,2) OVER (ORDER BY id) AS nxt2
            FROM LOGS
)t
WHERE num=nxt1 && num=nxt2

-- OR

select distinct num as ConsecutiveNums
from
(select num ,
lag(num) over() as prev,
lead(num) over() as nxt
from logs) as t
where
num-prev=0
and 
num-nxt=0

-- OR

select distinct a.num as ConsecutiveNums from Logs a
join Logs b on a.num = b.num and b.id=a.id+1
join Logs c on a.num = c.num and c.id=a.id+2

-- OR
SELECT
DISTINCT(l1.num) as ConsecutiveNums
FROM 
Logs l1,
Logs l2,
Logs l3
WHERE 
l1.num=l2.num AND
l2.num=l3.num AND
l1.id=L2.id+1 AND
l2.id=l3.id+1

/* 

Explanation:
We use the LEAD() function to look ahead at the next two rows (nxt1 and nxt2) ordered by id.
If the current num is equal to both nxt1 and nxt2, it means that the number appears at least three times consecutively.
We select DISTINCT num to avoid duplicates in the final result.

*/



/*  
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.

 */