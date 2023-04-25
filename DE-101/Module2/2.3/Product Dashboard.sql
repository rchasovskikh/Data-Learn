--Sales by Product Category over time
select distinct
extract(year from o.order_date) as year,
extract(month from o.order_date) as month,
o.category,
sum(o.sales) as sales
from orders o
group by year, month, o.category
order by year, month asc;