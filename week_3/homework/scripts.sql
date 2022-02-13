-- Question 1: What is count for fhv vehicles data for year 2019
SELECT count(*) as row_count
FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;
-- RESULT: 42084899


-- Question 2: How many distinct dispatching_base_num we have in fhv for 2019
SELECT count(distinct dispatching_base_num) as distinct_districts
FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;
-- RESULT: 792


-- Question 3: Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num
CREATE OR REPLACE TABLE `de-zoomcamp-338919.trips_fhv_data_all.option_1`
PARTITION BY DATE(dropoff_datetime) AS
SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;

-- impossible (partition column should be date)
CREATE OR REPLACE TABLE `de-zoomcamp-338919.trips_fhv_data_all.option_2`
PARTITION BY dispatching_base_num AS
SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;

CREATE OR REPLACE TABLE `de-zoomcamp-338919.trips_fhv_data_all.option_3`
PARTITION BY DATE(dropoff_datetime) 
CLUSTER BY dispatching_base_num AS
SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;

-- impossible (partition can be only created on one column)
CREATE OR REPLACE TABLE `de-zoomcamp-338919.trips_fhv_data_all.option_4`
PARTITION BY dispatching_base_num, DATE(dropoff_datetime) AS
SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.fhv_data`;

SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.option_1`
WHERE DATE(dropoff_datetime) between '2019-01-01' and '2019-01-31'
order by dispatching_base_num;
-- ESTIMATED RESULT: This query will process 904.9 MiB when run.
-- ACTUAL RESULT: Query complete (10.3 sec elapsed, 904.9 MB processed)


SELECT * FROM `de-zoomcamp-338919.trips_fhv_data_all.option_3`
WHERE DATE(dropoff_datetime) between '2019-01-01' and '2019-01-31'
order by dispatching_base_num;
-- ESTIMATED RESULT: This query will process 904.9 MiB when run.
-- ACTUAL RESULT: Query complete (9.1 sec elapsed, 904.9 MB processed)


-- Question 4: What is the count, estimated and actual data processed
-- for query which counts trip between 2019/01/01 and 2019/03/31 
-- for dispatching_base_num B00987, B02060, B02279 *
SELECT count(*) FROM `de-zoomcamp-338919.trips_fhv_data_all.option_3`
WHERE dropoff_datetime between '2019-01-01' and '2019-03-31'
  AND dispatching_base_num IN ('B00987', 'B02060', 'B02279');
-- ESTIMATED RESULT: This query will process 400.1 MiB when run.
-- ACTUAL RESULT: Query complete (0.3 sec elapsed, 135.7 MB processed)
-- COUNT: 26558