-- ============================================================
-- Pizza Sales SQL Analysis
-- Database: MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS pizza_sales_db;
USE pizza_sales_db;

-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS pizza_types;

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_pizzas_type
        FOREIGN KEY (pizza_type_id)
        REFERENCES pizza_types(pizza_type_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_order_details_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_details_pizza
        FOREIGN KEY (pizza_id)
        REFERENCES pizzas(pizza_id)
);

-- ============================================================
-- 2. LOAD CSV DATA
-- ============================================================
-- Place the four CSV files in the same folder structure as the
-- GitHub repository before running these commands.
--
-- LOCAL INFILE may need to be enabled in MySQL Workbench/server.
-- If LOCAL INFILE is disabled, import the CSV files through
-- MySQL Workbench's Table Data Import Wizard instead.

LOAD DATA LOCAL INFILE 'data/pizza_types.csv'
INTO TABLE pizza_types
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pizza_type_id, name, category, ingredients);

LOAD DATA LOCAL INFILE 'data/pizzas.csv'
INTO TABLE pizzas
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pizza_id, pizza_type_id, size, price);

LOAD DATA LOCAL INFILE 'data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, date, time);

LOAD DATA LOCAL INFILE 'data/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_details_id, order_id, pizza_id, quantity);

-- ============================================================
-- 3. BASIC ANALYSIS
-- ============================================================

-- Q1. Total number of orders placed
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- Q2. Total revenue generated from pizza sales
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;


-- Q3. Highest-priced pizza
SELECT
    p.pizza_id,
    pt.name AS pizza_name,
    p.size,
    p.price
FROM pizzas p
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;


-- Q4. Most common pizza size ordered
-- "Most common" is measured by total quantity ordered.
SELECT
    p.size,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC
LIMIT 1;


-- Q5. Top 5 most ordered pizza types by quantity
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;


-- ============================================================
-- 4. INTERMEDIATE ANALYSIS
-- ============================================================

-- Q6. Total quantity of each pizza category ordered
SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;


-- Q7. Distribution of orders by hour of the day
SELECT
    HOUR(time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY HOUR(time)
ORDER BY order_hour;


-- Q8. Category-wise distribution of pizzas ordered
-- Distribution is measured by quantity of pizzas sold.
SELECT
    pt.category,
    SUM(od.quantity) AS pizzas_sold,
    ROUND(
        100.0 * SUM(od.quantity)
        / (SELECT SUM(quantity) FROM order_details),
        2
    ) AS percentage_of_total
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY pizzas_sold DESC;


-- Q9. Average number of pizzas ordered per day
WITH daily_sales AS (
    SELECT
        o.date,
        SUM(od.quantity) AS pizzas_ordered
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    GROUP BY o.date
)
SELECT
    ROUND(AVG(pizzas_ordered), 2) AS average_pizzas_per_day
FROM daily_sales;


-- Q10. Top 3 pizza types based on revenue
SELECT
    pt.name AS pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


-- ============================================================
-- 5. ADVANCED ANALYSIS
-- ============================================================

-- Q11. Percentage contribution of each pizza type to total revenue
WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)
SELECT
    pizza_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100.0 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM pizza_revenue
ORDER BY revenue DESC;


-- Q12. Cumulative revenue generated over time
WITH daily_revenue AS (
    SELECT
        o.date,
        SUM(od.quantity * p.price) AS daily_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    GROUP BY o.date
)
SELECT
    date,
    ROUND(daily_revenue, 2) AS daily_revenue,
    ROUND(
        SUM(daily_revenue) OVER (
            ORDER BY date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM daily_revenue
ORDER BY date;


-- Q13. Top 3 pizza types by revenue within each pizza category
WITH pizza_revenue AS (
    SELECT
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
),
ranked_pizzas AS (
    SELECT
        category,
        pizza_name,
        revenue,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM pizza_revenue
)
SELECT
    category,
    pizza_name,
    ROUND(revenue, 2) AS revenue,
    revenue_rank
FROM ranked_pizzas
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank, revenue DESC;


-- ============================================================
-- END OF PROJECT
-- ============================================================
