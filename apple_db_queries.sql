-- View Table

SELECT * FROM category;
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM products;
SELECT * FROM warranty;


-- Improving Query Performance

-- pt : 1.688ms
-- et : 472.700ms
-- et after indexing : 15.215ms
EXPLAIN ANALYZE
SELECT *
FROM sales
WHERE product_id = 'P-69';

CREATE INDEX sales_product_id ON sales(product_id);
CREATE INDEX sales_store_id ON sales(store_id);
CREATE INDEX sales_sales_date ON sales(sales_date);


-- Business Questions

/* Easy to Medium (10 Questions)

1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Warranty Rejected".
6. Identify which store had the highest total units sold in the last 2 year.
7. Count the number of unique products sold in the last 2 year.
8. Find the average price of products in each category.
9. How many warranty claims were filed Completed?
10. For each store, identify the best-selling day based on highest quantity sold.
*/


-- 1. Find the number of stores in each country.
SELECT country, COUNT(store_id) AS store_num
FROM stores
GROUP BY country
ORDER BY store_num DESC;

-- 2. Calculate the total number of units sold by each store.
SELECT 
	sl.store_id,
	st.store_name,
	SUM(sl.quantity) AS total_units
FROM sales AS sl
JOIN stores AS st
ON st.store_id = sl.store_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- 3. Identify how many sales occurred in December 2023.
SELECT COUNT(*)
FROM sales
WHERE TO_CHAR(sales_date, 'MM-YYYY') = '12-2023';

-- 4. Determine how many stores have never had a warranty claim filed.
SELECT COUNT(*) FROM stores AS st
WHERE st.store_id NOT IN (
						SELECT DISTINCT store_id FROM sales AS sl
						RIGHT JOIN warranty AS w
						ON sl.sales_id = w.sales_id
						);

-- 5. Calculate the percentage of warranty claims marked as "Warranty Rejected".
SELECT
	ROUND(COUNT(*)/
	(SELECT COUNT(*) FROM warranty) :: numeric
	*100,2) AS warranty_rejected_percentage
FROM warranty
WHERE repair_status = 'Rejected';


-- 6. Identify which store had the highest total units sold in the last 2 year.
WITH abc AS
			(SELECT
				store_id,
				SUM(quantity) AS total_unit
			FROM sales
			WHERE sales_date >= (SELECT CURRENT_DATE - INTERVAL '2 year')
			GROUP BY store_id)
SELECT 
	s.store_id,
	s.store_name,
	abc.total_unit
FROM stores AS s
LEFT JOIN abc
ON s.store_id = abc.store_id
ORDER BY abc.total_unit DESC
LIMIT 1;


-- 7. Count the number of unique products sold in the last 2 year.
-- Each Product sold.

SELECT 
	product_id,
	COUNT(*) AS sold
FROM sales
WHERE sales_date >= (SELECT CURRENT_DATE - INTERVAL '2 year')
GROUP BY 1
ORDER BY 2 DESC;

-- Only the product numbers.
SELECT 
	COUNT(DISTINCT product_id)
FROM sales
WHERE sales_date >= (SELECT CURRENT_DATE - INTERVAL '2 year');

-- 8. Find the average price of products in each category.
SELECT 
		p.category_id,
		c.category_name,
		AVG(p.price) AS avg_price
FROM products AS p
JOIN category AS c
ON c.category_id = p.category_id
GROUP BY 1,2
ORDER BY avg_price DESC;


-- 9. How many warranty claims were filed Completed?

SELECT
	COUNT(*)
	-- EXTRACT(YEAR FROM claim_date) AS claim_year		-- Learn how to extract year from any date
FROM warranty
WHERE repair_status = 'Completed';

-- 10. For each store, identify the best-selling day based on highest quantity sold.

SELECT * FROM(
		SELECT 
			sl.store_id,
			TO_CHAR(sl.sales_date, 'Day') AS sale_day,
			SUM((p.price * sl.quantity)) AS net_price,
			RANK() OVER (PARTITION BY sl.store_id ORDER BY SUM((p.price * sl.quantity)) DESC) AS rank
		FROM sales AS sl
		LEFT JOIN products AS p
		ON sl.product_id = p.product_id
		GROUP BY 1,2) AS tb1
WHERE rank = 1;


/* Medium to Hard (5 Questions)

11. Identify the least selling product in each country for each year based on total units sold.
12. Calculate how many warranty claims were filed within 180 days of a product sale.
13. Determine how many warranty claims were filed for products launched in the last two years.
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
15. Identify the product category with the most warranty claims filed in the last two years.
*/


-- 11. Identify the least selling product in each country for each year based on total units sold.

WITH tb1 AS (
	SELECT 
		st.country,
		p.product_name,
		SUM(sl.quantity) AS total_unit,
		RANK() OVER(PARTITION BY st.country ORDER BY SUM(sl.quantity)) AS rank
	FROM sales AS sl
	JOIN stores AS st
	ON sl.store_id = st.store_id
	JOIN products AS p
	ON p.product_id = sl.product_id
	GROUP BY 1,2
	)
SELECT * FROM tb1
WHERE rank = 1;

-- 12. Calculate how many warranty claims were filed within 180 days of a product sale.

WITH abc AS (
	SELECT 
		sl.sales_id,
		sl.sales_date,
		sl.product_id,
		w.claim_date,
		(w.claim_date - sl.sales_date) AS diff_date
	FROM sales AS sl
	JOIN warranty AS w
	ON sl.sales_id = w.sales_id
	WHERE (w.claim_date - sl.sales_date) <= 180)
SELECT COUNT(*) FROM abc
WHERE diff_date >= 0;

-- 13. Determine how many warranty claims were filed for products launched in the last two years.

SELECT 
	COUNT(*)
	-- sl.sales_id,
	-- sl.product_id,
	-- p.launch_date,
	-- w.claim_date,
	-- (claim_date - launch_date) AS diff_date
FROM sales AS sl
JOIN products AS p
ON sl.product_id = p.product_id
JOIN warranty AS w
ON w.sales_id = sl.sales_id
WHERE ((w.claim_date - p.launch_date) <=  730)
	AND ((w.claim_date - p.launch_date) >=  0);


-- 14. List the months in the last three years where sales exceeded 5,000 units in the USA.
SELECT
	st.country,
	TO_CHAR(sl.sales_date, 'MM-YYYY'),		
	SUM(sl.quantity) AS total_unit
FROM sales AS sl
JOIN stores AS st
ON st.store_id = sl.store_id
WHERE 
	(country = 'United States')
	AND
	(sl.sales_date >= CURRENT_DATE - INTERVAL '3 YEAR')
GROUP BY 1,2
HAVING SUM(sl.quantity) > 5000;



-- 15. Identify the product category with the most warranty claims filed in the last two years.

SELECT 
	c.category_name,
	COUNT(w.claim_id) AS total_claim
FROM warranty AS w
LEFT JOIN sales AS sl
ON w.sales_id = sl.sales_id
JOIN products AS p
ON p.product_id = sl.product_id
JOIN category AS c
ON c.category_id = p.category_id
WHERE w.claim_date >= CURRENT_DATE -INTERVAL '2 YEAR'
GROUP BY 1
ORDER BY total_claim DESC
LIMIT 1;

/* Complex (6 Questions)

16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
17. Analyze the year-by-year growth ratio for each store.
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
19. Identify the store with the highest percentage of "Completed" claims relative to total claims filed.
20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
21. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
*/


-- 16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
SELECT 
	*,
	((total_claim :: numeric / total_unit :: numeric) * 100) AS risk
FROM
	(SELECT
		st.country,
		SUM(sl.quantity) AS total_unit,
		COUNT(w.claim_id) AS total_claim
	FROM sales AS sl
	JOIN stores AS st
	ON sl.store_id = st.store_id
	LEFT JOIN warranty AS w
	ON w.sales_id = sl.sales_id
	GROUP BY 1) AS tb1
ORDER BY 4 DESC;



-- 17. Analyze the year-by-year growth ratio for each store.
WITH tb1 AS
		(SELECT
			st.store_name,
			EXTRACT(YEAR FROM sl.sales_date) AS sales_year,
			SUM(sl.quantity * p.price ) AS current_sales
		FROM sales AS sl
		JOIN products AS p
		ON p.product_id = sl.product_id
		JOIN stores AS st
		ON st.store_id = sl.store_id
		GROUP BY 1,2),
	tb2 AS
		(SELECT
			tb1.*,
			LAG(current_sales, 1) OVER(PARTITION BY store_name ORDER BY sales_year) AS previous_sales
		FROM tb1)
SELECT
	tb2.*,
	ROUND(((tb2.current_sales - tb2.previous_sales) :: numeric / tb2.previous_sales :: numeric) * 100,2) AS growth
FROM tb2
WHERE (previous_sales IS NOT NULL)
	AND
	(sales_year <> 2024);		-- Current year(2024) is running that's we are ignoring it.


-- 18. Calculate the correlation between product price and warranty claims 
-- for products sold in the last five years, segmented by price range.
SELECT 
	CASE
		WHEN p.price < 500 THEN 'Less Expensive'
		WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid Range Expensive'
		ELSE 'Very Expensive Product'
	END,
	COUNT(w.claim_id) AS claimed_item
FROM warranty AS w
LEFT JOIN sales AS sl
ON sl.sales_id = w.sales_id
JOIN products AS p
ON p.product_id = sl.product_id
WHERE sl.sales_date >= CURRENT_DATE - INTERVAL '5 YEAR'
GROUP BY 1;


-- 19. Identify the store with the highest percentage of "Completed" claims relative to total claims filed.
WITH tb1 AS
	(SELECT 
		st.store_id,
		COUNT(w.claim_id) AS Completed_Claim
	FROM warranty AS w
	JOIN sales AS sl
	ON w.sales_id = sl.sales_id
	JOIN stores AS st
	ON st.store_id = sl.store_id
	WHERE w.repair_status = 'Completed'
	GROUP BY 1),
tb2 AS
	(SELECT 
		st.store_id,
		COUNT(w.claim_id) AS All_Claim
	FROM warranty AS w
	JOIN sales AS sl
	ON w.sales_id = sl.sales_id
	JOIN stores AS st
	ON st.store_id = sl.store_id
	GROUP BY 1)
SELECT 
	tb1.store_id,
	st.store_name,
	tb1.completed_claim,
	tb2.all_claim,
	ROUND((tb1.completed_claim :: numeric / tb2.all_claim :: numeric) * 100, 2) AS completed_claim_percentage
FROM tb1 JOIN tb2
ON tb1.store_id = tb2.store_id
JOIN stores AS st
ON st.store_id = tb1.store_id
ORDER BY 5 DESC;


-- 20. Write a query to calculate the monthly running total of sales for each store 
-- over the past four years and compare trends during this period.
WITH tb1 AS 
	(SELECT
		sl.store_id,
		EXTRACT(YEAR FROM sl.sales_date) AS sales_year,
		EXTRACT(MONTH FROM sl.sales_date) AS sales_month,
		SUM(sl.quantity * p.price ) AS total_revenue
	FROM sales AS sl
	LEFT JOIN products AS p
	ON sl.product_id = p.product_id
	GROUP BY 1,2,3
	ORDER BY 1,2,3)
SELECT
	store_id,
	sales_year,
	sales_month,
	total_revenue,
	SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY sales_year, sales_month) AS running_total
FROM tb1;



-- 21. Analyze product sales trends over time, segmented into key periods: 
-- from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

WITH tab1 AS
	(SELECT
		p.product_name,
		CASE
			WHEN sl.sales_date BETWEEN p.launch_date AND p.launch_date + INTERVAL '6 MONTH' THEN '0-6'
			WHEN sl.sales_date BETWEEN p.launch_date + INTERVAL '6 MONTH' AND p.launch_date + INTERVAL '12 MONTH' THEN '6-12'
			WHEN sl.sales_date BETWEEN p.launch_date + INTERVAL '12 MONTH' AND p.launch_date + INTERVAL '18 MONTH' THEN '12-18'
			ELSE '18+'
		END AS plc,
		SUM(sl.quantity) AS total_qty_sale
	FROM sales AS sl
	JOIN products AS p
	ON p.product_id = sl.product_id
	GROUP BY 1,2)
SELECT * FROM tab1
ORDER BY 1,
		CASE
			WHEN plc = '0-6' THEN 1
			WHEN plc = '6-12' THEN 2
			WHEN plc = '12-18' THEN 3
			ELSE 4
		END;



