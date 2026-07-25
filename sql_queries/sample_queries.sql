-- SELECT * FROM public.departments
-- ORDER BY department_id ASC LIMIT 100


SELECT * FROM public.order_items LIMIT 10;

SELECT COUNT(order_item_id) FROM public.order_items;
-- -- SELECT COUNT(DISTINCT *) FROM public.order_items; -- is invalid SQL

-- -- -- Count on all the columns -- -- -- 
SELECT COUNT(*) FROM departments;

SELECT COUNT(*) FROM categories;

SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM order_items;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

