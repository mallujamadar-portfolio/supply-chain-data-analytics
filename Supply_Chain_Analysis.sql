use supply_chain ;
-- 1. Total Revenue
SELECT CONCAT(ROUND(SUM(Revenue)/1000000,1),'M') AS Total_Revenue
FROM Fact_Orders;

-- 2. Gross Profit
SELECT CONCAT(ROUND(SUM(Revenue-COGS)/1000000,1),'M') AS Gross_Profit
FROM Fact_Orders;

-- 3. Gross Margin %
SELECT CONCAT(ROUND((SUM(Revenue-COGS)/SUM(Revenue))*100,2),'%') AS Gross_Margin_Pct
FROM Fact_Orders;

-- 4. On-Time Delivery %
SELECT CONCAT(
ROUND((SUM(CASE WHEN Delay_Days<=0 THEN 1 ELSE 0 END)100)/COUNT(),2),
'%') AS On_Time_Delivery_Pct
FROM Fact_Orders;

-- 5. Fill Rate %
SELECT CONCAT(ROUND(AVG(Fill_Rate_Pct),2),'%') AS Fill_Rate_Pct
FROM Fact_Orders;

-- 6. Monthly Revenue Trend
SELECT
MONTHNAME(Order_Date) AS Month,
CONCAT(ROUND(SUM(Revenue)/1000000,1),'M') AS Total_Revenue
FROM Fact_Orders
GROUP BY MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY MONTH(Order_Date);

-- 7. Top 10 Products by Revenue
SELECT
p.Product_Name,
CONCAT(ROUND(SUM(f.Revenue)/1000000,1),'M') AS Total_Revenue
FROM Fact_Orders f
JOIN Dim_Product p
ON f.Product_ID=p.Product_ID
GROUP BY p.Product_Name
ORDER BY SUM(f.Revenue) DESC
LIMIT 10;

-- 8. Revenue Share by Region
SELECT
c.Customer_Region,
CONCAT(ROUND((SUM(f.Revenue)/(SELECT SUM(Revenue) FROM Fact_Orders))*100,2),'%') AS Revenue_Share_Pct
FROM Fact_Orders f
JOIN Dim_Customer c
ON f.Customer_ID=c.Customer_ID
GROUP BY c.Customer_Region
ORDER BY SUM(f.Revenue) DESC;

-- 9. Delayed Orders by Carrier
SELECT
Carrier,
COUNT(*) AS Delayed_Orders
FROM Fact_Orders
WHERE Delay_Days>0
GROUP BY Carrier
ORDER BY Delayed_Orders DESC;

-- 10. Average Transit Time by Ship Mode
SELECT
Ship_Mode,
ROUND(AVG(Transit_Days)) AS Avg_Transit_Days
FROM Fact_Orders
GROUP BY Ship_Mode;