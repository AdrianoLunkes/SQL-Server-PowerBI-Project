-- ##################################################
--     SQL SERVER AND POWER BI INTEGRATION PROJECT
-- ##################################################

-- 1. Introduction


-- 2. Download AdventureWorks 2022 Database

/*
https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms
*/

-- 3. Defining the project indicators

-- GENERAL TAB

-- i) Total Revenue
-- ii) Quantity Sold
-- iii) Total Product Categories
-- iv) Number of Customers
-- v) Total Revenue and Total Profit by Month
-- vi) Profit Margin
-- vii) Quantity Sold by Month
-- viii) Profit by Country

-- CUSTOMERS TAB

-- i) Sales by Country
-- ii) Customers by Country
-- iii) Sales by Gender
-- iv) Sales by Category




-- 4. Defining the tables and columns to be used in the project

-- TABLES

SELECT * FROM FactInternetSales
SELECT * FROM DimProductCategory
SELECT * FROM DimCustomer
SELECT * FROM DimGeography


-- COLUMNS
 
-- SalesOrderNumber                    (FactInternetSales)
-- OrderDate + 7 Years                 (FactInternetSales)
-- EnglishProductCategoryName          (DimProductCategory) ****
-- CustomerKey                         (DimCustomer)
-- FirstName + ' ' + LastName          (DimCustomer)
-- Gender                              (DimCustomer)
-- EnglishCountryRegionName            (DimGeography)
-- OrderQuantity                       (FactInternetSales)
-- SalesAmount                         (FactInternetSales)
-- TotalProductCost                    (FactInternetSales)
-- SalesAmount - TotalProductCost      (FactInternetSales)



-- 5. Creating the RESULTS_ADW View

CREATE OR ALTER VIEW RESULTS_ADW AS
SELECT
    fis.SalesOrderNumber AS 'Order No.',
    DATEADD(YEAR, 7, fis.OrderDate) AS 'Order Date',
    dpc.EnglishProductCategoryName AS 'Product Category',
    fis.CustomerKey AS 'Customer ID',
    dc.FirstName + ' ' + dc.LastName AS 'Customer Name',
    REPLACE(REPLACE(dc.Gender, 'M', 'Male'), 'F', 'Female') AS 'Gender',
    dg.EnglishCountryRegionName AS 'Country',
    fis.OrderQuantity AS 'Quantity Sold',
    fis.SalesAmount AS 'Sales Revenue',
    fis.TotalProductCost AS 'Sales Cost',
    fis.SalesAmount - fis.TotalProductCost AS 'Sales Profit'
FROM FactInternetSales fis
INNER JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey
    INNER JOIN DimProductSubcategory dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
        INNER JOIN DimProductCategory dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
INNER JOIN DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
    INNER JOIN DimGeography dg ON dc.GeographyKey = dg.GeographyKey



-- 4. Defining the tables to be analyzed

-- TABLE 1: FactInternetSales
-- TABLE 2: DimCustomer
-- TABLE 3: DimSalesTerritory
-- TABLE 4: DimProductCategory ***

-- *** Here we need to create a chain relationship





-- 5. Defining the columns of the ONLINE_SALES view


-- FINAL VIEW ONLINE_SALES

-- Columns:

-- SalesOrderNumber                (TABLE 1: FactInternetSales)
-- OrderDate + 7 Years             (TABLE 1: FactInternetSales)
-- EnglishProductCategoryName      (TABLE 4: DimProductCategory)
-- FirstName + LastName            (TABLE 2: DimCustomer)
-- Gender                          (TABLE 2: DimCustomer)
-- SalesTerritoryCountry           (TABLE 3: DimSalesTerritory)
-- OrderQuantity                   (TABLE 1: FactInternetSales)
-- TotalProductCost                (TABLE 1: FactInternetSales)
-- SalesAmount                     (TABLE 1: FactInternetSales)




-- 6. Creating the ONLINE_SALES view code

-- i) Total Online Sales by Product Category
-- ii) Total Online Revenue by Order Month
-- iii) Total Online Revenue and Cost by Country
-- iv) Total Online Sales by Customer Gender

-- NOTE: THE ANALYSIS YEAR WILL BE ONLY 2021 (ORDER YEAR)


CREATE OR ALTER VIEW ONLINE_SALE AS
SELECT
    fis.SalesOrderNumber AS 'Order No.',
    DATEADD(YEAR, 7, fis.OrderDate) AS 'Order Date',
    dpc.EnglishProductCategoryName AS 'Product Category',
    dc.FirstName + ' ' + dc.LastName AS 'Customer Name',
    dst.SalesTerritoryCountry AS 'Country',
    fis.OrderQuantity AS 'Quantity Sold',
    fis.TotalProductCost AS 'Sales Cost',
    fis.SalesAmount AS 'Sales Revenue'
FROM FactInternetSales fis
INNER JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey
    INNER JOIN DimProductSubcategory dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
        INNER JOIN DimProductCategory dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
INNER JOIN DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
INNER JOIN DimSalesTerritory dst ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
WHERE YEAR(fis.OrderDate) = 2021



-- Data Optimization and Update Example
-- This section shows how to maintain data consistency by simulating a data update using a SQL transaction.

BEGIN TRANSACTION T1
    
    UPDATE FactInternetSales
    SET OrderQuantity = 20
    WHERE ProductKey = 361     -- Category Bike
    
COMMIT TRANSACTION T1
