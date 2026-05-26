-- Q1) a and b
create table employee_audit (
    emp_id int primary key,
    operation_type varchar not null,
    change_time timestamp not null
);

create or replace function Toget()
returns trigger
language plpgsql as $$
begin
    if TG_OP = 'INSERT' then
        insert into employee_audit values (new.emp_id, 'INSERT', current_timestamp);
        return new;
    elsif TG_OP = 'UPDATE' then
        insert into employee_audit values (new.emp_id, 'UPDATE', current_timestamp);
        return new;
    end if;
end;
$$;

create or replace trigger ce
after insert or delete
on employee
for each row
execute procedure Toget();

-- Q1) c and d
create or replace function logs()
returns trigger
language plpgsql as $$
begin
    if TG_OP = 'INSERT' then
        insert into employee_audit(emp_id, operation_type, change_time) values (new.emp_id, 'INSERT', current_timestamp);
        return new;
    elsif TG_OP = 'UPDATE' then
        insert into employee_audit(emp_id, operation_type, change_time) values (new.emp_id, 'UPDATE', current_timestamp);
        return new;
    end if;
end;
$$;

create or replace trigger Log_trigger
after insert or delete
on employee
for each row
execute procedure logs();

-- Q1) e
alter table employee_audit add column old_salary numeric;
alter table employee_audit add column new_salary numeric;

-- Q2) a
create or replace function prevent_payment()
returns trigger
language plpgsql as $$
begin
    if new.staff_id not in (select staff_id from staff) then
        raise exception 'Staff ID not found';
    end if;
    
    if new.amount < 0 then
        raise exception 'Payment amount is negative';
    end if;
    
    return new;
end;
$$;

create or replace trigger payment_exception
after insert
on payment
for each row
execute procedure prevent_payment();

-- Q3) a
select customer_id, sum(amount) from payment group by customer_id order by sum(amount) desc limit 1 offset 2;

-- Q3) b
explain analyze
select customer_id, sum(amount) from payment group by customer_id order by sum(amount) desc limit 1 offset 2;

-- Q3) c
-- Execution time for part a: 2.865 ms
-- Execution time for part b: 5.445 ms
-- Execution time for part c: 2.531 ms

-- Q6) a
create or replace view customer_payment_summary as
select customer_id, sum(amount) as sum, avg(amount) as avg_amount
from payment group by customer_id;

-- Q6) b
explain analyze
select * from customer_payment_summary order by sum desc limit 5;

-- Q6) c
select * from customer_payment_summary where sum > 150;

-- Q6) d
explain analyze
select * from customer_payment_summary order by sum desc limit 5;