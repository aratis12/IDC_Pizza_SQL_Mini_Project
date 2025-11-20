
select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

-- List all unique pizza categories (DISTINCT).


select distinct category
from pizza_types;

-- 3. Display `pizza_type_id`, `name`, and ingredients, replacing NULL ingredients with `"Missing Data"`. Show first 5 rows.
select pizza_type_id,
name,
(case when ingredients is null then 'Missing Data' else ingredients end) as ingredients
from pizza_types
limit 5;

-- 4. Check for pizzas missing a price (`IS NULL`).

select * 
from pizzas
where price IS NULL;

-- **Phase 2: Filtering & Exploration**

-- 1. Orders placed on `'2015-01-01'` (`SELECT` + `WHERE`).
select * 
from orders
where date= '2015-01-01';

-- 2. List pizzas with `price` descending.

select * 
from pizzas
order by price desc;

-- 3. Pizzas sold in sizes `'L'` or `'XL'`.
select * 
from pizzas
where size in ('L','XL');

-- 4. Pizzas priced between $15.00 and $17.00.
select * 
from pizzas
where price between '15.00' and '17.00';

-- 5. Pizzas with `"Chicken"` in the name.
select * 
from pizza_types
where name like '% chicken%';

-- 6. Orders on `'2015-02-15'` or placed after 8 PM.

select *
from orders
where date ='2015-02-15' or time >'20:00:00';

--------- Phase 3: Sales Performance**------------------------

-- 1. Total quantity of pizzas sold (`SUM`).
select sum(quantity)
from order_details;

-- 2. Average pizza price (`AVG`).
select avg(price)
from pizzas;

-- 3. Total order value per order (`JOIN`, `SUM`, `GROUP BY`).

select od.order_id,
sum(p.price)
from order_details od
join pizzas p
on od.pizza_id= p.pizza_id
group by od.order_id;

-- 4. Total quantity sold per pizza category (`JOIN`, `GROUP BY`).
select pt.category,
sum(od.quantity)
from pizza_types pt
 left join pizzas p
on pt.pizza_type_id= p.pizza_type_id
  left join order_details od
on p.pizza_id=od.pizza_id
group by pt.category;

-- 5. Categories with more than 5,000 pizzas sold (`HAVING`).
select pt.category,
sum(od.quantity) as total_quantity
from pizza_types pt
 left join pizzas p
on pt.pizza_type_id= p.pizza_type_id
  left join order_details od
on p.pizza_id=od.pizza_id
group by pt.category
having total_quantity >5000;

-- 6. Pizzas never ordered (`LEFT/RIGHT JOIN`).

select od.order_id, p.pizza_id, pt.name
from pizzas p
left join order_details od
on p.pizza_id = od.pizza_id
left join pizza_types pt
on p.pizza_type_id= pt.pizza_type_id
where od.order_id is null;

-- 7. Price differences between different sizes of the same pizza (`SELF JOIN`).

SELECT
    s.pizza_type_id,
    s.price AS small_price,
    m.price AS medium_price,
    l.price AS large_price,
    m.price - s.price AS diff_small_to_medium,
    l.price - m.price AS diff_medium_to_large,
    l.price - s.price AS diff_small_to_large
FROM pizzas s
JOIN pizzas m
    ON s.pizza_type_id = m.pizza_type_id
   AND m.size = 'M'
JOIN pizzas l
    ON s.pizza_type_id = l.pizza_type_id
   AND l.size = 'L'
WHERE s.size = 'S';