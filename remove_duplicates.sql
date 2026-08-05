use Retail;

-- Write a query to identify the number of duplicates in "sales_transaction" table. Also, 
-- create a separate table containing the unique values and remove the the 
-- original table from the databases


select * from sales_transaction
limit 5;
#make the transactionid abbrebiation free

alter table sales_transaction
rename column ï»¿TransactionID to Transactionid;


select 
transactionid, 
count(*)
from sales_transaction
group by transactionid
having count(*) > 1;

create table sales_transaction2 as
(select distinct * from sales_transaction);

drop table sales_transaction;



alter table sales_transaction2
rename to sales_transaction;

select * from sales_transaction;
