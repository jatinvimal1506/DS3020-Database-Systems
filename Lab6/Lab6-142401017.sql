-- Q1A
create role student_portal_user login password 'student123';
grant select on all tables in schema public to student_portal_user;

-- Q1B
select * from student;

-- Q2
grant insert, delete on all tables in schema public to student_portal_user;

insert into student values (1, 'Jatin', 'Math', 4);
select * from student where name = 'Jatin';
delete from student where name = 'Jatin';

-- Q3A
create role Faculty_group;
grant select, update on course to Faculty_group;

-- Q3B
create role assistant_professor login password 'prof123';
grant Faculty_group to assistant_professor;

-- Q3C
create role academic with login;
alter role academic in database university_db set log_statement = 'all';

update course set title = 'Java Programming' where course_id = 'CS101';
select * from course where course_id = 'CS101';

-- Q5
reassign owned by student_portal_user to postgres;
drop owned by student_portal_user;
drop role student_portal_user;

-- Q6
create view computer_science as
select * from student where dept_name = 'Comp. Sci.'
with check option;

insert into computer_science values (11, 'Jatin', 'Maths', 24);

-- Q7
-- Views get updated as soon as the tables get updated
create or replace view dept_summary as
select dept_name, count(distinct s_id) as total_students, count(distinct i_id) as total_instructors, count(course_id) as total_courses, avg(tot_cred) as average_credits
from department left join student using (dept_name)
left join course using (dept_name)
left join instructor using (dept_name)
group by dept_name;

insert into student values (1901, 'Statistics', 20);
select * from dept_summary;

-- Q9A
create or replace view classroom_utilisation as
select building, room_number, capacity, semester, year, count(*)
from section join classroom using (building, room_number)
group by building, room_number, capacity, semester, year;

select * from classroom_utilisation;