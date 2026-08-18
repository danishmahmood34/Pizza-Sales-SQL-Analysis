# 🍕 Pizza Sales SQL Analysis

## 📌 Project Overview

This project analyzes pizza sales data using **MySQL** to uncover sales trends, revenue performance, customer ordering patterns, and product performance.

The analysis uses multiple related tables containing order information, pizza details, pizza categories, prices, and quantities.

The goal is to answer important business questions and demonstrate practical SQL skills used in a Data Analyst role.

---

## 🎯 Business Objectives

The analysis focuses on answering questions such as:

* How many orders were placed?
* How much total revenue was generated?
* Which pizzas are the most popular?
* Which pizza sizes are ordered most frequently?
* Which pizza categories generate the most sales?
* What are the busiest ordering hours?
* Which pizzas generate the highest revenue?
* What percentage of revenue does each pizza contribute?
* How does cumulative revenue change over time?
* Which pizzas perform best within each category?

---

## 🗂️ Dataset

The project contains four CSV files:

| Table           | Description                                      |
| --------------- | ------------------------------------------------ |
| `orders`        | Contains order date and time information         |
| `order_details` | Contains pizza orders and quantities             |
| `pizzas`        | Contains pizza size and price information        |
| `pizza_types`   | Contains pizza names, categories and ingredients |

### Database Relationships

```text
orders
   │
   │ order_id
   ▼
order_details
   │
   │ pizza_id
   ▼
pizzas
   │
   │ pizza_type_id
   ▼
pizza_types
```

---

## 🛠️ Tools & Technologies

* **MySQL**
* SQL
* MySQL Workbench
* GitHub
* CSV

### SQL Concepts Used

* SELECT
* WHERE
* GROUP BY
* ORDER BY
* JOIN
* Aggregate Functions
* CASE Statements
* Common Table Expressions (CTEs)
* Subqueries
* Window Functions
* DENSE_RANK()
* SUM() OVER()
* Date & Time Functions
* Percentage Calculations

---

# 📊 Analysis

## 1. Basic Analysis

The following questions were answered:

1. Total number of orders placed
2. Total revenue generated
3. Highest-priced pizza
4. Most common pizza size ordered
5. Top 5 most ordered pizza types

---

## 2. Intermediate Analysis

The analysis also covers:

1. Total quantity of pizzas ordered by category
2. Distribution of orders by hour
3. Percentage distribution of pizzas by category
4. Average number of pizzas ordered per day
5. Top 3 pizza types based on revenue

---

## 3. Advanced Analysis

Advanced SQL techniques were used to calculate:

1. Percentage contribution of each pizza type to total revenue
2. Cumulative revenue over time
3. Top 3 revenue-generating pizzas within each category

---

# 💡 Key Insights

The analysis can help identify:

* Best-selling pizza products
* Highest-performing pizza categories
* Most popular pizza sizes
* Peak ordering hours
* Revenue-generating products
* Product contribution to overall revenue
* Top-performing products within individual categories
* Revenue growth patterns over time

These insights can support decisions around **product promotion, inventory planning, pricing and sales strategy**.

---

# 📁 Project Structure

```text
Pizza-Sales-SQL-Analysis/
│
├── README.md
│
├── data/
│   ├── orders.csv
│   ├── order_details.csv
│   ├── pizza_types.csv
│   └── pizzas.csv
│
└── sql/
    └── pizza_sales_analysis.sql
```

---

# 🚀 How to Use This Project

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/Pizza-Sales-SQL-Analysis.git
```

### 2. Open MySQL Workbench

Create or connect to your MySQL database.

### 3. Open the SQL file

Open:

```text
sql/pizza_sales_analysis.sql
```

### 4. Import the CSV files

Load the four datasets from the `data` folder into the corresponding MySQL tables.

### 5. Run the analysis queries

Execute the queries in the SQL file to reproduce the analysis.

---

# 📈 Skills Demonstrated

This project demonstrates my ability to:

* Work with relational datasets
* Write SQL queries for business analysis
* Combine multiple tables using JOINs
* Calculate business KPIs
* Analyze sales and revenue trends
* Use CTEs for complex analysis
* Apply SQL window functions
* Rank products within categories
* Translate business questions into SQL solutions

---

## 👨‍💻 About Me

I'm an aspiring **Data Analyst** with hands-on experience in SQL, Power BI, Excel and Python.

I'm continuously building practical projects to strengthen my analytical and problem-solving skills.

### 🔗 Connect With Me

* LinkedIn: https://www.linkedin.com/in/danish-mahmood-bansberia/
* GitHub: https://github.com/danishmahmood34

---

⭐ If you found this project useful, feel free to explore the repository and check out my other data analytics projects.
