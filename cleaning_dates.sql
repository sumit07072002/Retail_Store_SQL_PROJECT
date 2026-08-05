#Write a SQL query to clean the DATE column in the dataset.
#Steps:

#Create a separate table and change the data type of the date column as it is in TEXT format and name it as you wish to.
#Remove the original table from the database.
#Change the name of the new table and replace it with the original name of the table.


desc sales_transaction;

create table sales_transaction21  as 
select * , 
cast(transactiondate as date) as transactiondate_updated
from sales_transaction
;


alter table sales_transaction21
rename to  sales_transaction;


select * from sales_transaction ;

