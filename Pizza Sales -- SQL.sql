create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id));

select* from orders;

create table orders_details(
order_details_id int not null,
pizza_id text not null,
order_id int not null,
quantity int not null,
primary key (order_details_id));

select* from pizzas;

-- --- Retrieve the total number of orders placed. ---

select count(order_id) as Total_Orders from orders;

-- Calculate the total revenue generated from pizza sales.orders_details

select
round(sum(orders_details.quantity * pizzas.price),2) as Total_Revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id

-- Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities

select pizza_types.name , sum(orders_details.quantity) as total_quantity
from  pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by total_quantity desc limit 5

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category ,sum( orders_details.quantity) as Total_Quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id= pizzas.pizza_type_id
join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by pizza_types.category order by Total_Quantity desc

-- Determine the distribution of orders by hour of the day.

select hour(order_time) as hours , count(order_id) as order_counts from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

select category , count(name) from pizza_types 
group by category;

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg (quantity) from 
(select orders.order_date , sum(orders_details.quantity) as quantity
from orders join orders_details
on orders.order_id = orders_details.order_id
group by orders.order_date) as order_quantity;



