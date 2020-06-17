-- Question 68
-- Table: Queue

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | person_id   | int     |
-- | person_name | varchar |
-- | weight      | int     |
-- | turn        | int     |
-- +-------------+---------+
-- person_id is the primary key column for this table.
-- This table has the information about all people waiting for an elevator.
-- The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
 

-- The maximum weight the elevator can hold is 1000.

-- Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

-- The query result format is in the following example:

-- Queue table
-- +-----------+-------------------+--------+------+
-- | person_id | person_name       | weight | turn |
-- +-----------+-------------------+--------+------+
-- | 5         | George Washington | 250    | 1    |
-- | 3         | John Adams        | 350    | 2    |
-- | 6         | Thomas Jefferson  | 400    | 3    |
-- | 2         | Will Johnliams    | 200    | 4    |
-- | 4         | Thomas Jefferson  | 175    | 5    |
-- | 1         | James Elephant    | 500    | 6    |
-- +-----------+-------------------+--------+------+

-- Result table
-- +-------------------+
-- | person_name       |
-- +-------------------+
-- | Thomas Jefferson  |
-- +-------------------+

-- Queue table is ordered by turn in the example for simplicity.
-- In the example George Washington(id 5), John Adams(id 3) and Thomas Jefferson(id 6) will enter the elevator as their weight sum is 250 + 350 + 400 = 1000.
-- Thomas Jefferson(id 6) is the last person to fit in the elevator because he has the last turn in these three people.
-- Solution
With t1 as
(
select *,
sum(weight) over(order by turn) as cum_weight
from queue
order by turn)

select t1.person_name
from t1
where turn = (select max(turn) from t1 where t1.cum_weight<=1000)

