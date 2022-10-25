use master
go

--1. Create database named AZBank.
if EXISTS (select * from sys.databases where name='azbank')
drop database azbank
go
create database azbank
go
use azbank

--2. In the AZBank database, create tables with constraints as design above.
create table Customer(
	CustomerID int not null primary key,
	Name nvarchar(50) null,
	City nvarchar(50) null,
	Country nvarchar(50) null,
	Phone nvarchar(15) null,
	Email nvarchar(50) null
	);
create table CustomerAccount(
	AccountNumber char(9) not null primary key,
	CustomerId int not null,
	Balance money not null,
	MinAccount money null,
	constraint FK_CustomerAcc foreign key (CustomerID) references Customer(CustomerID)
	);
create table CustomerTransaction(
	TransactionID int not null primary key,
	AccountNumber char(9),
	TransactionDate smalldatetime null,
	Amount money null,
	DepositorWithdraw bit null,
	constraint fk_CustomerTran foreign key (AccountNumber) references CustomerAccount(AccountNumber)
	);

	--3. Insert into each table at least 3 records.
	Insert into Customer values('110','jack','hanoi','Vietnam','091247762','jack125@gmail.com');
	Insert into Customer values('111','jill','beijing','China','01562756','jill135@gmail.com');
	Insert into Customer values('112','Maxx','seoul','Korea','0933347762','maxx5@gmail.com');

	Insert into CustomerAccount values('365214786','110','3000000','10000');
	Insert into CustomerAccount values('365214722','111','2000000','5000');
	Insert into CustomerAccount values('365214435','112','1500000','3000');

	Insert into CustomerTransaction values('678','365214786','2022-02-02','15000','1');
	Insert into CustomerTransaction values('679','365214722','2022-02-03','55000','1');
	Insert into CustomerTransaction values('680','365214435','2022-02-04','5000','1');
	
	--4. Write a query to get all customers from Customer table who live in ‘Hanoi’.
	select * from Customer where Customer.City='hanoi';

	--5. Write a query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance).
	select Customer.Name,Customer.Phone,Customer.Email,CustomerAccount.AccountNumber,CustomerAccount.Balance from Customer full join CustomerAccount 
	on Customer.CustomerID=CustomerAccount.CustomerId

	--6. A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be over $1000000 (One million USDs). Create a CHECK constraint on Amount column of
	--CustomerTransaction table to check that each transaction amount is greater than 0 and less than or equal $1000000.
	alter table customertransaction add constraint ck_deposit check (Amount > 0 and Amount < 1000000);

	--7. Create a view named vCustomerTransactions that display Name, AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer, CustomerAccount and CustomerTransaction tables.
	create view vCustomerTransactions as
	select Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount, CustomerTransaction.DepositorWithdraw 
	from (Customer join CustomerAccount on Customer.CustomerID=CustomerAccount.CustomerId) join CustomerTransaction on CustomerAccount.AccountNumber=CustomerTransaction.AccountNumber;

	select * from vCustomerTransactions;