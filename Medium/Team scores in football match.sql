-- Question 53
-- Table: Teams

-- +---------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | team_id       | int      |
-- | team_name     | varchar  |
-- +---------------+----------+
-- team_id is the primary key of this table.
-- Each row of this table represents a single football team.
-- Table: Matches

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | host_team     | int     |
-- | guest_team    | int     | 
-- | host_goals    | int     |
-- | guest_goals   | int     |
-- +---------------+---------+
-- match_id is the primary key of this table.
-- Each row is a record of a finished match between two different teams. 
-- Teams host_team and guest_team are represented by their IDs in the teams table (team_id) and they scored host_goals and guest_goals goals respectively.
 

-- You would like to compute the scores of all teams after all matches. Points are awarded as follows:
-- A team receives three points if they win a match (Score strictly more goals than the opponent team).
-- A team receives one point if they draw a match (Same number of goals as the opponent team).
-- A team receives no points if they lose a match (Score less goals than the opponent team).
-- Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

-- The query result format is in the following example:

-- Teams table:
-- +-----------+--------------+
-- | team_id   | team_name    |
-- +-----------+--------------+
-- | 10        | Leetcode FC  |
-- | 20        | NewYork FC   |
-- | 30        | Atlanta FC   |
-- | 40        | Chicago FC   |
-- | 50        | Toronto FC   |
-- +-----------+--------------+

-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 10           | 20            | 3           | 0            |
-- | 2          | 30           | 10            | 2           | 2            |
-- | 3          | 10           | 50            | 5           | 1            |
-- | 4          | 20           | 30            | 1           | 0            |
-- | 5          | 50           | 30            | 1           | 0            |
-- +------------+--------------+---------------+-------------+--------------+

-- Result table:
-- +------------+--------------+---------------+
-- | team_id    | team_name    | num_points    |
-- +------------+--------------+---------------+
-- | 10         | Leetcode FC  | 7             |
-- | 20         | NewYork FC   | 3             |
-- | 50         | Toronto FC   | 3             |
-- | 30         | Atlanta FC   | 1             |
-- | 40         | Chicago FC   | 0             |
-- +------------+--------------+---------------+

-- Solution
with t1 as(
Select c.host_id, c.host_name, c.host_points
from(
select a.match_id, a.team_id as host_id, a.team_name as host_name, b.team_id as guest_id, b.team_name as guest_name, a.host_goals, a.guest_goals,
case
when a.host_goals > a.guest_goals then 3
when a.host_goals = a.guest_goals then 1
else 0
end as host_points,
case
when a.host_goals < a.guest_goals then 3
when a.host_goals = a.guest_goals then 1
else 0
end as guest_points
from(
select *
from matches m
join teams t
on t.team_id = m.host_team) a
join
(select *
from matches m
join teams t
on t.team_id = m.guest_team) b
on a.match_id = b.match_id) c
union all
Select d.guest_id, d.guest_name, d.guest_points
from(
select a.match_id, a.team_id as host_id, a.team_name as host_name, b.team_id as guest_id, b.team_name as guest_name, a.host_goals, a.guest_goals,
case
when a.host_goals > a.guest_goals then 3
when a.host_goals = a.guest_goals then 1
else 0
end as host_points,
case
when a.host_goals < a.guest_goals then 3
when a.host_goals = a.guest_goals then 1
else 0
end as guest_points
from(
select *
from matches m
join teams t
on t.team_id = m.host_team) a
join
(select *
from matches m
join teams t
on t.team_id = m.guest_team) b
on a.match_id = b.match_id) d)

Select team_id, team_name, coalesce(total,0) as num_points
from teams t2
left join(
select host_id, host_name, sum(host_points) as total
from t1
group by host_id, host_name) e
on t2.team_id = e.host_id
order by num_points desc, team_id
