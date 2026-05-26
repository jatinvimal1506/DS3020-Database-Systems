-- Q1
select film_id from film where film_id = '10';

select film_id from film where film_id = cast('10' as integer);

-- Q2
select * from rental where DATE(rental_date) = '2005-05-25';

-- Q3
select f.film_id, f.title 
from film as f
LEFT JOIN inventory as i ON f.film_id = i.film_id
LEFT JOIN rental as rent ON i.inventory_id = rent.inventory_id
where rent.rental_id is null;

-- Q4
select c.customer_id, COUNT(r.rental_id) as total_rentals 
from customer as c JOIN rental r ON c.customer_id = r.customer_id
group by c.customer_id;

-- Q5
select p.payment_id, c.customer_id, c.first_name || ' ' || c.last_name AS customer_full_name,
       s.staff_id, s.first_name || ' ' || s.last_name AS staff_full_name
from payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN staffs s ON p.staff_id = s.staff_id
where c.last_name = s.last_name
  and c.first_name <> s.first_name;

-- Q6
select a1.first_name || ' ' || a1.last_name as actor1,
       a2.first_name || ' ' || a2.last_name as actor2
from actor a1 JOIN actor a2
ON a1.actor_id < a2.actor_id and a1.first_name <> a2.first_name;

-- Q7
select count(f.film_id) from film f
left join inventory i on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id
where cast(r.rental_date as date) < cast('2005-05-25' as date);

-- Q8-i
select count(distinct(f.film_id))
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id and cast(r.rental_date as date) = '2005-05-25'
where r.rental_id is null;

-- Q8-ii
select count(distinct(f.film_id))
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id and cast(r.rental_date as date) > '2005-06-25'
where r.rental_id is null;

-- Q9-iii
select c.name, l.name, count(f.film_id)
from film f
join film_category fc on fc.film_id = f.film_id
join language l on l.language_id = f.language_id
join category c on c.category_id = fc.category_id
group by c.name, l.name;