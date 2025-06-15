
DROP TABLE IF EXISTS cashierproducts;
DROP TABLE IF EXISTS companyproducts;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS cashiers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS employeesbackup;
DROP TABLE IF EXISTS otherexpenses;
DROP TABLE IF EXISTS employeeinsertlog;
DROP TABLE IF EXISTS employeedeletelog;
DROP PROCEDURE IF EXISTS UpdateEmployeeSalary;
DROP PROCEDURE IF EXISTS getmonthlyexpensereport;
DROP PROCEDURE IF EXISTS updateemployeesalary;
DROP PROCEDURE IF EXISTS insertnewemployee;
DROP PROCEDURE IF EXISTS deleteemployee;
DROP VIEW IF EXISTS highsalaryemployees;
DROP VIEW IF EXISTS availablegroceries;
DROP VIEW IF EXISTS highpriceelectronics;

DROP TRIGGER IF EXISTS trgafterdeleteemployee;
DROP TRIGGER IF EXISTS trgafterinsertemployee;
DROP TRIGGER IF EXISTS logemployeechanges;

DROP FUNCTION IF EXISTS getfullname;
DROP FUNCTION IF EXISTS getage;
DROP FUNCTION IF EXISTS gettotalprice;
DROP FUNCTION IF EXISTS getproductsbycategory;
DROP FUNCTION IF EXISTS getaverageprice;

CREATE DATABASE supermarket;
USE supermarket;

CREATE TABLE employees (
    employeeid INT PRIMARY KEY,
    name VARCHAR(100),
    cnic VARCHAR(20),
    address VARCHAR(255),
    phone VARCHAR(15),
    bloodgroup VARCHAR(10),
    role VARCHAR(50),
    salary DECIMAL(10, 2),
    gender VARCHAR(10)
);

CREATE TABLE employeedeletelog (
    logid INT IDENTITY(1,1) PRIMARY KEY,
    employeeid INT,
    name NVARCHAR(100),
    deletedat DATETIME,
    FOREIGN KEY (employeeid) REFERENCES employees(employeeid)
);

CREATE TABLE employeeinsertlog (
    logid INT IDENTITY(1,1) PRIMARY KEY,
    employeeid INT,
    name NVARCHAR(100),
    insertedat DATETIME,
    FOREIGN KEY (employeeid) REFERENCES employees(employeeid)
);

CREATE TABLE products (
    productid INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    expirydate DATE,
    price DECIMAL(10, 2),
    quantity INT
);

CREATE TABLE cashiers (
    cashierid INT PRIMARY KEY,
    employeeid INT UNIQUE,
    shift VARCHAR(50),
    username VARCHAR(100),
    password VARCHAR(100),
    FOREIGN KEY (employeeid) REFERENCES employees(employeeid)
);

CREATE TABLE cashierproducts (
    cashierid INT,
    productid INT,
    handlingdate DATE,
    PRIMARY KEY (cashierid, productid),
    FOREIGN KEY (cashierid) REFERENCES cashiers(cashierid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

CREATE TABLE companyproducts (
    companyproductid INT PRIMARY KEY,
    companyname VARCHAR(100),
    phone VARCHAR(20),
    productid INT,
    purchasedate DATE,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

CREATE TABLE otherexpenses (
    expenseid INT PRIMARY KEY,
    category VARCHAR(50),
    amount DECIMAL(10, 2),
    paymentmethod VARCHAR(50),
    expensedate DATE
);

CREATE TABLE employeesbackup (
    employeeid INT PRIMARY KEY,
    name VARCHAR(100),
    cnic VARCHAR(20),
    address VARCHAR(255),
    phone VARCHAR(15),
    bloodgroup VARCHAR(10),
    role VARCHAR(50),
    salary DECIMAL(10, 2),
    gender VARCHAR(10),
    age INT
);

INSERT INTO employees (employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender)
VALUES
(1, 'hamna amir', '3520221234567', 'house no. 123, street no. 5, lahore', '+92 300 1234567', 'b+', 'cashier', 60000, 'male'),
(2, 'fatima akhtar', '3520221234568', 'apartment no. 45, gulshan-e-iqbal, karachi', '+92 321 2345678', 'a-', 'assistant manager', 45000, 'female'),
(3, 'ali', '3520221234569', 'village no. 67, rawalpindi', '+92 333 3456789', 'o+', 'cashier', 35000, 'male');

INSERT INTO products (productid, name, category, expirydate, price, quantity)
VALUES
(1, 'rice', 'groceries', '2024-12-31', 50, 100),
(2, 'cooking oil (5l)', 'groceries', '2025-06-30', 500, 50),
(3, 'flour (10kg)', 'groceries', '2024-09-30', 2000, 80);

INSERT INTO cashiers (cashierid, employeeid, shift, username, password)
VALUES
(1, 1, 'morning', 'daniyal.khan@market.com', 'password123'),
(2, 3, 'evening', 'ahmed.ali@market.com', 'pass456');

INSERT INTO otherexpenses (expenseid, category, amount, paymentmethod, expensedate)
VALUES
(1, 'electricity bill', 25000, 'online transfer', '2024-05-10'),
(2, 'water bill', 15000, 'cheque', '2024-05-15'),
(3, 'gas bill', 18000, 'cash', '2024-05-20');

INSERT INTO companyproducts (companyproductid, companyname, phone, productid, quantity, price, purchasedate)
VALUES
(1, 'abc pvt ltd', '+92 305 3555937', 3, 100, 1600, '2024-04-01');

INSERT INTO employeesbackup (employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender, age)
SELECT employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender, 25
FROM employees;

SELECT * FROM employees;
SELECT DISTINCT bloodgroup FROM employees;
SELECT * FROM employees WHERE gender = 'female';
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees WHERE salary > 40000 AND gender = 'male';
SELECT * FROM employees WHERE role = 'cashier' OR salary > 50000;
SELECT * FROM products WHERE NOT category = 'groceries';
SELECT * FROM employees WHERE employeeid = 4;

INSERT INTO employees (employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender)
VALUES (5, 'zainab tariq', '3520221234570', 'faisalabad, punjab', NULL, 'ab+', 'manager', 75000, 'female');

UPDATE employees SET salary = 65000 WHERE employeeid = 1;
UPDATE employees SET salary = 70000 WHERE name = 'fatima akhtar';
UPDATE products SET price = 2100, quantity = 90 WHERE name = 'flour (10kg)';

SELECT TOP 1 * FROM employees WHERE gender = 'male';
SELECT TOP 1 * FROM employees ORDER BY salary DESC;
SELECT * FROM products ORDER BY productid OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;
SELECT TOP 2 * FROM employees;

DELETE FROM otherexpenses WHERE expenseid = 3;

SELECT MIN(salary) AS minsalary FROM employees;
SELECT MAX(price) AS maxprice FROM products;
SELECT AVG(salary) AS avgsalary FROM employees;
SELECT AVG(price) AS avggroceriesprice FROM products WHERE category = 'groceries';

SELECT * FROM employees WHERE name LIKE 'muhammad%';
SELECT * FROM products WHERE name LIKE '%oil%';
SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);
SELECT DISTINCT bloodgroup FROM employees;
SELECT * FROM employees WHERE salary > 40000 AND gender = 'male';
SELECT * FROM employees WHERE role = 'cashier' OR salary > 50000;
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM products ORDER BY name ASC;

SELECT e.employeeid, e.name, c.cashierid, c.shift
FROM employees e
INNER JOIN cashiers c ON e.employeeid = c.employeeid;

SELECT e.employeeid, e.name, c.cashierid, c.shift
FROM employees e
LEFT JOIN cashiers c ON e.employeeid = c.employeeid;

SELECT e.employeeid, e.name, c.cashierid, c.shift
FROM employees e
RIGHT JOIN cashiers c ON e.employeeid = c.employeeid;

SELECT e.employeeid, e.name, c.cashierid, c.shift
FROM employees e
FULL OUTER JOIN cashiers c ON e.employeeid = c.employeeid;

SELECT e1.employeeid AS employee1, e1.name AS employee1_name,
       e2.employeeid AS employee2, e2.name AS employee2_name
FROM employees e1
INNER JOIN employees e2 ON e1.role = e2.role AND e1.employeeid != e2.employeeid;

SELECT employeeid, name FROM employees WHERE role = 'cashier'
UNION
SELECT employeeid, name FROM employees WHERE salary > 50000;

SELECT role, COUNT(*) AS numberofemployees
FROM employees
GROUP BY role;

SELECT role, COUNT(*) AS numberofemployees
FROM employees
GROUP BY role
HAVING COUNT(*) > 1;


SELECT * FROM employees
WHERE EXISTS (
    SELECT 1 FROM cashiers WHERE cashiers.employeeid = employees.employeeid
);

SELECT * FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE role = 'assistant manager'
);

SELECT * FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE role = 'cashier'
);


SELECT * INTO employeesbackup_2024 FROM employees;

INSERT INTO employeesbackup_2024 (employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender)
SELECT employeeid, name, cnic, address, phone, bloodgroup, role, salary, gender
FROM employees WHERE role = 'cashier';

SELECT employeeid, name,
    CASE 
        WHEN salary IS NULL THEN 'salary not set'
        ELSE CAST(salary AS VARCHAR)
    END AS salarystatus
FROM employees;

Select ProductID, name,  
    Case 
        when price < 100 then 'Cheap' 
        when price between 100 and 500 then 'Moderate' 
        else 'Expensive' 
    end as PriceCategory
from Products;

Go
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID int,
    @NewSalary decimal(10,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
    
    PRINT 'Employee salary updated successfully.';
END;
GO

Exec UpdateEmployeeSalary @EmployeeID = 1, @NewSalary = 70000;

Select * from sys.procedures where name = 'UpdateEmployeeSalary';

Go
Create procedure InsertNewEmployee
    @EmployeeID int,
    @Name varchar(100),
    @CNIC varchar(20),
    @Address varchar(255),
    @Phone varchar(15),
    @BloodGroup varchar(10),
    @Role varchar(50),
    @Salary decimal(10, 2),
    @Gender varchar(10)
as
begin
    begin try
        insert into Employees (EmployeeID, Name, CNIC, Address, Phone, BloodGroup, Role, Salary, Gender)
        values (@EmployeeID, @Name, @CNIC, @Address, @Phone, @BloodGroup, @Role, @Salary, @Gender);
    end try
    begin catch
        select error_message() as ErrorMessage;
    end catch
end;
Go

Exec InsertNewEmployee 
    @EmployeeID = 6, 
    @Name = 'John Doe', 
    @CNIC = '3520221234573', 
    @Address = 'Lahore, Punjab', 
    @Phone = '+92 300 6666666', 
    @BloodGroup = 'O+', 
    @Role = 'Manager', 
    @Salary = 75000, 
    @Gender = 'Male';
    
Select * from Employees where EmployeeID = 6;
Go
Create procedure DeleteEmployee
    @EmployeeID int
as
begin
    begin try
        declare @EmployeeName varchar(100);
        select @EmployeeName = Name from Employees where EmployeeID = @EmployeeID;
        insert into EmployeeDeleteLog (EmployeeID, Name, DeletedAt) 
        values (@EmployeeID, @EmployeeName, getdate());
        delete from Employees where EmployeeID = @EmployeeID;
    end try
    begin catch
        select error_message() as ErrorMessage;
    end catch
end;

Exec DeleteEmployee @EmployeeID = 101;
Select * from EmployeeDeleteLog;



Go
Create procedure GetMonthlyExpenseReport
    @Month int,
    @Year int
as
begin
    select Category, sum(Amount) as TotalAmount
    from OtherExpenses
    where month(ExpenseDate) = @Month and year(ExpenseDate) = @Year
    group by Category;
end;

Exec GetMonthlyExpenseReport @Month = 3, @Year = 2025;

Select * from Employees
where Salary >= 50000;

Select * from Products
where Price < 2000;

Select * from Employees
where Salary <> 45000;

Select * from Products
where Price = 500;

Select * from Employees
where Salary between 40000 and 60000;

Select * from Products
where Quantity between 50 and 100;

Go
Create view HighSalaryEmployees as
select EmployeeID, Name, Salary
from Employees
where Salary > 50000;
Go
If exists (select * from sys.views where name = 'HighSalaryEmployees')
    print 'View HighSalaryEmployees exists';
else
    print 'View does not exist';
Go

Create view AvailableGroceries as
select ProductID, Name, Price, Quantity
from Products
where Category = 'Groceries' and Quantity > 0;
Go

If exists (select * from sys.views where name = 'AvailableGroceries')
    print 'View AvailableGroceries exists';
else
    print 'View does not exist';

Go
Create view HighPriceElectronics as
select ProductID, Name, Price, Quantity
from Products
where Category = 'Electronics' and Price > 500;
Go
If exists (select * from sys.views where name = 'HighPriceElectronics')
    print 'View HighPriceElectronics exists';
else
    print 'View HighPriceElectronics does not exist';

Go
Create trigger trgAfterDeleteEmployee
on Employees
after delete
as
begin
    insert into EmployeeDeleteLog (EmployeeID, Name, DeletedAt)
    select EmployeeID, Name, getdate()
    from deleted;
end;
If exists (select * from sys.triggers where name = 'trg_AfterDelete_Employee')
    print 'Trigger exists';
else
    print 'Trigger does not exist';
Go
Go
Create trigger LogEmployeeChanges
on Employees
after insert, update, delete
as
begin
    declare @EmployeeID int, @Name varchar(100), @Operation varchar(10);
    
    if exists (select * from inserted)
    begin
        select @EmployeeID = EmployeeID, @Name = Name from inserted;
        set @Operation = 'INSERT';
        insert into EmployeeInsertLog (EmployeeID, Name, InsertedAt) values (@EmployeeID, @Name, getdate());
    end

    if exists (select * from deleted)
    begin
        select @EmployeeID = EmployeeID, @Name = Name from deleted;
        set @Operation = 'DELETE';
        insert into EmployeeDeleteLog (EmployeeID, Name, DeletedAt) values (@EmployeeID, @Name, getdate());
    end
end;

Insert into Employees (EmployeeID, Name, Role, Salary)
values (101, 'John Doe', 'Developer', 50000);

Delete from Employees where EmployeeID = 101;
GO
Create trigger trgAfterInsertEmployee
on Employees
after insert
as
begin
    insert into EmployeeInsertLog (EmployeeID, Name, InsertedAt)
    select EmployeeID, Name, getdate()
    from inserted;
end;
If exists (select * from sys.triggers where name = 'trg_AfterInsert_Employee')
    print 'Insert Trigger exists';
else
    print 'Insert Trigger does not exist';
Select * from EmployeeInsertLog;
Alter table Employees
add Salary decimal(10, 2);
Alter table Employees
alter column Name nvarchar(150);
Alter table Employees
drop column Age;
Select upper(Name) as UpperCaseName from Employees;
Select len(Name) as NameLength from Employees;
Select count(*) as TotalEmployees from Employees;
Select avg(Salary) as AverageSalary from Employees;
Select max(Salary) as MaxSalary from Employees;

Go
Create function GetFullName(@FirstName nvarchar(50), @LastName nvarchar(50))
returns nvarchar(100)
as
begin
    return (@FirstName + ' ' + @LastName)
end;
Go
Select dbo.GetFullName('Hamna', 'Amir') as FullName;

Go
Create function GetAge(@BirthDate date)
returns int
as
begin
    return datediff(year, @BirthDate, getdate()) - 
           case 
               when month(@BirthDate) > month(getdate()) or 
                    (month(@BirthDate) = month(getdate()) and day(@BirthDate) > day(getdate())) 
               then 1 
               else 0 
           end
end;
Go

Select dbo.GetAge('1995-03-15') as Age;

Go
Create function GetTotalPrice()
returns decimal(10,2)
as
begin
    declare @TotalPrice decimal(10,2);
    select @TotalPrice = sum(Price) from Products;
    return @TotalPrice;
end;
Go

Select dbo.GetTotalPrice() as TotalPrice;
Go
Create function GetProductsByCategory(@Category nvarchar(50))
returns table
as
return
(
    select ProductID, Price
    from Products
    where Category = @Category
);
Go

Select * from dbo.GetProductsByCategory('Electronics');
Drop function if exists GetAveragePrice;
Go
Create function GetAveragePrice()
returns decimal(10,2)
as
begin
    declare @AveragePrice decimal(10,2);
    select @AveragePrice = avg(Price) from Products;
    return @AveragePrice;
end;
Go

Select dbo.GetAveragePrice() as AveragePrice;



