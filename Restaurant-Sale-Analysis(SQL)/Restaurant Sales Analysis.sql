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
