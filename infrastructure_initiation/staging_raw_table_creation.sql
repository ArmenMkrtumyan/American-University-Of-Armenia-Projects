USE ORDER_DDS;

DROP TABLE IF EXISTS Categories_Staging;
DROP TABLE IF EXISTS Customers_Staging;
DROP TABLE IF EXISTS Employees_Staging;
DROP TABLE IF EXISTS OrderDetails_Staging;
DROP TABLE IF EXISTS Orders_Staging;
DROP TABLE IF EXISTS Products_Staging;
DROP TABLE IF EXISTS Regions_Staging;
DROP TABLE IF EXISTS Shippers_Staging;
DROP TABLE IF EXISTS Suppliers_Staging;
DROP TABLE IF EXISTS Territories_Staging;

CREATE TABLE Categories_Staging (
    staging_raw_category_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(MAX)
);

CREATE TABLE Customers_Staging (
    staging_raw_customer_id INT IDENTITY(1,1) PRIMARY KEY,
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

CREATE TABLE Employees_Staging (
    staging_raw_employee_id INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Title NVARCHAR(50),
    TitleOfCourtesy NVARCHAR(50),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    HomePhone NVARCHAR(30),
    Extension NVARCHAR(10),
    Photo VARBINARY(MAX),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(200)
);

CREATE TABLE OrderDetails_Staging (
    staging_raw_orderdetail_id INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2)
);

CREATE TABLE Orders_Staging (
    staging_raw_order_id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(10),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(10,2),
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(200),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    TerritoryID INT
);

CREATE TABLE Products_Staging (
    staging_raw_product_id INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

CREATE TABLE Regions_Staging (
    staging_raw_region_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionDescription NVARCHAR(100)
);

CREATE TABLE Shippers_Staging (
    staging_raw_shipper_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(30)
);

CREATE TABLE Suppliers_Staging (
    staging_raw_supplier_id INT IDENTITY(1,1) PRIMARY KEY,
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

CREATE TABLE Territories_Staging (
    staging_raw_territory_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryDescription NVARCHAR(100),
    RegionID INT
);
