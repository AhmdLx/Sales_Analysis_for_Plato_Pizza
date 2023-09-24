--Data Moduling
alter table 
  orders alter column date date 
alter table 
  order_details alter column order_details_id int not null 
alter table 
  order_details alter column order_id int not null 
alter table 
  order_details alter column pizza_id nvarchar(255) not null 
alter table 
  order_details 
add 
  primary key (order_details_id) 
alter table 
  orders alter column order_id int not null 
alter table 
  orders 
add 
  primary key (order_id) 
alter table 
  order_details 
add 
  foreign key (order_id) references orders 
alter table 
  pizzas alter column pizza_id nvarchar(255) not null 
alter table 
  pizzas 
add 
  primary key(pizza_id) 
alter table 
  pizza_types alter column pizza_type_id nvarchar(255) not null 
alter table 
  pizza_types 
add 
  primary key(pizza_type_id) 
alter table 
  order_details 
add 
  foreign key (pizza_id) references pizzas 
alter table 
  pizzas alter column pizza_type_id nvarchar(255) not null 
alter table 
  pizzas 
add 
  foreign key (pizza_type_id) references pizza_types 
   
--convert column (date) to (weekday) 
  
  -- method 1
SELECT 
  FORMAT(
    CAST(days_of_week AS DATE), 
    'dddd'
  ) as days_of_week 
from 
  orders 
  
  --method 2
SELECT 
  DATENAME(WEEKDAY, days_of_week) 
from 
  orders;
  
--convert column (time) to (hh,mm,ss)
 
SELECT 
  CONVERT(
    VARCHAR(10), 
    CAST(time AS TIME), 
    108
  ) as time 
from 
  orders 
  
--orders table contains days_of_week and time

  with cte as (
    select 
      order_id, 
      date, 
      (
        SELECT 
          DATENAME(WEEKDAY, days_of_week)
      ) as days_of_week, 
      (
        SELECT 
          CONVERT(
            VARCHAR(10), 
            CAST(time AS TIME), 
            108
          )
      ) as time 
    from 
      orders
  ) 
select 
  count(distinct order_id) as No_of_orders_per_day, 
  date, 
  days_of_week 
from 
  cte 
group by 
  date, 
  days_of_week 
order by 
  No_of_orders_per_day desc
  
-- conclusion 
-- max count of orders (115 order) in date (2015-11-27)

  ----------------------------------------------
  
select 
  pt.pizza_type_id, 
  pt.name, 
  pt.category, 
  p.size, 
  p.price, 
  o.order_details_id, 
  o.quantity 
from 
  pizza_types pt 
  join pizzas p on pt.pizza_type_id = p.pizza_type_id 
  join order_details o on o.pizza_id = p.pizza_id
  
--total price and tot quantity for each size in classic category
select 
  pt.category, 
  p.size, 
  round(
    sum(p.price), 
    0
  ) as tot_price, 
  sum(o.quantity) as Tot_quan 
from 
  pizza_types pt 
  join pizzas p on pt.pizza_type_id = p.pizza_type_id 
  join order_details o on o.pizza_id = p.pizza_id 
where 
  pt.category = 'classic' 
group by 
  pt.category, 
  p.size 
order by 
  tot_price asc
  
--total price and tot quantity for each size in Veggie category
select 
  pt.category, 
  p.size, 
  round(
    sum(p.price), 
    0
  ) as tot_price, 
  sum(o.quantity) as Tot_quan 
from 
  pizza_types pt 
  join pizzas p on pt.pizza_type_id = p.pizza_type_id 
  join order_details o on o.pizza_id = p.pizza_id 
where 
  pt.category = 'Veggie' 
group by 
  pt.category, 
  p.size 
order by 
  tot_price asc 
  
--total price and tot quantity for each size in Supreme category
  
select 
  pt.category, 
  p.size, 
  round(
    sum(p.price), 
    0
  ) as tot_price, 
  sum(o.quantity) as Tot_quan 
from 
  pizza_types pt 
  join pizzas p on pt.pizza_type_id = p.pizza_type_id 
  join order_details o on o.pizza_id = p.pizza_id 
where 
  pt.category = 'Supreme' 
group by 
  pt.category, 
  p.size 
order by 
  tot_price asc 
  
-- total price and tot quantity for each size in Chicken category
  
select 
  pt.category, 
  p.size, 
  round(
    sum(p.price), 
    0
  ) as Tot_price, 
  sum(o.quantity) as Tot_quan 
from 
  pizza_types pt 
  join pizzas p on pt.pizza_type_id = p.pizza_type_id 
  join order_details o on o.pizza_id = p.pizza_id 
where 
  pt.category = 'Chicken' 
group by 
  pt.category, 
  p.size 
order by 
  tot_price asc 
  
  
  -- conclusion :
  --worst category(classic XXL) (tot_quantity = 28 item )
  --best  category(classic  S) (tot_quantity = 6139 item )
  --best  size & total sales & total quantity :
  -- classic  ( L , 73269  $ , 4057 )
  -- classic  ( S , 67966  $ , 6139 )
  -- Veggie   ( L , 101552 $ , 5403 )
  -- Supreme  ( L , 92463  $ , 4564 )
  -- Chicken  ( L , 99579  $ , 4932 )
  ---------------------------------------------
  
  with cte as (
    select 
      order_id, 
      date, 
      (
        SELECT 
          DATENAME(WEEKDAY, days_of_week)
      ) as days_of_week, 
      (
        SELECT 
          CONVERT(
            VARCHAR(10), 
            CAST(time AS TIME), 
            108
          )
      ) as time 
    from 
      orders
  ) 
SELECT 
  O.order_details_id, 
  CTE.order_id, 
  CTE.date, 
  CTE.days_of_week, 
  CTE.TIME, 
  O.pizza_id, 
  O.quantity 
FROM 
  cte 
  JOIN order_details O ON cte.order_id = O.order_id 
  
  --------------------------------
  
  
--busiest day & time 
  
  with cte as (
    select 
      order_id, 
      date, 
      (
        SELECT 
          DATENAME(WEEKDAY, days_of_week)
      ) as days_of_week, 
      (
        SELECT 
          CONVERT(
            VARCHAR(10), 
            CAST(time AS TIME), 
            108
          )
      ) as time 
    from 
      orders
  ) 
SELECT 
  CTE.date, 
  cte.days_of_week, 
  CTE.TIME, 
  SUM(O.quantity) AS TOT_QUANT 
FROM 
  cte 
  JOIN order_details O ON cte.order_id = O.order_id 
GROUP BY 
  CTE.TIME, 
  CTE.date, 
  cte.days_of_week 
ORDER BY 
  TOT_QUANT desc
  
--conclusion 
-- busiest day & time
--( time = 12:25:12 , date = 2015-11-18 ,
-- day_of_week = wedensday ,
-- quantity during peak period = 28 piece )
  -------------------------------
  
  with cte as (
    select 
      order_id, 
      month(date) as no_of_month, 
      (
        SELECT 
          DATENAME(WEEKDAY, days_of_week)
      ) as days_of_week, 
      (
        SELECT 
          CONVERT(
            VARCHAR(10), 
            CAST(time AS TIME), 
            108
          )
      ) as time 
    from 
      orders
  ) 
SELECT 
  CTE.no_of_month, 
  SUM(O.quantity) AS TOT_QUANT 
FROM 
  cte 
  JOIN order_details O ON cte.order_id = O.order_id 
GROUP BY 
  CTE.no_of_month 
ORDER BY 
  TOT_QUANT desc
  
--conclusion
--max month in sales ( july , tot_quantity = 4392 )
  --------------------------------
  
  with CTE AS (
    select 
      order_id, 
      date, 
      (
        SELECT 
          DATENAME(WEEKDAY, days_of_week)
      ) AS days_of_week, 
      (
        SELECT 
          CONVERT(
            VARCHAR(10), 
            CAST(time AS TIME), 
            108
          )
      ) AS time 
    from 
      orders
  ) 
SELECT 
  CTE.days_of_week, 
  SUM(O.quantity) AS TOT_QUANT 
FROM 
  cte 
  JOIN order_details O ON cte.order_id = O.order_id 
GROUP BY 
  cte.days_of_week 
ORDER BY 
  TOT_QUANT desc
  
--conclusion
--max day in sales ( friday , tot_quantity = 8242 )

  -------------------------------------------
  
--avg order value

select 
  top (5) * 
from 
  order_details 
select 
  top (5) * 
from 
  orders 
select 
  top (5) * 
from 
  pizza_types 
select 
  top (5) * 
from 
  pizzas 
select 
  round (
    sum (p.price) / count(distinct od.order_id), 
    2
  ) AS AVG_Value_Per_Order 
from 
  order_details AS od 
  join pizzas AS p on od.pizza_id = p.pizza_id 
  
--AVG_Value_Per_Order = ( 37.56 $ )
  
-------------------------------

-- conclusion :
--worst category (classic XXL )(tot_quantity = 28 item )
--best  category ( classic  S )(tot_quantity = 6139 item )

--why that happen ?? 
----------------------------------
  
--Top 10 pizza names in sales
select 
  top 10 pt.name, 
  pt.category, 
  round(
    sum(p.price), 
    0
  ) As tot_price, 
  sum(od.quantity) AS tot_quant 
from 
  pizza_types AS pt 
  join pizzas AS p on p.pizza_type_id = pt.pizza_type_id 
  join order_details AS od on od.pizza_id = p.pizza_id 
group by 
  pt.name, 
  pt.category 
order by 
  tot_price desc, 
  tot_quant desc 
  
-- worst 10 pizza names in sales
select 
  top 10 pt.name, 
  pt.category, 
  round(
    sum(p.price), 
    0
  ) As tot_price, 
  sum(od.quantity) AS tot_quant 
from 
  pizza_types AS pt 
  join pizzas AS p on p.pizza_type_id = pt.pizza_type_id 
  join order_details AS od on od.pizza_id = p.pizza_id 
group by 
  pt.name, 
  pt.category 
order by 
  tot_price, 
  tot_quant 
  
------------------------------------------

select 
  top (5) * 
from 
  order_details 
select 
  top (5) * 
from 
  orders 
select 
  top (5) * 
from 
  pizza_types 
select 
  top (5) * 
from 
  pizzas 
  
--worst category( classic XXL) (tot_quantity = 28 item )
--best  category( classic  S ) (tot_quantity = 6139 item )

select 
  pt.name, 
  sum(od.quantity) AS NO_OF_SALES_QUANTITY 
from 
  pizzas AS p 
  join pizza_types AS pt on p.pizza_type_id = pt.pizza_type_id 
  join order_details AS od on p.pizza_id = od.pizza_id 
group by 
  pt.name, 
  category, 
  size 
having 
  category = 'classic' 
  and size = 'XXL' 
  
--worst pizza sales  in Classic Category , XXL Size is (The Greek Pizza) , (28 piece)
  -----------------------
  
select 
  pt.name, 
  sum(od.quantity) AS QUANTITY_OF_SALES 
from 
  pizzas AS p 
  join pizza_types AS pt on p.pizza_type_id = pt.pizza_type_id 
  join order_details AS od on p.pizza_id = od.pizza_id 
group by 
  pt.name, 
  category, 
  size 
having 
  category = 'classic' 
  and size = 'S' 
order by 
  QUANTITY_OF_SALES desc 

--best pizza sales in Classic Category , S Size is (The Big Meat Pizza),(1914 pieces)
