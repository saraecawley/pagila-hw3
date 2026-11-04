/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT name, title, "total rentals"
FROM (
    SELECT cat.name, f.title,
        count(*) AS "total rentals",
        row_number() OVER (PARTITION BY cat.category_id ORDER BY count(*) DESC, f.title DESC) AS rk
    FROM category cat
    JOIN film_category fc USING (category_id)
    JOIN film f USING (film_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
    GROUP BY cat.category_id, f.film_id
) t
WHERE rk <= 5
ORDER BY name, "total rentals" DESC, title;
