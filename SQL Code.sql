# Total sales in year 2025
SELECT SUM(total_price_eur - shipping_fee_eur) AS total_sales_2025
FROM SALES
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025;

# Total sales in year 2024
SELECT SUM(total_price_eur - shipping_fee_eur) AS total_sales_2024
FROM SALES
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2024;



# Total sales by month in year 2025 (Table 5.1, Row 1)
WITH sales_long_tab AS (
SELECT EXTRACT(MONTH FROM sale_timestamp) AS month_numb, SUM(total_price_eur - shipping_fee_eur) AS total_sales
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY EXTRACT(MONTH FROM sale_timestamp))
SELECT
  	MAX(CASE WHEN month_numb = 1 THEN total_sales END) AS January,
    MAX(CASE WHEN month_numb = 2 THEN total_sales END) AS February,
    MAX(CASE WHEN month_numb = 3 THEN total_sales END) AS March,
	  MAX(CASE WHEN month_numb = 4 THEN total_sales END) AS April,
    MAX(CASE WHEN month_numb = 5 THEN total_sales END) AS May,
    MAX(CASE WHEN month_numb = 6 THEN total_sales END) AS June,
    MAX(CASE WHEN month_numb = 7 THEN total_sales END) AS July,
    MAX(CASE WHEN month_numb = 8 THEN total_sales END) AS August,
    MAX(CASE WHEN month_numb = 9 THEN total_sales END) AS September,
    MAX(CASE WHEN month_numb = 10 THEN total_sales END) AS October,
    MAX(CASE WHEN month_numb = 11 THEN total_sales END) AS November,
    MAX(CASE WHEN month_numb = 12 THEN total_sales END) AS December
FROM sales_long_tab;



# Total sales by month in year 2025 (Table 5.1, Row 2)
WITH sales_long_tab AS (
SELECT EXTRACT(MONTH FROM sale_timestamp) AS month_numb, SUM(total_price_eur - shipping_fee_eur) AS total_sales
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY EXTRACT(MONTH FROM sale_timestamp))
SELECT
  	CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 1 THEN total_sales END) / SUM(total_sales), 2), '%') AS January,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 2 THEN total_sales END) / SUM(total_sales), 2), '%') AS February,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 3 THEN total_sales END) / SUM(total_sales), 2), '%') AS March,
	  CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 4 THEN total_sales END) / SUM(total_sales), 2), '%') AS April,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 5 THEN total_sales END) / SUM(total_sales), 2), '%') AS May,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 6 THEN total_sales END) / SUM(total_sales), 2), '%') AS June,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 7 THEN total_sales END) / SUM(total_sales), 2), '%') AS July,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 8 THEN total_sales END) / SUM(total_sales), 2), '%') AS August,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 9 THEN total_sales END) / SUM(total_sales), 2), '%') AS September,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 10 THEN total_sales END) / SUM(total_sales), 2), '%') AS October,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 11 THEN total_sales END) / SUM(total_sales), 2), '%') AS November,
    CONCAT(ROUND(100 * MAX(CASE WHEN month_numb = 12 THEN total_sales END) / SUM(total_sales), 2), '%') AS December
FROM sales_long_tab;



# Monthly sales comparison between 2024 and 2025 (Table 5.2)
WITH suma_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS year_numb, EXTRACT(MONTH FROM sale_timestamp) AS month_numb, MONTHNAME(sale_timestamp) AS month_name, SUM(total_price_eur - shipping_fee_eur) AS total_sales
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) BETWEEN 2024 AND 2025
GROUP BY EXTRACT(YEAR FROM sale_timestamp), EXTRACT(MONTH FROM sale_timestamp), MONTHNAME(sale_timestamp)),
lag_tab AS (
SELECT year_numb, month_numb, month_name, LAG(total_sales, 1) OVER (PARTITION BY month_numb ORDER BY year_numb ASC) AS total_sales_2024, total_sales AS total_sales_2025
FROM suma_tab),
comp_tab AS (
SELECT month_name, total_sales_2024, total_sales_2025 FROM lag_tab
WHERE year_numb = 2025
ORDER BY month_numb ASC)
SELECT month_name, CONCAT('€', FORMAT(total_sales_2024, 2)) AS total_sales_2024,
	CONCAT('€', FORMAT(total_sales_2025, 2)) AS total_sales_2025,
    CONCAT('€', FORMAT(total_sales_2025 - total_sales_2024, 2)) AS abs_change,
    CONCAT(ROUND(100 * (total_sales_2025 - total_sales_2024) / total_sales_2024, 2), '%') AS rel_change
FROM comp_tab;



# Total revenue increase in % by month for each year (Table 5.3)
WITH agg_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS year_numb, EXTRACT(MONTH FROM sale_timestamp) AS month_numb, MONTHNAME(sale_timestamp) AS month_name, SUM(total_price_eur) AS revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_timestamp), EXTRACT(MONTH FROM sale_timestamp), MONTHNAME(sale_timestamp)),
lag_tab AS (
SELECT year_numb, month_numb, month_name, LAG(revenue, 3) OVER (PARTITION BY month_numb ORDER BY year_numb ASC) AS rev_2022,
	LAG(revenue, 2) OVER (PARTITION BY month_numb ORDER BY year_numb ASC) AS rev_2023,
    LAG(revenue, 1) OVER (PARTITION BY month_numb ORDER BY year_numb ASC) AS rev_2024,
    revenue AS rev_2025
FROM agg_tab)
SELECT month_name, CONCAT(ROUND(100 * (rev_2023 - rev_2022) / rev_2022, 2), '%') AS change_22_23,
	CONCAT(ROUND(100 * (rev_2024 - rev_2023) / rev_2023, 2), '%') AS change_23_24,
    CONCAT(ROUND(100 * (rev_2025 - rev_2024) / rev_2024, 2), '%') AS change_24_25
FROM lag_tab
WHERE year_numb = 2025
ORDER BY month_numb;



# Cumulative registered customers by year (Table 5.4)
WITH year_tab AS (
SELECT customer_id,
	CASE
		WHEN EXTRACT(YEAR FROM signup_timestamp) <= 2022 THEN 2022
        WHEN EXTRACT(YEAR FROM signup_timestamp) = 2023 THEN 2023
        WHEN EXTRACT(YEAR FROM signup_timestamp) = 2024 THEN 2024
        WHEN EXTRACT(YEAR FROM signup_timestamp) = 2025 THEN 2025
	END AS registered_by
FROM customers_cleaned),
agg_tab AS (
SELECT registered_by, COUNT(DISTINCT customer_id) AS new_registrations
FROM year_tab
GROUP BY registered_by),
sum_tab AS (
SELECT registered_by AS year, SUM(new_registrations) OVER (ORDER BY registered_by ASC) AS cum_registrations
FROM agg_tab)
SELECT
	FORMAT(MAX(CASE WHEN year = 2022 THEN cum_registrations END), 0) AS year_2022,
    FORMAT(MAX(CASE WHEN year = 2023 THEN cum_registrations END), 0) AS year_2023,
    FORMAT(MAX(CASE WHEN year = 2024 THEN cum_registrations END), 0) AS year_2024,
    FORMAT(MAX(CASE WHEN year = 2025 THEN cum_registrations END), 0) AS year_2025
FROM sum_tab;



# Active customers by year (Table 5.5)
WITH id_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS year_numb, customer_id FROM sales),
agg_tab AS (
SELECT year_numb, COUNT(DISTINCT customer_id) AS numb_active_cust
FROM id_tab
GROUP BY year_numb)
SELECT
	FORMAT(MAX(CASE WHEN year_numb = 2022 THEN numb_active_cust END), 0) AS year_2022,
    FORMAT(MAX(CASE WHEN year_numb = 2023 THEN numb_active_cust END), 0) AS year_2023,
    FORMAT(MAX(CASE WHEN year_numb = 2024 THEN numb_active_cust END), 0) AS year_2024,
    FORMAT(MAX(CASE WHEN year_numb = 2025 THEN numb_active_cust END), 0) AS year_2025
FROM agg_tab;





# Average order value by year (Table 5.6)
WITH agg_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS year_numb, AVG(total_price_eur) AS average_order_eur
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_timestamp))
SELECT
	CONCAT('€', FORMAT(MAX(CASE WHEN year_numb = 2022 THEN average_order_eur END), 2)) AS year_2022,
    CONCAT('€', FORMAT(MAX(CASE WHEN year_numb = 2023 THEN average_order_eur END), 2)) AS year_2023,
    CONCAT('€', FORMAT(MAX(CASE WHEN year_numb = 2024 THEN average_order_eur END), 2)) AS year_2024,
    CONCAT('€', FORMAT(MAX(CASE WHEN year_numb = 2025 THEN average_order_eur END), 2)) AS year_2025
FROM agg_tab;



# Yearly order counts and average orders by active customer (Table 5.7)
(WITH agg_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS sale_year, COUNT(*) AS orders_placed
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_timestamp))
SELECT
	FORMAT(MAX(CASE WHEN sale_year = 2022 THEN orders_placed END), 0) AS year_2022,
    FORMAT(MAX(CASE WHEN sale_year = 2023 THEN orders_placed END), 0) AS year_2023,
    FORMAT(MAX(CASE WHEN sale_year = 2024 THEN orders_placed END), 0) AS year_2024,
    FORMAT(MAX(CASE WHEN sale_year = 2025 THEN orders_placed END), 0) AS year_2025
FROM agg_tab)
UNION ALL
(WITH agg_tab2 AS (
SELECT tab1.year_numb AS year_numb, ROUND(tab2.orders_placed / tab1.active_cust_count, 2) AS orders_per_capita
FROM (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS year_numb, COUNT(DISTINCT customer_id) AS active_cust_count
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_timestamp)) AS tab1
INNER JOIN (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS sale_year, COUNT(*) AS orders_placed
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_timestamp)) AS tab2 ON tab1.year_numb = tab2.sale_year)
SELECT
	MAX(CASE WHEN year_numb = 2022 THEN orders_per_capita END) AS year_2022,
    MAX(CASE WHEN year_numb = 2023 THEN orders_per_capita END) AS year_2023,
    MAX(CASE WHEN year_numb = 2024 THEN orders_per_capita END) AS year_2024,
    MAX(CASE WHEN year_numb = 2025 THEN orders_per_capita END) AS year_2025
FROM agg_tab2);





# Order count, average orders by active customer, total revenue,
# and average order value by active customer for customers registered
# before and in 2025 (Table 5.8)
WITH joined_tab AS (
SELECT tab1.signup_year, tab2.numb_act_cust, tab1.order_count, tab1.revenue, tab1.eur_per_order FROM (
WITH comb_tab AS (
SELECT sa.sale_id, sa.customer_id,
	CASE
		WHEN EXTRACT(YEAR FROM c.signup_timestamp) <= 2024 THEN 'before 2025'
        WHEN EXTRACT(YEAR FROM c.signup_timestamp) = 2025 THEN 'in 2025'
	END AS signup_year,
    sa.total_price_eur
FROM sales AS sa
INNER JOIN customers AS c ON sa.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM sa.sale_timestamp) = 2025)
SELECT signup_year, COUNT(*) AS order_count, SUM(total_price_eur) AS revenue, SUM(total_price_eur) / COUNT(*) AS eur_per_order
FROM comb_tab
GROUP BY signup_year) AS tab1
INNER JOIN (
WITH c2tab AS (
SELECT sa.customer_id,
	CASE
		WHEN EXTRACT(YEAR FROM c.signup_timestamp) <= 2024 THEN 'before 2025'
        WHEN EXTRACT(YEAR FROM c.signup_timestamp) = 2025 THEN 'in 2025'
	END AS signup_year
FROM sales AS sa
INNER JOIN customers AS c ON sa.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM sa.sale_timestamp) = 2025)
SELECT signup_year, COUNT(DISTINCT customer_id) AS numb_act_cust
FROM c2tab
GROUP BY signup_year) AS tab2 ON tab1.signup_year = tab2.signup_year)
SELECT signup_year, FORMAT(order_count, 0) AS order_count, ROUND(order_count / numb_act_cust, 2) AS orders_per_capita,
	CONCAT('€', FORMAT(revenue, 2)) AS revenue, CONCAT('€', FORMAT(eur_per_order, 2)) AS value_per_order
FROM joined_tab;



# Number of new and returning customers in 2025 (Table 5.9)
WITH agg_tab AS (
SELECT customer_id, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_timestamp ASC) AS nr_purchase, EXTRACT(YEAR FROM sale_timestamp) AS sale_year
FROM sales),
type_tab AS (
SELECT customer_id,
	CASE
		WHEN MIN(nr_purchase) = 1 THEN 'new'
        ELSE 'returning'
	END AS customer_type
FROM agg_tab
WHERE sale_year = 2025
GROUP BY customer_id),
count_tab AS (
SELECT customer_type, COUNT(*) AS customer_count
FROM type_tab
GROUP BY customer_type),
abs_tab AS (
SELECT
	MAX(CASE WHEN customer_type = 'returning' THEN customer_count END) AS returning_cust,
    MAX(CASE WHEN customer_type = 'new' THEN customer_count END) AS new_cust
FROM count_tab)
(SELECT
	FORMAT(returning_cust, 0) AS 'Returning',
    FORMAT(new_cust, 0) AS 'New',
    FORMAT(returning_cust + new_cust, 0) AS 'Total'
FROM abs_tab)
UNION ALL
(SELECT
	CONCAT(ROUND(100 * returning_cust / (returning_cust + new_cust), 2), '%') AS 'Returning',
    CONCAT(ROUND(100 * new_cust / (returning_cust + new_cust), 2), '%') AS 'New',
    '100.00%' AS 'Total'
FROM abs_tab);



# Revenue concentration among active customers in 2025 (Table 5.10)
WITH pre_tab AS (
SELECT f.thousands + g.tthousands AS lower_bound, LEAD(f.thousands + g.tthousands) OVER (ORDER BY f.thousands + g.tthousands ASC) AS upper_bound
FROM (
SELECT 0 AS thousands
UNION ALL SELECT 5000
) AS f
CROSS JOIN (
SELECT 0 AS tthousands
UNION ALL SELECT 10000
UNION ALL SELECT 20000
UNION ALL SELECT 30000
UNION ALL SELECT 40000
UNION ALL SELECT 50000
UNION ALL SELECT 60000
UNION ALL SELECT 70000
UNION ALL SELECT 80000
UNION ALL SELECT 90000
) AS g
ORDER BY f.thousands + g.tthousands ASC),
group_tab AS (
SELECT lower_bound, upper_bound - 0.01 AS upper_bound, CONCAT('[€', FORMAT(lower_bound, 0), ', €', FORMAT(upper_bound, 0), ')') AS category
FROM pre_tab
WHERE upper_bound <= 75000),
sale_tab AS (
SELECT customer_id, SUM(total_price_eur) AS revenue
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY customer_id),
comb_tab AS (
SELECT st.customer_id, st.revenue, gt.category, gt.lower_bound AS lower_bound
FROM sale_tab AS st
INNER JOIN group_tab AS gt ON st.revenue BETWEEN gt.lower_bound AND gt.upper_bound),
pre_final AS (
SELECT category, COUNT(*) AS cust_count, lower_bound
FROM comb_tab
GROUP BY category, lower_bound)
SELECT category, FORMAT(cust_count, 0), CONCAT(FORMAT(100 * cust_count / (SUM(cust_count) OVER ()), 2), '%') AS rel
FROM pre_final
ORDER BY lower_bound;







# Number of orders in 2025 by days since the previous purchase (Table 5.11)
WITH time_tab AS (
SELECT customer_id, sale_timestamp, TIMESTAMPDIFF(SECOND, LAG(sale_timestamp, 1) OVER (PARTITION BY customer_id ORDER BY sale_timestamp ASC), sale_timestamp) / 86400.0 AS days_since_last_purch
FROM sales
ORDER BY customer_id, sale_timestamp),
freq_tab AS (
SELECT customer_id, days_since_last_purch
FROM time_tab
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025),
pre_group AS (
SELECT hund_tab.hundreds + thous_tab.thousands AS lower_bound,
	LEAD(hund_tab.hundreds + thous_tab.thousands, 1) OVER (ORDER BY hund_tab.hundreds + thous_tab.thousands) AS upper_bound
FROM (
SELECT 0 AS hundreds
UNION ALL SELECT 100
UNION ALL SELECT 200
UNION ALL SELECT 300
UNION ALL SELECT 400
UNION ALL SELECT 500
UNION ALL SELECT 600
UNION ALL SELECT 700
UNION ALL SELECT 800
UNION ALL SELECT 900
) AS hund_tab
CROSS JOIN (
SELECT 0 AS thousands
UNION ALL SELECT 1000
) AS thous_tab
ORDER BY  hund_tab.hundreds + thous_tab.thousands ASC),
group_tab AS (
SELECT lower_bound, upper_bound - 1 AS upper_bound, CONCAT('between ', lower_bound, ' and ', upper_bound - 1) AS category
FROM pre_group
WHERE upper_bound <= 1400),
count_tab AS (
SELECT gt.category, gt.lower_bound
FROM freq_tab AS ft
INNER JOIN group_tab AS gt ON ft.days_since_last_purch >= gt.lower_bound AND ft.days_since_last_purch < gt.upper_bound + 1),
pre_final AS (
SELECT category, COUNT(*) AS order_count, lower_bound
FROM count_tab
GROUP BY category, lower_bound
ORDER BY lower_bound)
SELECT category, FORMAT(order_count, 0) AS abs, CONCAT(FORMAT(100 * order_count / SUM(order_count) OVER (), 2), '%') AS rel
FROM pre_final;



# Key features of top 20 customers by revenue in 2025 (Table 5.12)
WITH rev_tab AS (
SELECT customer_id, SUM(total_price_eur) AS revenue
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY customer_id
ORDER BY SUM(total_price_eur) DESC),
ord_tab AS (
SELECT customer_id, COUNT(*) AS order_count
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY customer_id
ORDER BY COUNT(*) DESC),
recency_tab AS (
SELECT customer_id, TIMESTAMPDIFF(SECOND, MAX(sale_timestamp), '2026-01-01 00:00:00') / 86400.0 AS recency
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
GROUP BY customer_id),
cust_id_2025 AS (
SELECT DISTINCT customer_id
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) = 2025
),
first_tab AS (
	SELECT cid.customer_id, stab.time_since_first_purch
    FROM cust_id_2025 AS cid
    LEFT JOIN (
		SELECT customer_id, TIMESTAMPDIFF(SECOND, MIN(sale_timestamp), '2026-01-01 00:00:00') / 86400.0 AS time_since_first_purch
        FROM sales
        GROUP BY customer_id
    ) AS stab ON cid.customer_id = stab.customer_id),
cat_pre AS (
SELECT s1.customer_id, s3.category
FROM sales AS s1
INNER JOIN sale_items AS s2 ON s1.sale_id = s2.sale_id
LEFT JOIN products AS s3 ON s2.product_id = s3.product_id
WHERE EXTRACT(YEAR FROM s1.sale_timestamp) = 2025),
cat_final AS (
SELECT customer_id, COUNT(DISTINCT category) AS category_count
FROM cat_pre
GROUP BY customer_id)
SELECT rt.customer_id, CONCAT('€', FORMAT(rt.revenue, 2)) AS revenue,
	CONCAT(FORMAT(100 * rt.revenue / (SUM(rt.revenue) OVER ()), 2), '%') AS perc,
    FORMAT(ot.order_count, 0) AS order_count, CONCAT('€', FORMAT(rt.revenue / ot.order_count, 2)) AS average_rev_per_order, cc.customer_type,
    FORMAT(rec_tab.recency, 2) AS recency, FORMAT(ft.time_since_first_purch, 2) AS time_since_first_purch, ct.category_count
FROM rev_tab AS rt
INNER JOIN ord_tab AS ot ON rt.customer_id = ot.customer_id
INNER JOIN customers_cleaned AS cc ON rt.customer_id = cc.customer_id
INNER JOIN recency_tab AS rec_tab ON rt.customer_id = rec_tab.customer_id
INNER JOIN first_tab AS ft ON rt.customer_id = ft.customer_id
INNER JOIN cat_final AS ct ON rt.customer_id = ct.customer_id
ORDER BY rt.revenue DESC
LIMIT 20;









# Average customer-level revenue change between 2024 and 2025 among
# customers doing a purchase in both years (Table 5.13)
WITH agg_tab AS (
SELECT customer_id, EXTRACT(YEAR FROM sale_timestamp) AS sale_year, SUM(total_price_eur) AS revenue
FROM sales
WHERE EXTRACT(YEAR FROM sale_timestamp) BETWEEN 2024 AND 2025
GROUP BY EXTRACT(YEAR FROM sale_timestamp), customer_id),
lag_tab AS (
SELECT customer_id, sale_year, revenue AS revenue2025, LAG(revenue, 1) OVER (PARTITION BY customer_id ORDER BY sale_year ASC) AS revenue2024
FROM agg_tab),
change_tab AS (
SELECT customer_id, revenue2024, revenue2025, revenue2025 - revenue2024 AS revenue_shift, 100 * (revenue2025 - revenue2024) / revenue2024 AS revenue_change_rel
FROM lag_tab
WHERE sale_year = 2025 AND revenue2024 IS NOT NULL)
SELECT CONCAT('€', FORMAT(AVG(revenue_shift), 2)) AS mean_abs_change, CONCAT(FORMAT(AVG(revenue_change_rel), 2), '%') AS mean_rel_change
FROM change_tab;



# Top 10 products by revenue for years 2022 through 2025 (Table 5.14)
WITH join_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS sale_year, si.product_id, si.units_sold, si.line_total_eur AS revenue,
	pr.product_name, pr.category, pr.subcategory, pr.brand
FROM sales AS sa
INNER JOIN sale_items AS si ON sa.sale_id = si.sale_id
LEFT JOIN products_cleaned AS pr ON si.product_id = pr.product_id),
agg_tab AS (
SELECT sale_year, product_id, product_name, SUM(revenue) AS revenue
FROM join_tab
GROUP BY sale_year, product_id, product_name),
rank_tab AS (
SELECT sale_year, product_name, revenue, DENSE_RANK() OVER (PARTITION BY sale_year ORDER BY revenue DESC) AS ranking
FROM agg_tab)
SELECT sale_year, ranking, product_name, CONCAT('€', FORMAT(revenue, 2)) AS revenue
FROM rank_tab
WHERE ranking <= 10
ORDER BY sale_year DESC, ranking ASC;



# Product categories ranked by revenue for 2022 through 2025 (Table 5.15)
WITH join_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS sale_year, si.product_id, si.units_sold, si.line_total_eur AS revenue,
	pr.product_name, pr.category, pr.subcategory, pr.brand
FROM sales AS sa
INNER JOIN sale_items AS si ON sa.sale_id = si.sale_id
LEFT JOIN products_cleaned AS pr ON si.product_id = pr.product_id),
agg_tab AS (
SELECT sale_year, category, SUM(revenue) AS revenue
FROM join_tab
GROUP BY sale_year, category),
rank_tab AS (
SELECT sale_year, category, revenue, DENSE_RANK() OVER (PARTITION BY sale_year ORDER BY revenue DESC) AS ranking
FROM agg_tab)
SELECT sale_year, ranking, category, CONCAT('€', FORMAT(revenue, 2)) AS revenue
FROM rank_tab
WHERE ranking <= 10
ORDER BY sale_year DESC, ranking ASC;



# Top 10 brands by revenue for 2022 through 2025 (Table 5.16)
WITH join_tab AS (
SELECT EXTRACT(YEAR FROM sale_timestamp) AS sale_year, si.product_id, si.units_sold, si.line_total_eur AS revenue,
	pr.product_name, pr.category, pr.subcategory, pr.brand
FROM sales AS sa
INNER JOIN sale_items AS si ON sa.sale_id = si.sale_id
LEFT JOIN products_cleaned AS pr ON si.product_id = pr.product_id),
agg_tab AS (
SELECT sale_year, brand, SUM(revenue) AS revenue
FROM join_tab
GROUP BY sale_year, brand),
rank_tab AS (
SELECT sale_year, brand, revenue, DENSE_RANK() OVER (PARTITION BY sale_year ORDER BY revenue DESC) AS ranking
FROM agg_tab)
SELECT sale_year, ranking, brand, CONCAT('€', FORMAT(revenue, 2)) AS revenue
FROM rank_tab
WHERE ranking <= 10
ORDER BY sale_year DESC, ranking ASC;
