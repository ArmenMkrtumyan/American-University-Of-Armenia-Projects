# QUERIES

-- Inner join

-- Getting the information in exhibitions and their respective galleries

SELECT 
    ex.exib_id,
    ex.exib_date,
    ex.exib_name,
    ex.theme,
    g.gallery_name,
    g.country,
    g.city,
    g.address
FROM
    exhibition AS ex
        INNER JOIN
    gallery AS g USING (gallery_id);

-- getting all the artsts that have exhibition

SELECT 
    *
FROM
    Artist AS a
        INNER JOIN
    artist_exhibition AS e USING (artist_id);

-- LEFT JOIN

-- Find the buyers who do not have any loans

SELECT b.first_name as `Artist who don't have loans`
FROM Buyers b
LEFT JOIN Loan l
ON b.buyer_id = l.buyer_id
WHERE l.buyer_id IS NULL;

-- --------------------------------------------

-- RIGHT JOIN

-- Show all the artworks and the buyers who purchased them, including artworks that have not been purchased by any buyer.

SELECT 
    a.artwork_id, a.title, b.first_name as `buyer name`
FROM
    Buyers b
        RIGHT JOIN
    Artwork a ON b.buyer_id = a.buyer_id;

-- NOT IN

-- All the buyers who do not have loans

SELECT 
    b.buyer_id,
    b.first_name,
    b.middle_name,
    b.last_name,
    b.email
FROM
    Buyers b
WHERE
    b.buyer_id NOT IN (SELECT 
            l.buyer_id
        FROM
            Loan l);


-- NOT EXISTS

-- Artists who have never had exhibition 

SELECT 
    a.artist_id, a.first_name, a.last_name
FROM
    Artist a
WHERE
    NOT EXISTS( SELECT 
            1
        FROM
            Artist_exhibition ae
        WHERE
            ae.artist_id = a.artist_id);


-- GROUP BY (Aggregation) / HAVING

-- Count the number of loans made each month.

SELECT 
    MONTH(loan_date) AS `month`, COUNT(*) AS `loan count`
FROM
    loan
GROUP BY MONTH(loan_date)
ORDER BY `month`;

-- Determine the number of employees in each department.

SELECT 
    dept_name, comp_id, COUNT(*) AS num_employees
FROM
    employee AS e
GROUP BY comp_id , dept_name
ORDER BY comp_id;

-- Select all the buyers who have more than 1 phone number

SELECT 
    b.first_name, COUNT(*) AS `N of phones`
FROM
    Buyers AS b
        JOIN
    Buyer_phone USING (buyer_id)
GROUP BY buyer_id
HAVING `N of phones` > 1;

-- Group the loan amounts into ranges

SELECT * FROM Loan;

SELECT 
    CASE
        WHEN loan_amount BETWEEN 0 AND 10000 THEN '0 - 10k'
        WHEN loan_amount BETWEEN 10001 AND 20000 THEN '10k - 20k'
        WHEN loan_amount BETWEEN 20001 AND 30000 THEN '20k - 30k'
        WHEN loan_amount BETWEEN 30001 AND 40000 THEN '30k - 40k'
        ELSE '40k +'
    END AS loan_range,
    COUNT(*) AS loan_count
FROM
    loan
GROUP BY CASE
    WHEN loan_amount BETWEEN 0 AND 10000 THEN '0 - 10k'
    WHEN loan_amount BETWEEN 10001 AND 20000 THEN '10k - 20k'
    WHEN loan_amount BETWEEN 20001 AND 30000 THEN '20k - 30k'
    WHEN loan_amount BETWEEN 30001 AND 40000 THEN '30k - 40k'
    ELSE '40k +'
END;


-- WITH

-- choosing artists who are dead

WITH dead_artists AS (
    SELECT artist_id, first_name, last_name, date_of_birth, date_of_death
    FROM Artist
    WHERE date_of_death IS NOT NULL
)

SELECT *
FROM dead_artists
ORDER BY date_of_death DESC;

-- buyers who have purchased artworks created before 2000

WITH early_art_buyers AS (
    SELECT b.buyer_id, b.first_name as `name`
    FROM Buyers b
    JOIN Artwork a ON b.buyer_id = a.buyer_id
    WHERE a.date_of_creation < '2000-01-01'
)

SELECT `name`, a.title, a.date_of_creation
FROM early_art_buyers
JOIN Artwork a ON early_art_buyers.buyer_id = a.buyer_id
ORDER BY a.date_of_creation DESC;

-- Nested queries

-- buyers who have average loan amount greater than the total average loan amount

SELECT 
    b.first_name, AVG(l.loan_amount) AS average
FROM
    Buyers b
        JOIN
    Loan l ON b.buyer_id = l.buyer_id
GROUP BY b.buyer_id
HAVING average > (SELECT 
        AVG(loan_amount)
    FROM
        Loan);

-- buyers who have loan more than 20000

SELECT 
    b.buyer_id, b.first_name, b.last_name, loans.loan_amount
FROM
    (SELECT 
        l.buyer_id, l.loan_amount
    FROM
        Loan l) AS loans
        JOIN
    Buyers b ON loans.buyer_id = b.buyer_id
WHERE
    loans.loan_amount > 20000;  

-- buyers total loan amount

SELECT 
    b.first_name,
    b.last_name,
    (
        SELECT SUM(l.loan_amount)
        FROM Loan l
        WHERE l.buyer_id = b.buyer_id
    ) AS total_loan_amount
FROM Buyers b;
