/*
	Task 3:
	
	How many taxi trips were there on January 15?
	Consider only trips that started on January 15.
*/
SELECT 
	count(*)
FROM yellow_taxi_trips
WHERE tpep_pickup_datetime::date = '2021-01-15'
;

-- Answer: 53024

/*
	Task 4:
	
	Find the largest tip for each day. On which day it was the largest tip in January?
	Use the pick up time for your calculations.
*/
SELECT
	tpep_pickup_datetime::date AS pickup_date,
	MAX(tip_amount) AS max_tip
FROM yellow_taxi_trips
GROUP BY pickup_date
ORDER BY 2 DESC
LIMIT 1
;

-- Answer: 1140.44 at 2021-01-20

/*
	Task 5:
	
	What was the most popular destination for passengers picked up in central park on January 14?
	Use the pick up time for your calculations.
	Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"
*/
SELECT
	zdo."Zone",
	COUNT(*) cnt
FROM yellow_taxi_trips AS trips
JOIN zones AS zpu
	ON trips."PULocationID" = zpu."LocationID"
JOIN zones AS zdo
	ON trips."DOLocationID" = zdo."LocationID"
WHERE trips.tpep_pickup_datetime::date = '2021-01-14'
	AND zpu."Zone" = 'Central Park'
GROUP BY
	zdo."Zone"
ORDER BY cnt DESC
;

-- Answer:  Upper East Side South (97 rides)

/*
	Task 6:
	
	What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?
	Enter two zone names separated by a slash
	
	For example: "Jamaica Bay / Clinton East"
	If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East".
*/
SELECT
	COALESCE(z1."Zone", 'Unknown') || ' / ' || COALESCE(z2."Zone", 'Unknown') AS pickup_dropoff_pair,
	AVG(trips.total_amount) AS avg_price
FROM yellow_taxi_trips AS trips
JOIN zones AS z1
	ON trips."PULocationID" = z1."LocationID"
JOIN zones AS z2
	ON trips."DOLocationID" = z2."LocationID"
GROUP BY z1."Zone", z2."Zone"
ORDER BY avg_price DESC
;

-- Answer: Alphabet City / Unknown (2292.4)
