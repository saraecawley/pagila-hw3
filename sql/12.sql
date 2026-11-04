/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN LATERAL (
    SELECT rental_id
    FROM rental
    WHERE customer_id = c.customer_id
    ORDER BY rental_date DESC
    LIMIT 5
) recent ON true
JOIN rental r ON r.rental_id = recent.rental_id
JOIN inventory i USING (inventory_id)
WHERE EXISTS (
    SELECT 1
    FROM film_category fc
    JOIN category cat USING (category_id)
    WHERE fc.film_id = i.film_id AND cat.name = 'Action'
)
GROUP BY c.customer_id
HAVING count(*) >= 4
ORDER BY c.customer_id;
