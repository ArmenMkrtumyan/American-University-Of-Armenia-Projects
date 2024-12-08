-- staging_raw_table_creation.sql
-- Location: infrastructure_initiation folder
-- Description: Creates staging raw tables for data ingestion

-- Table: DimCategories
CREATE TABLE DimCategories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(MAX)
);

-- Table: DimCustomers
CREATE TABLE DimCustomers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(10),
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(50),
    [Address] NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30)
);

-- Table: DimEmployees
CREATE TABLE DimEmployees (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Title NVARCHAR(50),
    TitleOfCourtesy NVARCHAR(50),
    BirthDate DATETIME,
    HireDate DATETIME,
    [Address] NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    HomePhone NVARCHAR(30),
    Extension NVARCHAR(10),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(200)
);

CREATE TABLE OrderDetails (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(18,2),
    Quantity INT,
    Discount DECIMAL(5,2)
);

-- Table: FactOrders
CREATE TABLE FactOrders (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NVARCHAR(10),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(200),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    TerritoryID INT
);

-- Table: DimProducts
CREATE TABLE DimProducts (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(18,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- Table: DimRegion
CREATE TABLE DimRegion (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

-- Table: DimShippers
CREATE TABLE DimShippers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(30)
);

-- Table: DimSuppliers
CREATE TABLE DimSuppliers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    CompanyName NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(50),
    [Address] NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30),
    HomePage NVARCHAR(MAX)
);

-- Table: DimTerritories
CREATE TABLE DimTerritories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(100),
    TerritoryCode NVARCHAR(20),
    RegionID INT
);

