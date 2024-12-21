# To make sure everything is in place

-- SELECT * FROM Company;
-- SELECT * FROM Employee;
-- SELECT * FROM Department;
-- SELECT * FROM Artist;
-- SELECT * FROM artist_phone;
-- SELECT * FROM artist_exhibition;
-- SELECT * FROM exhibition;
-- SELECT * FROM artwork_exhibition;
-- SELECT * FROM artwork;
-- SELECT * FROM buyer_phone;
-- SELECT * FROM Buyers;
-- SELECT * FROM Loan;
-- SELECT * FROM Gallery;
-- SELECT * FROM employee_gallery;

# DDL/DML 

SELECT * FROM LOAN;

ALTER TABLE LOAN
ADD delete_column VARCHAR(30);

ALTER TABLE LOAN
DROP COLUMN delete_column;

UPDATE LOAN
SET loan_amount = 30000
WHERE loan_id = 1 and buyer_id = 1;


# INDEXING 

CREATE INDEX idx_employee_comp_id ON Employee (comp_ID);
-- SELECT * FROM Employee WHERE comp_ID = 3;
EXPLAIN SELECT * FROM Employee WHERE comp_ID = 3;

# FUNCTIONS

-- 1. Get gallery name given gallery id

drop function if exists `get_gallery_name`;

DELIMITER $$
CREATE FUNCTION get_gallery_name(gallery_ID INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
	DECLARE galleryName VARCHAR(255);

	SELECT gallery_name into galleryName
    FROM Gallery as g
    WHERE g.gallery_ID = gallery_ID;
    
	RETURN galleryName;
END$$

DELIMITER ;

SELECT get_gallery_name(2);

-- 2. How many artists live in given country

DROP FUNCTION IF EXISTS `artist_count`;

DELIMITER //
CREATE FUNCTION artist_count (country_name VARCHAR(100))
RETURNS VARCHAR(100)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE a_count INT;
    DECLARE return_message VARCHAR(100);
		SELECT 
    COUNT(*)
INTO a_count FROM
    Artist a
WHERE
    a.country = country_name;
	SELECT CONCAT(a_count, ' live in the ', country_name) INTO return_message;
	return return_message;
END;

//             
DELIMITER ;

SELECT ARTIST_COUNT('USA') AS artist_count;
SELECT ARTIST_COUNT('France') AS artist_count;
SELECT ARTIST_COUNT('Armenia') AS artist_count;

-- 3. How many employees does given company have

DROP FUNCTION IF EXISTS employee_count;

DELIMITER //

CREATE FUNCTION employee_count(company_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC -- caching, so next time same company_id comes around, the output will be the same
BEGIN
    DECLARE employee_count INT;
    DECLARE c_name VARCHAR(30);
    SELECT comp_name FROM COMPANY as c WHERE company_id =  c.comp_id INTO c_name;
    SELECT COUNT(*) INTO employee_count
    FROM Employee
    WHERE comp_ID = company_id;
    RETURN CONCAT('Company called ', c_name, ' has an employee count: ', employee_count);
END;

//
DELIMITER ;

SELECT employee_count(1) AS EmployeeCount;

# VIEWS

-- View to get artwork and its artist's information

DROP VIEW IF EXISTS artwork_inventory;
CREATE VIEW artwork_inventory AS
    SELECT 
        aw.artwork_id,
        aw.title AS artwork_title,
        aw.date_of_creation,
        aw.type AS type,
        CONCAT(' ',
                a.first_name,
                a.middle_name,
                a.last_name) AS artist,
        a.country AS artist_country,
        a.style AS artist_style
    FROM
        artwork AS aw
            INNER JOIN
        artist AS a USING (artist_id);

SELECT 
    *
FROM
    artwork_inventory;