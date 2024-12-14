-- ================================================================
-- Step 1: Drop Existing Tables in Correct Order
-- ================================================================

-- Drop Fact and Dimension tables first to avoid dependency issues
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

-- Table: DimCategories
CREATE TABLE DimCategories (
    DimCategoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_nk INT UNIQUE NOT NULL, -- Business Key
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX)
);

-- Table: DimCustomers
CREATE TABLE DimCustomers (
    DimCustomersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID_nk NVARCHAR(10) UNIQUE NOT NULL, -- Business Key
    CompanyName NVARCHAR(100) NOT NULL,
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
    DimEmployeeID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID_nk INT UNIQUE NOT NULL, -- Business Key
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
    ReportsTo_sk_fk INT NULL, -- Self-referencing Foreign Key
    PhotoPath NVARCHAR(200)
);

-- Table: DimRegion
CREATE TABLE DimRegion (
    DimRegionID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_nk INT UNIQUE NOT NULL, -- Business Key
    RegionDescription NVARCHAR(100) NOT NULL,
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

-- Table: DimShippers
CREATE TABLE DimShippers (
    DimShippersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID_nk INT UNIQUE NOT NULL, -- Business Key
    CompanyName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(30)
);

-- Table: DimSuppliers
CREATE TABLE DimSuppliers (
    DimSuppliersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT UNIQUE NOT NULL, -- Business Key
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
    HomePage NVARCHAR(MAX)
);

-- Table: DimTerritories
CREATE TABLE DimTerritories (
    DimTerritoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID NVARCHAR(20) UNIQUE NOT NULL, -- Business Key
    TerritoryDescription NVARCHAR(100) NOT NULL,
    TerritoryCode NVARCHAR(20),
    Region_sk_fk INT NOT NULL -- Foreign Key to DimRegion
);

-- Table: DimProducts
CREATE TABLE DimProducts (
    DimProductID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ProductID_nk INT UNIQUE NOT NULL, -- Business Key
    ProductName NVARCHAR(100) NOT NULL,
    Supplier_sk_fk INT NOT NULL, -- Foreign Key to DimSuppliers
    Category_sk_fk INT NOT NULL, -- Foreign Key to DimCategories
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(18,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT
);

-- ================================================================
-- Step 3: Create Fact Tables Without Foreign Keys
-- ================================================================

-- Table: FactOrders
CREATE TABLE FactOrders (
    FactOrdersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT UNIQUE NOT NULL, -- Business Key
    Customer_sk_fk INT NOT NULL, -- Foreign Key to DimCustomers
    Employee_sk_fk INT NOT NULL, -- Foreign Key to DimEmployees
    OrderDate DATETIME NOT NULL,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    Shipper_sk_fk INT NOT NULL, -- Foreign Key to DimShippers
    Freight DECIMAL(18,2),
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(200),
    ShipCity NVARCHAR(50),
    ShipRegion NVARCHAR(50),
    ShipPostalCode NVARCHAR(20),
    ShipCountry NVARCHAR(50),
    Territory_sk_fk INT NOT NULL -- Foreign Key to DimTerritories
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailsID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    Order_sk_fk INT NOT NULL, -- Foreign Key to FactOrders
    Product_sk_fk INT NOT NULL, -- Foreign Key to DimProducts
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(5,2)
);

-- ================================================================
-- Step 4: Add Foreign Key Constraints Using ALTER TABLE
-- ================================================================

-- Foreign Keys for DimEmployees
ALTER TABLE DimEmployees
    ADD CONSTRAINT FK_DimEmployees_ReportsTo
    FOREIGN KEY (ReportsTo_sk_fk) REFERENCES DimEmployees(DimEmployeeID_sk_pk);

-- Foreign Keys for DimTerritories
ALTER TABLE DimTerritories
    ADD CONSTRAINT FK_DimTerritories_DimRegion
    FOREIGN KEY (Region_sk_fk) REFERENCES DimRegion(DimRegionID_sk_pk);

-- Foreign Keys for DimProducts
ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimSuppliers
    FOREIGN KEY (Supplier_sk_fk) REFERENCES DimSuppliers(DimSuppliersID_sk_pk);

ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimCategories
    FOREIGN KEY (Category_sk_fk) REFERENCES DimCategories(DimCategoriesID_sk_pk);

-- Foreign Keys for FactOrders
ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimCustomers
    FOREIGN KEY (Customer_sk_fk) REFERENCES DimCustomers(DimCustomersID_sk_pk);

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimEmployees
    FOREIGN KEY (Employee_sk_fk) REFERENCES DimEmployees(DimEmployeeID_sk_pk);

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimShippers
    FOREIGN KEY (Shipper_sk_fk) REFERENCES DimShippers(DimShippersID_sk_pk);

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimTerritories
    FOREIGN KEY (Territory_sk_fk) REFERENCES DimTerritories(DimTerritoriesID_sk_pk);

-- Foreign Keys for OrderDetails
ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_FactOrders
    FOREIGN KEY (Order_sk_fk) REFERENCES FactOrders(FactOrdersID_sk_pk);

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_DimProducts
    FOREIGN KEY (Product_sk_fk) REFERENCES DimProducts(DimProductID_sk_pk);
