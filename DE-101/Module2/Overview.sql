/*
Total sales
Total profit
Profit ratio
*/
select 
sum(sales) as sales,
sum(profit) as profit,
sum(profit)/sum(sales) * 100 as ratio
from orders o;

--Profit per Order
select distinct
order_id,
sum(profit) as ord_prof
from orders o 
group by order_id;

--Sales per customer
select distinct
customer_id,
customer_name,
sum(sales) as cust_sale
from orders o 
group by customer_id, customer_name;

--Avg discount
select
avg(discount) * 100
from orders o;

--Monthly sales by segment
select distinct
extract(year from o.order_date) as year,
extract(month from o.order_date) as month,
o.segment ,
sum(o.sales)
from orders o
group by year, month, o.segment
order by year, month asc;

--Monthly sales by product category
select distinct
extract(year from o.order_date) as year,
extract(month from o.order_date) as month,
o.category,
sum(o.sales)
from orders o
group by year, month, o.category
order by year, month asc;