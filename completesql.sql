USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\DELL\Desktop\mssql\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\DELL\Desktop\mssql\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\DELL\Desktop\mssql\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

use DataWarehouseAnalytics
go
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_products'
order by ORDINAL_POSITION DESC;

use DataWarehouseAnalytics;
go
SELECT DISTINCT category,product_id from GOLD.dim_products
order by product_id asc;

SELECT category,product_id from GOLD.dim_products
where category is not null
order by product_id asc;

SELECT  category,product_id,category_id from GOLD.dim_products
group by category_id,category,product_id order by product_id asc;

select min(birthdate) ,max(birthdate) max_bd,DATEDIFF(YEAR,min(birthdate),max(birthdate)) as year_span from gold.dim_customers 
select min(birthdate) oldest_customer,max(birthdate) youngest_customer,DATEDIFF(YEAR,min(birthdate),getdate())y_age,datediff(year,max(birthdate),getdate()) year_span from gold.dim_customers 

select 'total_sales' as measure_name,sum(sales_amount)  as value_data from gold.fact_sales
union all
select 'avg_sales' ,AVG(sales_amount) from gold.fact_sales
union all
select 'count of quantity',count(quantity) from gold.fact_sales
union all
select 'product_sold',count(distinct order_number) from gold.fact_sales
union all
select 'total_customer',count(distinct customer_key) from gold.dim_customers


-- total customers by country

select country,count(distinct customer_key) as total_customer from gold.dim_customers
where country is not null and customer_key is not null and country <> 'n/a'
group by country order by 2 desc
--- magnitude analysis

--- total customer by gender

select gender,count(distinct customer_key) as total_customer from gold.dim_customers
where gender is not null and customer_key is not null and gender <> 'n/a'
group by gender order by 2 desc
  
  --- total product by category

select category,count(distinct product_key) as total_product from gold.dim_products
where category is not null and product_key is not null and category <> 'n/a'
group by category order by 2 desc

--- avg cost by category

select avg(cost) as avg_cost,category from gold.dim_products
where category is not null and category <> 'n/a'
group by category order by 2 desc

----find the total revenue by category

select p.category,p.subcategory,sum(f.sales_amount) as total_revenue from gold.fact_sales f left join gold.dim_products p on p.product_key = f.product_key
where p.category is not null and p.subcategory is not null and f.sales_amount is not null
group by p.category,p.subcategory

----find the total revenue by category

select top 1 c.customer_id,c.first_name,sum(f.sales_amount) as total_revenue from gold.fact_sales f left join gold.dim_customers c on f.customer_key = c.customer_key
where c.customer_id is not null and c.first_name is not null and f.sales_amount is not null
group by c.customer_id,c.first_name order by total_revenue desc


------- what is the distribution of sold items across the country

select c.country,sum(f.quantity) as total_items_sold from gold.fact_sales f right join gold.dim_customers c on f.customer_key= c.customer_key
where c.country is not null and f.quantity is not null and c.country <> 'n/a'
group by c.country

----RANKING

--which 5 products generated the highest sales

select top 5 p.product_name,sum(f.sales_amount) as total_sales from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
where p.product_name <> 'n/a'
group by p.product_name order by total_sales desc


------- worst 5 products  sales

select top 5 p.product_name,sum(f.sales_amount) as total_sales from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
where p.product_name <> 'n/a'
group by p.product_name order by total_sales

------- worst performing products


select top 5 p.product_name,count(f.quantity) as total_sold from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
where p.product_name <> 'n/a'
group by p.product_name order by total_sold

---------------------------------- using window function


select * from(select p.product_name,sum(f.sales_amount) as total_sales,dense_rank() over(order by sum(f.sales_amount)) as ranks from gold.fact_sales f left join gold.dim_products p on  f.product_key = p.product_key
group by p.product_name)t
where ranks < 6


----- worst performing 


select * from(select c.customer_id,c.first_name,sum(f.sales_amount) as total_sales,rank() over(order by sum(f.sales_amount) desc) as ranks from gold.fact_sales f left join gold.dim_customers c on  f.customer_key = c.customer_key
group by c.first_name,c.customer_id)t 
where ranks < 11

----first date

select min(year(order_date)) from gold.fact_sales

----last date

select max(year(order_date)) from gold.fact_sales

------- date diff

select min(year(order_date))first_date,max(year(order_date))last_date,datediff(year,min(year(order_date)),max(year(order_date))) year_span from gold.fact_sales

select year(order_date) years,sum(sales_amount) total_sales from gold.fact_sales group by year(order_date)

select year(order_date) years,month(order_date) months,sum(sales_amount) total_sales from gold.fact_sales where month(order_date) is not null
group by year(order_date),month(order_date) order by year(order_date) 

select year(f.order_date) years,month(f.order_date) months,count(c.customer_id) total_customer,sum(f.quantity) total_product_sold from gold.fact_sales f left join gold.dim_customers c on c.customer_key=f.customer_key
where year(f.order_date) is not null 
group by year(f.order_date),month(f.order_date) order by year(order_date)

select sum(distinct(quantity)) from gold.fact_sales

-----CUMALATIVE ANALYSIS


select months,total_sales,sum(total_sales)over(order by months)runnning_sales from(select datetrunc(month,order_date) months,datetrunc(year,order_date) years, sum(sales_amount) total_sales from gold.fact_sales
where  datetrunc(month,order_date) is not null
group by datetrunc(month,order_date),datetrunc(year,order_date))t


----------- data segmentation

with product_segment as (
select product_key,product_name,cost,
case
when cost < 100 then 'below 100'
when cost between 100 and 500 then '100-500'
when cost between 500 and 1000 then '500-1000'
else 'above 1000'
end as cost_range from gold.dim_products
)
select count(product_key) as total_product,cost_range from product_segment group by  cost_range order by total_product desc

/*group customers into three segments based on their spending behviour:
- vip: customer with at least 12 months of history  and spendig more than 5000
- regular <5000
-new <12 month
find the total number of customers by each group*/

WITH cus_seg AS (
    SELECT
        c.customer_id,
        SUM(f.sales_amount) AS total_spending,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS customer_span_mn,
        CASE
            WHEN DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) > 12
                 AND SUM(f.sales_amount) > 5000
                THEN 'VIP'
            WHEN SUM(f.sales_amount) < 5000
                THEN 'Regular'
            ELSE 'New'
        END AS c_seg
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
)
SELECT
    count(customer_id)
    c_seg
FROM cus_seg group by c_seg order by total_spending

---order  year current sales with product_name
use DataWarehouseAnalytics

with cte as(
select year(f.order_date) years,p.product_name,sum(f.sales_amount)total_sales from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
where p.product_name is not null and p.product_name <> 'n/a' and year(f.order_date) is not null
group by year(f.order_date),p.product_name
--order by year(f.order_date)
)


select years,product_name,total_sales,round(avg(total_sales) over(partition by product_name order by years),2) as total_avg,round(avg(total_sales)
over (partition by years order by product_name,years),2) as running_avg,(total_sales-avg(total_sales) over(partition by product_name)) as diff_avg,case
when (total_sales-avg(total_sales) over(partition by product_name)) > 0 then 'above average'
when (total_sales-avg(total_sales) over(partition by product_name)) = 0 then 'sum'
else 'below average' end as diff_type
from cte 
order by years
--year over year analysis
with cte as(
select year(f.order_date) years,p.product_name,sum(f.sales_amount)total_sales from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
where p.product_name is not null and p.product_name <> 'n/a' and year(f.order_date) is not null and f.sales_amount is not null
group by year(f.order_date),p.product_name
--order by year(f.order_date)
)
select years,product_name,total_sales,round(avg(total_sales) over(partition by product_name order by years),2) as total_avg,round(avg(total_sales)
over (partition by years order by product_name,years),2) as running_avg,(total_sales-avg(total_sales) over(partition by product_name)) as diff_avg,lag(total_sales) over(partition by years order by years) lag_ts,
case
when (lag(total_sales) over(partition by years order by years) - total_sales) > 0 then 'increase'
when (lag(total_sales) over(partition by years order by years) - total_sales) < 0 then 'decrease'
else 'no change' 
end as py_change
from cte 
order by years