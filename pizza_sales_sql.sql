use pizza_store;
select * from pizza_sales;

select str_to_date(order_date, "%d-%m-%y") from pizza_sales;

#kpi......

# 1. TOTAL REVENUE:- The sum of the total price of all pizza orders... 
select sum(total_price) as TOTAL_REVENUE from pizza_sales;


# 2. AVERAGE ORDER VALUE :- THe average amount spent per order,calculate by dividing the total revenueby the total number of orders:-
select sum(total_price)/count(distinct order_id) as AVG_ORDER_VALUE from pizza_sales;


# 3. Total pizzas sold :- The sum of the quantities of all pizzas sold
select sum(quantity) as total_pizzas_sold from pizza_sales;


# 4. Total Orders :- The total number of orders placed
select count(distinct order_id) as Total_orders from pizza_sales;



# 5. AVERAGE PIZZAS PER ORDER :- The average number of pizzas sold per order, calculate by
# dividing the total number of pizzas sold by the total number of orders..
select cast(cast(sum(quantity) as decimal(10,2))/ 
cast(count(distinct order_id) as decimal (10,2)) as decimal (10,2)) as AVG_pizza_per_order 
from pizza_sales;

alter table pizza_sales 
modify order_date date;

update pizza_sales 
set order_date = str_to_date(order_date, "%d-%m-%Y");

# Charts requirement..... 
# 1. DAILY TREND FOR TOTAL ORDERS :- Create a bar chart that display the daily trend of total orders over a specific time period. 
# This chart will help us identify any pattern or fluctuations in order volumes on a daily basis.
select dayname(order_date) as order_day , count(distinct order_id) as total_orders
from pizza_sales
group by dayname(order_date);





# 2. MONTHLY TREND FOR TOTAL ORDERS:- Create a line chart that illustrates the hourly trend of total orders throughout the day.
#This chart will allow us to identify peak hours or periods of highorder activity.. 
select monthname(order_date) as month_name, count(distinct order_id) as total_orders
from pizza_sales
group by monthname(order_date)
order by total_orders desc;






# 3. PERCENTAGE OF SALES BY PIZZA CATEGORY :-Create a pie chart that shows the distribution of sales across different pizza categories. 
# This chart will provide insights into the popularity of various pizza categories and their contribution to overall sales. 
select pizza_category, sum(total_price) as total_sales,sum(total_price)*100/ (select sum(total_price) from pizza_sales where month(order_date)= 1) as pct
from pizza_sales
where month(order_date)= 1
group by pizza_category;





# 4.PERCENTAGE OF SALES BY PIZZA SIZE:- Generate a pie chart that represents the percentage of sales attributed to different pizza sizes.
#this chart will help us understand customer perferences for pizza sizes and their impact sales.  
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_sales, cast(sum(total_price)*100/ 
(select sum(total_price) from pizza_sales where quarter (order_date) =1 ) as decimal(10,2)) as pct 
from pizza_sales
where Quarter (order_date )= 1
group by pizza_size
order by pct desc;




# 5. TOTAL PIZZAS SOLD BY PIZZA CATEGORY :- Create a funnel chart that presents the total number of pizzas sold for each pizza category.
# this chart will allow us to compare the sales performance of different pizza categories.. 
select pizza_category, sum(quantity) as total_quantity_sold from pizza_sales
where month(order_date) = 2
group by pizza_category
order by total_quantity_sold desc;





#6. TOP 5 BEST SELLERS BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS :- Create a bar chart highlighting the top 5 best_selling pizzas based 
# on the revenue , total quantity , total orders,. this chart will help us identify the most popular pizzas options. 
select pizza_name, sum(total_price) as total_revenue from pizza_sales
group by pizza_name
order by total_revenue desc limit 5;

select pizza_name, sum(quantity) as total_quantity from pizza_sales
group by pizza_name
order by total_quantity desc limit 5;

select pizza_name, count(distinct order_id) as total_order from pizza_sales
group by pizza_name
order by total_order desc limit 5;




# 7. BOTTOM 5 BEST SELLERS BY REVENUE , TOTAL QUANTITY AND TOTAL ORDERS :-  Create a bar chart showcasing the bottom 5 worst-selling pizzas 
# based on the revenue, total quantity , total orders. This chart will enable us to identify underperforming or less popular pizza options.  
select pizza_name , sum(total_price) as total_revenue from pizza_sales
group by pizza_name
order by total_revenue asc limit 5;


select pizza_name , sum(quantity) as total_quantity from pizza_sales
group by pizza_name
order by total_quantity asc limit 5;


select pizza_name, count(distinct order_id) as total_order from pizza_sales
group by pizza_name
order by total_order asc limit 5;