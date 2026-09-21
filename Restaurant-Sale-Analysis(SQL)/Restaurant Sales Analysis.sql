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
