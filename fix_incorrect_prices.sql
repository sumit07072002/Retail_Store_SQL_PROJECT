-- Write a query to identify the discrepancies in the price of the same product
-- in "sales_transaction" and "product_inventory" tables. Also, 
-- update those discrepancies to match the price in both the tables.

select s.transactionid as TransactionID, 
s.price as TransactionPrice,
p.price as Inventoryprice

from sales_transaction as s
join product_inventory as p 
on s.productid = p.productid
where  s.price != p.price
;

-- set sql_safe_updates = 0;

update sales_transaction as s
join product_inventory as p 
on s.productid = p.productid
set s.price = p.price
where s.price != p.price ;



select *
from sales_transaction 
;