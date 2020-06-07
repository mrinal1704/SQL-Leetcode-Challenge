Select U.name as name, coalesce(sum(R.distance),0) as travelled_distance 
from Users U left join Rides R
on R.user_id = U.id
group by name
Order by travelled_distance desc, name