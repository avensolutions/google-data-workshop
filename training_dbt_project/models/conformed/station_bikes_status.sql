
with station_bike_status as (
    SELECT 
        stn.station_id as station_id,
        stn.name as station_name,	
        stn.latitude as latitude,
        stn.longitude as longitude,
        stn.dockcount as dockcount,
        stn.landmark as landmark,
        stn.installation_date as installation_date,
        sts.bikes_available as bikes_available,
        sts.docks_available as docks_available,
        sts.time as ts
    FROM {{ ref('bikeshare_status') }} sts
    INNER JOIN {{ ref('bikeshare_stations') }} stn
    ON sts.station_id = stn.station_id
)

select * from station_bike_status
