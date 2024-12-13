-- CREATE DATABASE ORDER_DDS;
-- USE ORDER_DDS;
-- SELECT @@SERVERNAME;

USE ORDER_DDS;


-- Create Schemas if they don't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dim')
BEGIN
    EXEC('CREATE SCHEMA dim');
END


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'fact')
BEGIN
    EXEC('CREATE SCHEMA fact');
END


-- Drop tables if they exist to ensure a clean state
IF OBJECT_ID('fact.FactOrderDetails', 'U') IS NOT NULL
    DROP TABLE fact.FactOrderDetails;

IF OBJECT_ID('dim.DimProducts', 'U') IS NOT NULL
    DROP TABLE dim.DimProducts;

IF OBJECT_ID('dim.DimCategories', 'U') IS NOT NULL
    DROP TABLE dim.DimCategories;

IF OBJECT_ID('dim.DimCustomers', 'U') IS NOT NULL
    DROP TABLE dim.DimCustomers;

IF OBJECT_ID('dim.DimTerritories', 'U') IS NOT NULL
    DROP TABLE dim.DimTerritories;

IF OBJECT_ID('dim.DimRegion', 'U') IS NOT NULL
    DROP TABLE dim.DimRegion;

IF OBJECT_ID('dim.DimDate', 'U') IS NOT NULL
    DROP TABLE dim.DimDate;


-- Create DimRegion table with a primary key
CREATE TABLE dim.DimRegion (
    RegionID INT PRIMARY KEY, -- Primary Key
    RegionName NVARCHAR(100) NOT NULL
);


-- Create DimTerritories table with a foreign key referencing DimRegion
CREATE TABLE dim.DimTerritories (
    TerritoryID INT PRIMARY KEY, -- Primary Key
    TerritoryName NVARCHAR(100) NOT NULL,
    RegionID INT NOT NULL,
    FOREIGN KEY (RegionID) REFERENCES dim.DimRegion(RegionID)
);


-- Create DimCustomers table with a foreign key referencing DimTerritories
CREATE TABLE dim.DimCustomers (
    CustomerID INT PRIMARY KEY, -- Primary Key
    CustomerName NVARCHAR(100) NOT NULL,
    -- Add other customer fields as needed
    TerritoryID INT,
    FOREIGN KEY (TerritoryID) REFERENCES dim.DimTerritories(TerritoryID)
);


-- Create DimCategories table
CREATE TABLE dim.DimCategories (
    CategoryID INT PRIMARY KEY, -- Primary Key
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX)
);


-- Create DimProducts table with a foreign key referencing DimCategories
CREATE TABLE dim.DimProducts (
    ProductID INT PRIMARY KEY, -- Primary Key
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES dim.DimCategories(CategoryID)
);


-- Create DimDate table
CREATE TABLE dim.DimDate (
    DateID INT PRIMARY KEY, -- Primary Key
    Date DATE NOT NULL,
    Year INT,
    Month INT,
    Day INT
);


-- Create FactOrderDetails table with foreign keys referencing DimCustomers, DimProducts, and DimDate
CREATE TABLE fact.FactOrderDetails (
    OrderDetailID INT PRIMARY KEY, -- Primary Key
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    DateID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES dim.DimProducts(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES dim.DimCustomers(CustomerID),
    FOREIGN KEY (DateID) REFERENCES dim.DimDate(DateID)
);


-- Add additional table creation scripts below following the same pattern
-- Example:
-- CREATE TABLE dim.AnotherDimension (
--     DimensionID INT PRIMARY KEY,
--     DimensionName NVARCHAR(100) NOT NULL
-- );
