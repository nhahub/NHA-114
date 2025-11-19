select
    date_format(Birth_Date, '%Y-%m') as month_bucket,
    avg((Math + Physics + Chemistry + Biology + English + History) / 6) as avg_score,
    min((Math + Physics + Chemistry + Biology + English + History) / 6) as min_score,
    max((Math + Physics + Chemistry + Biology + English + History) / 6) as max_score,
    count(*) AS student_count
from {{ ref('Students_SQL') }}
group by month_bucket
order by month_bucket
