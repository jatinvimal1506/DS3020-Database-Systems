--Q1a and b 
create index idx_rental_rate on film using btree(rental_rate);

explain analyse select * from film order by rental_rate desc;

--Q1c 
--By default PosgtresSQL uses Quick Sort Technique

--Q2A
--a
drop index email_idx;
explain analyse select * from customer where email = 'linda.williams@sakilacustomer.org';
create unique index unique_email on customer(email);

--b
explain analyse select * from customer where email = 'linda.williams@sakilacustomer.org';

--c
-- Ensures no duplicate values are allowed in the specified columns and for query optimisation 
-- it gives efficient where or join clauses

--Q2B
explain analyse select * from payment where date(payment_date) = '2007-02-15';

create index idx_payment_date on payment using hash(date(payment_date));


--Q3
explain analyse select staff_id,payment_date,amount from payment where staff_id = 2 and
amount >= 5.00 and payment_date::date between '2007-01-01' and '2007-12-31' order by 
payment_date;

create index multi_idx_amount_date on payment(staff_id,payment_date,amount);


--Q4
explain analyse select release_year,length from film where release_year = 2006 and length > 100;

create index idx_release_year on film using btree(release_year);

create index covering_idx on film(release_year) include(length);

--Q5 
explain analyse select * from film where length = 116 or rating = 'PG' or 
replacement_cost > 10;

create index mul_col_inx on film(rating,length,replacement_cost);

create index ind_len on film using hash(length) where length = 116;
create index ind_rating on film using hash(rating) where rating = 'PG';
create index ind_replace_cost on film using btree(replacement_cost) where replacement_cost > 10;


explain analyse select * from film where length = 116 or rating = 'PG' or 
replacement_cost > 10 order by replacement_cost;

--Q6
explain analyse select * from film where length = 116 and rating = 'PG' and replacement_cost > 10;

--a
create index multi_idx on film(rating,length,replacement_cost);

explain analyse 
select * from film where length = 116 and rating = 'PG' and replacement_cost > 10;

--b 
explain analyse 
select * from film where replacement_cost > 10 and length = 116 and rating = 'PG';

--c
---1
explain analyse select * from film where length = 116 and rating = 'PG';

--2
explain analyse select * from film where rating = 'PG' and replacement_cost = 10;

--3
explain analyse select * from film where length = 116 and replacement_cost = 10;

--d
create index multi_idx on film(replacement_cost,rating,length);

explain analyse select * from film where length = 116 and rating = 'PG';

--2
explain analyse select * from film where rating = 'PG' and replacement_cost = 10;

--3
explain analyse select * from film where length = 116 and replacement_cost = 10;

--Q7

explain analyse select * from film where length = 116 and rating = 'PG' and replacement_cost > 10;

create index len_idx on film using hash(length) where length = 116;
create index rating_idx on film using hash(rating) where rating = 'PG';
create index replacement_cost_idx on film using btree(replacement_cost) where replacement_cost > 10;

create index multi_idx on film(replacement_cost,rating,length);

explain analyse select * from film where length = 116 and rating = 'PG' and replacement_cost > 10;





