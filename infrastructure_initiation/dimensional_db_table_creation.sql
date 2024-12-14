USE ORDER_DDS;

-- ================================================================
-- 0) Drop Existing Tables in Correct Order
-- ================================================================



IF OBJECT_ID('dbo.OrderDetails','U')    IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.FactOrders','U')      IS NOT NULL DROP TABLE dbo.FactOrders;
IF OBJECT_ID('dbo.DimProducts','U')     IS NOT NULL DROP TABLE dbo.DimProducts;
IF OBJECT_ID('dbo.DimCategories','U')   IS NOT NULL DROP TABLE dbo.DimCategories;
IF OBJECT_ID('dbo.DimCustomers','U')    IS NOT NULL DROP TABLE dbo.DimCustomers;
IF OBJECT_ID('dbo.DimEmployees','U')    IS NOT NULL DROP TABLE dbo.DimEmployees;
IF OBJECT_ID('dbo.DimTerritories','U')  IS NOT NULL DROP TABLE dbo.DimTerritories;
IF OBJECT_ID('dbo.DimSuppliers','U')    IS NOT NULL DROP TABLE dbo.DimSuppliers;
IF OBJECT_ID('dbo.DimShippers','U')     IS NOT NULL DROP TABLE dbo.DimShippers;
IF OBJECT_ID('dbo.DimRegion','U')       IS NOT NULL DROP TABLE dbo.DimRegion;




-------------------------------------------------------------------------------
-- 1) CREATE DIMENSION AND FACT TABLES
-------------------------------------------------------------------------------
CREATE TABLE DimCategories (
    CategoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_nk INT UNIQUE NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX)
);

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
    Fax NVARCHAR(30)
);

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
    PhotoPath NVARCHAR(200)
);

CREATE TABLE DimRegion (
    RegionID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_nk INT UNIQUE NOT NULL,
    RegionDescription NVARCHAR(100) NOT NULL,
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);

CREATE TABLE DimShippers (
    ShippersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID_nk INT UNIQUE NOT NULL,
    CompanyName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(30)
);

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
    HomePage NVARCHAR(MAX)
);

CREATE TABLE DimTerritories (
    TerritoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID_nk INT UNIQUE NOT NULL,
    TerritoryDescription NVARCHAR(100) NOT NULL,
    TerritoryCode NVARCHAR(20),
    Region_sk_fk INT NOT NULL
);

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
    Discontinued BIT
);

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
    Territory_sk_fk INT NOT NULL
);

CREATE TABLE OrderDetails (
    OrderDetailsID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    Order_sk_fk INT NOT NULL,
    Product_sk_fk INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(5,2)
);



-------------------------------------------------------------------------------
-- 2) ADD FOREIGN KEY CONSTRAINTS
-------------------------------------------------------------------------------
ALTER TABLE DimEmployees
    ADD CONSTRAINT FK_DimEmployees_ReportsTo
    FOREIGN KEY (ReportsTo) REFERENCES DimEmployees(EmployeeID_sk_pk)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE DimTerritories
    ADD CONSTRAINT FK_DimTerritories_DimRegion
    FOREIGN KEY (Region_sk_fk) REFERENCES DimRegion(RegionID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimSuppliers
    FOREIGN KEY (Supplier_sk_fk) REFERENCES DimSuppliers(SuppliersID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DimProducts
    ADD CONSTRAINT FK_DimProducts_DimCategories
    FOREIGN KEY (Category_sk_fk) REFERENCES DimCategories(CategoriesID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimCustomers
    FOREIGN KEY (Customer_sk_fk) REFERENCES DimCustomers(CustomersID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimEmployees
    FOREIGN KEY (Employee_sk_fk) REFERENCES DimEmployees(EmployeeID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimShippers
    FOREIGN KEY (ShipVia) REFERENCES DimShippers(ShippersID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FactOrders
    ADD CONSTRAINT FK_FactOrders_DimTerritories
    FOREIGN KEY (Territory_sk_fk) REFERENCES DimTerritories(TerritoriesID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_FactOrders
    FOREIGN KEY (Order_sk_fk) REFERENCES FactOrders(FactOrdersID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OrderDetails
    ADD CONSTRAINT FK_OrderDetails_DimProducts
    FOREIGN KEY (Product_sk_fk) REFERENCES DimProducts(ProductID_sk_pk)
    ON DELETE CASCADE ON UPDATE CASCADE;



-------------------------------------------------------------------------------
-- 3) FACT TABLE SNAPSHOT
-------------------------------------------------------------------------------


MERGE dbo.FactOrders AS DST
USING (
    SELECT
        stg.OrderID AS OrderID_nk,
        stg.OrderDate,
        stg.RequiredDate,
        stg.ShippedDate,
        c.CustomersID_sk_pk    AS Customer_sk_fk,
        e.EmployeeID_sk_pk     AS Employee_sk_fk,
        shp.ShippersID_sk_pk   AS ShipVia,
        ter.TerritoriesID_sk_pk AS Territory_sk_fk,
        stg.Freight,
        stg.ShipName,
        stg.ShipAddress,
        stg.ShipCity,
        stg.ShipRegion,
        stg.ShipPostalCode,
        stg.ShipCountry
    FROM dbo.Orders_Staging AS stg
    LEFT JOIN dbo.DimCustomers    AS c   ON stg.CustomerID  = c.CustomerID_nk
    LEFT JOIN dbo.DimEmployees    AS e   ON stg.EmployeeID  = e.EmployeeID_nk
    LEFT JOIN dbo.DimShippers     AS shp ON stg.ShipVia     = shp.ShipperID_nk
    LEFT JOIN dbo.DimTerritories  AS ter ON stg.TerritoryID = ter.TerritoryID_nk
) AS SRC
ON DST.OrderID_nk = SRC.OrderID_nk

WHEN MATCHED AND (
       ISNULL(DST.Customer_sk_fk,  0) <> ISNULL(SRC.Customer_sk_fk,  0)
    OR ISNULL(DST.Employee_sk_fk,  0) <> ISNULL(SRC.Employee_sk_fk,  0)
    OR ISNULL(DST.ShipVia,         0) <> ISNULL(SRC.ShipVia,         0)
    OR ISNULL(DST.Territory_sk_fk, 0) <> ISNULL(SRC.Territory_sk_fk, 0)
    OR ISNULL(DST.OrderDate,       '1900-01-01') <> ISNULL(SRC.OrderDate,       '1900-01-01')
    OR ISNULL(DST.RequiredDate,    '1900-01-01') <> ISNULL(SRC.RequiredDate,    '1900-01-01')
    OR ISNULL(DST.ShippedDate,     '1900-01-01') <> ISNULL(SRC.ShippedDate,     '1900-01-01')
    OR ISNULL(DST.Freight,         0)            <> ISNULL(SRC.Freight,         0)
    OR ISNULL(DST.ShipName,        '')           <> ISNULL(SRC.ShipName,        '')
    OR ISNULL(DST.ShipAddress,     '')           <> ISNULL(SRC.ShipAddress,     '')
    OR ISNULL(DST.ShipCity,        '')           <> ISNULL(SRC.ShipCity,        '')
    OR ISNULL(DST.ShipRegion,      '')           <> ISNULL(SRC.ShipRegion,      '')
    OR ISNULL(DST.ShipPostalCode,  '')           <> ISNULL(SRC.ShipPostalCode,  '')
    OR ISNULL(DST.ShipCountry,     '')           <> ISNULL(SRC.ShipCountry,     '')
)
THEN
    UPDATE SET
       DST.Customer_sk_fk   = SRC.Customer_sk_fk,
       DST.Employee_sk_fk   = SRC.Employee_sk_fk,
       DST.ShipVia          = SRC.ShipVia,
       DST.Territory_sk_fk  = SRC.Territory_sk_fk,
       DST.OrderDate        = SRC.OrderDate,
       DST.RequiredDate     = SRC.RequiredDate,
       DST.ShippedDate      = SRC.ShippedDate,
       DST.Freight          = SRC.Freight,
       DST.ShipName         = SRC.ShipName,
       DST.ShipAddress      = SRC.ShipAddress,
       DST.ShipCity         = SRC.ShipCity,
       DST.ShipRegion       = SRC.ShipRegion,
       DST.ShipPostalCode   = SRC.ShipPostalCode,
       DST.ShipCountry      = SRC.ShipCountry

WHEN NOT MATCHED BY TARGET
THEN INSERT (
    OrderID_nk,
    Customer_sk_fk,
    Employee_sk_fk,
    ShipVia,
    Territory_sk_fk,
    OrderDate,
    RequiredDate,
    ShippedDate,
    Freight,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipRegion,
    ShipPostalCode,
    ShipCountry
)
VALUES (
    SRC.OrderID_nk,
    SRC.Customer_sk_fk,
    SRC.Employee_sk_fk,
    SRC.ShipVia,
    SRC.Territory_sk_fk,
    SRC.OrderDate,
    SRC.RequiredDate,
    SRC.ShippedDate,
    SRC.Freight,
    SRC.ShipName,
    SRC.ShipAddress,
    SRC.ShipCity,
    SRC.ShipRegion,
    SRC.ShipPostalCode,
    SRC.ShipCountry
)

WHEN NOT MATCHED BY SOURCE
THEN DELETE;