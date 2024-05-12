--Total Revenue
select
	round(sum(o.quantity * p.unit_price)::numeric, 2)  as total_sales
from orders o
join pizza_prices p
on o.pizza_id=p.pizza_id and o.pizza_size = p.pizza_size ;

--Average Order Value
select round(avg(s.total_order)::numeric, 2) as avg_oder_value from (
	select
		order_timestamp,
		sum(o.quantity * p.unit_price) as total_order
	from orders o
	join pizza_prices p
	on o.pizza_id=p.pizza_id and o.pizza_size = p.pizza_size
	group by 1
) s ;

--Total Pizza Sold
select sum(quantity) as total_pizzas_sold from orders o ;

--Total Orders
select count(distinct order_timestamp) as total_number_orders from orders ;

--Average Pizzas Per Order
select round(avg(s.total_order)::numeric, 2) as avg_pizzas_per_order from (
	select
		order_timestamp,
		sum(o.quantity) as total_order
	from orders o
	join pizza_prices p
	on o.pizza_id=p.pizza_id and o.pizza_size = p.pizza_size
	group by 1
) s ;

--Sales Performance Analysis

--What is the average unit price and revenue of pizza across different categories?
select
	p.pizza_category,
	round(avg(pp.unit_price)::numeric, 2) as avg_pizza_price,
	round(avg(o.quantity * pp.unit_price)::numeric, 2) as avg_revenue
from orders o
join pizzas p using (pizza_id)
join pizza_prices pp using (pizza_id, pizza_size)
group by 1
order by 2 ;

--What is the average unit price and revenue of pizza across different sizes?
select
	o.pizza_size,
	round(avg(pp.unit_price)::numeric, 2) as avg_pizza_price,
	round(avg(o.quantity * pp.unit_price)::numeric, 2) as avg_revenue
from orders o
join pizzas p using (pizza_id)
join pizza_prices pp using (pizza_id, pizza_size)
group by 1
order by 2 ;

--What is the average unit price and revenue of most sold 3 pizzas?
select
	p.pizza_name,
	sum(o.quantity) as pizzas_sold,
	round(avg(pp.unit_price)::numeric, 2) as avg_pizza_price,
	round(avg(o.quantity * pp.unit_price)::numeric, 2) as avg_revenue
from orders o
join pizzas p using (pizza_id)
join pizza_prices pp using (pizza_id, pizza_size)
group by 1
order by 2 desc
limit 3 ;

--Seasonal Analysis

--Which days of the week have the highest number of orders?
select
	to_char(order_timestamp, 'Day') as weekday,
	sum(quantity) as pizzas_sold
from orders
group by 1
order by 2 desc ;

--At what time do most orders occur?
select
	extract(hour from order_timestamp) as day_hour,
	sum(quantity) as pizzas_sold
from orders
group by 1
order by 2 desc ;

--Which month has the highest revenue?
select
	to_char(o.order_timestamp, 'Month') as month,
	round(sum(o.quantity * pp.unit_price)::numeric, 2) as total_sales
from orders o
join pizza_prices pp using (pizza_id, pizza_size)
group by 1
order by 2 desc ;

--Which season has the highest revenue?
select
	case
		WHEN lower(s.m) IN ('december', 'january', 'february') THEN 'Winter'
        WHEN lower(s.m) IN ('march', 'april', 'may') THEN 'Spring'
        WHEN lower(s.m) IN ('june', 'july', 'august') THEN 'Summer'
		WHEN lower(s.m) IN ('september', 'october', 'november') THEN 'Autumn'
	end as season,
	sum(s.total_sales) as season_sales
from (
	select
		-- the output of to_char has blank spaces at the end
		trim(to_char(o.order_timestamp, 'Month')) as m,
		round(sum(o.quantity * pp.unit_price)::numeric, 2) as total_sales
	from orders o
	join pizza_prices pp using (pizza_id, pizza_size)
	group by 1
	order by 1
	) s
group by 1
order by 2 desc ;

--Customer Behavior Analysis

--Which pizza is the favorite of customers (most ordered pizza)?
select
	p.pizza_name,
	sum(o.quantity) as total_pizzas_sold
from orders o
join pizzas p using (pizza_id)
group by 1
order by 2 desc
limit 1 ;

--Which pizza is ordered the most number of times?
select
	p.pizza_name,
	count(o.pizza_id) as times_ordered
from orders o
join pizzas p using (pizza_id)
group by 1
order by 2 desc
limit 1 ;

--Which pizza size is preferred by customers?
select
	o.pizza_size,
	count(o.pizza_size) as times_ordered
from orders o
group by 1
order by 2 desc
limit 1 ;

--Which pizza category is preferred by customers?
select
	p.pizza_category,
	sum(o.quantity) as times_ordered
from orders o
join pizzas p using (pizza_id)
group by 1
order by 2 desc
limit 1 ;

--Pizza Analysis

--The pizza with the least price and highest price
with prices as (
	select
		p.pizza_name,
		pp.pizza_size,
		pp.unit_price as price
	from pizza_prices pp
	join pizzas p using (pizza_id)
)
select *
from prices
where prices.price in ( 
	-- cheapest pizza	
	(select min(price) from prices),
	-- most expensive pizza
	(select max(price) from prices)
	)
order by price ;

--Number of pizzas per category
select
	p.pizza_category,
	sum(o.quantity) as total_pizzas_sold
from orders o
join pizzas p using (pizza_id)
group by 1
order by 2 desc ;

--Number of pizzas per size
select
	o.pizza_size,
	sum(o.quantity) as total_pizzas_sold
from orders o
group by 1
order by 2 desc ;

-- Number of different pizzas in each category
select
	pizza_category,
	count(pizza_id) as total_pizzas
from pizzas
group by 1
order by 2 desc ;

--Pizzas with more than one category
select
	pizza_name,
	count(pizza_category) as total_pizzas
from pizzas
group by 1
having count(pizza_category) > 1
order by 2 desc ;
-- Each pizza belongs to only 1 category

