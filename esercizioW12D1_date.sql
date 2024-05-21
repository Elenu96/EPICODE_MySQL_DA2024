# Effettuate un’esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene? 
# Fate in modo di avere un’idea abbastanza chiara riguardo a con cosa state lavorando

# Scoprite quanti clienti si sono registrati nel 2006

SELECT COUNT(customer.customer_id) AS ClientiRegistrati
FROM customer
WHERE customer.create_date LIKE '2006-%';

#oppure

SELECT COUNT(customer.customer_id) AS ClientiRegistrati
FROM customer
WHERE YEAR(customer.create_date) = 2006;

# Trovate il numero totale di noleggi effettuati il giorno 1/1/2006

SELECT COUNT(rental.rental_id) AS NumeroNoleggi
FROM rental
WHERE rental.rental_date LIKE '2006-01-01%';

#oppure

SELECT COUNT(rental.rental_id) AS NumeroNoleggi
FROM rental
WHERE DATE(rental.rental_date) = '2006-01-01';

# Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati

SELECT film.title, customer.first_name, customer.last_name, customer.email, customer.address_id
FROM rental JOIN customer ON rental.customer_id=customer.customer_id JOIN store ON customer.store_id=store.store_id JOIN inventory ON store.store_id=inventory.store_id JOIN film ON inventory.film_id=film.film_id
WHERE rental.rental_date >= CURRENT_DATE() - INTERVAL 7 DAY;

SELECT film.title, customer.first_name, customer.last_name, customer.email, customer.address_id
FROM rental JOIN customer ON rental.customer_id=customer.customer_id JOIN store ON customer.store_id=store.store_id JOIN inventory ON store.store_id=inventory.store_id JOIN film ON inventory.film_id=film.film_id
WHERE rental.rental_date >= '2005-05-30' - INTERVAL 7 DAY;

# Calcolate la durata media del noleggio per ogni categoria di film

SELECT 
    category.name AS Catergoria,
    ROUND(AVG(TIMESTAMPDIFF(DAY,
                rental.rental_date,
                rental.return_date))) AS DurataMediaNoleggio
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film_category.film_id = film.film_id
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
WHERE
    rental.return_date IS NOT NULL
GROUP BY category.name;

# Trovare la durata del noleggio più lungo

SELECT MAX(TIMESTAMPDIFF(DAY,
                rental.rental_date,
                rental.return_date)) AS NoleggioPiuLungo
FROM rental
WHERE rental.return_date IS NOT NULL; 