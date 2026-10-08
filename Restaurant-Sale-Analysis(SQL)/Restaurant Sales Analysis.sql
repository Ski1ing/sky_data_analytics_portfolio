/*RESTAURANT SALES ANALYSIS USING SQL*/

/*Question1: How many unique orders were placed?*/
SELECT 
	COUNT(DISTINCT order_id) AS total_orders
FROM
	order_details;

/*Question2: How many order-detail records are there?*/
SELECT 
	COUNT(order_details_id) AS total_order_details
FROM
	order_details;
    
/*Question3: How many different menu items were ordered?*/
SELECT 
	COUNT(DISTINCT item_id) AS unique_item_ordered
FROM
	order_details;
    
/*Question4: What is the total number of items ordered?*/
SELECT 
	COUNT(item_id) AS total_items_ordered
FROM
	order_details;

/*Question5: How many menu items are in each category?*/
SELECT 
	category, COUNT(menu_item_id) AS items_per_category
FROM 
	menu_items
GROUP BY 
	category;
    
/*Question6: What is the average price of menu items in each category?*/
SELECT
	category, ROUND(AVG(price), 2) AS average_price
FROM
	menu_items
GROUP BY
	category;
    
/*Question7: What are the most expensive menu items?*/
SELECT 
	item_name, category, price
FROM
	menu_items
ORDER BY
	price DESC
limit
	5;
    
/*Question8: What are the least expensive menu items?*/
SELECT 
	item_name, category, price
FROM
	menu_items
ORDER BY
	price ASC
limit
	5;
    
/*Question9: Which menu items were ordered the most?*/
SELECT
	menu_items.item_name, 
    COUNT(order_details.item_id) AS item_count, 
    menu_items.price
FROM
	order_details
JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id
GROUP BY
	menu_items.item_name,
    menu_items.price
ORDER BY
	item_count DESC
LIMIT
	5;

/*Question10: Which menu items generated the most revenue?*/
SELECT
	menu_items.item_name,
    COUNT(order_details.item_id) AS times_ordered,
    menu_items.price,
	SUM(menu_items.price) AS total_revenue
FROM 
	order_details
JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id
GROUP BY 
	menu_items.item_name,
    menu_items.price
ORDER BY
	total_revenue DESC
LIMIT 
	5;
    
/*Question11: Which menu categories generated the most revenue?*/
SELECT
	menu_items.category,
    COUNT(order_details.item_id) AS times_ordered,
	SUM(menu_items.price) AS total_revenue
FROM
	menu_items
JOIN order_details
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.category
ORDER BY
	total_revenue DESC;
	
/*Question12: What are the top 10 menu items by revenue?*/
SELECT
	menu_items.item_name,
    COUNT(order_details.item_id) AS times_ordered,
    SUM(menu_items.price) AS total_revenue
FROM
	menu_items
JOIN order_details
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.item_name,
    menu_items.menu_item_id
ORDER BY
	total_revenue DESC
LIMIT 10;

/*Question13: What percentage of total revenue does each category contribute?*/
SELECT
	menu_items.category,
    SUM(menu_items.price) AS total_revenue,
    ROUND(
		SUM(menu_items.price) / 
        (SELECT SUM(menu_items.price)
         FROM menu_items
         JOIN order_details
         ON menu_items.menu_item_id = order_details.item_id) 
         * 100, 2) AS revenue_percentage
FROM 
	menu_items
JOIN order_details
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.category
ORDER BY
	total_revenue DESC;

/*Question14: Which date had the most orders?*/
SELECT
	order_date,
    COUNT(order_date) AS total_orders
FROM
	order_details
GROUP BY
	order_date
ORDER BY
	total_orders DESC
LIMIT 1;

/*Question15: Which date generated the most revenue?*/
SELECT 
	order_date,
    SUM(menu_items.price) AS total_revenue
FROM 
	order_details
JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id
GROUP BY 
	order_date
ORDER BY 
	total_revenue DESC
LIMIT 1;

/*Question16: Which hour of the day had the most orders?*/
SELECT 
	HOUR(order_time) AS order_hour,
    COUNT(order_id) AS total_orders
FROM
	order_details
GROUP BY 	
	order_hour
ORDER BY
	total_orders DESC
LIMIT 1;

/*Question17: Which hour of the the day generated the most revenue?*/
SELECT
	HOUR(order_time) AS order_hour,
    SUM(menu_items.price) AS total_revenue
FROM
	order_details
JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id
GROUP BY 
	order_hour
ORDER BY 
	total_revenue DESC
LIMIT 1;

/*Question18: How does revenue vary by day?*/
SELECT
	DAYNAME(order_date) AS day_of_week,
    SUM(menu_items.price) AS total_revenue
FROM
	order_details
JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id
GROUP BY
	day_of_week
ORDER BY 
	total_revenue DESC;
    
/*Question19: What are the top 3 highest-revenue in each item category?*/
WITH item_revenue AS (
SELECT
	menu_items.category,
    menu_items.item_name,
    SUM(menu_items.price) AS total_revenue
FROM 
	menu_items
JOIN order_details
	ON menu_items.menu_item_id = order_details.item_id
GROUP BY 
	menu_items.item_name,
    menu_items.category
),
ranked_items AS (
	SELECT
		category,
        item_name,
        total_revenue,
        ROW_NUMBER() OVER (
			PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS revenue_rank
	FROM item_revenue
)
SELECT
	category,
    item_name,
    total_revenue,
    revenue_rank
FROM 
	ranked_items
WHERE
	revenue_rank <= 3
ORDER BY 
	category,
    revenue_rank;

/*Question20: What is the average revenue generated per order?*/
SELECT
    ROUND(AVG(order_revenue), 2) AS average_revenue_per_order 
FROM (
	SELECT
		order_details.order_id,
        SUM(menu_items.price) AS order_revenue
	FROM 
		order_details
	JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id
	GROUP BY 
		order_details.order_id
) AS order_totals;
