# BONUS (TRIGGERS, IF ELSE STATEMENTS, RANKINGS, SIGNALS, PROCEDURES, TRANSACTIONS, WINDOW FUNCTIONS)

-- Procedures

DROP FUNCTION IF EXISTS get_employee_names;
DELIMITER $$

CREATE FUNCTION get_employee_names(gallery_ID INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE employee_names VARCHAR(255);
    SELECT CONCAT('Employees named ', GROUP_CONCAT(e.emp_name SEPARATOR ' and '), ' work at the gallery with name ', get_gallery_name(gallery_ID))
    INTO employee_names
    FROM Employee e
    JOIN Employee_gallery eg ON e.emp_ID = eg.emp_ID
    WHERE eg.gallery_ID = gallery_ID;

    RETURN employee_names;
END$$

DELIMITER ;

SELECT get_employee_names(1) AS employees;


-- TRANSACTIONS, PROCEDURES, IF ELSE STATEMENTS, SIGNALS
 
DROP PROCEDURE IF EXISTS take_loan;
DELIMITER $$

CREATE PROCEDURE take_loan(amount_passed INT, person_id INT)
BEGIN
    DECLARE l_amount DECIMAL(10,2);
    DECLARE l_balance DECIMAL(10,2);

	SET l_amount = amount_passed;
    SELECT loan_amount INTO l_balance FROM LOAN WHERE buyer_id = person_id;

    IF l_balance + l_amount > 100000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Your loan cannot be more than 100000';
    ELSE
        UPDATE LOAN SET loan_amount = l_balance + l_amount WHERE buyer_id = person_id;
    END IF;
END$$

DELIMITER ;

-- check if loan amount is less than 100000 
START TRANSACTION; 
-- CALL take_loan(5000, 1); -- loan amount, person_id
CALL take_loan(100000, 2);
COMMIT; -- Commit the transaction if no exceptions were raised


# PARTITIONING, RANKING, WINDOW FUNCTIONS

-- loan amounts per country

SELECT first_name, last_name, country, loan_amount, 
	DENSE_RANK() OVER (PARTITION BY country ORDER BY loan_amount) as `loan amount per country`
FROM Buyers AS b JOIN Loan as l USING (buyer_id);

-- sumary of loan amounts, how much loan was taken overall?

SELECT loan_id, loan_date, loan_amount, sum(loan_amount) OVER (ORDER BY loan_date) AS `summary over the periods`
FROM loan;

# TRIGGERS

# 1

-- prevent adding an artwork to the exhibition if the space of artworks is full

DELIMITER //
CREATE TRIGGER check_exhibition_capacity 
BEFORE INSERT ON Artwork_Exhibition
FOR EACH ROW
BEGIN 
	DECLARE exhibition_capacity int;
    select count(artwork_id) INTO exhibition_capacity from Artwork_Exhibition where exib_id = NEW.exib_id;
	IF exhibition_capacity > 3 then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Exhibition capacity is full. A new artwork cannot be added";
    END IF;

END;

//
DELIMITER ;

-- drop trigger `check_exhibition_capacity`;

-- TESTING

insert into Artwork_Exhibition(artwork_id, exib_id) values (7,2);
insert into Artwork_Exhibition(artwork_id, exib_id) values (11,2);
insert into Artwork_Exhibition(artwork_id, exib_id) values (12,2);

# 2

DELIMITER //

CREATE TRIGGER no_changes_after_2024
BEFORE UPDATE ON Exhibition
FOR EACH ROW
BEGIN
	IF YEAR(NEW.exib_date) LIKE '%2024%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'New change: Starting from 2024 once the hosting gallery is decided, it cannot be changed';
    END IF;
    
END;

//
DELIMITER ;

-- test for the update trigger

UPDATE Exhibition SET gallery_id = 8 WHERE exib_id = 4;
UPDATE Exhibition SET gallery_id = 6 WHERE exib_id = 10;

# 3

DELIMITER //

CREATE TRIGGER wrong_dob
BEFORE INSERT ON Artist
FOR EACH ROW
BEGIN
	IF NEW.date_of_birth > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The artist date of birth is greater than the current date';
    END IF;
    
END;

//
DELIMITER ;

INSERT INTO Artist (first_name, last_name, date_of_birth)
VALUES ('John', 'Doe', '2025-01-01');
