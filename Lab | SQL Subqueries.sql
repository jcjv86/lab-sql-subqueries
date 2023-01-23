-- Lab | SQL Subqueries 3.03 --


USE sakila;

/* 1 How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT count(inventory_id) AS number_of_copies FROM inventory
WHERE film_id LIKE (
	SELECT film_id FROM film
	WHERE title LIKE 'Hunchback Impossible');


/* 2 List all films whose length is longer than the average of all the films. */
SELECT film_id, title, length FROM film
WHERE length > (
	SELECT round(AVG(length),2) AS average FROM film);


/* 3 Use subqueries to display all actors who appear in the film Alone Trip. */
SELECT first_name, last_name FROM actor
WHERE actor_id IN(
	SELECT actor_id FROM film_actor
	WHERE film_id IN(
		SELECT film_id FROM film
		WHERE title LIKE 'Alone Trip'));


/* 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. */
SELECT title FROM film
WHERE film_id IN(
	SELECT film_id FROM film_category
	WHERE category_id IN (
		SELECT category_id FROM category
		WHERE name LIKE 'Family'));


/* 5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the 
correct tables with their primary keys and foreign keys, that will help you get the relevant information. */
SELECT first_name, last_name, email from customer
WHERE address_id IN(
	SELECT address_id from address
	WHERE city_id IN (
		SELECT city_id from city
		WHERE country_id IN (
			SELECT country_id FROM country
			WHERE country LIKE 'Canada')));

SELECT cs.first_name, cs.last_name, cs.email FROM customer AS cs
JOIN address AS a
ON cs.address_id = a.address_id
	JOIN city AS ct
	ON a.city_id = ct.city_id
		JOIN country AS c
		ON ct.country_id = c.country_id
		WHERE c.country LIKE 'Canada';


/* 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred. */
SELECT film_id, title, length, release_year FROM film
WHERE film_id IN(
	SELECT film_id FROM film_actor
		WHERE actor_id LIKE (
			SELECT actor_id FROM(
				SELECT actor_id, count(actor_id) AS number_of_films FROM film_actor
				GROUP BY actor_id
				ORDER BY number_of_films DESC
				LIMIT 1) AS db1 ));
    
    
/* 7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer
 that has made the largest sum of payments */
SELECT first_name, last_name, customer_id FROM customer
WHERE customer_id IN (
	SELECT customer_id FROM(
		SELECT customer_id, sum(amount) FROM payment
		GROUP BY customer_id
		ORDER BY sum(amount) DESC
		LIMIT 1) AS sub1);
 
 
/* 8 Customers who spent more than the average payments. */
SELECT customer_id, sum(amount) FROM payment AS total
GROUP BY customer_id
HAVING sum(amount) > (
		SELECT round(AVG(amount),2) AS avg_payment FROM payment)
ORDER BY sum(amount) DESC;