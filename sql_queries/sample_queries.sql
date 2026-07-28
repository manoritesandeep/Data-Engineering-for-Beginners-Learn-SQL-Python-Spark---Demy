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
SELECT order_item_order_id
, round(sum(order_item_subtotal)::numeric , 2) AS order_revenue
FROM order_items
GROUP BY 1
HAVING round(sum(order_item_subtotal)::numeric , 2) >= 2000
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
SELECT 
	o.order_date
	, oi.order_item_product_id
	, ROUND(SUM(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
CREATE OR REPLACE VIEW order_details_v AS 
SELECT 
	o.*
	, oi.order_item_product_id
	,oi.order_item_subtotal
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_item_order_id;

SELECT * FROM order_details_v;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- CTAS
CREATE TABLE orders_stg
AS
SELECT * FROM orders WHERE false;

CREATE TABLE daily_revenue
AS
SELECT o.order_date,
	ROUND(SUM(oi.order_item_subtotal)::numeric, 2) AS order_revenue
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1;

SELECT * FROM daily_revenue;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
EXPLAIN 
SELECT * FROM orders WHERE order_id=2;

EXPLAIN 
SELECT o.*
	, ROUND(SUM(oi.order_item_subtotal)::numeric ,2) as revenue
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_item_order_id
WHERE o.order_id = 2
GROUP BY o.order_id, o.order_date, o.order_customer_id, o.order_status;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Stored procedure to run query many times (1000 in this case) to 
-- analyze execution speed
CREATE OR REPLACE PROCEDURE perfdemo()
LANGUAGE plpgsql
AS $$
DECLARE
	cur_order_details CURSOR (a_customer_id INT) FOR
		SELECT COUNT(*)
		FROM orders AS o
			JOIN order_items AS oi
				ON o.order_id = oi.order_item_order_id
		WHERE o.order_customer_id = a_customer_id;
	v_customer_id INT := 0;
	v_order_item_count INT;
BEGIN
	LOOP
		EXIT WHEN v_customer_id >= 1000;
		OPEN cur_order_details(v_customer_id);
		FETCH cur_order_details INTO v_order_item_count;
		v_customer_id = v_customer_id + 1;
		CLOSE cur_order_details;
	END LOOP;
END;
$$;

DO $$
BEGIN
	CALL perfdemo();
END;
$$;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

DROP INDEX orders_order_date_idx;
DROP INDEX order_items_oid_idx;

COMMIT;

ALTER TABLE order_items ADD
	FOREIGN KEY (order_item_order_id) REFERENCES orders (order_id);

ALTER TABLE orders ADD
	FOREIGN KEY (order_customer_id) REFERENCES customers (customer_id);

-- -- ADD back index for performance optimisation
CREATE INDEX orders_order_customer_id_idx
ON orders (order_customer_id);

CREATE INDEX order_items_order_item_order_id_idx
ON order_items (order_item_order_id);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 






-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 






-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 









-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 







-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 






-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 





-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 