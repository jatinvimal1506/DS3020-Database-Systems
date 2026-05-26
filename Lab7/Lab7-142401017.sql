--Q1
create procedure process_rental_payment(p_customer_id int,p_rental_id int,p_amount numeric)
language plpgsql as $$
begin 
if not exists (select customer_id from customer where customer_id = p_customer_id)
then raise exception 'Customer ID does not exist';
end if; 

if not exists(select rental_id from rental where customer_id = p_customer_id and 
rental_id = p_rental_id)
then raise exception 'Rental ID does not exist';
end if;

if exists (select * from payment where customer_id = p_customer_id and rental_id = p_rental_id)
then raise exception 'Bill has been already paid';
end if;

insert into payment(customer_id,staff_id,rental_id,amount,payment_date) values 
(p_customer_id,1,p_rental_id,p_amount,current_timestamp);
end;
$$;

call process_rental_payment(408,3,7)  -- Rental Id does not exist error
call process_rental_payment(32849,1520,200); -- Customer id does not exist
call process_rental_payment(459,2,100); -- Inserting the values


select * from payment where customer_id = 459 and rental_id = 2;
select * from rental where rental_id = 2;


-- drop procedure process_rental_payment;

--Q2
begin;
update film set rental_rate = 3.99 where film_id = 10;
savepoint first_savepoint;
update film set replacement_cost = 25.99 where film_id = 10;
rollback to first_savepoint;
commit;

select * from film where film_id = 10

--Q3
create procedure print_numbers(p_limit int)
language plpgsql
as $$
declare
	counter INT := 1;
begin
	while counter <= p_limit loop
	raise notice 'Current number : %',counter;
	counter := counter + 1;
	end loop;
end;
$$;
call print_numbers(10);

-- DROP PROCEDURE print_numbers;

--Q5
select f.title from film f left join inventory i on f.film_id = i.film_id left join rental r on i.inventory_id = r.inventory_id group by f.film_id having count(r.rental_id) = 0;

--Q6
select first_name,last_name,email,ct.city from customer c join address a on c.address_id = a.address_id join city ct on a.city_id = ct.city_id
where ct.city = 'London';

--Q7
select st.staff_id,count(r.rental_id) from staff st join rental r on st.staff_id = r.staff_id group by st.staff_id order by st.staff_id;





