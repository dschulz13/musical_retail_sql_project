
USE ecommerce_synthetic;
SELECT * FROM customers;
DESC customers;

SELECT *, LAG(customer_id, 1) OVER (PARTITION BY st.first_name, st.last_name, st.email ORDER BY st.customer_created_at) AS shifted_customer_id FROM
(
SELECT customer_id, first_name, last_name, email, phone, ROW_NUMBER() OVER (PARTITION BY first_name, last_name, email ORDER BY customer_created_at) AS rn,
customer_created_at
FROM customers) AS st;

# 1. Fix customers table, including
#        - fixing special characters in German
#        - replacing 'str.' by 'straße' in address
#        - trimming all entries
#        - adding a leading 0 to all postal_codes with length of four


SELECT st.customer_id, st.first_name, st.last_name,
	CASE WHEN st.address LIKE '%str. %' THEN REPLACE(st.address, 'str.', 'straße') ELSE st.address END AS address,
    st.postal_code, st.city, st.country, st.phone, st.email, st.customer_created_at
FROM
(
SELECT customer_id,
	TRIM(
		CASE
			WHEN first_name LIKE '%Ã¼%' THEN REPLACE(first_name, 'Ã¼', 'ü')
			WHEN first_name LIKE '%ÃŸ%' THEN REPLACE(first_name, 'ÃŸ', 'ß')
			WHEN first_name LIKE '%Ã¶%' THEN REPLACE(first_name, 'Ã¶', 'ö')
			WHEN first_name LIKE '%Ã¤%' THEN REPLACE(first_name, 'Ã¤', 'ä')
			ELSE first_name
		END
	) AS first_name,
    TRIM(
		CASE
			WHEN last_name LIKE '%Ã¼%' THEN REPLACE(last_name, 'Ã¼', 'ü')
			WHEN last_name LIKE '%ÃŸ%' THEN REPLACE(last_name, 'ÃŸ', 'ß')
			WHEN last_name LIKE '%Ã¶%' THEN REPLACE(last_name, 'Ã¶', 'ö')
			WHEN last_name LIKE '%Ã¤%' THEN REPLACE(last_name, 'Ã¤', 'ä')
			ELSE last_name
		END
	) AS last_name,
	TRIM(
		CASE
			WHEN address LIKE '%Ã¼%' THEN REPLACE(address, 'Ã¼', 'ü')
			WHEN address LIKE '%ÃŸ%' THEN REPLACE(address, 'ÃŸ', 'ß')
			WHEN address LIKE '%Ã¶%' THEN REPLACE(address, 'Ã¶', 'ö')
			WHEN address LIKE '%Ã¤%' THEN REPLACE(address, 'Ã¤', 'ä')
			ELSE address
		END
	) AS address,
    CASE WHEN LENGTH(postal_code) = 4 THEN CONCAT('0', postal_code) ELSE postal_code END AS postal_code,
    TRIM(
		CASE
			WHEN city LIKE '%Ã¼%' THEN REPLACE(city, 'Ã¼', 'ü')
			WHEN city LIKE '%ÃŸ%' THEN REPLACE(city, 'ÃŸ', 'ß')
			WHEN city LIKE '%Ã¶%' THEN REPLACE(city, 'Ã¶', 'ö')
			WHEN city LIKE '%Ã¤%' THEN REPLACE(city, 'Ã¤', 'ä')
			ELSE city
		END
	) AS city,
    country, phone, email, customer_created_at
FROM customers
) AS st;

SELECT * FROM sales;

SELECT sale_id, buyer_id, product_id, sale_timestamp, row_number() OVER (PARTITION BY buyer_id, product_id ORDER BY sale_timestamp ASC) AS rn
FROM sales;

# 1. Fix sales table, including
#        - fixing special characters in German
#        - replacing 'str.' by 'straße' in address
#        - trimming all entries
#        - adding a leading 0 to all postal_codes with length of four