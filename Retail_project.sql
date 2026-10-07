create table sales_data (
    row_id int primary key,
	order_id varchar(20),
	order_date date,
	ship_date date,
	ship_mode varchar(50),
	customer_id varchar(50),
	customer_name varchar(100),
	segment varchar(50),
	country varchar(50),
	city varchar(50),
	state varchar(50),
	postel_code varchar(20),
	region varchar(50),
	product_id varchar(50),
	category varchar(50),
	sub_category varchar(50),
	product_name varchar(255),
	sales numeric,
	quantity int,
	discount numeric,
	profit numeric
);
 
copy sales_data
from 'C:\Project\Sample - Superstore.csv.csv' 
with (format csv, header true, delimiter ',', encoding 'WIN1252');

-- For Check --

select * from sales_data;

select count(*) from sales_data;

-- 🚀 STEP 1: Basic Health Check --
-- ✅ Query 1: Total Sales & Total Profit --

select 
    sum(sales) as total_sales,
	sum(profit) as total_profit
from sales_data;

-- 🚀 STEP 2: Overall Profit Margin --

select
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data;	

-- 🚀 STEP 3: Category Wise Profitability --

select category,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by category
order by profit_margin asc;

-- 🚀 STEP 4: Sub-Category Deep Investigation --

select sub_category,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by sub_category
order by profit_margin asc;

-- 🚀 STEP 5: Region Wise Loss --

select region,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by region
order by profit_margin asc;

-- 🚀 STEP 6: Discount Impact Analysis (VERY IMPORTANT 🔥) --

select discount,
    count(*) as total_orders,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by discount
order by discount;

-- 🚀 STEP 7: High Sales But Low Profit Products --

select product_name,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by product_name
having sum(sales) > 50000
order by profit_margin asc;

-- 🚀 STEP 8: Year-wise Profit Trend --

select
    extract(year from order_date) as year,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by year
order by year;

-- 🚀 STEP 9: Month-wise Profit Trend --

select
    extract(month from order_date) as month,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by month
order by month;

-- 🚀 STEP 10: Shipping Delay Impact --

select
    avg(ship_date - order_date) as avg_shipping_days
from sales_data;	
 
-- 🚀 STEP 11: Segment Wise Profitability --


select segment,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
group by segment
order by profit_margin asc;



-- 🔥 ADVANCED SQL LAYER (FINAL PHASE)

Ab hum root cause ko PROVE karenge — assume nahi karenge. --

-- ✅ STEP 1: Segment + Discount Combined Analysis

select 
    segment,
	discount,
	count(*) as total_order,
    sum(sales) as total_sales,
	sum(profit) as total_profit,
	round((sum(profit) / sum(sales)) * 100, 2) as profit_margin
from sales_data
where discount >= 0.3
group by segment, discount
order by total_profit asc;

-- ✅ STEP 2: Region + High Discount Correlation

select 
    region,
	discount,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from sales_data
where discount >= 0.3
group by region, discount
order by total_profit asc;

-- ✅ STEP 3: Category + High Discount

select 
    category,
	discount,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from sales_data
where discount >= 0.3
group by category, discount
order by total_profit asc;

-- ✅ STEP 4: Top 10 Loss Making Products (Overall)

select product_name,
    sum(sales) as total_sales,
	sum(profit) as total_profit
from sales_data
group by product_name
order by total_profit asc
limit 10;

-- ✅ STEP 5: Shipping Delay Impact

select
    (ship_date - order_date) as shipping_days,
	sum(profit) as total_profit
from sales_data
group by shipping_days
order by shipping_days;

-- ✅ STEP 6: Pareto Analysis (80/20 Rule)

-- Top revenue contributing products --

select
    product_name,
	sum(sales) as total_sales
from sales_data
group by product_name
order by product_name desc;

-- Ab advanced version: --

select *,
       sum(total_sales) over () as overall_sales,
	   round((total_sales / sum(total_sales) over ()) * 100,2) as sales_percentage
from (
     select product_name,
	 sum(sales) as total_sales
  from sales_data
  group by product_name
)t
order by total_sales desc;

-- ✅ STEP 7: High Sales But Negative Profit Cases

select product_name,
    sum(sales) as total_sales,
	sum(profit) as total_profit
from sales_data
group by product_name
having sum(profit) < 0
order by total_sales desc;





















