CREATE SCHEMA DWH; 

SELECT * FROM DWH.DIM_ECONOMY; 
SELECT * FROM DWH.DIM_HEALTH
SELECT * FROM DWH.dim_health 
SELECT * FROM DWH.dim_date
SELECT * FROM DWH.dim_demographics


SELECT * FROM DWH.fact_covid_cases
ALTER TABLE DWH.fact_covid_cases
ADD health_id INT 

