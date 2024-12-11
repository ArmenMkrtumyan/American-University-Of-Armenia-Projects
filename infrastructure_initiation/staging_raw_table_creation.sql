CREATE TABLE DimCategories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(MAX)
);

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

CREATE TABLE DimRegion (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

CREATE TABLE DimShippers (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(30)
);

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

CREATE TABLE DimTerritories (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(100),
    TerritoryCode NVARCHAR(20),
    RegionID INT,
    CONSTRAINT FK_DimTerritories_DimRegion FOREIGN KEY (RegionID)
        REFERENCES DimRegion(RegionID)
);

CREATE TABLE DimDate (
    staging_raw_id INT IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE NOT NULL,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    DayOfWeek NVARCHAR(20),
    MonthName NVARCHAR(20),
    QuarterName NVARCHAR(20)
);


ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimCustomers FOREIGN KEY (CustomerID)
REFERENCES DimCustomers (CustomerID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimEmployees FOREIGN KEY (EmployeeID)
REFERENCES DimEmployees (EmployeeID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimProducts FOREIGN KEY (ProductID)
REFERENCES DimProducts (ProductID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimShippers FOREIGN KEY (ShipVia)
REFERENCES DimShippers (ShipperID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimTerritories FOREIGN KEY (TerritoryID)
REFERENCES DimTerritories (TerritoryID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimDate FOREIGN KEY (OrderDate)
REFERENCES DimDate (FullDate);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimDate FOREIGN KEY (OrderDate)
REFERENCES DimDate (FullDate);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_FactOrders FOREIGN KEY (OrderID)
REFERENCES FactOrders (OrderID);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_DimProducts FOREIGN KEY (ProductID)
REFERENCES DimProducts (ProductID);

ALTER TABLE DimTerritories
ADD CONSTRAINT FK_DimTerritories_DimRegion
FOREIGN KEY (RegionID)
REFERENCES DimRegion (RegionID);

ALTER TABLE FactOrders
ADD CONSTRAINT FK_FactOrders_DimDate FOREIGN KEY (OrderDate)
REFERENCES DimDate (FullDate);
