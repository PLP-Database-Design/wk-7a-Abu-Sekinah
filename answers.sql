-- To achieve 1NF, we will normalize the table so that each order contains one product.
-- We'll need to insert each product into its own row.

-- Assuming we have the original table `ProductDetail`
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8) n
  ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY OrderID;



-- First, create a table for storing Customer Information.
CREATE TABLE CustomerDetails (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert data into CustomerDetails table, capturing each unique customer by OrderID.
INSERT INTO CustomerDetails (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Now, create the OrderDetails table, removing the CustomerName field from it.
CREATE TABLE OrderDetailsNormalized (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES CustomerDetails(OrderID)
);

-- Insert data into the normalized OrderDetails table (without CustomerName column).
INSERT INTO OrderDetailsNormalized (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
