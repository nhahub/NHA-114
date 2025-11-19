{{ config(materialized='table') }}

with raw_scores as (

    select Student_ID, 1 as Subject_ID, Math as Score from {{ ref('Students_SQL') }}
    union all
    select Student_ID, 2, Physics from {{ ref('Students_SQL') }}
    union all
    select Student_ID, 3, Chemistry from {{ ref('Students_SQL') }}
    union all
    select Student_ID, 4, Biology from {{ ref('Students_SQL') }}
    union all
    select Student_ID, 5, English from {{ ref('Students_SQL') }}
    union all
    select Student_ID, 6, History from {{ ref('Students_SQL') }}

)

select
    row_number() over(order by Student_ID, Subject_ID) as Score_ID,
    Student_ID,
    Subject_ID,
    Score
from raw_scores

