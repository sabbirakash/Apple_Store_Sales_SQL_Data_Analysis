
# ![Apple Logo](https://github.com/najirh/Apple-Retail-Sales-SQL-Project---Analyzing-Millions-of-Sales-Rows/blob/main/Apple_Changsha_RetailTeamMembers_09012021_big.jpg.slideshow-xlarge_2x.jpg) Apple Store Sales Data Analysis using PostgreSQL (1M+ Rows)

**Get the guided project/datasets here**: [Get the Project Datasets](https://www.kaggle.com/datasets/amangarg08/apple-retail-sales-dataset)

## Project Overview

This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

The project is ideal for data analysts looking to enhance their SQL skills by working with a large-scale dataset and solving real-world business questions.

## Entity Relationship Diagram (ERD)

![ERD](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/ERD%20image.png)

## Tech Stack

- PostgreSQL
- pgAdmin
- SQL
- Git
- GitHub

## Performance Optimization

- created indexes
- checked execution plans
- considered query efficiency.

## SQL Concept Used

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- CTE
- Window Functions
- RANK()
- LAG()
- CASE
- Aggregate Functions
- EXTRACT()
- TO_CHAR()
- Date Functions
- GROUP BY
- HAVING
- ORDER BY
- Subqueries
- Common Table Expressions

Here’s the shortened and improved version of the "What’s Included" and "Why Choose This Project" sections, along with the link:

---

### What’s Included:
- **SQL Practice Problems**: Extensive coverage of major SQL topics for mastering concepts with real-world data.
- **21 Advanced SQL Queries**: Step-by-step solutions for complex queries, enhancing your skills in performance tuning and optimization.
- **5 Detailed Tables**: Comprehensive datasets with over 1 million rows, including sales, stores, product categories, products, and warranties.
- **Query Performance Tuning**: Learn to optimize queries for real-world data handling.


**Get the guided project/datasets here**: [Get the Project Datasets](https://www.kaggle.com/datasets/amangarg08/apple-retail-sales-dataset)

## Database Schema

The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Objectives

The project is split into three tiers of questions to test SQL skills of increasing complexity:

### Easy to Medium (10 Questions)

1. Find the number of stores in each country.
   ```sql
      SELECT country, COUNT(store_id) AS store_num
      FROM stores
      GROUP BY country
      ORDER BY store_num DESC;
   ```
   ![query-1](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/1.png)
   ## Business Insight:
   This analysis helps identify Apple's retail presence across different countries. Countries with more stores may represent larger customer markets, while regions with fewer stores could indicate potential opportunities for future expansion.
   
2. Calculate the total number of units sold by each store.
   ```sql
      SELECT 
      	sl.store_id,
      	st.store_name,
      	SUM(sl.quantity) AS total_units
      FROM sales AS sl
      JOIN stores AS st
      ON st.store_id = sl.store_id
      GROUP BY 1,2
      ORDER BY 3 DESC;
   ```
   ![query-2](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/2.png)
   ## Business Insight:
   Identifying the highest-performing stores enables management to recognize successful sales strategies, allocate inventory more effectively, and share best practices across other retail locations.
3. Identify how many sales occurred in December 2023.
   ```sql
      SELECT COUNT(*)
      FROM sales
      WHERE TO_CHAR(sales_date, 'MM-YYYY') = '12-2023';
   ```
   ![query-3](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/3.png)
   ## Business Insight:
   Measuring sales during December helps evaluate holiday season performance. This information can support seasonal inventory planning, staffing decisions, and promotional campaign effectiveness.
4. Determine how many stores have never had a warranty claim filed.
   ```sql
      SELECT COUNT(*) FROM stores AS st
      WHERE st.store_id NOT IN (
      						SELECT DISTINCT store_id FROM sales AS sl
      						RIGHT JOIN warranty AS w
      						ON sl.sales_id = w.sales_id
      						);
   ```
   ![query-4](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/4.png)
   ## Business Insight:
   Stores with no warranty claims may indicate excellent product quality, better customer handling, or simply lower sales volume. These locations can be further investigated to understand the underlying reasons.
5. Calculate the percentage of warranty claims marked as "Warranty Rejected".
   ```sql
      SELECT
      	ROUND(COUNT(*)/
      	(SELECT COUNT(*) FROM warranty) :: numeric
      	*100,2) AS warranty_rejected_percentage
      FROM warranty
      WHERE repair_status = 'Rejected';
   ```
   ![query-5](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/5.png)
   ## Business Insight:
   Monitoring the rejection rate helps assess warranty policy effectiveness and identify cases where customers frequently submit invalid warranty requests, reducing unnecessary service costs.
6. Identify which store had the highest total units sold in the last 2 year.
   ```sql
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
   ```
   ![query-6](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/6.png)
   ## Business Insight:
   Recognizing the best-performing store provides valuable insights into regional demand and operational excellence, helping management replicate successful strategies across other locations.
7. Count the number of unique products sold in the last 2 year.
   ```sql
      SELECT 
      	product_id,
      	COUNT(*) AS sold
      FROM sales
      WHERE sales_date >= (SELECT CURRENT_DATE - INTERVAL '2 year')
      GROUP BY 1
      ORDER BY 2 DESC;
   ```
   ![query-7](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/7.png)
   ## Business Insight:
   Product diversity reflects the breadth of customer demand. Understanding how many different products were sold helps evaluate product portfolio performance and inventory utilization.
8. Find the average price of products in each category.
   ```sql
      SELECT 
      		p.category_id,
      		c.category_name,
      		AVG(p.price) AS avg_price
      FROM products AS p
      JOIN category AS c
      ON c.category_id = p.category_id
      GROUP BY 1,2
      ORDER BY avg_price DESC;
   ```
   ![query-8](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/8.png)
   ## Business Insight:
   Comparing average prices across product categories helps understand Apple's pricing strategy and supports revenue forecasting, product positioning, and profitability analysis.
9. How many warranty claims were filed Completed?
    ```sql
      SELECT
      	COUNT(*)
      	-- EXTRACT(YEAR FROM claim_date) AS claim_year		-- Learn how to extract year from any date
      FROM warranty
      WHERE repair_status = 'Completed';
    ```
   ![query-9](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/9.png)
   ## Business Insight:
   Tracking completed warranty claims measures service efficiency and indicates how effectively customer issues are being resolved.
10. For each store, identify the best-selling day based on highest quantity sold.
    ```sql
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
    ```
   ![query-10](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/10.png)
   ## Business Insight:
   Identifying the highest-performing sales day allows store managers to optimize staffing, marketing campaigns, and promotional events during peak customer activity.

### Medium to Hard (5 Questions)

11. Identify the least selling product in each country for each year based on total units sold.
    ```sql
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
    ```
   ![query-11](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/11.png)
   ## Business Insight:
   Low-performing products may require promotional campaigns, pricing adjustments, or discontinuation in specific markets to improve inventory efficiency.
12. Calculate how many warranty claims were filed within 180 days of a product sale.
   ```sql
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
   ```
   ![query-12](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/12.png)
   
   ## Business Insight:
   Early warranty claims may indicate manufacturing defects or quality issues. Identifying these cases helps improve product reliability and supplier quality control.
13. Determine how many warranty claims were filed for products launched in the last two years.
   ```sql
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
   ```
   ![query-13](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/13.png)
   
   ## Business Insight:
   Evaluating warranty claims for recently launched products helps assess product quality after release and enables faster corrective actions for newly introduced devices.
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
   ```sql
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
   ```
   ![query-14](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/14.png)
   
   ## Business Insight:
   Identifying peak sales months helps forecast future demand, improve inventory planning, and optimize marketing campaigns during high-performing periods.
15. Identify the product category with the most warranty claims filed in the last two years.
   ```sql
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
   ```
   ![query-15](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/15.png)

   ## Business Insight:
   Categories with the highest warranty claims may require design improvements, enhanced quality assurance, or better customer support to reduce future claim rates.
### Complex (6 Questions)

16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
    ```sql
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
    ```
   ![query-16](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/16.png)
   
   ## Business Insight:
   Comparing warranty claim rates across countries helps identify regional differences in product performance, customer behavior, or service quality, enabling targeted operational improvements.
17. Analyze the year-by-year growth ratio for each store.
   ```sql
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
   ```
   ![query-17.1](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/17.1.png)
   ![query-17.2](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/17.2.png)
   
   ## Business Insight:
   Measuring annual sales growth helps evaluate store performance over time, identify consistently growing locations, and detect stores that may require strategic intervention.
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
   ```sql
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
   ```
   ![query-18](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/18.png)
   
   ## Business Insight:
   Comparing warranty claims across different price segments helps determine whether premium or budget products experience higher service demand, supporting pricing and product quality strategies.
19. Identify the store with the highest percentage of "Completed" claims relative to total claims filed.
   ```sql
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
   ```
   ![query-19.1](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/19.1.png)
   ![query-19.2](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/19.2.png)
   
   ## Business Insight:
   Stores with higher warranty completion rates demonstrate stronger customer service performance and more efficient after-sales support, contributing to improved customer satisfaction.
20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
   ```sql
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
   ```
   ![query-20](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/20.png)
   
   ## Business Insight:
   Running totals reveal long-term sales trends and growth patterns, helping management monitor store performance and make informed forecasting and budgeting decisions.
21. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
   ```sql
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
   ```
   ![query-21.1](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/21.1.png)
   ![query-21.2](https://github.com/sabbirakash/Apple_Store_Sales_SQL_Data_Analysis/blob/main/Query_Images/21.2.png)

   ## Business Insight:
   Analyzing sales across different product lifecycle stages reveals how customer demand changes after product launch. These insights help optimize marketing efforts, inventory planning, and future product release strategies.
## Project Focus

This project primarily focuses on developing and showcasing the following SQL skills:

- **Complex Joins and Aggregations**: Demonstrating the ability to perform complex SQL joins and aggregate data meaningfully.
- **Window Functions**: Using advanced window functions for running totals, growth analysis, and time-based queries.
- **Data Segmentation**: Analyzing data across different time frames to gain insights into product performance.
- **Correlation Analysis**: Applying SQL functions to determine relationships between variables, such as product price and warranty claims.
- **Real-World Problem Solving**: Answering business-related questions that reflect real-world scenarios faced by data analysts.


## Dataset

- **Size**: 1 million+ rows of sales data.
- **Period Covered**: The data spans multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores across various countries.

## Conclusion

By completing this project, you will develop advanced SQL querying skills, improve your ability to handle large datasets, and gain practical experience in solving complex data analysis problems that are crucial for business decision-making. This project is an excellent addition to your portfolio and will demonstrate your expertise in SQL to potential employers.

---
