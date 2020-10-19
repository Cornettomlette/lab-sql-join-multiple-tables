/*Lab | SQL Joins on multiple tables
In this lab, you will be using the Sakila database of movie rentals.

Instructions
	Write a query to display for each store its store ID, city, and country.
	Write a query to display how much business, in dollars, each store brought in.
	What is the average running time of films by category?
	Which film categories are longest?
	Display the most frequently rented movies in descending order.
	List the top five genres in gross revenue in descending order.
	Is "Academy Dinosaur" available for rent from Store 1?  */
    
USE sakila;

-- 1) Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 2) Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, count(amount) as amount_brought
FROM store
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 3) What is the average running time of films by category?
SELECT name, round(avg(film.length), 2) as average_length
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name;

-- 4) Which film categories are longest?
SELECT name, round(avg(film.length), 2) as average_length, 
dense_rank() over (order by round(avg(film.length), 2) desc) as ranking
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name
LIMIT 5;

-- 5) Display the most frequently rented movies in descending order.
SELECT title, count(rental_id) as num_rented
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY count(rental_id) desc
LIMIT 5;

-- 6) List the top five genres in gross revenue in descending order.
SELECT category.name, sum(payment.amount) 
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY category.name desc
LIMIT 5;

-- 7) Is "Academy Dinosaur" available for rent from Store 1?
SELECT store.store_id, title, count(inventory_id) as copies_available, 
CASE
WHEN count(inventory_id) > 0 THEN 'available for rent'
ELSE 'not available'
END AS 'available_or_not'
FROM store
INNER JOIN inventory ON store.store_id = inventory.store_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY store.store_id, title
HAVING title = 'ACADEMY DINOSAUR' and store.store_id = 1;