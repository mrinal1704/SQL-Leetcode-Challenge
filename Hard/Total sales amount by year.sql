-- Question 114
-- Table: Product

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- product_name is the name of the product.
 

-- Table: Sales

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | product_id          | int     |
-- | period_start        | varchar |
-- | period_end          | date    |
-- | average_daily_sales | int     |
-- +---------------------+---------+
-- product_id is the primary key for this table. 
-- period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
-- The average_daily_sales column holds the average daily sales amount of the items for the period.

-- Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

-- Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.

-- The query result format is in the following example:


-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 1          | LC Phone     |
-- | 2          | LC T-Shirt   |
-- | 3          | LC Keychain  |
-- +------------+--------------+

-- Sales table:
-- +------------+--------------+-------------+---------------------+
-- | product_id | period_start | period_end  | average_daily_sales |
-- +------------+--------------+-------------+---------------------+
-- | 1          | 2019-01-25   | 2019-02-28  | 100                 |
-- | 2          | 2018-12-01   | 2020-01-01  | 10                  |
-- | 3          | 2019-12-01   | 2020-01-31  | 1                   |
-- +------------+--------------+-------------+---------------------+

-- Result table:
-- +------------+--------------+-------------+--------------+
-- | product_id | product_name | report_year | total_amount |
-- +------------+--------------+-------------+--------------+
-- | 1          | LC Phone     |    2019     | 3500         |
-- | 2          | LC T-Shirt   |    2018     | 310          |
-- | 2          | LC T-Shirt   |    2019     | 3650         |
-- | 2          | LC T-Shirt   |    2020     | 10           |
-- | 3          | LC Keychain  |    2019     | 31           |
-- | 3          | LC Keychain  |    2020     | 31           |
-- +------------+--------------+-------------+--------------+
-- LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
-- LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
-- LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.

-- Solution
SELECT
    b.product_id,
    a.product_name,
    a.yr AS report_year,
    CASE 
        WHEN YEAR(b.period_start)=YEAR(b.period_end) AND a.yr=YEAR(b.period_start) THEN DATEDIFF(b.period_end,b.period_start)+1
        WHEN a.yr=YEAR(b.period_start) THEN DATEDIFF(DATE_FORMAT(b.period_start,'%Y-12-31'),b.period_start)+1
        WHEN a.yr=YEAR(b.period_end) THEN DAYOFYEAR(b.period_end) 
        WHEN a.yr>YEAR(b.period_start) AND a.yr<YEAR(b.period_end) THEN 365
        ELSE 0
    END * average_daily_sales AS total_amount
FROM
    (SELECT product_id,product_name,'2018' AS yr FROM Product
    UNION
    SELECT product_id,product_name,'2019' AS yr FROM Product
    UNION
    SELECT product_id,product_name,'2020' AS yr FROM Product) a
    JOIN 
    Sales b
    ON a.product_id=b.product_id  
HAVING total_amount > 0
ORDER BY b.product_id,a.yr