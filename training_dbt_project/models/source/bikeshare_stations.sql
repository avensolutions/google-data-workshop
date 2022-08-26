
with stations as (
    SELECT *
    FROM `bigquery-public-data.san_francisco.bikeshare_stations` s
)

select * from stations
