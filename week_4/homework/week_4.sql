-- Question 1: What is the count of records in the model fact_trips after running all 
-- models with the test run variable disabled and filtering for 2019 and 2020 data only (pickup datetime)
SELECT COUNT(*) FROM `de-zoomcamp-338919.dbt_pdanchenko.fact_trips`
WHERE EXTRACT(YEAR from pickup_datetime) BETWEEN 2019 AND 2020;
-- RESULT: 61635174
-- Chose the closest on in the answers


-- Question 3: What is the count of records in the model stg_fhv_tripdata 
-- after running all models with the test run variable disabled *
SELECT COUNT(*) FROM `de-zoomcamp-338919.dbt_pdanchenko.stg_fhv_data`;
-- RESULT: 42084899


 -- Question 4: What is the count of records in the model fact_fhv_trips 
 -- after running all dependencies with the test run variable disabled
SELECT COUNT(*) from `de-zoomcamp-338919.dbt_pdanchenko.fact_fhv_trips`;
-- RESULT: 22676253