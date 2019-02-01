Use sakila;
--1a.
SELECT first_name, last_name
FROM actor;
--1b .
SELECT first_name, last_name,
	CONCAT_WS(' ', first_name, last_name) as "Actor Name"
FROM actor;

--2a.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

--2b. 
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%G%' AND last_name LIKE '%E%' AND last_name LIKE '%N%';

--2c. 
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%L%' AND last_name LIKE '%I%';


--2d.
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

--3a.
ALTER TABLE actor
ADD description BLOB;

--3b.
ALTER TABLE actor
Drop description;

--4a.
SELECT last_name, count(last_name)
FROM actor
group by last_name;

--4b.
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name) >1;

--4c.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

--4d.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

--5a.
CREATE TABLE address (
  address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  address varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone varchar(20) NOT NULL,
  location geometry NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY idx_location (location),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

--6a.
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON(a.address_id = s.address_id);

--6b.
SELECT s.first_name, s.last_name, s.staff_id, sum(p.amount) AS "Total amount rung up by staff member in August 2005"
FROM payment p 
JOIN staff s
ON(s.staff_id = p.staff_id)
WHERE payment_Date LIKE '2005-08-%'
GROUP BY s.staff_id;

--6c.
SELECT f.title, count(a.actor_id) AS "# of actors"
FROM film f
INNER JOIN film_actor a ON
f.film_id = a.film_id
GROUP BY f.title;

--6d. 
SELECT count(i.film_id) AS "Copies of Hunchback Impossible"
FROM inventory i 
WHERE i.film_id IN(
	SELECT f.film_id 
    FROM film f
    WHERE f.title = "Hunchback Impossible");

--6e.
SELECT c.first_name, c.last_name, sum(p.amount) AS "Total paid by customer"
FROM customer c 
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.last_name
ORDER BY c.last_name;

--7a. 
SELECT title AS "Movies starting with K or Q that are in English"
FROM film 
WHERE title LIKE 'k%' OR title LIKE 'q%' AND language_id IN(
	SELECT language_id 
    FROM language
    WHERE name = "English");
    
--7b. 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"));


--7c.
SELECT c.first_name, c.last_name, c.email, a.address
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city y
ON a.city_id = y.city_id
JOIN country t
ON y.country_id = t.country_id
WHERE t.country = "Canada";

--7d.
SELECT title AS "Family Friendly Movies"
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = "Family"));
        
--7e. 
SELECT f.title AS "Most freqently rented movies", count(r.rental_date) AS "Number of times rented"
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY count(r.rental_date) DESC;

--7f.
SELECT s.store_id, sum(p.amount) AS "Business in Dollars"
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY s.store_id;

--7g.
SELECT s.store_id, y.city, t.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city y
ON a.city_id = y.city_id
JOIN country t
ON y.country_id = t.country_id;

--7h.
SELECT c.name AS "Film Genre", sum(p.amount) AS "Gross Revenue" 
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id=p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

--8a. 
CREATE VIEW Top_5_Grossing_Film_Genres AS 
SELECT c.name AS "Film Genre", sum(p.amount) AS "Gross Revenue" 
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id=p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

--8b.
SHOW CREATE VIEW Top_5_Grossing_Film_Genres;

--8c. 
DROP VIEW Top_5_Grossing_Film_Genres;
