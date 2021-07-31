CREATE DATABASE project;

SHOW DATABASES;

USE project;

CREATE TABLE crash (
    Location_Description TEXT(1000),
    Road_Configuration CHAR(100),	
    Light_Condition CHAR(100),	
    Weather CHAR(100),
    Fatality INT,
    Injury INT,
    Contributing_Factor TEXT(1000),
    Traffic_Control CHAR(100),
    Vehicle1 CHAR(100),
    Vehicle2 CHAR(100),
    Vehicle3 CHAR(100),
    Vehicle4 CHAR(100),
    Vehicle5 CHAR(100),
    Crash_Date CHAR(100),
    year ,	
    Fatalities CHAR(50),
    Injuries CHAR(50),
    Month INT);

LOAD DATA LOCAL INFILE 'data_clean.csv'
INTO TABLE crash
FIELDS TERMINATED BY ';';

SELECT year, COUNT(*) AS number_of_crashes
FROM crash
GROUP BY year
ORDER BY year DESC;

SELECT Contributing_Factor, COUNT(*) AS number_of_crashes
FROM crash
WHERE Contributing_Factor != ''
GROUP BY Contributing_Factor
ORDER BY number_of_crashes DESC
LIMIT 6;
