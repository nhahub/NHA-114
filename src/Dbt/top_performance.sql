{{ config(materialized='view') }}

with ranked_scores as (
    select
        sc.Student_ID,
        st.First_Name,
        st.Last_Name,
        sb.Subject_Name,
        sc.Score,
        row_number() over (
            partition by sc.Subject_ID
            order by sc.Score desc
        ) as rn
    from {{ ref('scores') }} sc
    join {{ ref('students') }} st
        on sc.Student_ID = st.Student_ID
    join {{ ref('subjects') }} sb
        on sc.Subject_ID = sb.subject_id
)

select
    Student_ID,
    First_Name,
    Last_Name,
    Subject_Name,
    Score
from ranked_scores
where rn = 1

