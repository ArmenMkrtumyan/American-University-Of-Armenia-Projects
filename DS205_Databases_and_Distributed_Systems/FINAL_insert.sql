use ArtGallery;

INSERT INTO Department (dept_name, budget)
VALUES 
('Acquisitions', 500000),
('Sales', 300000),
('Marketing', 200000),
('Restoration', 150000);

INSERT INTO Company (comp_name, country, city, address, zip_code)
VALUES 
('ArtWorld Inc.', 'USA', 'New York', '123 Art St', '10001'),
('Modern Art Co', 'USA', 'Los Angeles', '456 Modern Rd', '90001'),
('Classic Artworks', 'USA', 'Chicago', '789 Classic Ave', '60007'),
('Gallery One', 'Canada', 'Toronto', '1313 Gallery St', 'M5A 1A1'),
('European Artworks', 'UK', 'London', '1414 European Rd', 'E1 6AN');

INSERT INTO Employee (emp_name, surname, email, job_title, comp_id, dept_name)
VALUES 
('John', 'Doe', 'johndoe@artworld.com', 'Curator', 1, 'Acquisitions'),
('Emily', 'Rose', 'emilyrose@modernart.com', 'Sales Manager', 2, 'Sales'),
('Michael', 'Bay', 'michaelbay@classicart.com', 'Director', 3, 'Marketing'),
('Sarah', 'Connor', 'sarahconnor@galleryone.com', 'Restorer', 4, 'Restoration'),
('James', 'Smith', 'jamessmith@artworld.com', 'Archivist', 1, 'Acquisitions'),
('Anna', 'Belle', 'annabelle@modernart.com', 'Curator', 2, 'Marketing'),
('Oliver', 'Twist', 'olivertwist@classicart.com', 'Custodian', 3, 'Sales'),
('Charlotte', 'Web', 'charlotteweb@galleryone.com', 'Marketing Manager', 4, 'Marketing'),
('Tony', 'Stark', 'tonystark@europeanart.com', 'Developer', 5, 'Sales'),
('Natasha', 'Romanoff', 'natashar@europeanart.com', 'Security Manager', 5, 'Restoration');

INSERT INTO Gallery (gallery_name, country, city, address)
VALUES 
('Downtown Gallery', 'USA', 'New York', '234 Gallery Lane'),
('Ocean View Gallery', 'USA', 'Los Angeles', '345 Ocean Rd'),
('Wind City Art', 'USA', 'Chicago', '456 Wind St'),
('Space Needle Art', 'USA', 'Seattle', '567 Space Rd'),
('Sunshine Gallery', 'USA', 'Miami', '678 Sunshine Ave'),
('Maple Leaf Gallery', 'Canada', 'Toronto', '789 Maple St'),
('The Crown Gallery', 'UK', 'London', '890 Crown Rd'),
('La Artiste', 'France', 'Paris', '901 Artist Blvd'),
('Roman Legacy', 'Italy', 'Rome', '1012 Legacy Ln'),
('Berlin Art Hub', 'Germany', 'Berlin', '1123 Hub Ave');

INSERT INTO Artist (first_name, middle_name, last_name, country, city, date_of_birth, date_of_death, email, style)
VALUES 
('Emily', 'J', 'Fant', 'USA', 'Boston', '1970-02-15', NULL, 'emilyfant@artmail.com', 'Painter'),
('Michael', 'L', 'Angelo', 'Italy', 'Florence', '1475-03-06', '1525-03-07', 'mangelo@renaissance.it', 'Sculptor'),
('Leonardo', 'D', 'Bright', 'France', 'Paris', '1965-07-30', '2020-03-03', 'lbright@modernart.fr', 'Digital Artist'),
('Sarah', 'E', 'Clearwater', 'USA', 'Chicago', '1980-11-15', NULL, 'sclearwater@contemp.us', 'Photographer'),
('James', 'A', 'Monet', 'France', 'Giverny', '1840-11-14', '1940-04-04', 'jmonet@paintmail.fr', 'Painter'),
('Anna', 'M', 'Stone', 'USA', 'New York', '1990-05-21', NULL, 'astone@sculpture.com', 'Sculptor'),
('Oliver', 'P', 'Print', 'UK', 'London', '1975-08-20', NULL, 'oprint@prints.uk', 'Printmaker'),
('Charlotte', 'G', 'Web', 'France', 'Lyon', '1985-01-25', NULL, 'cweb@fabricart.in', 'Textile Artist'),
('Tony', 'R', 'Sketch', 'USA', 'San Francisco', '1950-09-09', NULL, 'tsketch@sketchbook.com', 'Illustrator'),
('Natasha', 'V', 'Ink', 'Japan', 'Tokyo', '1989-12-25', NULL, 'nink@inkmaster.jp', 'Calligrapher');

INSERT INTO Buyers (first_name, middle_name, last_name, country, city, email)
VALUES 
('Sara', 'L', 'Linn', 'USA', 'New York', 'saralinn@buyart.com'),
('Mark', 'R', 'Twain', 'USA', 'San Francisco', 'marktwain@collector.com'),
('Jane', 'F', 'Austen', 'UK', 'London', 'janeausten@bookart.co.uk'),
('Charles', 'D', 'Dickens', 'UK', 'Bath', 'charlesdickens@historic.co.uk'),
('Herman', 'M', 'Melville', 'USA', 'Boston', 'hermanmelville@whaleart.com'),
('Virginia', 'A', 'Woolf', 'UK', 'London', 'virginiawoolf@modernism.co.uk'),
('Frida', 'C', 'Kahlo', 'Mexico', 'Coyoacan', 'fridakahlo@painandpassion.mx'),
('Pablo', 'D', 'Picasso', 'Spain', 'Malaga', 'pablop@guernica.es'),
('Vincent', 'W', 'van Gogh', 'Netherlands', 'Zundert', 'vincentvg@starrynight.nl'),
('Claude', 'O', 'Monet', 'France', 'Paris', 'claudem@waterlilies.fr');

INSERT INTO Artist_Phone (artist_id, phone)
VALUES 
(1, '123-456-7890'),
(2, '234-567-8901'),
(3, '345-678-9012'),
(4, '456-789-0123'),
(5, '567-890-1234'),
(6, '678-901-2345'),
(7, '789-012-3456'),
(8, '890-123-4567'),
(9, '901-234-5678'),
(10, '012-345-6789');

INSERT INTO Buyer_Phone (buyer_id, phone)
VALUES 
(1, '101-202-3030'),
(2, '202-303-4040'),
(2, '303-404-5050'),
(2, '404-505-6060'),
(5, '505-606-7070'),
(6, '606-707-8080'),
(7, '707-808-9090'),
(7, '808-909-1010'),
(9, '909-010-1111'),
(10, '010-111-2222');

INSERT INTO Artist_Exhibition (artist_id, exib_id, date_attended)
VALUES 
(1, 1, '2023-06-01'),
(3, 1, '2023-06-03'),
(4, 2, '2023-06-04'),
(6, 2, '2023-06-06'),
(7, 3, '2023-06-07'),
(9, 3, '2023-06-09'),
(10, 3, '2023-06-10');

INSERT INTO Artwork_Exhibition (artwork_id, exib_id)
VALUES 
(1, 1),
(3, 1),
(4, 2),
(6, 2),
(7, 3),
(8, 3),
(10, 3);

INSERT INTO Employee_Gallery (emp_id, gallery_id)
VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5);

INSERT INTO Artwork (buyer_id, artist_id, title, date_of_creation, type)
VALUES 
(1, 1, 'Sunset Dreams', '1999-05-20', 'Oil Painting'),
(2, 2, 'Morning Glow', '2000-06-15', 'Watercolor'),
(NULL, 3, 'City Lights', '2001-07-22', 'Photography'),
(4, 4, 'Abstract Thoughts', '2002-08-30', 'Acrylic'),
(5, 5, 'Winter Blues', '2003-11-19', 'Mixed Media'),
(6, 6, 'Summer Vibes', '1950-05-24', 'Oil Painting'),
(7, 7, 'Autumn Hues', '2005-09-13', 'Pastel'),
(NULL, 8, 'Spring Blossoms', '2006-03-07', 'Watercolor'),
(9, 9, 'Night Sky', '1800-10-21', 'Photography'),
(10, 10, 'Daydream', '2008-12-15', 'Acrylic');

INSERT INTO Loan (buyer_id, loan_amount, loan_date)
VALUES
(1, 32000, '2023-07-20'),
(2, 25000, '2023-01-25'),
(4, 19000, '2023-02-15'),
(5, 18000, '2023-03-01'),
(6, 52000, '2023-03-11'),
(7, 26000, '2023-04-21'),
(8, 34000, '2023-05-31'),
(10, 20000, '2023-01-15')
;

INSERT INTO Exhibition (exib_date, exib_name, theme, gallery_id)
VALUES 
('2023-06-01', 'Summer Modern Art', 'Modernism', 1),
('2023-06-15', 'Classic Views', 'Classicism', 2),
('2023-07-01', 'New Age Photography', 'Photography', 3),
('2024-07-15', 'Renaissance Revived', 'Renaissance', 4),
('2023-08-01', 'Abstract and Beyond', 'Abstract', 5),
('2023-08-15', 'Sculpture Spectacle', 'Sculpture', 6),
('2024-09-01', 'Textile Traditions', 'Textile Art', 7),
('2023-09-15', 'Printmaking Processes', 'Printmaking', 8),
('2024-10-01', 'Illustrative Insights', 'Illustration', 9),
('2023-10-15', 'Calligraphy Corner', 'Calligraphy', 10);

