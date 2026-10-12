-- ==========================================
-- 1. TABLE CREATION & DATA IMPORT
-- ==========================================

CREATE TABLE bnb_data (
    id CHAR(15),
    NAME VARCHAR(3000),
    host_id VARCHAR(150),
    host_identity_verified VARCHAR(150),
    host_name VARCHAR(150),
    neighbourhood_group VARCHAR(150),
    neighbourhood VARCHAR(150),
    lat FLOAT,
    long FLOAT,
    country VARCHAR(150),
    country_code CHAR(15),
    instant_bookable CHAR(15),
    cancellation_policy VARCHAR(150),
    room_type VARCHAR(150),
    Construction_year VARCHAR(150),
    price FLOAT,
    service_fee FLOAT,
    minimum_nights INT,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month FLOAT,
    review_rate_number INT,
    calculate_host_listings_count INT,
    availability_365 INT,
    house_rules VARCHAR(3000),
    license VARCHAR(150)
);

COPY bnb_data
FROM 'E:\Data Analysis Projects\Project 2\Airbnb_Open_Data.csv\Airbnb_Open_Data.csv'
HEADER CSV
DELIMITER ',';

SELECT COUNT(*) FROM bnb_data;


-- ==========================================
-- 2. CREATE CLEAN_DATA TABLE & COPY DATA
-- ==========================================


CREATE TABLE clean_data (LIKE bnb_data);  

INSERT INTO clean_data  
SELECT * FROM bnb_data;

SELECT * FROM clean_data;


-- ==========================================
-- 3. REMOVING DUPLICATES
-- ==========================================

-- Add column for row numbering
ALTER TABLE clean_data
ADD COLUMN row_num INT;

-- CHANGE DATA TYPES FOR HANDLING NULL VALUES
ALTER TABLE clean_data
ALTER COLUMN last_review TYPE VARCHAR(150)

-- Populate row_num using a CTE and window function
WITH CTE AS (
    SELECT 
        ctid,  
        ROW_NUMBER() OVER (
            PARTITION BY id, name, host_id, host_identity_verified, neighbourhood, lat, long
        ) AS row_num
    FROM clean_data
)
UPDATE clean_data
SET row_num = CTE.row_num
FROM CTE
WHERE clean_data.ctid = CTE.ctid;

-- Delete duplicate rows where row_num is greater than 1
DELETE FROM clean_data
WHERE row_num > 1;
ALTER TABLE clean_data
DROP COLUMN row_num


ALTER TABLE clean_data
DROP COLUMN license
 

-- ==========================================
-- 4. HANDLING NULL VALUES
-- ==========================================

DELETE FROM clean_data
WHERE name IS NULL
  AND host_identity_verified IS NULL;

DELETE FROM clean_data
WHERE name IS NULL;

DELETE FROM clean_data
WHERE host_identity_verified IS NULL;

DELETE FROM clean_data  
WHERE country IS NULL
  AND country_code IS NULL
  AND instant_bookable IS NULL
  AND cancellation_policy IS NULL;

DELETE FROM clean_data  
WHERE country IS NULL;

DELETE FROM clean_data
WHERE instant_bookable IS NULL;

DELETE FROM clean_data
WHERE availability_365 IS NULL;

DELETE FROM clean_data 
WHERE minimum_nights < 0

DELETE FROM clean_data 
WHERE minimum_nights > 370

DELETE FROM clean_data 
WHERE price IS NULL




-- ==========================================
-- 5. DATA TRIMMING & CLEANING TEXT
-- ==========================================

UPDATE clean_data
SET name = TRIM(name);

UPDATE clean_data
SET host_identity_verified = TRIM(host_identity_verified);

UPDATE clean_data
SET host_id = TRIM(host_id);

UPDATE clean_data
SET house_rules = TRIM(house_rules)

UPDATE clean_data AS c1
SET neighbourhood = c2.neighbourhood
FROM clean_data AS c2
WHERE c1.neighbourhood IS NULL
  AND c2.neighbourhood IS NOT NULL
  AND c1.lat = c2.lat;

UPDATE clean_data AS c1
SET neighbourhood_group = c2.neighbourhood_group
FROM clean_data AS c2
WHERE c1.neighbourhood_group IS NULL
  AND c2.neighbourhood_group IS NOT NULL
  AND c1.neighbourhood = c2.neighbourhood;


-- ==========================================
-- 6. VERIFICATION QUERIES (NULL CHECKS)
-- ==========================================

SELECT * FROM clean_data WHERE host_identity_verified IS NULL;
SELECT * FROM clean_data WHERE name IS NULL;
SELECT * FROM clean_data WHERE host_identity_verified IS NULL;
SELECT * FROM clean_data WHERE country IS NULL;
SELECT * FROM clean_data WHERE instant_bookable IS NULL;
SELECT * FROM clean_data WHERE cancellation_policy IS NULL;
SELECT * FROM clean_data WHERE country_code IS NULL;
SELECT * FROM clean_data WHERE host_id IS NULL;
SELECT * FROM clean_data WHERE price IS NULL;
SELECT * FROM clean_data WHERE construction_year IS NULL;


WITH CTE AS (
SELECT *
FROM clean_data c1
JOIN clean_data c2 
ON c1.lat = c2.lat 
WHERE c1.neighbourhood IS NULL
AND c2.neighbourhood IS NOT NULL 
)
SELECT * FROM CTE


-- ==========================================
-- 7. DATA STANDARDIZATION
-- ==========================================

UPDATE clean_data
SET country = 'United States'
WHERE country_code = 'US';

UPDATE clean_data
SET country_code = 'US'
WHERE country = 'United States';

UPDATE clean_data 
SET number_of_reviews = 0
WHERE number_of_reviews IS NULL

UPDATE clean_data 
SET house_rules = 'No Rule'
WHERE house_rules IS NULL

UPDATE clean_data 
SET reviews_per_month = 0
WHERE reviews_per_month IS NULL


UPDATE clean_data 
SET last_review = 'No Review'
WHERE last_review IS NULL

UPDATE clean_data
SET house_rules = REPLACE(house_rules ,'-','')

UPDATE clean_data 
SET calculate_host_listings_count = 1
WHERE calculate_host_listings_count IS NULL

UPDATE clean_data 
SET review_rate_number = 0
WHERE review_rate_number IS NULL

UPDATE clean_data
SET minimum_nights = 1
WHERE minimum_nights IS NULL

UPDATE clean_data 
SET calculate_host_listings_count = 67
WHERE calculate_host_listings_count > 67




-- Final preview of the clean dataset
SELECT * FROM clean_data;


-- EDA report

-- Total Revenue

SELECT SUM(price) AS Total_Rev FROM clean_data

-- Revenue BY room type

SELECT room_type , SUM(price) AS Total_Rev ,SUM(service_fee) AS Total_fee FROM clean_data
GROUP BY room_type;

-- Total Service fee

SELECT SUM(service_fee) AS Total FROM clean_data

-- Total_Listing

SELECT SUM(calculate_host_listings_count) AS Total_Listing FROM clean_data

-- Verified & Unverifed Hosts
SELECT host_identity_verified ,COUNT(host_id) AS Total FROM clean_data
GROUP BY host_identity_verified

-- Instant Bookable 

SELECT Instant_bookable,COUNT(host_id) AS Total FROM clean_data
GROUP BY Instant_bookable

-- Cancellation policy
SELECT cancellation_policy,COUNT(host_id) AS Total FROM clean_data
GROUP BY cancellation_policy







