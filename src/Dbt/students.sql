select distinct
    Student_ID,
    First_Name,
    Last_Name,
    Birth_Date
from {{ ref('Students_SQL') }}
