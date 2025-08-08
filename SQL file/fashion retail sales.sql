use fashion_retail;

select * from customers;

select count(customer_ID) from customers;
SHOW COLUMNS FROM customers;
SELECT COUNT(`Customer ID`) FROM customers;
show columns from orders;
SELECT 
    c.`Customer ID`,
    c.Name,
    c.Email,
    c.Age,
    c.Gender,
    SUM(o.`Total Price`) AS Total_Spent
FROM 
    customers c
JOIN 
    orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY 
    c.`Customer ID`, c.Name, c.Email, c.Age, c.Gender
ORDER BY 
    Total_Spent DESC
LIMIT 10;

select
	COUNT(c.`Customer ID`) AS customer_count, 
    c.source
from	
	customers c
group by c.source
order by customer_count desc;
    
SELECT
    COUNT(DISTINCT CASE WHEN order_count = 1 THEN `Customer ID` END) AS OneTime_Customers,
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN `Customer ID` END) AS Returning_Customers,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN order_count > 1 THEN `Customer ID` END) * 100.0 /
        COUNT(DISTINCT `Customer ID`), 2
    ) AS Retention_Rate_Percent
FROM (
    SELECT
        `Customer ID`,
        COUNT(*) AS order_count
    FROM
        orders
    GROUP BY
        `Customer ID`
) t;

SELECT 
    COUNT(DISTINCT c.`Customer ID`) AS Total_Customers,
    COUNT(DISTINCT o.`Customer ID`) AS Returning_Customers,
    ROUND(
        COUNT(DISTINCT o.`Customer ID`) * 100.0 / COUNT(DISTINCT c.`Customer ID`), 
        2
    ) AS Retention_Percentage
FROM customers c
LEFT JOIN orders o ON c.`Customer ID` = o.`Customer ID`;

SELECT 
    c.`Loyalty Tier`,
    COUNT(DISTINCT o.`Customer ID`) AS Active_Customers,
    COUNT(DISTINCT c.`Customer ID`) AS Total_Customers,
    ROUND(
        COUNT(DISTINCT o.`Customer ID`) * 100.0 / COUNT(DISTINCT c.`Customer ID`), 
        2
    ) AS Retention_Rate
FROM customers c
LEFT JOIN orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Loyalty Tier`;

SELECT
  CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS Age_Group,
  COUNT(DISTINCT o.`Order ID`) AS Total_Orders,
  SUM(o.`Total Price`) AS Total_Revenue
FROM customers c
JOIN orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY Age_Group
ORDER BY Total_Revenue DESC;

SELECT
  c.Source,
  COUNT(DISTINCT o.`Order ID`) AS Orders,
  SUM(o.`Total Price`) AS Revenue,
  ROUND(AVG(o.`Total Price`), 2) AS Avg_Order_Value
FROM customers c
JOIN orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.Source
ORDER BY Revenue DESC;

SELECT
  c.`Customer ID`,
  c.Name,
  SUM(o.Quantity) AS Total_Items,
  SUM(o.`Total Price`) AS Total_Spent
FROM customers c
JOIN orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer ID`, c.Name
ORDER BY Total_Items DESC
LIMIT 10;

SELECT
  c.`Customer ID`,
  c.Name,
  SUM(o.`Total Price`) AS CLTV
FROM customers c
JOIN orders o ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer ID`, c.Name
ORDER BY CLTV DESC
LIMIT 10;

-- Customers who placed at least one order
WITH ordered_customers AS (
  SELECT DISTINCT Customer_ID FROM orders
)

SELECT
  c.Source,
  COUNT(DISTINCT c.`Customer ID`) AS Total_Customers,
  COUNT(DISTINCT oc.`Customer ID`) AS Converted_Customers,
  ROUND(
    (COUNT(DISTINCT oc.`Customer ID`) * 1.0 / COUNT(DISTINCT c.`Customer ID`)) * 100,
    2
  ) AS Conversion_Rate_Percent
FROM customers c
LEFT JOIN orders oc ON c.`Customer ID` = oc.`Customer ID`
GROUP BY c.Source;

SELECT
  o.`Product ID`,
  p.Category,
  p.`Sub-Category`,
  SUM(o.Quantity) AS Total_Units_Sold,
  SUM(o.`Total Price`) AS Revenue
FROM orders o
JOIN products p ON o.`Product ID` = p.`Product ID`
GROUP BY o.`Product ID`, p.Category, p.`Sub-Category`
ORDER BY Total_Units_Sold DESC
LIMIT 10;

SELECT 
    p.`Sub-Category` AS product_name,
    COUNT(f.Rating) AS total_reviews,
    SUM(f.Rating) AS total_rating,
    ROUND(AVG(f.Rating), 2) AS average_rating
FROM feedback f
JOIN products p ON f.`Product ID` = p.`Product ID`
GROUP BY p.`Sub-Category`
ORDER BY average_rating DESC;

SELECT 
    f.`Customer ID`,
    COUNT(*) AS products_rated,
    AVG(f.Rating) AS avg_given_rating
FROM feedback f
GROUP BY f.`Customer ID`;

SELECT 
    p.`Sub-Category`,
    ROUND(AVG(f.Rating)) AS avg_rating,
    COUNT(*) AS total_reviews
FROM feedback f
JOIN products p ON f.`Product ID` = p.`Product ID`
GROUP BY p.`Sub-Category`
ORDER BY avg_rating DESC;

SELECT 
    c.`Name` AS customer_name,
    c.Gender
FROM feedback f
JOIN customers c ON c.`Customer ID` = f.`Customer ID`
GROUP BY Gender;

SELECT 
    c.`Customer ID`,
    c.`Name`,
    c.`Gender`,
    COUNT(f.Rating) AS total_ratings,
    ROUND(AVG(f.Rating), 2) AS avg_rating
FROM feedback f
JOIN customers c ON f.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer ID`, c.`Name`, c.`Gender`
ORDER BY total_ratings DESC;





    
    
