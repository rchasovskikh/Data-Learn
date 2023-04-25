--Sales and Profit by Customer
select distinct 
o.customer_id ,
o.customer_name ,
sum(sales) as sales,
sum(profit) as profit
from orders o
group by o.customer_id, o.customer_name;

--Customer Ranking
select distinct 
o.customer_id ,
o.customer_name ,
sum(sales) as sale
from orders o
group by o.customer_id, o.customer_name
order by sale desc ;

--Sales per region
select distinct 
o.region,
sum(sales)
from orders o
group by o.region;
