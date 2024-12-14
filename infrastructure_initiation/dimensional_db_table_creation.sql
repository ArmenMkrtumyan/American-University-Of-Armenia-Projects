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
IF OBJECT_ID('dbo.Dim_SOR','U')         IS NOT NULL DROP TABLE dbo.Dim_SOR;


---------------------------------------------------------------------------
-- 1) CREATE DIMENSION AND FACT TABLES
---------------------------------------------------------------------------
CREATE TABLE dbo.DimCategories (
    CategoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_nk INT UNIQUE NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(MAX)
);


CREATE TABLE dbo.DimCustomers (
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


CREATE TABLE dbo.DimEmployees (
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


CREATE TABLE dbo.DimRegion (
    RegionID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    RegionID_nk INT UNIQUE NOT NULL,
    RegionDescription NVARCHAR(100) NOT NULL,
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50)
);


CREATE TABLE dbo.DimShippers (
    ShippersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID_nk INT UNIQUE NOT NULL,
    CompanyName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(30)
);


CREATE TABLE dbo.DimSuppliers (
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


CREATE TABLE dbo.DimTerritories (
    TerritoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    TerritoryID_nk INT UNIQUE NOT NULL,
    TerritoryDescription NVARCHAR(100) NOT NULL,
    TerritoryCode NVARCHAR(20),
    Region_sk_fk INT NOT NULL
);


CREATE TABLE dbo.DimProducts (
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


CREATE TABLE dbo.FactOrders (
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


CREATE TABLE dbo.OrderDetails (
    OrderDetailsID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    Order_sk_fk INT NOT NULL,
    Product_sk_fk INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(5,2)
);


CREATE TABLE dbo.Dim_SOR (
    SORID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    RawTableName NVARCHAR(100) NOT NULL
);


---------------------------------------------------------------------------
-- 2) ADD FOREIGN KEY CONSTRAINTS
---------------------------------------------------------------------------
ALTER TABLE dbo.DimEmployees
    ADD CONSTRAINT FK_DimEmployees_RepoartsTo
    FOREIGN KEY (ReportsTo) REFERENCES dbo.DimEmployees(EmployeeID_sk_pk)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE dbo.DimTerritories
    ADD CONSTRAINT FK_DimTerritories_DimRegion
    FOREIGN KEY (Region_sk_fk) REFERENCES dbo.DimRegion(RegionID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.DimProducts
    ADD CONSTRAINT FK_DimProducts_DimSuppliers
    FOREIGN KEY (Supplier_sk_fk) REFERENCES dbo.DimSuppliers(SuppliersID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.DimProducts
    ADD CONSTRAINT FK_DimProducts_DimCategories
    FOREIGN KEY (Category_sk_fk) REFERENCES dbo.DimCategories(CategoriesID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.FactOrders
    ADD CONSTRAINT FK_FactOrders_DimCustomers
    FOREIGN KEY (Customer_sk_fk) REFERENCES dbo.DimCustomers(CustomersID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.FactOrders
    ADD CONSTRAINT FK_FactOrders_DimEmployees
    FOREIGN KEY (Employee_sk_fk) REFERENCES dbo.DimEmployees(EmployeeID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.FactOrders
    ADD CONSTRAINT FK_FactOrders_DimShippers
    FOREIGN KEY (ShipVia) REFERENCES dbo.DimShippers(ShippersID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.FactOrders
    ADD CONSTRAINT FK_FactOrders_DimTerritories
    FOREIGN KEY (Territory_sk_fk) REFERENCES dbo.DimTerritories(TerritoriesID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.OrderDetails
    ADD CONSTRAINT FK_OrderDetails_FactOrders
    FOREIGN KEY (Order_sk_fk) REFERENCES dbo.FactOrders(FactOrdersID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE dbo.OrderDetails
    ADD CONSTRAINT FK_OrderDetails_DimProducts
    FOREIGN KEY (Product_sk_fk) REFERENCES dbo.DimProducts(ProductID_sk_pk)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-------------------------------------------------------------------------------
-- 3) DimCategories SCD 1 with Delete
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.DimCategories_SCD1;


CREATE TABLE dbo.DimCategories_SCD1 (
    CategoriesID_sk_pk INT PRIMARY KEY IDENTITY(1, 1), 
    CategoryID_nk      INT,                            
    CategoryName       NVARCHAR(255) NOT NULL,
    [Description]      VARCHAR(500)  NULL
);

MERGE dbo.DimCategories_SCD1 AS DST
USING dbo.Categories_Staging AS SRC
    ON (DST.CategoryID_nk = SRC.CategoryID)
WHEN MATCHED 
    AND (
       ISNULL(DST.CategoryName, '') <> ISNULL(SRC.CategoryName, '') 
       OR ISNULL(DST.[Description], '') <> ISNULL(SRC.[Description], '')
    )
THEN
    UPDATE
    SET
        DST.CategoryName  = SRC.CategoryName,
        DST.[Description] = SRC.[Description]
WHEN NOT MATCHED BY TARGET
THEN
    INSERT (CategoryID_nk, CategoryName, [Description])
    VALUES (SRC.CategoryID, SRC.CategoryName, SRC.[Description])
WHEN NOT MATCHED BY SOURCE
THEN
    DELETE;

SELECT * FROM dbo.DimCategories_SCD1;




-------------------------------------------------------------------------------
-- 4) DimCustomers SCD 2
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.DimCustomers_SCD2;
CREATE TABLE dbo.DimCustomers_SCD2
(
    DimCustomersSK INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID_nk  NVARCHAR(10)  NOT NULL,
    CompanyName    NVARCHAR(100) NOT NULL,
    ContactName    NVARCHAR(100),
    ContactTitle   NVARCHAR(50),
    [Address]      NVARCHAR(200),
    City           NVARCHAR(50),
    Region         NVARCHAR(50),
    PostalCode     NVARCHAR(20),
    Country        NVARCHAR(50),
    Phone          NVARCHAR(30),
    Fax            NVARCHAR(30),
    ValidFrom      INT,
    ValidTo        INT,
    IsCurrent      BIT
);

IF OBJECT_ID('dbo.Customers_Staging','U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers_Staging
    (
        CustomerID   NVARCHAR(10),
        CompanyName  NVARCHAR(100),
        ContactName  NVARCHAR(100),
        ContactTitle NVARCHAR(50),
        [Address]    NVARCHAR(200),
        City         NVARCHAR(50),
        Region       NVARCHAR(50),
        PostalCode   NVARCHAR(20),
        Country      NVARCHAR(50),
        Phone        NVARCHAR(30),
        Fax          NVARCHAR(30)
    );
END;

DECLARE @Yesterday INT = (YEAR(DATEADD(DAY, -1, GETDATE())) * 10000) + (MONTH(DATEADD(DAY, -1, GETDATE())) * 100) + DAY(DATEADD(DAY, -1, GETDATE()));
DECLARE @Today INT = (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE());

IF OBJECT_ID('tempdb..#DimCustomersUpdates') IS NOT NULL
    DROP TABLE #DimCustomersUpdates;

CREATE TABLE #DimCustomersUpdates
(
    ActionTaken   NVARCHAR(10),
    CustomerID    NVARCHAR(10),
    CompanyName   NVARCHAR(100),
    ContactName   NVARCHAR(100),
    ContactTitle  NVARCHAR(50),
    [Address]     NVARCHAR(200),
    City          NVARCHAR(50),
    Region        NVARCHAR(50),
    PostalCode    NVARCHAR(20),
    Country       NVARCHAR(50),
    Phone         NVARCHAR(30),
    Fax           NVARCHAR(30)
);

MERGE dbo.DimCustomers_SCD2 AS DST
USING dbo.Customers_Staging AS SRC
    ON DST.CustomerID_nk = SRC.CustomerID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        CustomerID_nk,
        CompanyName,
        ContactName,
        ContactTitle,
        [Address],
        City,
        Region,
        PostalCode,
        Country,
        Phone,
        Fax,
        ValidFrom,
        IsCurrent
    )
    VALUES (
        SRC.CustomerID,
        SRC.CompanyName,
        SRC.ContactName,
        SRC.ContactTitle,
        SRC.[Address],
        SRC.City,
        SRC.Region,
        SRC.PostalCode,
        SRC.Country,
        SRC.Phone,
        SRC.Fax,
        @Today,
        1
    )
WHEN MATCHED 
     AND DST.IsCurrent = 1
     AND (
            ISNULL(DST.CompanyName,'') <> ISNULL(SRC.CompanyName,'')
         OR ISNULL(DST.ContactName,'') <> ISNULL(SRC.ContactName,'')
         OR ISNULL(DST.ContactTitle,'') <> ISNULL(SRC.ContactTitle,'')
         OR ISNULL(DST.[Address],'') <> ISNULL(SRC.[Address],'')
         OR ISNULL(DST.City,'') <> ISNULL(SRC.City,'')
         OR ISNULL(DST.Region,'') <> ISNULL(SRC.Region,'')
         OR ISNULL(DST.PostalCode,'') <> ISNULL(SRC.PostalCode,'')
         OR ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'')
         OR ISNULL(DST.Phone,'') <> ISNULL(SRC.Phone,'')
         OR ISNULL(DST.Fax,'') <> ISNULL(SRC.Fax,'')
        )
THEN 
    UPDATE
        SET DST.IsCurrent = 0,
            DST.ValidTo   = @Yesterday
    OUTPUT
        $action,
        SRC.CustomerID,
        SRC.CompanyName,
        SRC.ContactName,
        SRC.ContactTitle,
        SRC.[Address],
        SRC.City,
        SRC.Region,
        SRC.PostalCode,
        SRC.Country,
        SRC.Phone,
        SRC.Fax
    INTO #DimCustomersUpdates;

INSERT INTO dbo.DimCustomers_SCD2
(
    CustomerID_nk,
    CompanyName,
    ContactName,
    ContactTitle,
    [Address],
    City,
    Region,
    PostalCode,
    Country,
    Phone,
    Fax,
    ValidFrom,
    IsCurrent
)
SELECT
    U.CustomerID,
    U.CompanyName,
    U.ContactName,
    U.ContactTitle,
    U.[Address],
    U.City,
    U.Region,
    U.PostalCode,
    U.Country,
    U.Phone,
    U.Fax,
    @Today,
    1
FROM #DimCustomersUpdates U
WHERE U.ActionTaken = 'UPDATE';



---------------------------------------------------------------------------
-- 3) ADD FOREIGN KEY CONSTRAINT FOR Dim_SOR IF REQUIRED
---------------------------------------------------------------------------
-- If there are tables that should reference Dim_SOR, add foreign key constraints here.
-- Example:
-- ALTER TABLE dbo.SomeTable
--     ADD CONSTRAINT FK_SomeTable_Dim_SOR
--     FOREIGN KEY (SOR_sk_fk) REFERENCES dbo.Dim_SOR(SORID_sk_pk)
--     ON DELETE CASCADE
--     ON UPDATE CASCADE;
--
---------------------------------------------------------------------------
-- 4) FACT TABLE SNAPSHOT
---------------------------------------------------------------------------

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
