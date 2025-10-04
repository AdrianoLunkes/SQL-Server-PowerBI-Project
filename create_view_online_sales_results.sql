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
-- OrderDate                           (FactInternetSales)
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
	fis.SalesOrderNumber AS 'ORDER NUMBER',
	fis.OrderDate AS 'ORDER DATE',
	dpc.EnglishProductCategoryName AS 'PRODUCT CATEGORY',
	fis.CustomerKey AS 'CUSTOMER ID',
	dc.FirstName + ' ' + dc.LastName AS 'CUSTOMER NAME',
	REPLACE(REPLACE(dc.Gender, 'M', 'Male'), 'F', 'Female') AS 'GENDER',
	dg.EnglishCountryRegionName AS 'COUNTRY',
	fis.OrderQuantity AS 'QUANTITY SOLD',
	fis.SalesAmount AS 'SALES REVENUE',
	fis.TotalProductCost AS 'SALES COST',
	fis.SalesAmount - fis.TotalProductCost AS 'SALES PROFIT'
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
-- OrderDate                       (TABLE 1: FactInternetSales)
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


SELECT
	fis.SalesOrderNumber AS 'ORDER NUMBER',
	fis.OrderDate AS 'ORDER DATE',
	dpc.EnglishProductCategoryName AS 'PRODUCT CATEGORY',
	dc.FirstName + ' ' + dc.LastName AS 'CUSTOMER NAME',
	SalesTerritoryCountry AS 'COU
