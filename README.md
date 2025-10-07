# SQL Server and Power BI Integration Project

This project demonstrates an end-to-end business intelligence (BI) solution for analyzing internet sales data from the **AdventureWorks 2022** database. The workflow involves data extraction and transformation using SQL Server, followed by data visualization and analysis in Power BI.

---

### Technologies Used

- **Database:** SQL Server
- **Data Visualization:** Power BI
- **Sample Data:** AdventureWorks 2022

---

### Key Performance Indicators (KPIs)

The analysis is structured around two main dashboards: a **General** dashboard for high-level business metrics and a **Customers** dashboard for a more segmented view of the sales data.

**General Dashboard**
- Total Revenue
- Quantity Sold
- Profit by Country
- Total Product Categories
- Profit Margin
- Revenue and Profit by Month
- Quantity Sold by Month

**Customers Dashboard**
- Sales by Country
- Customers by Country
- Sales by Gender
- Sales by Category

---

### Project Process

1. **Environment Setup:** The project begins with downloading and configuring the **AdventureWorks 2022** sample database in SQL Server.
2. **Data Modeling:** Instead of importing multiple tables into Power BI, a SQL `VIEW` (`RESULTS_ADW`) was created in SQL Server to centralize the business logic. This approach ensures better performance and a single source of truth for the data.
3. **Data Transformation:** The `VIEW` performs all necessary joins and creates new columns (like `Sales Profit`) directly in the database.
4. **Data Visualization:** The `VIEW` is then connected to Power BI to create an interactive dashboard for sales analysis.

---

### Database Schema and SQL Code

The following tables and columns were used to build the final `VIEW`.

- `FactInternetSales`: Sales details.
- `DimCustomer`: Customer information.
- `DimProductCategory`: Product categories.
- `DimGeography`: Customer location.

**SQL View for Analysis**

The `RESULTS_ADW` view provides a clean, ready-to-use dataset for Power BI.

```sql
CREATE OR ALTER VIEW RESULTS_ADW AS
SELECT
    fis.SalesOrderNumber AS 'Order No.',
    DATEADD(YEAR, 9, fis.OrderDate) AS 'Order Date',
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
```

### Additional Analysis: Focusing on 2021 Sales

For a more specific case study, a second view, `ONLINE_SALES`, was created to analyze only the sales from the year **2021**.

**SQL View for 2021 Sales (`ONLINE_SALES`)**

```sql
CREATE OR ALTER VIEW ONLINE_SALE AS
SELECT
    fis.SalesOrderNumber AS 'Order No.',
    DATEADD(YEAR, 9, fis.OrderDate) AS 'Order Date',
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
```

### Data Optimization and Update Example

This section shows how to maintain data consistency by simulating a data update using a SQL transaction.

```sql
BEGIN TRANSACTION T1
    
    UPDATE FactInternetSales
    SET OrderQuantity = 20
    WHERE ProductKey = 361     -- Category Bike
    
COMMIT TRANSACTION T1
