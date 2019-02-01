use sakila; 

#1a. Display the first and last names of all actors from the table actor
SELECT 
    first_name, last_name
FROM
    actor;

/*1b. Display the first and last name of each actor in a single column in 
		upper case letters. Name the column Actor Name.*/
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM
    actor;

/*2a. You need to find the ID number, first name, and last name of an actor, 
		of whom you know only the first name, "Joe."*/
SELECT 
    *
FROM
    actor
WHERE
    first_name = 'Joe';


#2b. Find all actors whose last name contain the letters GEN:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

/*2c. Find all actors whose last names contain the letters LI. This time, 
		order the rows by last name and first name, in that order:*/
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name ASC , first_name;   

/*2d. Using IN, display the country_id and country columns of the following 
		countries: Afghanistan, Bangladesh, and China:*/
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

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
SELECT 
    last_name, COUNT(last_name) AS 'count'
FROM
    actor
GROUP BY last_name;

/*4b. List last names of actors and the number of actors who have that last name, 
		but only for names that are shared by at least two actors*/
SELECT 
    last_name, COUNT(last_name) AS 'count'
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
		GROUCHO WILLIAMS. Write a query to fix the record.*/
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'Groucho'
        AND last_name = 'Williams';

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
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        JOIN
    address ON staff.address_id = address.address_id;

/*6b. Use JOIN to display the total amount rung up by each staff member in 
		August of 2005. Use tables staff and payment.*/      
SELECT 
    staff.staff_id, SUM(payment.amount) AS 'total_amount'
FROM
    staff
        JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE
    payment.payment_date BETWEEN '2005-05-01 00:00:00' AND '2005-05-31 11:59:59'
GROUP BY staff.staff_id;

/*6c. List each film and the number of actors who are listed for that film. 
		Use tables film_actor and film. Use inner join.*/
SELECT 
    film.title, COUNT(film_actor.actor_id) AS actors
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(inventory.film_id) AS inventory_count, film.title
FROM
    inventory
        JOIN
    film ON inventory.film_id = film.film_id
WHERE
    film.title = 'Hunchback Impossible';

/*6e. Using the tables payment and customer and the JOIN command, list the total paid 
		by each customer. List the customers alphabetically by last name:*/
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_amt_paid
FROM
    payment
        JOIN
    customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
	As an unintended consequence, films starting with the letters K and Q have also 
    soared in popularity. Use subqueries to display the titles of movies starting with 
    the letters K and Q whose language is English.*/
SELECT 
    title
FROM
    film
WHERE
    title LIKE 'K%'
        OR title LIKE 'Q%'
        AND language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            language_id = 1);

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
