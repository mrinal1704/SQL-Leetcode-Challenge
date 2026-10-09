with unique_listens as (
    select distinct user_id, song_id, day
    from listens
),

friends as (
    select l1.user_id, l2.user_id recommended_id
    from unique_listens l1
    join unique_listens l2
        on l1.user_id < l2.user_id
        and l1.song_id = l2.song_id
        and l1.day = l2.day
    where not exists (
        select 1
        from friendship f
        where (f.user1_id = l1.user_id and f.user2_id = l2.user_id)
           or (f.user1_id = l2.user_id and f.user2_id = l1.user_id)
    )
    group by l1.user_id, l2.user_id, l1.day
    having count(*) >= 3
)

select user_id, recommended_id
from friends

union

select recommended_id, user_id
from friends;
