CREATE DATABASE ecommerce_db;
USE ecommerce_db;

create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    signup_date date
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    order_status varchar(20),
    payment_method varchar(20),
    foreign key (customer_id) 
    references customers(customer_id)
);

create table order_items (
    order_item_id Int primary key,
    order_id int,
    product_name varchar(50),
    category varchar(50),
    quantity int,
    amount int,
    foreign key (order_id) 
    references orders(order_id)
);

insert into customers values
(1, 'Ritu Chuauhan', 'Ahmedabad', '2023-01-05'),
(2, 'Sumit Patel', 'Mumbai', '2023-01-10'),
(3, 'Aarti more', 'Delhi', '2023-01-15'),
(4, 'yesha mehta', 'Pune', '2023-02-01'),
(5, 'Nikunj Kapoor', 'Bangalore', '2023-02-10');

insert into orders value
(101, 1, '2023-01-12', 'Delivered', 'UPI'),
(102, 1, '2023-02-18', 'Delivered', 'Credit Card'),
(103, 2, '2023-01-22', 'Delivered', 'Cash on Delivery'),
(104, 3, '2023-03-02', 'Cancelled', 'UPI'),
(105, 4, '2023-02-28', 'Delivered', 'Debit Card'),
(106, 5, '2023-03-12', 'Delivered', 'UPI'),
(107, 4, '2023-01-25', 'Shipped', 'Credit Card'),
(108, 1, '2023-02-20', 'Delivered', 'UPI'),
(109, 3, '2023-03-18', 'Delivered', 'Credit Card'),
(110, 2, '2023-03-22', 'cancelled', 'Cash on Delivery');

INSERT INTO order_items VALUES
(1, 101, 'Samsung Phone', 'Electronics', 1, 20000),
(2, 101, 'Apple AirPods', 'Electronics', 1, 5000),
(3, 102, 'Nike Shoes', 'Fashion', 2, 8000),
(4, 103, 'Mobile Cover ', 'Accessories', 1, 200),
(5, 103, 'Remote Cover', 'Accessories', 1, 500),
(6, 104, 'Baggy Jeans', 'Fashion', 1, 700),
(7, 105, 'HP Laptop', 'Electronics', 1, 55000),
(8, 106, 'H&M Dress', 'Fashion', 1, 3500),
(9, 107, 'Boat Headphones', 'Electronics', 1, 2000),
(10, 108, 'School Bag', 'Accessories', 1, 1500),
(11, 109, 'Canon Camera', 'Electronics', 1, 45000),
(12, 110, 'Adidas Shoes', 'Fashion', 1, 7000),
(13, 110, 'T-shirt', 'Fashion', 2, 1500),
(14, 105, 'Smart Watch', 'Electronics', 1, 10000),
(15, 103, 'Microwave Oven', 'Home Appliances', 1, 8000);

#1. Total Revenue
select sum(amount) as total_revenue 
from order_items;

#2. Total Orders & Customers
select(select count(*) from orders) as total_orders,
	  (select count(*) from customers as total_customers) as total_customers;

#3. revenue by category 
select category, sum(amount) as revenue
from order_items
group by category
order by revenue desc;

#4. Monthly Revenue Trend
select month(order_date) as months,
sum(oi.amount) as revenue
from orders o 
join order_items oi
on o.order_id = oi.order_id
group by months 
order by months;

#5. Top 3 Customers by Spending
select c.customer_name, sum(oi.amount) as total_spent
from customers c
join orders o on 
c.customer_id = o.customer_id 
join order_items oi on o.order_id = oi.order_id
group by c.customer_name
order by total_spent desc
limit 3;

#6. Most sold Products by quentity
select product_name, sum(quantity) as total_quantity 
from order_items
group by product_name 
order by total_quantity desc 
limit 5;

#7. Average Order Value (AOV)
select avg(order_total) as avg_order_value
from ( 
       select order_id, sum(amount) as order_total
       from order_items
       group by order_id
)t;

#8. Repeat Customers(retention)
select customer_id, count(order_id) as total_orders
from orders
group by customer_id
having total_orders > 1;

#9. Revenue by city 
select c.city, sum(oi.amount) as revenue
from customers c
join orders o 
on c.customer_id = o.customer_id
join order_items oi 
on oi.order_id = o.order_id 
group by c.city
order by revenue desc;

#10. Order Status Distribution
select order_status, count(*) as total_orders
from orders
group by order_status;

#11.Payment method Analysis 
select payment_method, count(*) as total_orders
from orders
group by payment_method 
order by total_orders desc;

#12. Highest Value Order
select order_id, sum(amount) as total_amount
from order_items
group by order_id 
order by total_amount desc
limit 1;

#13. Customer Ranking 
select customer_name, total_spent,
rank() over (order by total_spent desc) as rank_position 
from (
      select c.customer_name,
      sum(oi.amount) as total_spent 
      from customers c
      join orders o 
      on c.customer_id = o.customer_id 
      join order_items oi on 
      o.order_id = oi.order_id
      group by c.customer_name)t;
      
#14. Category Contribution (% of total revenue)
select category, 
round(sum(amount) * 100/
      (select sum(amount) from order_items),2) as percentage 
from order_items
group by category;

#15. Customers with No orders 
select customer_name
from customers
where customer_id is null;
          
