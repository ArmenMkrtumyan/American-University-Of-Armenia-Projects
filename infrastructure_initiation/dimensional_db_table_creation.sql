DROP TABLE IF EXISTS DimCategories;
DROP TABLE IF EXISTS DimCustomers;
DROP TABLE IF EXISTS DimEmployees;
DROP TABLE IF EXISTS DimTerritories;
DROP TABLE IF EXISTS DimSuppliers;
DROP TABLE IF EXISTS DimShippers;
DROP TABLE IF EXISTS DimProducts;
DROP TABLE IF EXISTS DimRegion;
DROP TABLE IF EXISTS FactOrders;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS DimSOR;



-- Table: SOR
CREATE TABLE DimSOR (
    dim_sor_sk_pk INT IDENTITY(1,1) PRIMARY KEY,  
    staging_raw_id INT NOT NULL,                  
    staging_key_column NVARCHAR(100) NOT NULL,   
    ingestion_date DATETIME DEFAULT GETDATE()
);




-- Table: DimCategories
CREATE TABLE DimCategories (
	DimCategoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_category_id INT,
	dim_sor_sk_fk INT,
    CategoryID_nk INT,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(MAX),
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)

);

-- Table: DimCustomers
CREATE TABLE DimCustomers (
	DimCustomersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_customer_id INT,
	dim_sor_sk_fk INT,
    CustomerID_nk NVARCHAR(10),
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
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimEmployees
CREATE TABLE DimEmployees (
	DimEmployeeID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_employee_id INT,
	dim_sor_sk_fk INT,
    EmployeeID_nk INT,
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
    PhotoPath NVARCHAR(200),
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
	OrderDetailsID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_orderdetail_id INT,
	dim_sor_sk_fk INT,
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(18,2),
    Quantity INT,
    Discount DECIMAL(5,2),
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)

);

-- Table: FactOrders
CREATE TABLE FactOrders (
	FactOrdersID_sk_pk INT  IDENTITY(1,1) PRIMARY KEY,
    staging_raw_order_id INT,
	dim_sor_sk_fk INT,
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
    TerritoryID INT,
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimProducts
CREATE TABLE DimProducts (
	DimProductID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_product_id INT,
	dim_sor_sk_fk INT,
    ProductID_nk INT,
    ProductName NVARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(18,2),
    UnitsInStock SMALLINT,
    UnitsOnOrder SMALLINT,
    ReorderLevel SMALLINT,
    Discontinued BIT,
	FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimRegion
CREATE TABLE DimRegion (
    DimRegionID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_region_id INT,
    dim_sor_sk_fk INT,
    RegionID_nk INT,
    RegionDescription NVARCHAR(100),
    RegionCategory NVARCHAR(50),
    RegionImportance NVARCHAR(50),
    FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimShippers
CREATE TABLE DimShippers (
    DimShippersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_shipper_id INT,
    dim_sor_sk_fk INT,
    ShipperID_nk INT,
    CompanyName NVARCHAR(100),
    Phone NVARCHAR(30),
    FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimSuppliers
CREATE TABLE DimSuppliers (
    DimSuppliersID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_supplier_id INT,
    dim_sor_sk_fk INT,
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
    HomePage NVARCHAR(MAX),
    FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

-- Table: DimTerritories
CREATE TABLE DimTerritories (
    DimTerritoriesID_sk_pk INT IDENTITY(1,1) PRIMARY KEY,
    staging_raw_territory_id INT,
    dim_sor_sk_fk INT,
    TerritoryID NVARCHAR(20),
    TerritoryDescription NVARCHAR(100),
    TerritoryCode NVARCHAR(20),
    RegionID INT,
    FOREIGN KEY (dim_sor_sk_fk) REFERENCES DimSOR (dim_sor_sk_pk)
);

