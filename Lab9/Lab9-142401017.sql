--Q1 a
select customer_id,amount from payment where amount >5 and amount<8
order by amount desc;

explain analyse select customer_id,amount from payment where amount >5 and amount<8
order by amount desc;

--Q1 b
create index payment_amount_idx on payment using btree(amount);


--Q2a
explain analyse select first_name,last_name from customer where first_name ilike 'W%'
and last_name ilike '%e%';

--Q2b
create extension pg_trgm;

create index trgm_idx_first on customer using gin(first_name gin_trgm_ops);
create index trgm_idx_last on customer using gin(last_name gin_trgm_ops);

explain analyse select first_name,last_name from customer where first_name ilike 'W%'
and last_name ilike '%e%';

--Q2c
create index trgm_idx_first_and_last on customer
using gin(first_name gin_trgm_ops,last_name gin_trgm_ops);

explain analyse select first_name,last_name from customer where first_name ilike 'W%'
and last_name ilike '%e%';


--Q3a
select * from customer where email = 'melissa.king@sakilacustomer.org';

--Q3b
select * from film where replacement_cost > 3;

--Q3c
--For replacement_cost
explain analyse select * from film where replacement_cost > 3;
create index replacement_cost_idx on film using btree(replacement_cost);

--For email
create index email_idx on customer using hash(email);

explain analyse select * from customer
where email = 'melissa.king@sakilacustomer.org';

--Q4a
select * from payment where amount = 4.99 and (payment_date < '2007-02-15' and payment_date > '2007-02-01');

--Q4b

--Q4c
create index hash_amount on payment using hash(amount);
create index btree_payment_date on payment using btree(payment_date);


explain analyse select * from payment where amount = 4.99 
and (payment_date < '2007-02-15' and payment_date > '2007-02-01');

--Q5b
select * from film where special_features @> array['Behind the Scenes'];

--Q5a
create index idx_special_feature on film using gin(special_features);

explain analyse select * from film 
where special_features @> array['Behind the Scenes'];

--Q6a
create table dummy_data(
	text_data text,
	num_data integer
)


insert into dummy_data(text_data,num_data)
select md5(random()::text),random()*100
from (select * from generate_series(1,10000) as id)as x;

select * from dummy_data;

--Q6b-1
select * from dummy_data where text_data ilike '%ed%' and num_data > 50;

--Q6b-2
explain analyse select * from dummy_data 
where text_data ilike '%ed%' and num_data > 50;

--Q6b-3
create index dumm_hash_text_data on dummy_data using hash(text_data);
create index dummy_btree on dummy_data using btree(num_data);

explain analyse select * from dummy_data 
where text_data ilike '%ed%' and num_data > 50;


