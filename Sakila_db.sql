use sakila; 

#1a. Display the first and last names of all actors from the table actor
select first_name, last_name 
from actor;

/*1b. Display the first and last name of each actor in a single column in 
		upper case letters. Name the column Actor Name.*/
select concat(first_name, ' ', last_name) as 'Actor Name'
from actor;

/*2a. You need to find the ID number, first name, and last name of an actor, 
		of whom you know only the first name, "Joe."*/
select * from actor
where first_name = 'Joe';


#2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like '%GEN%';

/*2c. Find all actors whose last names contain the letters LI. This time, 
		order the rows by last name and first name, in that order:*/
select * from actor
where last_name like '%LI%'
order by last_name asc, first_name;   

/*2d. Using IN, display the country_id and country columns of the following 
		countries: Afghanistan, Bangladesh, and China:*/
select country_id, country 
from country
where country in('Afghanistan', 'Bangladesh', 'China');

/*3a. You want to keep a description of each actor. You don't think you will be
		performing queries on a description, so create a column in the table actor 
				named description and use the data type BLOB*/
alter table actor
add column description blob;

/*3b. Very quickly you realize that entering descriptions for each actor is too much 
		effort. Delete the description column.*/
alter table actor
drop column description;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'count'
from actor
group by last_name;

/*4b. List last names of actors and the number of actors who have that last name, 
		but only for names that are shared by at least two actors*/
select last_name, count(last_name) as 'count'
from actor
group by last_name
having count(last_name) >= 2;

/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
		GROUCHO WILLIAMS. Write a query to fix the record.*/
update actor
set first_name = 'HARPO'
where first_name = 'Groucho' and last_name = 'Williams';

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
		GROUCHO was the correct name after all! In a single query, if the first 
		name of the actor is currently HARPO, change it to GROUCHO.*/
set sql_safe_updates = 0;
update actor
set first_name = 'GROUCHO'
where first_name = 'Harpo';
set sql_safe_updates = 1;

#5a. Locate the schema of the address table.
describe address;

/*6a. Use JOIN to display the first and last names, as well as the address, 
	of each staff member. Use the tables staff and address:*/
select staff.first_name, staff.last_name, address.address
from staff join address
on staff.address_id = address.address_id;

/*6b. Use JOIN to display the total amount rung up by each staff member in 
		August of 2005. Use tables staff and payment.*/      
select staff.staff_id, sum(payment.amount) as 'total_amount'
from staff join payment
on staff.staff_id = payment.staff_id
where payment.payment_date between '2005-05-01 00:00:00' and '2005-05-31 11:59:59'
group by staff.staff_id;

/*6c. List each film and the number of actors who are listed for that film. 
		Use tables film_actor and film. Use inner join.*/