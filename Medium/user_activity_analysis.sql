-- Problem: Find users who have both free_trial and paid activity

-- Approach:
-- Group by user_id
-- Count occurrences of each activity type
-- Use HAVING to filter users having both activities

SELECT user_id
FROM activity
GROUP BY user_id
HAVING 
SUM(CASE WHEN activity_type = 'free_trial' THEN 1 ELSE 0 END) > 0
AND
SUM(CASE WHEN activity_type = 'paid' THEN 1 ELSE 0 END) > 0;