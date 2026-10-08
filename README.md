Music Retailer Sales SQL Project
================
Dominik Schulz,
October 08, 2026

- [1 Executive summary](#1-executive-summary)
- [2 Company & data information](#2-company--data-information)
- [3 Business questions](#3-business-questions)
- [4 Applied tools](#4-applied-tools)
- [5 Procedural structure](#5-procedural-structure)
- [6 Detailed project results](#6-detailed-project-results)
  - [6.1 Revenue & sales performance](#61-revenue--sales-performance)
  - [6.2 Customer health](#62-customer-health)

<!-- README.md is generated from README.Rmd. Please edit that file -->

**Note:** This entire project is currently a work in progress and not
yet finished. It will be updated regularly.

# 1 Executive summary

1.  The company’s increase in revenue is mainly driven by its increase
    in number of customers, whereas the average number of orders per
    active customer is decreasing slowly over time. We recommend
    measures, such as special discount events and stamp card systems, to
    activate sleeping clients and increase the number of orders per
    active customer. These effects would also affect new customers.

# 2 Company & data information

The company in question is an online retailer for music equipment and
related items. The data at hand gives information about daily sales of
the company for the entirety of the years 2022, 2023, 2024, and 2025.
Related information on registered customers, sale items, products,
inventory movements, and so on is also provided.

**Note:** The data used is the synthetic SQL database
`musical_retail_germany.sql` provided in my GitHub repository
[dschulz13/musical_retail_germany](https://github.com/dschulz13/musical_retail_germany).

The available data is structured as displayed in Figure
<a href="#fig:fig-struct">2.1</a>.

<div class="figure" style="text-align: center">

<img src="structure_musical_retail_germany.png" alt="An overview of the structure of the musical_retail_germany SQL database." width="80%" height="80%" />
<p class="caption">
<span id="fig:fig-struct"></span>Figure 2.1: An overview of the
structure of the musical_retail_germany SQL database.
</p>

</div>

We have the eight interconnected tables `sales`, ‘sale_items’,
`products`, `product_prices`, `customers`, `suppliers`, `inventory_in`,
and `inventory_out`.

# 3 Business questions

Given the provided data, the following six business topics with
sub-questions arise. This project aims to answer them.

1.  **Revenue & sales performance**

- How much was sold in 2025?
- How did 2025 compare with 2024?
- Is revenue growing?
- How many registered customers and conducted orders are there?
- What is the average order value?
- What is the source of the increase/decrease in revenue?

2.  **Customer health**

- How many active customers are there in 2025?
  - How many of them are new and how many are returning?
- How concentrated is revenue among customers?
- What does customer purchasing frequency look like?
- Are there high-value customer segments?
- Are customers becoming more or less valuable?

3.  **Product portfolio**

- Which categories/brands/products drive revenue?
- Which products are growing?
- Which products have poor sales?
- How concentrated is revenue among products?
- Which products are newly introduced?
- Which products have been discontinued?

4.  **Pricing**

- Which products experienced major price changes?
- What happened to sales volumes after price changes?
- Which products increased in price without losing much volume?
- Which products became cheaper but sold considerably more?
- Which brands/categories have the highest prices?

5.  **Inventory health**

- Which products are overstocked?
- Which products have very high inventory turnover?
- Which products appear to be slow-moving?
- How much capital is tied up in inventory?
- Are discontinued products still sitting in inventory?
- Which products might need replenishment?

6.  **Supplier health**

- Which suppliers provide the most products?
- Which suppliers account for the most incoming units?
- Is the company highly dependent on a small number of suppliers?
- Which suppliers serve strategically important products?
- What does the supplier base look like geographically?

# 4 Applied tools

Data manipulation and calculations are conducted with
[MySQL](https://www.mysql.com/de/). Graphics are created using
[Python](https://www.python.org/). For the report and table creation,
the R Markdown engine was used.

# 5 Procedural structure

1.  **Data cleaning**

Inconsistencies, like leading/trailing whitespace, uneven capitalization
of names, etc., were detected in selected tables. Hence, a first
cleaning step was done leading to the SQL view objects
`customers_cleaned`, `products_cleaned`, and `suppliers_cleaned`, which
can be reused for future analysis.

2.  **Sequential table creation**

Tabular results were created from the cleaned data in a sequential way
to answer the stated business questions in Section 3.

3.  **Sequential graphic creation**

Where meaningful, supporting graphics were created.

4.  **Insights & recommendations**

From the tabular and graphical outputs, insights were found to answer
the business questions in Section 3 and corresponding business
recommendations were formulated.

# 6 Detailed project results

Here, detailed answers (with tables and figures) to the business
questions in Section 3 as well as corresponding business recommendations
can be found. Results are stated by topic and business question.

## 6.1 Revenue & sales performance

### 6.1.1 How much was sold in 2025?

We derive the **total amount of sales** (total sales minus shipping
fees) for the year 2025 to be **€181,162,213.59**.

Table <a href="#tab:sales-monthly-tab">6.1</a> shows the monthly total
sales of the year 2025. The most lucrative months are hence those
leading up to Christmas, i.e. October, November and December, with
**€15,862,459.29**, **€20,654,304.18**, and **€19,996,241.47**,
respectively. Those three months together account for approx. 31.00% of
the year’s sales.

|  | January | February | March | April | May | June | July | August | September | October | November | December |
|----|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Absolute | €11,634,671.43 | €13,224,547.24 | €14,406,142.15 | €14,108,479.68 | €14,687,588.63 | €13,669,492.17 | €13,437,017.96 | €14,455,434.75 | €15,025,834.64 | €15,862,459.29 | €20,654,304.18 | €19,996,241.47 |
| Relative | 6.42% | 7.30% | 7.95% | 7.79% | 8.11% | 7.55% | 7.42% | 7.98% | 8.29% | 8.76% | 11.40% | 11.04% |

<span id="tab:sales-monthly-tab"></span>Table 6.1: Monthly total sales
(absolute and relative) of the year 2025.

### 6.1.2 How did 2025 compare with 2024?

The total sales of **€181,162,213.59** in the year 2025 is an **absolute
increase** of **€20,310,547.77** and a **relative increase** of
**12.63%** compared to the year 2024, where sales of **€160,851,665.82**
were achieved.

| Month     |     Sales 2024 |     Sales 2025 | Absolute change | Relative change |
|:----------|---------------:|---------------:|----------------:|----------------:|
| January   | €10,662,098.53 | €11,634,671.43 |     €972,572.90 |           9.12% |
| February  | €12,509,612.61 | €13,224,547.24 |     €714,934.63 |           5.72% |
| March     | €12,716,601.72 | €14,406,142.15 |   €1,689,540.43 |          13.29% |
| April     | €12,951,284.01 | €14,108,479.68 |   €1,157,195.67 |           8.93% |
| May       | €13,269,831.06 | €14,687,588.63 |   €1,417,757.57 |          10.68% |
| June      | €12,281,043.47 | €13,669,492.17 |   €1,388,448.70 |          11.31% |
| July      | €11,909,782.25 | €13,437,017.96 |   €1,527,235.71 |          12.82% |
| August    | €12,686,576.47 | €14,455,434.75 |   €1,768,858.28 |          13.94% |
| September | €13,107,929.40 | €15,025,834.64 |   €1,917,905.24 |          14.63% |
| October   | €13,674,035.81 | €15,862,459.29 |   €2,188,423.48 |          16.00% |
| November  | €17,877,541.31 | €20,654,304.18 |   €2,776,762.87 |          15.53% |
| December  | €17,205,329.18 | €19,996,241.47 |   €2,790,912.29 |          16.22% |

<span id="tab:sales-monthly-comp"></span>Table 6.2: Monthly sales
comparison between the years 2024 and 2025.

As visible from Table <a href="#tab:sales-monthly-comp">6.2</a>, all
months show an increase in 2025 compared to the corresponding month of
the previous year. The lowest increase is currently shown in January,
February and April. Conversely, the largest increases are observable in
October, November and December.

### 6.1.3 Is revenue growing?

| Month     | Change 2022 to 2023 | Change 2023 to 2024 | Change 2024 to 2025 |
|:----------|--------------------:|--------------------:|--------------------:|
| January   |               5.40% |               9.52% |               9.11% |
| February  |               9.71% |              10.35% |               5.72% |
| March     |              11.48% |               5.01% |              13.27% |
| April     |               6.70% |               7.06% |               8.93% |
| May       |               6.31% |               8.90% |              10.67% |
| June      |               6.63% |               9.29% |              11.30% |
| July      |               6.42% |              10.13% |              12.81% |
| August    |               7.20% |              11.48% |              13.94% |
| September |               7.87% |               7.08% |              14.62% |
| October   |               8.60% |              10.25% |              15.99% |
| November  |               9.28% |               9.11% |              15.52% |
| December  |               6.53% |               9.42% |              16.21% |

<span id="tab:revenue-monthly-comp"></span>Table 6.3: Yearly relative
revenue changes by month 2022 through 2025.

Following Table <a href="#tab:revenue-monthly-comp">6.3</a>, revenue
streams keep increasing over the years. While for March through
December, the rate of revenue increase has itself been increasing from
2024 to 2025, it has been declining for January and February. Further
investigation of reasons for this phenomenon is recommended.

The increase rate in revenue has most strongly risen in March between
2024 and 2025 by more than eight percentage points. Further strong
months are September through December, where the rate increased by
approx. five to seven percentage points in the year 2025.

### 6.1.4 How many registered customers and conducted orders are there?

|   2022 |   2023 |   2024 |   2025 |
|-------:|-------:|-------:|-------:|
| 16,000 | 20,500 | 25,000 | 30,000 |

<span id="tab:reg-cust-tab"></span>Table 6.4: Cumulative number of
registered customers by year.

Table <a href="#tab:reg-cust-tab">6.4</a> shows that the number of
registered customers could almost be doubled since 2022. In 2025, the
number of overall registered customers on the company’s platform is
therefore at 30,000.

|   2022 |   2023 |   2024 |   2025 |
|-------:|-------:|-------:|-------:|
| 14,463 | 18,157 | 21,908 | 26,408 |

<span id="tab:act-cust-tab"></span>Table 6.5: Number of active customers
by year.

In contrast, as can be seen from Table
<a href="#tab:act-cust-tab">6.5</a>, the amount of **active
customers** - those having placed an order at least once in the
corresponding year - is always similar yet smaller than the number of
registered customers. Overall, the share of active customers from the
registered ones for any given year seems to sit between **87.63%** and
**90.39%**, with **88.03%** in **2025**.

### 6.1.5 What is the average order value?

|      2022 |      2023 |      2024 |      2025 |
|----------:|----------:|----------:|----------:|
| €2,179.57 | €2,175.15 | €2,192.33 | €2,268.35 |

<span id="tab:tab-average-order"></span>Table 6.6: Yearly average order
value for years 2022 through 2025.

According to Table <a href="#tab:tab-average-order">6.6</a>, the yearly
average order value has been decreasing from 2022 to 2023. However,
afterwards until 2025 it kept increasing, implying that on average
customers tend to spend more money on their orders. The latest average
order value (year 2025) is **€2,268.35**.

### 6.1.6 What is the source of the increase/decrease in revenue?

|                   |   2022 |   2023 |   2024 |   2025 |
|-------------------|-------:|-------:|-------:|-------:|
| Number of orders  | 63,000 | 68,000 | 73,500 | 80,000 |
| Orders per capita |   4.36 |   3.75 |   3.35 |   3.03 |

<span id="tab:tab-num-order"></span>Table 6.7: Yearly number of orders
placed.

| Signup year | Order count | Orders per capita | Revenue | Average order value |
|:---|---:|---:|---:|---:|
| before 2025 | 72,301 | 3.23 | €164,052,186.74 | €2,269.02 |
| in 2025 | 7,699 | 1.92 | €17,415,849.65 | €2,262.09 |

<span id="tab:tab62"></span>Table 6.8: Distinction between existing and
new customers in 2025.

Table <a href="#tab:tab-num-order">6.7</a> suggests that, while the
**total number of orders** is **increasing** on the platform, the
**average number of orders per active customer** is actually
**decreasing** steadily since 2022. Considering Table
<a href="#tab:tab-average-order">6.6</a>, we conclude that each active
customer only spends €6,873.10 with the company in 2025 instead of
€7,344.31 as in 2024. Following our analysis in Section 6.1.4, we know
that the share of active customers is also not notably different from
usual in 2025 than in other years. Hence, the increase in revenue comes
mostly from the fact that the company was able to increase its number of
newly registered customers by 5,000 in 2025.

The **revenue increase** from 2024 to 2025 is **€20,331,745.00**. A
what-if analysis shows that, had the average order value stayed the same
as in 2024 but the same rise in the number of orders taken place, the
increase in number of orders would have led to an increase in revenue of
**€14,250,145.00**. On the other hand, had the number of orders stayed
at the level of 2024 but the average order value increased, the increase
in revenue would have been **€5,587,470.00**. The remaining
**€494,130.00** are cross-effects from the increase in both the number
of orders and the average order value. Hence, the number of orders is
the driving force of the revenue increase.

Table <a href="#tab:tab62">6.8</a> illustrates that the **revenue in
2025** produced by **customers registered in 2024 and before** is only
**larger by approx. €3,000,000.00** **than** the total revenue **in
2024**. For that group of customers, the order count is decreasing, as
is the amount of orders per capita. The vast share of **new revenue in
2025** comes from the **newly registered clients**, which, while they do
not order as frequently, produce roughly **€17,500,000.00** in revenue.

While it is profitable to gain many customers as fast as possible to
establish the platform as the main seller for musical equipment, such
growth may not be sustainable with a long-term perspective. It is
therefore recommended to invest more into strategies to **re-activate
existing customers** in the client database, with both the goals to
activate sleeping customers and to increase the orders per capita of
already active customers. As a suggestion, the company could run a
short-term campaign, where they offer long-term clients a discount, or
they could implement a stamp card system that leads to future discounts.
This would also have the benefit that the number of orders by newly
registered customers could be increased at the same time.

## 6.2 Customer health

### 6.2.1 How many active customers are there in 2025?

**Sub-question:** How many of them are new and how many are returning?

|          | Returning |    New |   Total |
|----------|----------:|-------:|--------:|
| Absolute |    20,789 |  5,619 |  26,408 |
| Relative |    78.72% | 21.28% | 100.00% |

<span id="tab:tab7"></span>Table 6.9: New and returning customers in
2025.

<a href="#tab:tab7">6.9</a> highlights that in the **year 2025**, the
company has **26,408 active customers**, i.e. customers who did at least
one purchase with the company. Given that a new customer is a customer
doing the very first purchase with the company (not the registration on
the platform), we see that there are **5,619 new active customers**
(**21.28%**) and **20,789 returning active customers** (**78.72%**).

### 6.2.2 How concentrated is revenue among customers?

| Revenue interval    | Customer count | Relative |
|:--------------------|---------------:|---------:|
| \[€0, €5,000)       |         13,044 |   49.39% |
| \[€5,000, €10,000)  |          6,952 |   26.33% |
| \[€10,000, €15,000) |          3,584 |   13.57% |
| \[€15,000, €20,000) |          1,555 |    5.89% |
| \[€20,000, €25,000) |            687 |    2.60% |
| \[€25,000, €30,000) |            331 |    1.25% |
| \[€30,000, €35,000) |            129 |    0.49% |
| \[€35,000, €40,000) |             64 |    0.24% |
| \[€40,000, €45,000) |             25 |    0.09% |
| \[€45,000, €50,000) |             16 |    0.06% |
| \[€50,000, €55,000) |             11 |    0.04% |
| \[€55,000, €60,000) |              4 |    0.02% |
| \[€60,000, €65,000) |              2 |    0.01% |
| \[€65,000, €70,000) |              3 |    0.01% |
| \[€70,000, €75,000) |              1 |    0.00% |

<span id="tab:tab8"></span>Table 6.10: Active customer counts in 2025 by
revenue in 2025.

The distribution of revenue in 2025 by revenue interval is displayed in
Table <a href="#tab:tab8">6.10</a>. Therein, only active customers in
2025 were considered. The **distribution** is **highly skewed**. Almost
**50%** of active customers contribute in a smaller revenue range
**between €0.00 and €4,999.99**. About **75%** of customers spend
between **€0.00 and €9,999.99**. Only **0.08%** of customers spend at
least **€50,000.00**.

### 6.2.3 What does customer purchasing frequency look like?

| Days since last purchase | Order count | Relative |
|:-------------------------|------------:|---------:|
| between 0 and 99         |      45,764 |   61.87% |
| between 100 and 199      |      15,780 |   21.33% |
| between 200 and 299      |       6,665 |    9.01% |
| between 300 and 399      |       3,076 |    4.16% |
| between 400 and 499      |       1,393 |    1.88% |
| between 500 and 599      |         677 |    0.92% |
| between 600 and 699      |         305 |    0.41% |
| between 700 and 799      |         155 |    0.21% |
| between 800 and 899      |          72 |    0.10% |
| between 900 and 999      |          48 |    0.06% |
| between 1000 and 1099    |          25 |    0.03% |
| between 1100 and 1199    |           9 |    0.01% |
| between 1200 and 1299    |           1 |    0.00% |
| between 1300 and 1399    |           2 |    0.00% |

<span id="tab:tab9"></span>Table 6.11: Order counts in 2025 by days
since last purchase.

In 2025, **61.87%** of orders were done **within 99 days** of the
previous purchase, **83.2%** **within 199 days**. About **3.62%** of
orders took place more than a year after their previous orders. **37**
customers waited **at least 1,000 days** before they did another
purchase in 2025. Overall, the purchase frequency is heavily skewed.

### 6.2.4 Are there high-value customer segments?

| Customer ID | Total revenue | Relative revenue | Order count | Average revenue per order | Customer type | Days since last purchase | Days since first purchase | Product categories |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 13597 | €73,936.02 | 0.04% | 19 | €3,891.37 | business | 34.43 | 1,283.34 | 9 |
| 7188 | €68,869.68 | 0.04% | 22 | €3,130.44 | business | 2.54 | 1,427.33 | 8 |
| 10773 | €68,352.92 | 0.04% | 17 | €4,020.76 | business | 16.43 | 1,442.57 | 9 |
| 21762 | €68,133.97 | 0.04% | 22 | €3,097.00 | business | 4.45 | 591.21 | 9 |
| 8195 | €62,537.72 | 0.03% | 19 | €3,291.46 | business | 6.36 | 1,399.58 | 9 |
| 2490 | €60,087.47 | 0.03% | 19 | €3,162.50 | business | 25.55 | 1,430.33 | 9 |
| 6827 | €59,359.82 | 0.03% | 19 | €3,124.20 | business | 43.56 | 1,450.29 | 9 |
| 6671 | €57,768.30 | 0.03% | 16 | €3,610.52 | business | 69.53 | 1,412.60 | 8 |
| 9104 | €57,288.53 | 0.03% | 10 | €5,728.85 | business | 10.21 | 1,452.39 | 9 |
| 3633 | €55,129.13 | 0.03% | 11 | €5,011.74 | business | 37.59 | 1,432.21 | 7 |
| 1313 | €53,967.22 | 0.03% | 19 | €2,840.38 | business | 3.30 | 1,451.49 | 9 |
| 24930 | €53,718.34 | 0.03% | 19 | €2,827.28 | business | 1.41 | 347.43 | 9 |
| 6300 | €53,535.55 | 0.03% | 22 | €2,433.43 | business | 14.36 | 1,432.35 | 9 |
| 12403 | €52,805.53 | 0.03% | 17 | €3,106.21 | business | 32.46 | 1,377.31 | 8 |
| 19151 | €52,045.45 | 0.03% | 11 | €4,731.40 | business | 7.37 | 816.28 | 8 |
| 5387 | €51,136.08 | 0.03% | 27 | €1,893.93 | business | 4.45 | 1,427.28 | 9 |
| 24902 | €50,688.00 | 0.03% | 13 | €3,899.08 | business | 42.45 | 350.60 | 9 |
| 3092 | €50,628.83 | 0.03% | 21 | €2,410.90 | business | 9.22 | 1,458.44 | 9 |
| 8579 | €50,591.70 | 0.03% | 17 | €2,975.98 | business | 1.36 | 1,422.55 | 9 |
| 9543 | €50,522.10 | 0.03% | 13 | €3,886.32 | business | 6.32 | 1,433.34 | 8 |

<span id="tab:tab10"></span>Table 6.12: Top-customers in 2025 by
revenue.

Table <a href="#tab:tab10">6.12</a> shows a few characteristics of the
top 20 customers in 2025 by the total amount of revenue generated by
them. The most profitable clients seem to be business clients, who
purchase somewhat frequently and from various product categories. As can
also be noted, they are usually long-time customers for more than 1,000
days. Each of them contributes with 0.03% to 0.04% to the overall
revenue generated by the company in 2025. Therefore, there is no
individual customer dominating the revenue. More interestingly, we could
take a look at the best private clients. To actually define different
customer segments, we may use unsupervised techniques such as K-means
clustering, which are, however, beyond the scope of this SQL-driven
project.

### 6.2.5 Are customers becoming more or less valuable?
