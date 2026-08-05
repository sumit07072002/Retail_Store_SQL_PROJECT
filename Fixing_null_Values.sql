-- Write a SQL query to identify the null values in 
-- the dataset and replace those by “Unknown”


alter table retail.customer_profiles
rename column ï»¿Customerid to customerid;

-- #this will ensure which column has nulls values 



select 
 sum(case when customerid is null then 1 else 0 end) as c_id_nulls, 
 sum(case when age is null then 1 else 0 end ) as age_id_nulls, 
 sum(case when gender is null then 1 else 0 end) as G_nuls,  
 sum(case when location is null then 1 else 0 end) as loc_nulls, 
 sum(case when  joindate is null then 1 else 0 end ) as date_nulls


 from customer_profiles;

-- --Location is column which has the nulls values

-- --- let's fill the nulls values with 'unknown'

update customer_profiles
set location = 'Unknown'
where location is Null
;


select * from customer_profiles;






