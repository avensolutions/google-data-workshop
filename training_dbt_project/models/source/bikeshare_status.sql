
with bikeshare_status as (
    SELECT *
    FROM `bigquery-public-data.san_francisco.bikeshare_status` s
)

select * from bikeshare_status
