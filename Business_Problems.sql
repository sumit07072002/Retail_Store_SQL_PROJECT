# Write a SQL query to summarize the total sales and quantities sold per product by the company.

select ProductID, 
sum(QuantityPurchased) as TotalUnitsSold, 
Round(sum(Price*QuantityPurchased), 2) as TotalSales 
from sales_transaction
group by Productid
order by TotalSales desc 
 ;
 
 
 # Write a SQL query to count the number of transactions per customer to understand purchase frequency.
 
 select 
customerid, 
count(transactionid) as NumberOfTransactions 
from sales_transaction
group by customerid
order by NumberOfTransactions desc
;


# Write a SQL query to evaluate the performance of the product categories 
# based on the total sales which help us understand the product categories 
# which needs to be promoted in the marketing campaigns

select p.Category,
sum(s.QuantityPurchased) as totalUnitsSold, 
round(sum(s.price  * s.QuantityPurchased ), 2)as TotalSales
from product_inventory as p 
join sales_transaction as s 
on p.productid = s.productid
group by  p.Category
order by TotalSales desc
;



# Write a SQL query to find the top 10 products with the highest total 
# sales revenue from the sales transactions. This will help the company to 
# identify the High sales products which needs to be focused to increase 
# the revenue of the company.


select productid, 
round(sum(price*quantitypurchased), 2) as totalRevenue 
from sales_transaction
group by productid
order by totalRevenue desc
limit 10
;



-- Write a SQL query to find the ten products with the least amount of units sold 
-- from the sales transactions, provided that at least one unit was 
-- sold for those products.

select 
productid , 
sum(quantitypurchased) as TotalUnitsSold
from sales_transaction
group by productid
having sum(quantitypurchased) > 0
order by TotalUnitsSold asc
limit 10
;


-- Write a SQL query to identify the sales trend to understand the revenue pattern of the company.

select


date_format(transactiondate, '%Y-%m-%d') as Datetrans, 
count(transactionID) as transaction_count, 
sum(quantitypurchased) as TotalUnitsSold, 
round(sum(Price*quantitypurchased), 2) as TotalSales


from sales_transaction
group by date_format(transactiondate, '%Y-%m-%d')
order by Datetrans desc
;

-- Write a SQL query to understand the month on month growth rate of sales 
-- of the company which will help understand the growth trend of the company.

select month, 
total_sales, 
lag(total_sales) over(order by month) as previous_month_sales,
round((total_sales - lag(total_sales) over(order by month))/lag(total_sales) over(order by month)*100, 2) as 
mom_growth_percentage

from

(select month(transactiondate) as month , 
round(sum(price*quantitypurchased), 2) as total_sales


from sales_transaction 
group by month(transactiondate)) as new 

order by month;

-- Write a SQL query that describes the number of transaction along 
-- with the total amount spent by each customer which are on the higher
-- side and will help us understand the customers who are the high 
-- frequency purchase customers in the company.


select customerid, 
count(transactionid) as NumberOfTransactions, 
sum(price*quantitypurchased) as TotalSpent

from sales_transaction
group by customerid
having count(transactionid) > 10 
and sum(price*quantitypurchased) > 1000 
order by TotalSpent desc
;

-- Problem statement
-- Write a SQL query that describes the number of transaction 
-- along with the total amount spent by each customer, which will 
-- help us understand the customers who are occasional customers or
-- have low purchase frequency in the company.

-- Hint:

-- Use the “Sales_transaction” table.
-- The resulting table must have number of transactions less than or 
-- equal to 2 and corresponding total amount spent on those transactions by related customers.
-- Return the result table of “NumberOfTransactions” in ascending order and “TotalSpent” in descending order.

select customerid, 
count(transactionid) as NumberOfTransactions, 
round(sum(price*quantitypurchased), 2) as TotalSpent

from sales_transaction
group by customerid
having count(transactionid) <= 2
order by NumberOfTransactions asc, 
TotalSpent desc
;

-- Write a SQL query that describes the total number of purchases made by each 
-- customer against each productID to understand the repeat customers in the company.

select
customerid, 
productid, 
count(transactionid) as TimesPurchased

from sales_transaction
group by customerid, 
productid
having count(transactionid) > 1
order by TimesPurchased desc
;

-- Write a SQL query that describes the duration between the first and the 
-- last purchase of the customer in that particular company to 
-- understand the loyalty of the customer.

select customerid, 
min(new_date) as firstPurchase, 
max(new_date) as LastPurchase, 

datediff(max(new_date), min(new_date)) as DaysBetweenPurchases
from


(select customerid, 
str_to_date(Transactiondate, '%Y-%m-%d') as new_date
from 
sales_transaction) as new 

group by 
customerid
having DaysBetweenPurchases > 0
order by  DaysBetweenPurchases desc
;

-- Write an SQL query that segments customers based on the total 
-- quantity of products they have purchased. Also, count the number of 
-- customers in each segment which will help us target a particular 
-- segment for marketing.

CREATE TABLE customer_SEGMENT AS
SELECT CustomerID,
 CASE WHEN TotalQuantity BETWEEN 1 and 10 THEN "Low"
 WHEN TotalQuantity BETWEEN 11 AND 30 THEN "Med"
 WHEN TotalQuantity > 30 THEN "High"
 ELSE "None" END as CustomerSegment
FROM
(SELECT a.CustomerID, sum(b.QuantityPurchased) as TotalQuantity
FROM customer_profiles a
JOIN sales_transaction b
ON a.CustomerID=b.CustomerID
GROUP by a.CustomerID) as totquant ;
SELECT CustomerSegment, COUNT(*)
 FROM customer_Segment
 GROUP BY CustomerSegment;
    
    