-- Question 83
-- Table: Transactions

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | country       | varchar |
-- | state         | enum    |
-- | amount        | int     |
-- | trans_date    | date    |
-- +---------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
 

-- Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

-- The query result format is in the following example:

-- Transactions table:
-- +------+---------+----------+--------+------------+
-- | id   | country | state    | amount | trans_date |
-- +------+---------+----------+--------+------------+
-- | 121  | US      | approved | 1000   | 2018-12-18 |
-- | 122  | US      | declined | 2000   | 2018-12-19 |
-- | 123  | US      | approved | 2000   | 2019-01-01 |
-- | 124  | DE      | approved | 2000   | 2019-01-07 |
-- +------+---------+----------+--------+------------+

-- Result table:
-- +----------+---------+-------------+----------------+--------------------+-----------------------+
-- | month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
-- +----------+---------+-------------+----------------+--------------------+-----------------------+
-- | 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
-- | 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
-- | 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
-- +----------+---------+-------------+----------------+--------------------+-----------------------+

-- Solution
with t1 as(
select DATE_FORMAT(trans_date,'%Y-%m') as month, country, count(state) as trans_count, sum(amount) as trans_total_amount
from transactions
group by country, month(trans_date)),

t2 as (
Select DATE_FORMAT(trans_date,'%Y-%m') as month, country, count(state) as approved_count, sum(amount) as approved_total_amount
from transactions
where state = 'approved'
group by country, month(trans_date))

select t1.month, t1.country, coalesce(t1.trans_count,0) as trans_count, coalesce(t2.approved_count,0) as approved_count, coalesce(t1.trans_total_amount,0) as trans_total_amount, coalesce(t2.approved_total_amount,0) as approved_total_amount
from t1 left join t2
on t1.country = t2.country and t1.month = t2.month