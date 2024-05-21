
-- yl21-2 Raamatute nimekiri: alates 2010 aastast välja antud raamatud, mis on uued. 
-- Sorteerida pealkirja järgi tähestikulises järjekorras.
		--SELECT * FROM tabel WHERE tingimus1 AND tinigmus2 ORDER BY veerg;
    --(tulemus 113 kirjet)

SELECT *
FROM books
WHERE release_date >= '2010' AND type = 'new'
ORDER BY title ASC;

-- yl21-3
--Raamatute nimekiri: raamatud, mis on ilmunud enne 1970. aastat on kasutatud ja mille hind on väiksem kui 20 eurot. 
--Väljastada ainult pealkiri, aasta, hind ja tüüp veerud. (tulemus 2 kirjet)

SELECT title, release_date, price, type
FROM books
WHERE release_date < 1970
  AND price < 20
  AND type = 'used';

-- yl21-4
--Täidetud tellimuste arv aasta kaupa. Väljasta ainult tellimuse aasta ja tellimuste arv. 
--Tulemuse veeru pealkirjaks pane “Aasta” ja “Tellimuste arv” (ei ole vaja andmebaasis tabelit muuta!). 
--COUNT(), GROUP BY, DATE või YEAR, AS (tulemus 4 kirjet)


SELECT YEAR(order_date) AS Aasta, COUNT(*) AS 'Tellimuste arv'
FROM orders
GROUP BY YEAR(order_date);

-- yl21-5
--Täidetud tellimuste arv aasta kaupa ja müükide summa. 
--Pane veergudele ilusad pealkirjad ja ümarda summa kahe komakohani. 
--LEFT JOIN (tulemus summad 5814.08, 18676.06, 21211.61, 23661.34)

SELECT 
    YEAR(o.order_date) AS 'Aasta',          -- Võtab aasta `orders` tabeli `order_date` veerust ja nimetab selle 'Aasta'
    COUNT(o.id) AS 'Tellimuste Arv',  -- Loendab `orders` tabeli `order_id` väärtuste arvu ja nimetab selle 'Tellimuste Arv'
    ROUND(SUM(b.price), 2) AS 'Müükide Summa'  -- Arvutab kogumüügi (price * quantity), ümardab tulemuse kahe komakohani ja nimetab selle 'Müükide Summa'
FROM 
    orders o  -- Annab `orders` tabelile lühendi 'o'
LEFT JOIN 
    books b ON o.book_id = b.id  -- Ühendab `books` tabeli (lühendiga 'b') `orders` tabeliga (lühendiga 'o') `book_id` veeru alusel
GROUP BY 
    YEAR(o.order_date)  -- Grupeerib tulemused aasta järgi
    

    --yl21-6 
    -- Täidetud tellimuste arv viimase aasta jooksul ja müükide summa.
    SELECT 
    YEAR(o.order_date) AS 'Aasta',          -- Võtab aasta `orders` tabeli `order_date` veerust ja nimetab selle 'Aasta'
    COUNT(o.id) AS 'Tellimuste Arv',  -- Loendab `orders` tabeli `order_id` väärtuste arvu ja nimetab selle 'Tellimuste Arv'
    ROUND(SUM(b.price), 2) AS 'Müükide Summa'  -- Arvutab kogumüügi (price * quantity), ümardab tulemuse kahe komakohani ja nimetab selle 'Müükide Summa'
FROM 
    orders o  -- Annab `orders` tabelile lühendi 'o'
LEFT JOIN 
    books b ON o.book_id = b.id  -- Ühendab `books` tabeli (lühendiga 'b') `orders` tabeliga (lühendiga 'o') `book_id` veeru alusel
WHERE 
    o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);


-- yl21-7 Väljastada kliendid viimase aasta jooksul tehtud tellimuste põhjal kulutatud summa järgi.

SELECT 
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS 'Kliendi nimi',
    COUNT(o.id) AS 'Tellimuste arv',
    ROUND(SUM(b.price), 2) AS 'Kokku kulutatud summa'
FROM 
    orders o
LEFT JOIN 
    clients c ON o.client_id = c.id
LEFT JOIN 
    books b ON o.book_id = b.id
WHERE 
    o.order_date >= DATE_SUB(CURDATE(), INTERVAL 10 YEAR)
GROUP BY 
    c.id
ORDER BY 
    SUM(b.price) DESC;

--Viimase aasta top 10 enim müüdud raamatud. LIMIT
SELECT b.title, COUNT(o.book_id) AS total_orders
FROM orders o
JOIN books b ON o.id = b.id
WHERE YEAR(o.order_date) BETWEEN YEAR(CURDATE()) - 9 AND YEAR(CURDATE()) --WHERE YEAR(o.order_date) = 2017
GROUP BY b.title
ORDER BY total_orders DESC
LIMIT 10;

--Raamatute nimekiri, mille hind on keskmisest kõrgem. (1096)
SELECT title, price
FROM books
WHERE price > (SELECT AVG(price) FROM books);