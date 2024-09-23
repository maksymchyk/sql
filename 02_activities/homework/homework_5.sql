-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.

HINT: Be sure you select only relevant columns and rows. 
Remember, CROSS JOIN will explode your table rows, so CROSS JOIN should likely be a subquery. 
Think a bit about the row counts: how many distinct vendors, product names are there (x)?
How many customers are there (y). 
Before your final group by you should have the product of those two queries (x*y).  */
-- Step 1: Get all vendor-product combinations with the original price
WITH vendor_products AS (
  SELECT 
    v.vendor_name,
    p.product_name,
    COALESCE(vi.original_price, 0) AS original_price
  FROM vendor v
  CROSS JOIN product p
  LEFT JOIN vendor_inventory vi 
    ON v.vendor_id = vi.vendor_id 
    AND p.product_id = vi.product_id
),

-- Step 2: Get the total number of customers
customer_count AS (
  SELECT COUNT(*) AS num_customers
  FROM customer
)

-- Step 3: Calculate potential revenue for each vendor-product combination
SELECT 
  vp.vendor_name,
  vp.product_name,
  SUM(vp.original_price * 5 * cc.num_customers) AS total_revenue_per_product
FROM vendor_products vp
CROSS JOIN customer_count cc
GROUP BY vp.vendor_name, vp.product_name;


-- INSERT
/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */
-- Step 1: Create the new table with the structure from the product table and an additional timestamp column
CREATE TABLE product_units AS
SELECT 
    product *,                            -- Select all columns from the product table
    CURRENT_TIMESTAMP AS snapshot_timestamp  -- Add a new column for the current timestamp
FROM 
    product p
WHERE 
    p.product_qty_type = 'unit';     -- Filter rows where the product quantity type is 'unit'


/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

INSERT INTO product_units (product_id, product_name, product_size, product_category_id, product_qty_type, snapshot_timestamp)
VALUES (123, 'Apple Pie', '10"', '3', 'unit', CURRENT_TIMESTAMP);
SELECT * FROM product_units;

-- DELETE
/* 1. Delete the older record for the whatever product you added. 

HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/

SELECT * FROM product_units
WHERE product_name = 'Apple Pie'
ORDER BY snapshot_timestamp;

DELETE FROM product_units
WHERE product_name = 'Apple Pie'
AND snapshot_timestamp = (
    SELECT MIN(snapshot_timestamp)
    FROM product_units
    WHERE product_name = 'Apple Pie'

-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.*/

ALTER TABLE product_units
ADD current_quantity INT;

/*Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.

HINT: This one is pretty hard. 
First, determine how to get the "last" quantity per product. 
Second, coalesce null values to 0 (if you don't have null values, figure out how to rearrange your query so you do.) 
Third, SET current_quantity = (...your select statement...), remembering that WHERE can only accommodate one column. 
Finally, make sure you have a WHERE statement to update the right row, 
	you'll need to use product_units.product_id to refer to the correct row within the product_units table. 
When you have all of these components, you can run the update statement. */

UPDATE product_units
SET current_quantity = COALESCE(
    (SELECT vi.quantity
     FROM vendor_inventory vi
     WHERE vi.product_id = product_units.product_id
     AND vi.vendor_id = (SELECT vendor_id
                         FROM vendor_inventory vi2
                         WHERE vi2.product_id = product_units.product_id
                         ORDER BY vi2.market_date DESC
                         LIMIT 1)  -- Get the most recent vendor for the product
     ORDER BY vi.market_date DESC
     LIMIT 1), 0)  -- Default to 0 if no quantity found
WHERE EXISTS (
    SELECT 1
    FROM vendor_inventory vi
    WHERE vi.product_id = product_units.product_id
);
