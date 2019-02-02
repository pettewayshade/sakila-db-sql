USE sakila; 

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
ALTER TABLE actor
ADD COLUMN description BLOB;

/*3b. Very quickly you realize that entering descriptions for each actor is too much 
		effort. Delete the description column.*/
ALTER TABLE actor
DROP COLUMN description;

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
SET sql_safe_updates = 0;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'Harpo';
SET sql_safe_updates = 1;

#5a. Locate the schema of the address table.
DESCRIBE address;

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
    f.title, COUNT(fa.actor_id) AS actors
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(i.film_id) AS inventory_count, f.title
FROM
    inventory i
        JOIN
    film f ON i.film_id = f.film_id
WHERE
    f.title = 'Hunchback Impossible';

/*6e. Using the tables payment and customer and the JOIN command, list the total paid 
		by each customer. List the customers alphabetically by last name:*/
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_amt_paid
FROM
    payment p
        JOIN
    customer c ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

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
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

/*7c. You want to run an email marketing campaign in Canada, for which you
	will need the names and email addresses of all Canadian customers. Use
	joins to retrieve this information.*/
SELECT 
    first_name, last_name, email
FROM
    customer c
        JOIN
    address a ON c.address_id = a.address_id
        JOIN
    city ON city.city_id = a.city_id
        JOIN
    country ctry ON ctry.country_id = city.city_id
WHERE
    ctry.country = 'Canada';

/*7d. Sales have been lagging among young families, and you wish to target 
	all family movies for a promotion. Identify all movies categorized as 
    family films.*/
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));
                    
#7e. Display the most frequently rented movies in descending order.
SELECT 
    COUNT(r.rental_id) AS rent_count, f.title
FROM
    rental r
        JOIN
    inventory i ON i.inventory_id = r.inventory_id
        JOIN
    film f ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY rent_count;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    s.store_id, SUM(p.amount) AS total_revenue
FROM
    payment p
        JOIN
    rental r ON p.rental_id = r.rental_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    store s ON i.store_id = s.store_id
GROUP BY s.store_id; 

#7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id, city.city, ctry.country
FROM
    address a
        JOIN
    store s ON s.address_id = a.address_id
        JOIN
    city ON city.city_id = a.city_id
        JOIN
    country ctry ON ctry.country_id = city.country_id;

/*7h. List the top five genres in gross revenue in descending order. 
	(Hint: you may need to use the following tables: category, film_category, 
    inventory, payment, and rental.)*/
SELECT 
    c.name AS genre, SUM(p.amount) AS total_revenue
FROM
    category c
        JOIN
    film_category fc ON c.category_id = fc.category_id
        JOIN
    inventory i ON fc.film_id = i.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
        JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue
LIMIT 5;

/*8a. In your new role as an executive, you would like to have an easy way of 
	viewing the Top five genres by gross revenue. Use the solution from the 
	problem above to create a view. If you haven't solved 7h, you can substitute 
    another query to create a view.*/
CREATE VIEW top_five_by_gross AS
    SELECT 
        c.name AS genre, SUM(p.amount) AS total_revenue
    FROM
        category c
            JOIN
        film_category fc ON c.category_id = fc.category_id
            JOIN
        inventory i ON fc.film_id = i.film_id
            JOIN
        rental r ON i.inventory_id = r.inventory_id
            JOIN
        payment p ON r.rental_id = p.rental_id
    GROUP BY c.name
    ORDER BY total_revenue
    LIMIT 5;
    
#8b. How would you display the view that you created in 8a?
SELECT 
    *
FROM
    top_five_by_gross;
    
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_by_gross;