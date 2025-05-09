Create Database restaurant;
Use restaurant; 

-- Creates the Customer table
CREATE TABLE Customer (
    custid INT PRIMARY KEY,
    cust_firstname VARCHAR(50) NOT NULL,
    cust_lastname VARCHAR(50) NOT NULL
);

SELECT * FROM restaurant.customer;
-- Insert values into the Customer table
INSERT INTO Customer (custid, cust_firstname, cust_lastname)
VALUES
    (1, 'John', 'Soda'),
    (2, 'Jane', 'Smith'),
    (3, 'Michael', 'Johnson'),
    (4, 'Emily', 'Brown'),
    (5, 'Robert', 'Wilson');

-- Create the Cashier table
CREATE TABLE Cashier (
    cashier_id INT PRIMARY KEY,
    cashier_name VARCHAR(50) NOT NULL,
    hourly_wage DECIMAL(10, 2) NOT NULL
);

SELECT * FROM restaurant.cashier; 
-- Insert values into the Cashier table
INSERT INTO Cashier (cashier_id, cashier_name, hourly_wage)
VALUES
    (1, 'Jay', 10),
    (2, 'Samuel', 10.25),
    (3, 'Noel', 11),
    (4, 'Jill', 10.25),
    (5, 'Philip', 12);

-- Create the Address table
CREATE TABLE Address (
    address_id INT PRIMARY KEY,
    delivery_address1 VARCHAR(200) NOT NULL,
    delivery_address2 VARCHAR(200),
    delivery_city VARCHAR(50) NOT NULL,
    delivery_eircode VARCHAR(10) NOT NULL
);

SELECT * FROM restaurant.address;
-- Insert values into the Address table
INSERT INTO Address (address_id, delivery_address1, delivery_address2, delivery_city, delivery_eircode)
VALUES
    (1, '123 Main Street', NULL, 'City A', 'EIR123'),
    (2, '456 Elm Street', 'Apt 101', 'City B', 'EIR456'),
    (3, '789 Oak Street', NULL, 'City C', 'EIR789'),
    (4, '321 Pine Street', 'Suite 5', 'City D', 'EIR321'),
    (5, '654 Birch Street', 'Apt 202', 'City E', 'EIR654');

-- Create the Item table
CREATE TABLE Item (
    itemID INT PRIMARY KEY,
    cashier_id INT NOT NULL,
    custid INT NOT NULL,
    address_id INT NOT NULL,
    totalcost decimal(5, 2) NOT NULL,
    FOREIGN KEY (cashier_id) REFERENCES Cashier(cashier_id),
    FOREIGN KEY (custid) REFERENCES Customer(custid),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

SELECT * FROM restaurant.item;
-- Insert values into the Item table
INSERT INTO Item (itemID, cashier_id, custid, address_id, totalcost)
VALUES
    (1, 3, 1, 1, 25.50),
    (2, 1, 2, 2, 30.75),
    (3, 1, 3, 3, 18.90),
    (4, 2, 4, 4, 42.25),
    (5, 1, 5, 5, 22.60);

-- Create the Mealone table
CREATE TABLE Mealone (
    itemID INT PRIMARY KEY,
    Fruit_Cocktail VARCHAR(50),
    FOREIGN KEY (itemID) REFERENCES Item(itemID)
);

SELECT * FROM restaurant.mealone;
-- Insert values into the Mealone table
INSERT INTO Mealone (itemID, Fruit_Cocktail)
VALUES
    (1, 'Tropical Fruit Cocktail'),
    (2, 'Mixed Berry Cocktail'),
    (3, 'Pineapple and Mango Cocktail'),
    (4, 'Exotic Fruit Delight'),
    (5, 'Watermelon and Cantaloupe');


-- Create the Mealtwo table
CREATE TABLE Mealtwo (
    itemID INT PRIMARY KEY,
    Fruits VARCHAR(50),
    FOREIGN KEY (itemID) REFERENCES Item(itemID)
);

SELECT * FROM restaurant.mealtwo;
-- Insert values into the Mealtwo table
INSERT INTO Mealtwo (itemID, Fruits)
VALUES
    (1, 'Tropical Fruit Cocktail'),
    (2, 'Strawberries and Kiwi'),
    (3, 'Bananas and Grapes'),
    (4, 'Watermelon and Cantaloupe'),
    (5, 'Exotic Fruit Delight');
    
-- Create the Mealthree table
CREATE TABLE Mealthree (
    itemID INT PRIMARY KEY,
    Fruitsalad VARCHAR(50),
    FOREIGN KEY (itemID) REFERENCES Item(itemID)
);

SELECT * FROM restaurant.mealthree;
-- Insert values into the Mealthree table
INSERT INTO Mealthree (itemID, Fruitsalad)
VALUES
    (1, 'Tropical Fruit Cocktail'),
    (2, 'Tropical Fruitsalad'),
    (3, 'Citrus Fruitsalad'),
    (4, 'Citrus Fruit Medley'),
    (5, 'Berry Fruitsalad');
    
Drop table mealone;
Drop table mealtwo;
Drop table mealthree;
Drop table Item;
Drop table Customer;
Drop table Address;
Drop table Cashier;


	-- Inner join, shows what is similar in both meals. But we see both have different Item Id
SELECT *
FROM Mealone
INNER JOIN Mealtwo
ON Mealone.Fruit_Cocktail = Mealtwo.Fruits;

	-- Right Join for meal one and three, we see only tropical fruit is intersecting with mealthree in the right join 
SELECT *
FROM Mealone
Right JOIN Mealthree
ON Mealone.Fruit_Cocktail = Mealthree.Fruitsalad;
	
-- stored procedure 1 [calls customer table]
DELIMITER //
CREATE PROCEDURE get_customers()
BEGIN
    SELECT * 
    FROM customer;
END;
//
DELIMITER ;

-- stored procedure 2 [calls id]
DELIMITER //
CREATE PROCEDURE find_customers(IN id INT)
BEGIN
    SELECT * 
    FROM customer
    WHERE custid = id;
END;
//
DELIMITER ;

	-- calling procedures
CALL get_customers();
CALL find_customers(1);
CALL find_customers(5);

   -- Delete a function named GetMealType
DROP PROCEDURE IF EXISTS get_customers;
DROP PROCEDURE IF EXISTS find_customers;

	-- SubQuery - part 1 
Select cashier_name, hourly_wage,
	ROUND((SELECT AVG(hourly_wage) FROM cashier), 2) as Average_hourly_wage
from cashier;   
 
 -- SubQuery - part 2 
Select cashier_name, hourly_wage
from cashier
where hourly_wage > ROUND((SELECT AVG(hourly_wage) FROM cashier), 2);

Select cashier_name, hourly_wage
from cashier
where hourly_wage < ROUND((SELECT AVG(hourly_wage) FROM cashier), 2);

DELIMITER //


	-- stored function
CREATE FUNCTION CalculateTotalHourlyWage() RETURNS DECIMAL(10, 2) DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(hourly_wage) INTO total
    FROM restaurant.cashier;
    
    RETURN total;
END;
//

DELIMITER ;

SELECT CalculateTotalHourlyWage() AS total_hourly_wage;

	-- Trigger exercise
Alter Table cashier
ADD COLUMN salary DECIMAL(10, 2) AFTER hourly_wage;
Select * from cashier;

Update cashier
SET salary = hourly_wage * 37.5 * 52;
Select * from cashier;

CREATE TRIGGER before_hourly_wage_update
BEFORE UPDATE ON cashier
FOR EACH ROW 
SET NEW.SALARY = (NEW.hourly_wage * 37.5 * 52);

show triggers;
 
Update cashier
SET hourly_wage = 15
WHERE cashier_id = 1;
Select * from cashier;

Update cashier
SET hourly_wage = 10
WHERE cashier_id = 1;
Select * from cashier;

ALTER TABLE cashier
DROP COLUMN salary;
DROP DATABASE restaurant;