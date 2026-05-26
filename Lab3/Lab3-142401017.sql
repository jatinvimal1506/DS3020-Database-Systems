-- Q1A
SELECT customer_id FROM payment WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15'
EXCEPT ALL
SELECT customer_id FROM payment WHERE payment_date BETWEEN '2007-02-16' AND '2007-02-28';

-- Q1B
SELECT first_name || ' ' || last_name as name FROM customer WHERE customer_id IN (
    SELECT customer_id FROM payment WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15'
    EXCEPT ALL
    SELECT customer_id FROM payment WHERE payment_date BETWEEN '2007-02-16' AND '2007-02-28'
);

-- Q2
SELECT customer_id FROM payment WHERE EXTRACT(month FROM payment_date) = 2 AND EXTRACT(year FROM payment_date) = 2007
EXCEPT
SELECT customer_id FROM payment WHERE EXTRACT(month FROM payment_date) = 3 AND EXTRACT(year FROM payment_date) = 2007;

-- Q3
SELECT customer_id, SUM(amount) FROM payment WHERE customer_id IN (
    SELECT customer_id FROM payment GROUP BY customer_id HAVING COUNT(payment_id) > 30
) GROUP BY customer_id;

-- Q4
SELECT title FROM film WHERE rental_rate > (SELECT AVG(rental_rate) FROM film) AND replacement_cost > (SELECT AVG(replacement_cost) FROM film);

-- Q5
SELECT customer_id FROM payment GROUP BY customer_id HAVING SUM(amount) > ALL (
    SELECT AVG(amount) FROM payment GROUP BY customer_id
);

-- Q6
SELECT COUNT(film_id), 
CASE 
    WHEN rental_rate = 0.99 THEN 'Cheap'
    WHEN rental_rate = 2.99 THEN 'Moderate'
    WHEN rental_rate = 4.99 THEN 'Premium'
END as Pricebands
FROM film GROUP BY Pricebands;

-- Q7
SELECT EXTRACT(day FROM rental_date) as day, COUNT(rental_id) as number FROM rental GROUP BY day ORDER BY number DESC LIMIT 1;

-- Q8
SELECT customer_id, (COUNT(CASE WHEN amount = 0 THEN 1 ELSE NULL END)::float / COUNT(amount)) * 100 as percentage 
FROM payment GROUP BY customer_id;

-- Q9
SELECT COUNT(film_id), category.name FROM film_category 
JOIN category ON film_category.category_id = category.category_id 
GROUP BY category.name;

-- Q10
SELECT customer_id FROM rental GROUP BY customer_id HAVING COUNT(rental_id) > (
    SELECT AVG(count_rental) FROM (SELECT COUNT(rental_id) as count_rental FROM rental GROUP BY customer_id) as sub
);