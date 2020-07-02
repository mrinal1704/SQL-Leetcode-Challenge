-- Question 116
-- Table Activities:

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | sell_date   | date    |
-- | product     | varchar |
-- +-------------+---------+
-- There is no primary key for this table, it may contains duplicates.
-- Each row of this table contains the product name and the date it was sold in a market.
 

-- Write an SQL query to find for each date, the number of distinct products sold and their names.

-- The sold-products names for each date should be sorted lexicographically. 

-- Return the result table ordered by sell_date.

-- The query result format is in the following example.

-- Activities table:
-- +------------+-------------+
-- | sell_date  | product     |
-- +------------+-------------+
-- | 2020-05-30 | Headphone   |
-- | 2020-06-01 | Pencil      |
-- | 2020-06-02 | Mask        |
-- | 2020-05-30 | Basketball  |
-- | 2020-06-01 | Bible       |
-- | 2020-06-02 | Mask        |
-- | 2020-05-30 | T-Shirt     |
-- +------------+-------------+

-- Result table:
-- +------------+----------+------------------------------+
-- | sell_date  | num_sold | products                     |
-- +------------+----------+------------------------------+
-- | 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
-- | 2020-06-01 | 2        | Bible,Pencil                 |
-- | 2020-06-02 | 1        | Mask                         |
-- +------------+----------+------------------------------+
-- For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by comma.
-- For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by comma.
-- For 2020-06-02, Sold item is (Mask), we just return it.

-- Solution
select sell_date, count(distinct product) as num_sold, group_concat(distinct product) as products
from activities
group by 1
order by 1