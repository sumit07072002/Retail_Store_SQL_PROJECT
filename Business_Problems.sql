-- create database ECom;

use Ecom;

-- Problem statement 1
-- Identify the top 3 cities with the highest number of customers to 
-- determine key markets for targeted marketing and logistic optimization.
-- and 
-- As per the last query's result, Which of the cities must be focused as a part of marketing strategies?

select location,
count(customer_id)  
as number_of_customers
from customers
group by location
order by number_of_customers desc
limit 3
;

-- Problem statement 2
-- Determine how many customers fall into each order frequency 
-- category based on the number of orders they have placed.

-- Using the Orders table, calculate the number of customers who 
-- placed 1 order, 2 orders, 3 orders, etc.

-- and 

-- As per the Engagement Depth Analysis question, 
-- What is the trend of the number of customers v/s number of orders?

-- and 

-- As per the Engagement Depth Analysis question, 
-- Which customers category does the company experiences the most?

select NumberOfOrders, 
count(CustomerCount) as CustomerCount
from

(select count(order_id) as NumberOfOrders, 
customer_id as CustomerCount
from orders 
group by customer_id
) 
as new
group by NumberOfOrders
order by NumberOfOrders asc;



-- Problem statement = 3
-- Identify products where the average purchase quantity per order 
-- is 2 but with a high total revenue, suggesting premium product trends.

-- and 

-- Among products with an average purchase quantity of two, 
-- which ones exhibit the highest total revenue?

select *
from

(select product_id,
avg(quantity) as avgQuantity,
sum(quantity*price_per_unit) as totalRevenue

from  orderdetails
group by product_id
order by totalRevenue desc

) as new 
where avgQuantity = 2 
order by totalRevenue desc
;

-- Problem statement-- 4
-- For each product category, calculate the unique number of customers 
-- purchasing from it. This will help understand which categories have 
-- wider appeal across the customer base.

-- and 

-- As per the last question, Which product category needs more focus as it is in high demand among the customers?

select p.category, 
count(distinct o.customer_id) as unique_customers

from products as p 
join orderdetails as od
on p.product_id = od.product_id
join orders as o 
on od.order_id = o.order_id
group by p.category 
order by unique_customers desc;


-- Problem statement -- 5
-- Analyze the month-on-month percentage change in total sales to identify growth trends.

-- and 

-- As per Sales Trend Analysis question, During which month 
-- did the sales experience the largest decline?

-- and 

-- As per Sales Trend Analysis question, 
-- What could be inferred about the sales trend from March to August?

select month, 
Totalsales, 
round((Totalsales - lag(Totalsales) over(order by month))/ (lag(Totalsales) over(order by month))*100, 2) as 
PercentChange 
from


(select 
date_format(order_date, '%Y-%m') as month, 
sum(total_amount) as Totalsales

from orders 
group by date_format(order_date, '%Y-%m')) as new 
group by  month, 
Totalsales
;

-- Problem statement - 6
-- Examine how the average order value changes month-on-month. 
-- Insights can guide pricing and promotional strategies to enhance order value.

-- and 

-- As per last question, Which month has the highest change in the average order value?

-- 

select month, 
aov as AvgOrderValue, 
aov - lag(aov) over(order by month) as ChangeInValue

from 

(select 
date_format(order_date, '%Y-%m') as month, 
round(sum(total_amount)/count(*), 2) as AOV

from orders 
group by date_format(order_date, '%Y-%m'))
as new 
group by month
order by ChangeInValue desc
;

-- Problem statement - 7
-- Based on sales data, identify products with the fastest turnover rates, 
-- suggesting high demand and the need for frequent restocking.

-- and 

-- As per last question, Which product_id has the highest turnover rates and needs to be restocked frequently?

-- and 

select product_id, 
count(order_id) as SalesFrequency  

from orderdetails
group by product_id
order by  salesfrequency desc
limit 5;


-- Problem statement - 7
-- List products purchased by less than 40% of the customer base, 
-- indicating potential mismatches between inventory and customer interest.

-- and 

-- Why might certain products have purchase rates below 40% of the total customer base?

-- and 

-- After running an analysis to identify products purchased by less than 40% of the customer base, 
-- it was found that a few products have lower purchase rates than expected.
-- What could be a strategic action to improve the sales of these underperforming products?



select p.product_id, 
p.name, 
count(distinct o.customer_id) as UniqueCustomerCount 
from Products as p 
join OrderDetails as od 
on p.product_id = od.product_id
join orders as o 
on od.order_id = o.order_id

group by p.product_id, 
p.name
having UniqueCustomerCount < (select count(*) from Customers) *0.4


-- Problem statement --- 8
-- Evaluate the month-on-month growth rate in the customer base to understand the 
-- effectiveness of marketing campaigns and market expansion efforts.

-- and 

-- As per last question, What can be inferred about the growth trend in the customer base from the result table?

select firstPurchaseMonth, 
count(distinct customer_id )as 
TotalNewCustomers

from

(select 
date_format(min(order_date), '%Y-%m') as firstPurchaseMonth, 
customer_id
from orders 
group by 
customer_id)
as new 
group by firstPurchaseMonth
order by firstPurchaseMonth asc

 ;


-- Problem statement --- 9
-- Identify the months with the highest sales volume, aiding in planning for 
-- stock levels, marketing efforts, and staffing in anticipation of peak demand periods.

-- and 

-- As per last question, Which months will require major restocking of product and increased staffs?

select 
date_format(order_date, '%Y-%m') as month, 
sum(total_amount)  as TotalSales

from orders 
group by 
date_format(order_date, '%Y-%m') 
order by  TotalSales desc
limit 3;


