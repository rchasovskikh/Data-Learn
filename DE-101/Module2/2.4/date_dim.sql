--Creatind date dim
CREATE TABLE date_sequence (date date NOT NULL);

INSERT INTO
  date_sequence(date)  
SELECT
  '1990-01-01'::DATE + SEQUENCE.number AS date
FROM
  GENERATE_SERIES(0, 14974) AS SEQUENCE (number)
  
CREATE TABLE date_dim (
  date_value DATE NOT NULL,
  day_name TEXT NOT NULL,
  day_of_week INT NOT NULL,
  day_of_month INT NOT NULL,
  day_of_year INT NOT NULL,
  month INT NOT NULL,
  month_name TEXT NOT NULL,
  month_name_abbreviated TEXT NOT NULL,
  year_value INT NOT NULL,
  first_day_of_week DATE NOT NULL,
  last_day_of_week DATE NOT NULL
);

INSERT INTO date_dim
SELECT   
date as date_value,    
TO_CHAR(date, 'TMDay') AS day_name,   
EXTRACT(ISODOW FROM date) AS day_of_week,   
EXTRACT(DAY FROM date) AS day_of_month,   
EXTRACT(DOY FROM date) AS day_of_year,   
EXTRACT(MONTH FROM date) AS month,   
TO_CHAR(date, 'TMMonth') AS month_name,   
TO_CHAR(date, 'Mon') AS month_name_abbreviated,   
EXTRACT(YEAR FROM date) AS year_value,   
date + (1 - EXTRACT(ISODOW FROM date))::INT AS first_day_of_week,   date + (7 - EXTRACT(ISODOW FROM date))::INT AS last_day_of_week   from date_sequence
ORDER BY date ASC