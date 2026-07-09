CREATE SCHEMA STG; 

ALTER TABLE STG.cleaned_data
ADD location_type VARCHAR(20) ; 

SELECT * FROM STG.cleaned_data
SELECT DISTINCT iso_code, location_type, continent FROM stg.cleaned_data
SELECT DISTINCT location_type FROM stg.cleaned_data

SELECT * FROM ODS.raw_data