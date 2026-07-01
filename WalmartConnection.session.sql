-- exploratory data analysis EDA

SELECT * FROM walmart;

SELECT COUNT(*) FROM walmart;

SELECT payment_method, COUNT(*) FROM walmart GROUP BY payment_method;

SELECT COUNT(DISTINCT "Branch") FROM walmart;

SELECT MAX(quantity) FROM walmart;

SELECT MIN(quantity) FROM walmart;

/*

PROBLEM SET

FIND DIFFERENT PAYMENT METHOD AND NUMBER OF TRANSACTIONS, NUMBER OF QTY SOLD

IDENTIFY THE HIGHEST RATED CATEGORY IN EACH BRANCH, DISPLAYING THE BRANCH CATEGORY, AVERAGE RATING

IDENTIFY THE BUSIEST DAY FOR EACH BRANCH BASED ON THE NUMBER OF TRANSACTIONS

CALCULATE THE TOTAL QUANTITY OF ITEMS SOLD PER PAYMENT METHOD. LIST PAYMENT_METHOD AND TOTAL QUANTITY

DETERMINE THE AVERAGE , MINIMUM, MAXIMUM RATING OF CATEGORY FOR EACH CITY
LIST THE CITY, AVERAGE RATING, MINIMUM RATING , MAXIMUM RATING 

DETERMINE THE MOST COMMON PAYMENT METHOD FOR EACH BRANCH.
DISPLAY BRANCH AND THE PREFERRED PAYMENT METHOD..


CATEGORIZE SALES INTO 3 GROUP MORNING, AFTERNOON , EVENING
FIND OUT EACH OF THE SHIFT AND NUMBER OF INVOICES

*/


SELECT payment_method , COUNT(*), sum(quantity)
FROM walmart
GROUP BY payment_method;




WITH category_avg AS (
    SELECT
        "Branch",
        category,
        AVG(rating) AS avg_rating
    FROM walmart
    GROUP BY "Branch", category
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY "Branch" ORDER BY avg_rating DESC) AS rnk
    FROM category_avg
)
SELECT
    "Branch",
    category,
    avg_rating
FROM ranked
WHERE rnk = 1;








SELECT * 
FROM
(SELECT 
    "Branch",
    TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
    COUNT(*) as no_transactions,
    RANK() OVER(PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY 1, 2
    )
WHERE rank = 1;






SELECT payment_method, SUM(quantity) as TOTAL_QUANTITY
FROM walmart
GROUP BY payment_method;



SELECT * FROM walmart LIMIT 1;

SELECT 
    "City",
    category,
    AVG(rating) as average_rating,
    MIN(rating) as minimum_rating,
    MAX(rating) as maximum_rating
FROM walmart
GROUP BY 1, 2;






SELECT
    category,
    SUM(unit_price * quantity * profit_margin) as total_profit
FROM walmart
GROUP BY 1
ORDER BY 2 DESC;


WITH cte AS (
    SELECT
        "Branch",
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rank
FROM walmart
GROUP BY 1, 2
)
SELECT * FROM cte WHERE rank = 1;

SELECT
CASE
        WHEN EXTRACT(HOUR FROM (time::time)) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END day_time,
    COUNT(*)
FROM walmart
GROUP BY 1;
