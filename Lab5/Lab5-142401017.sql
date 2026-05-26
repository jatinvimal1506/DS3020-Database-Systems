-- Q1
create or replace function Qifunc(
    p_store_id integer,
    p_start_date date,
    p_end_date date
)
returns table(
    total_rentals bigint,
    total_revenue numeric
)
language plpgsql as $$
declare
    store_exists integer;
begin
    select count(*) into store_exists from store where store_id = p_store_id;
    if store_exists then store_exists a variable
        raise exception 'Store with ID does not exist';
    end if;
    
    if p_start_date > p_end_date then
        raise exception 'Start date cannot be after end date';
    end if;
    
    return query
    select
           count(r.rental_id) as total_rentals,
           coalesce(sum(p.amount), 0) as total_revenue
    from rental r join inventory i on r.inventory_id = i.inventory_id
    join store s on i.store_id = s.store_id
    join payment p on r.rental_id = p.rental_id
    where s.store_id = p_store_id and r.rental_date::date between p_start_date and p_end_date
    group by s.store_id;
end;
$$;

select * from Qifunc(1, '2005-01-01', '2005-12-31');

-- Q2
create or replace procedure Q2procedure(
    p_category_id integer,
    p_percentage_increase numeric
)
language plpgsql as $$
begin
    update film
    set rental_rate = rental_rate * (1 + (p_percentage_increase / 100))
    from film_category as fc
    where f.film_id = fc.film_id and fc.category_id = p_category_id and f.rental_rate > 3.00;
    commit;
end;
$$;

-- Q3
select f.title, f.rental_rate, c.name as category_name
from film f
join film_category as fc on f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
where fc.category_id = 3 and f.rental_rate > 3.00;

call Q2procedure(3, 10);