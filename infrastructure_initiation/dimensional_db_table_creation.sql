USE ORDER_DDS;
GO


-- ================================================================
-- Step 1: Drop Existing Tables in Correct Order
-- ================================================================
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS FactOrders;
DROP TABLE IF EXISTS DimCategories;
DROP TABLE IF EXISTS DimCustomers;
DROP TABLE IF EXISTS DimEmployees;
DROP TABLE IF EXISTS DimTerritories;
DROP TABLE IF EXISTS DimSuppliers;
DROP TABLE IF EXISTS DimShippers;
DROP TABLE IF EXISTS DimProducts;
DROP TABLE IF EXISTS DimRegion;

DROP CONSTRAINT IF EXISTS FK_OrderDetails_FactOrders;
DROP CONSTRAINT IF EXISTS FK_OrderDetails_DimProducts;
DROP CONSTRAINT IF EXISTS FK_FactOrders_DimCustomers;
DROP CONSTRAINT IF EXISTS FK_FactOrders_DimEmployees;
DROP CONSTRAINT IF EXISTS FK_FactOrders_DimShippers;
DROP CONSTRAINT IF EXISTS FK_FactOrders_DimTerritories;
DROP CONSTRAINT IF EXISTS FK_DimProducts_DimSuppliers;
DROP CONSTRAINT IF EXISTS FK_DimProducts_DimCategories;
DROP CONSTRAINT IF EXISTS FK_DimTerritories_DimRegion;
DROP CONSTRAINT IF EXISTS FK_DimEmployees_ReportsTo;

-- ================================================================
-- Step 2: Create Dimension Tables Without Foreign Keys
-- ================================================================

CREATE TABLE DimCategories (
    CategoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_nk INT UNIQUE NOT NULL, 
    CategoryName NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX));

CREATE TABLE DimCustomers (
    CustomersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID_nk NVARCHAR(10) UNIQUE NOT NULL, 
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(50),
    [Address] NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30));

CREATE TABLE DimEmployees (
    EmployeeID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID_nk INT UNIQUE NOT NULL, 
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
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
    ReportsTo INT NULL, 
    PhotoPath NVARCHAR(200));


CREATE TABLE OrderDetails (
    OrderDetailsID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    Order_sk_fk INT NOT NULL, 
    Product_sk_fk INT NOT NULL, 
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(5,2));

CREATE TABLE DimRegion (
    RegionID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_nk INT UNIQUE NOT NULL, 
    RegionDescription NVARCHAR(100) NOT NULL,
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50));

CREATE TABLE DimShippers (
    ShippersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID_nk INT UNIQUE NOT NULL, 
    CompanyName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(30));

CREATE TABLE DimSuppliers (
    SuppliersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID_nk INT UNIQUE NOT NULL, 
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    ContactTitle NVARCHAR(50),
    [Address] NVARCHAR(200),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30),
    HomePage NVARCHAR(MAX));

CREATE TABLE DimTerritories (
    TerritoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID_nk NVARCHAR(20) UNIQUE NOT NULL, 
    TerritoryDescription NVARCHAR(100) NOT NULL,
    TerritoryCode NVARCHAR(20),
    Region_sk_fk INT NOT NULL);


CREATE TABLE DimProducts (
    ProductID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ProductID_nk INT UNIQUE NOT NULL, 
    ProductName NVARCHAR(100) NOT NULL,
    Supplier_sk_fk INT NOT NULL, 
    Category_sk_fk INT NOT NULL, 
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(18,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT);

-- ================================================================
-- Step 3: Create Fact Tables
-- ================================================================

CREATE TABLE FactOrders (
    FactOrdersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    OrderID_nk INT UNIQUE NOT NULL,
    Customer_sk_fk INT NOT NULL,
    Employee_sk_fk INT NOT NULL, 
    OrderDate DATETIME NOT NULL,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT NOT NULL, 
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(200),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    Territory_sk_fk INT NOT NULL);


-- ================================================================
-- Step 4: Add Foreign Key Constraints Using ALTER TABLE
-- ================================================================

ALTER TABLE DimEmployees
    ADD CONSTRAINT FK_DimEmployees_ReportsTo
    FOREIGN KEY (ReportsTo) REFERENCES DimEmployees(EmployeeID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DimTerritories
    ADD CONSTRAINT FK_DimTerritories_DimRegion
    FOREIGN KEY (Region_sk_fk) REFERENCES DimRegion(RegionID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimSuppliers
    FOREIGN KEY (Supplier_sk_fk) REFERENCES DimSuppliers(SuppliersID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimCategories
    FOREIGN KEY (Category_sk_fk) REFERENCES DimCategories(CategoriesID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimCustomers
    FOREIGN KEY (Customer_sk_fk) REFERENCES DimCustomers(CustomersID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimEmployees
    FOREIGN KEY (Employee_sk_fk) REFERENCES DimEmployees(EmployeeID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimShippers
    FOREIGN KEY (ShipVia) REFERENCES DimShippers(ShippersID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimTerritories
    FOREIGN KEY (Territory_sk_fk) REFERENCES DimTerritories(TerritoriesID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_FactOrders
    FOREIGN KEY (Order_sk_fk) REFERENCES FactOrders(FactOrdersID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_DimProducts
    FOREIGN KEY (Product_sk_fk) REFERENCES DimProducts(ProductID_sk_pk) ON DELETE CASCADE ON UPDATE CASCADE;




-- ================================================================
-- FactOrders : Snapshot
-- ================================================================


