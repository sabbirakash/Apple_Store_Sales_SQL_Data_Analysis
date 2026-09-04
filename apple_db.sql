-- Apple Retail Million Rows Sales Schemas

-- Drop Table Command
DROP TABLE IF EXISTS category;	-- Parent Table
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS stores;	-- Parent Table
DROP TABLE IF EXISTS warranty;



-- Create Table Command
CREATE TABLE stores (
store_id	VARCHAR(20) PRIMARY KEY,
store_name	VARCHAR(30),
city		VARCHAR(30),
country		VARCHAR(30)
);



CREATE TABLE category (
category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(50)
);


CREATE TABLE products (
product_id		VARCHAR(10) PRIMARY KEY,
product_name	VARCHAR(50),
category_id		VARCHAR(20),
launch_date		DATE,
price			FLOAT,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);


CREATE TABLE sales (
sales_id	VARCHAR(20) PRIMARY KEY,
sales_date	DATE,
store_id	VARCHAR(20),	-- this fk
product_id	VARCHAR(20),	-- this fk
quantity	INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);



CREATE TABLE warranty (
claim_id		VARCHAR(20) PRIMARY KEY,
claim_date		DATE,
sales_id		VARCHAR(20),	--this is fk
repair_status	VARCHAR(20),
CONSTRAINT fk_sales FOREIGN KEY (sales_id) REFERENCES sales(sales_id)
ON UPDATE CASCADE
ON DELETE CASCADE
);


-- Success Message
SELECT 'Schema Created Successfully' AS Success_Message;