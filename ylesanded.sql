
-- yl21-2
SELECT *
FROM books
WHERE release_date >= '2010' AND type = 'new'
ORDER BY title ASC;

-- yl21-3
SELECT title, release_date, price, type
FROM books
WHERE release_date < 1970
  AND price < 20
  AND type = 'used';

-- yl21-4
SELECT YEAR(order_date) AS Aasta, COUNT(*) AS 'Tellimuste arv'
FROM orders
GROUP BY YEAR(order_date);



