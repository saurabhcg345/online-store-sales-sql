-- =====================================
-- ONLINE STORE SALES ANALYSIS
-- Database: MySQL
-- =====================================

CREATE DATABASE IF NOT EXISTS online_store_analysis;

USE online_store_analysis;

--Section 1: Basic SQL queries (Q1–Q10)
USE online_store_analysis;

-- Q1. Display all customers
SELECT * FROM customers;


-- Q2. Display all orders
SELECT * FROM orders;


-- Q3. Count total customers
SELECT COUNT(*) AS total_customers
FROM customers;


-- Q4. Count total orders
SELECT COUNT(*) AS total_orders
FROM orders;


-- Q5. Display customer names and cities
SELECT customer_name, city
FROM customers;


-- Q6. Find customers from Pune
SELECT *
FROM customers
WHERE city = 'Pune';


-- Q7. Find customers older than 30
SELECT *
FROM customers
WHERE age > 30;


-- Q8. Display unique cities
SELECT DISTINCT city
FROM customers;


-- Q9. Display orders above ₹10,000
SELECT *
FROM orders
WHERE amount > 10000;


-- Q10. Display the five highest-value orders
SELECT *
FROM orders
ORDER BY amount DESC
LIMIT 5;

--Section 2: Aggregate functions (Q11–Q20)
-- Q11. Calculate total revenue
SELECT SUM(amount) AS total_revenue
FROM orders;


-- Q12. Calculate average order value
SELECT AVG(amount) AS average_order_value
FROM orders;


-- Q13. Find the highest order amount
SELECT MAX(amount) AS highest_order
FROM orders;


-- Q14. Find the lowest order amount
SELECT MIN(amount) AS lowest_order
FROM orders;


-- Q15. Calculate total quantity sold
SELECT SUM(quantity) AS total_quantity_sold
FROM orders;


-- Q16. Calculate revenue by product
SELECT
    product,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY product
ORDER BY total_revenue DESC;


-- Q17. Count orders by product
SELECT
    product,
    COUNT(*) AS total_orders
FROM orders
GROUP BY product
ORDER BY total_orders DESC;


-- Q18. Calculate revenue by city
SELECT
    c.city,
    SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- Q19. Count customers by city
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;


-- Q20. Find cities with more than two customers
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 2;

--Section 3: JOINs and customer analysis (Q21–Q30)
-- Q21. Display customer names with their orders
SELECT
    c.customer_name,
    o.order_id,
    o.product,
    o.amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- Q22. Display all customers, including those without orders
SELECT
    c.customer_name,
    o.order_id,
    o.product
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;


-- Q23. Find customers who have never placed an order
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q24. Count orders placed by each customer
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC;


-- Q25. Find customers who placed more than one order
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;


-- Q26. Calculate total spending by each customer
SELECT
    c.customer_name,
    SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;


-- Q27. Find the highest-spending customer
SELECT
    c.customer_name,
    SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 1;


-- Q28. Find the most frequently purchased product
SELECT
    product,
    COUNT(*) AS order_count
FROM orders
GROUP BY product
ORDER BY order_count DESC
LIMIT 1;


-- Q29. Find customers whose total spending exceeds ₹50,000
SELECT
    c.customer_name,
    SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.amount) > 50000;


-- Q30. Find average spending by city
SELECT
    c.city,
    AVG(o.amount) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY average_order_value DESC;

--Section 4: Advanced SQL (Q31–Q40)
-- Q31. Find orders above the average order amount
SELECT *
FROM orders
WHERE amount > (
    SELECT AVG(amount)
    FROM orders
);


-- Q32. Find customers who have placed an order for a Laptop
SELECT DISTINCT
    c.customer_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.product = 'Laptop';


-- Q33. Find the second-highest order amount
SELECT MAX(amount) AS second_highest_order
FROM orders
WHERE amount < (
    SELECT MAX(amount)
    FROM orders
);


-- Q34. Rank orders by amount
SELECT
    order_id,
    product,
    amount,
    RANK() OVER (
        ORDER BY amount DESC
    ) AS order_rank
FROM orders;


-- Q35. Rank customers by total spending
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.amount) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spending,
    DENSE_RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM CustomerSpending;


-- Q36. Calculate monthly revenue
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(amount) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- Q37. Classify orders based on their amount
SELECT
    order_id,
    product,
    amount,
    CASE
        WHEN amount >= 50000 THEN 'High Value'
        WHEN amount >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_category
FROM orders;


-- Q38. Find customers whose spending is above average customer spending
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.amount) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM CustomerSpending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM CustomerSpending
);


-- Q39. Calculate running total of revenue
SELECT
    order_id,
    order_date,
    amount,
    SUM(amount) OVER (
        ORDER BY order_date, order_id
    ) AS running_revenue
FROM orders;


-- Q40. Create a view for customer sales summary
CREATE OR REPLACE VIEW customer_sales_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_spending
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city;


-- Display the view
SELECT *
FROM customer_sales_summary;

