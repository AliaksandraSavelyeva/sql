use Savelyeva_10;

---
---  CREATE TABLE statements
---

--DROP TABLE ORDERS;
--DROP TABLE CUSTOMERS;
--DROP TABLE SALESREPS;
--DROP TABLE OFFICES;
--DROP TABLE PRODUCTS;


CREATE TABLE PRODUCTS
     (MFR_ID CHAR(3) NOT NULL,
  PRODUCT_ID CHAR(5) NOT NULL,
 DESCRIPTION VARCHAR(20) NOT NULL,
       PRICE MONEY NOT NULL,
 QTY_ON_HAND INTEGER NOT NULL,
 PRIMARY KEY (MFR_ID, PRODUCT_ID));


CREATE TABLE OFFICES
     (OFFICE INT NOT NULL,
        CITY VARCHAR(15) NOT NULL,
      REGION VARCHAR(10) NOT NULL,
         MGR INT,
      TARGET DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (OFFICE));


CREATE TABLE SALESREPS
   (EMPL_NUM INT NOT NULL,
             CHECK (EMPL_NUM BETWEEN 101 AND 199),
        NAME VARCHAR(15) NOT NULL,
         AGE INTEGER,
  REP_OFFICE INTEGER,
       TITLE VARCHAR(10),
   HIRE_DATE DATE NOT NULL,
     MANAGER INT,
       QUOTA DECIMAL(9,2),
       SALES DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (EMPL_NUM),
 FOREIGN KEY (MANAGER) REFERENCES SALESREPS(EMPL_NUM),
 CONSTRAINT WORKSIN FOREIGN KEY (REP_OFFICE)  
  REFERENCES OFFICES(OFFICE));


CREATE TABLE CUSTOMERS
   (CUST_NUM INTEGER    NOT NULL,
    COMPANY VARCHAR(20) NOT NULL,
    CUST_REP INTEGER,
    CREDIT_LIMIT DECIMAL(9,2),
 PRIMARY KEY (CUST_NUM),
 CONSTRAINT HASREP FOREIGN KEY (CUST_REP)
  REFERENCES SALESREPS(EMPL_NUM));


CREATE TABLE ORDERS
  (ORDER_NUM INTEGER NOT NULL,
             CHECK (ORDER_NUM > 100000),
  ORDER_DATE DATE NOT NULL,
        CUST INTEGER NOT NULL,
         REP INTEGER,
         MFR CHAR(3) NOT NULL,
     PRODUCT CHAR(5) NOT NULL,
         QTY INTEGER NOT NULL,
      AMOUNT DECIMAL(9,2) NOT NULL,
 PRIMARY KEY (ORDER_NUM),
 CONSTRAINT PLACEDBY FOREIGN KEY (CUST)
  REFERENCES CUSTOMERS(CUST_NUM)
   ON DELETE CASCADE,
 CONSTRAINT TAKENBY FOREIGN KEY (REP)
  REFERENCES SALESREPS(EMPL_NUM),
 CONSTRAINT ISFOR FOREIGN KEY (MFR, PRODUCT)
  REFERENCES PRODUCTS(MFR_ID, PRODUCT_ID));


ALTER TABLE OFFICES
  ADD CONSTRAINT HASMGR
  FOREIGN KEY (MGR) REFERENCES SALESREPS(EMPL_NUM);

---
---  Inserts for sample schema
---

---
---  PRODUCTS
---
INSERT INTO PRODUCTS VALUES('REI','2A45C','Ratchet Link',79.00,210);
INSERT INTO PRODUCTS VALUES('ACI','4100Y','Widget Remover',2750.00,25);
INSERT INTO PRODUCTS VALUES('QSA','XK47 ','Reducer',355.00,38);
INSERT INTO PRODUCTS VALUES('BIC','41627','Plate',180.00,0);
INSERT INTO PRODUCTS VALUES('IMM','779C ','900-LB Brace',1875.00,9);
INSERT INTO PRODUCTS VALUES('ACI','41003','Size 3 Widget',107.00,207);
INSERT INTO PRODUCTS VALUES('ACI','41004','Size 4 Widget',117.00,139);
INSERT INTO PRODUCTS VALUES('BIC','41003','Handle',652.00,3);
INSERT INTO PRODUCTS VALUES('IMM','887P ','Brace Pin',250.00,24);
INSERT INTO PRODUCTS VALUES('QSA','XK48 ','Reducer',134.00,203);
INSERT INTO PRODUCTS VALUES('REI','2A44L','Left Hinge',4500.00,12);
INSERT INTO PRODUCTS VALUES('FEA','112  ','Housing',148.00,115);
INSERT INTO PRODUCTS VALUES('IMM','887H ','Brace Holder',54.00,223);
INSERT INTO PRODUCTS VALUES('BIC','41089','Retainer',225.00,78);
INSERT INTO PRODUCTS VALUES('ACI','41001','Size 1 Wiget',55.00,277);
INSERT INTO PRODUCTS VALUES('IMM','775C ','500-lb Brace',1425.00,5);
INSERT INTO PRODUCTS VALUES('ACI','4100Z','Widget Installer',2500.00,28);
INSERT INTO PRODUCTS VALUES('QSA','XK48A','Reducer',177.00,37);
INSERT INTO PRODUCTS VALUES('ACI','41002','Size 2 Widget',76.00,167);
INSERT INTO PRODUCTS VALUES('REI','2A44R','Right Hinge',4500.00,12);
INSERT INTO PRODUCTS VALUES('IMM','773C ','300-lb Brace',975.00,28);
INSERT INTO PRODUCTS VALUES('ACI','4100X','Widget Adjuster',25.00,37);
INSERT INTO PRODUCTS VALUES('FEA','114  ','Motor Mount',243.00,15);
INSERT INTO PRODUCTS VALUES('IMM','887X ','Brace Retainer',475.00,32);
INSERT INTO PRODUCTS VALUES('REI','2A44G','Hinge Pin',350.00,14);


---
---  OFFICES
---
INSERT INTO OFFICES VALUES(22,'Denver','Western',null,300000.00,186042.00);
INSERT INTO OFFICES VALUES(11,'New York','Eastern',null,575000.00,692637.00);
INSERT INTO OFFICES VALUES(12,'Chicago','Eastern',null,800000.00,735042.00);
INSERT INTO OFFICES VALUES(13,'Atlanta','Eastern',null,350000.00,367911.00);
INSERT INTO OFFICES VALUES(21,'Los Angeles','Western',null,725000.00,835915.00);


---
---  SALESREPS
---
INSERT INTO SALESREPS VALUES (106,'Sam Clark',52,11,'VP Sales','2006-06-14',null,275000.00,299912.00);
INSERT INTO SALESREPS VALUES (109,'Mary Jones',31,11,'Sales Rep','2007-10-12',106,300000.00,392725.00);
INSERT INTO SALESREPS VALUES (104,'Bob Smith',33,12,'Sales Mgr','2005-05-19',106,200000.00,142594.00);
INSERT INTO SALESREPS VALUES (108,'Larry Fitch',62,21,'Sales Mgr','2007-10-12',106,350000.00,361865.00);
INSERT INTO SALESREPS VALUES (105,'Bill Adams',37,13,'Sales Rep','2006-02-12',104,350000.00,367911.00);
INSERT INTO SALESREPS VALUES (102,'Sue Smith',48,21,'Sales Rep','2004-12-10',108,350000.00,474050.00);
INSERT INTO SALESREPS VALUES (101,'Dan Roberts',45,12,'Sales Rep','2004-10-20',104,300000.00,305673.00);
INSERT INTO SALESREPS VALUES (110,'Tom Snyder',41,null,'Sales Rep','2008-01-13',101,null,75985.00);
INSERT INTO SALESREPS VALUES (103,'Paul Cruz',29,12,'Sales Rep','2005-03-01',104,275000.00,286775.00);
INSERT INTO SALESREPS VALUES (107,'Nancy Angelli',49,22,'Sales Rep','2006-11-14',108,300000.00,186042.00);


---
---   OFFICE MANAGERS
---
UPDATE OFFICES SET MGR=108 WHERE OFFICE=22;
UPDATE OFFICES SET MGR=106 WHERE OFFICE=11;
UPDATE OFFICES SET MGR=104 WHERE OFFICE=12;
UPDATE OFFICES SET MGR=105 WHERE OFFICE=13;
UPDATE OFFICES SET MGR=108 WHERE OFFICE=21;

---
---   CUSTOMERS
---
INSERT INTO CUSTOMERS VALUES(2111,'JCP Inc.',103,50000.00);
INSERT INTO CUSTOMERS VALUES(2102,'First Corp.',101,65000.00);
INSERT INTO CUSTOMERS VALUES(2103,'Acme Mfg.',105,50000.00);
INSERT INTO CUSTOMERS VALUES(2123,'Carter \& Sons',102,40000.00);
INSERT INTO CUSTOMERS VALUES(2107,'Ace International',110,35000.00);
INSERT INTO CUSTOMERS VALUES(2115,'Smithson Corp.',101,20000.00);
INSERT INTO CUSTOMERS VALUES(2101,'Jones Mfg.',106,65000.00);
INSERT INTO CUSTOMERS VALUES(2112,'Zetacorp',108,50000.00);
INSERT INTO CUSTOMERS VALUES(2121,'QMA Assoc.',103,45000.00);
INSERT INTO CUSTOMERS VALUES(2114,'Orion Corp.',102,20000.00);
INSERT INTO CUSTOMERS VALUES(2124,'Peter Brothers',107,40000.00);
INSERT INTO CUSTOMERS VALUES(2108,'Holm \& Landis',109,55000.00);
INSERT INTO CUSTOMERS VALUES(2117,'J.P. Sinclair',106,35000.00);
INSERT INTO CUSTOMERS VALUES(2122,'Three Way Lines',105,30000.00);
INSERT INTO CUSTOMERS VALUES(2120,'Rico Enterprises',102,50000.00);
INSERT INTO CUSTOMERS VALUES(2106,'Fred Lewis Corp.',102,65000.00);
INSERT INTO CUSTOMERS VALUES(2119,'Solomon Inc.',109,25000.00);
INSERT INTO CUSTOMERS VALUES(2118,'Midwest Systems',108,60000.00);
INSERT INTO CUSTOMERS VALUES(2113,'Ian \& Schmidt',104,20000.00);
INSERT INTO CUSTOMERS VALUES(2109,'Chen Associates',103,25000.00);
INSERT INTO CUSTOMERS VALUES(2105,'AAA Investments',101,45000.00);

---
---  ORDERS
---
INSERT INTO ORDERS VALUES (112961,'2007-12-17',2117,106,'REI','2A44L',7,31500.00);
INSERT INTO ORDERS VALUES (113012,'2008-01-11',2111,105,'ACI','41003',35,3745.00);
INSERT INTO ORDERS VALUES (112989,'2008-01-03',2101,106,'FEA','114',6,1458.00);
INSERT INTO ORDERS VALUES (113051,'2008-02-10',2118,108,'QSA','XK47',4,1420.00);
INSERT INTO ORDERS VALUES (112968,'2007-10-12',2102,101,'ACI','41004',34,3978.00);
INSERT INTO ORDERS VALUES (113036,'2008-01-30',2107,110,'ACI','4100Z',9,22500.00);
INSERT INTO ORDERS VALUES (113045,'2008-02-02',2112,108,'REI','2A44R',10,45000.00);
INSERT INTO ORDERS VALUES (112963,'2007-12-17',2103,105,'ACI','41004',28,3276.00);
INSERT INTO ORDERS VALUES (113013,'2008-01-14',2118,108,'BIC','41003',1,652.00);
INSERT INTO ORDERS VALUES (113058,'2008-02-23',2108,109,'FEA','112',10,1480.00);
INSERT INTO ORDERS VALUES (112997,'2008-01-08',2124,107,'BIC','41003',1,652.00);
INSERT INTO ORDERS VALUES (112983,'2007-12-27',2103,105,'ACI','41004',6,702.00);
INSERT INTO ORDERS VALUES (113024,'2008-01-20',2114,108,'QSA','XK47',20,7100.00);
INSERT INTO ORDERS VALUES (113062,'2008-02-24',2124,107,'FEA','114',10,2430.00);
INSERT INTO ORDERS VALUES (112979,'2007-10-12',2114,102,'ACI','4100Z',6,15000.00);
INSERT INTO ORDERS VALUES (113027,'2008-01-22',2103,105,'ACI','41002',54,4104.00);
INSERT INTO ORDERS VALUES (113007,'2008-01-08',2112,108,'IMM','773C',3,2925.00);
INSERT INTO ORDERS VALUES (113069,'2008-03-02',2109,107,'IMM','775C',22,31350.00);
INSERT INTO ORDERS VALUES (113034,'2008-01-29',2107,110,'REI','2A45C',8,632.00);
INSERT INTO ORDERS VALUES (112992,'2007-11-04',2118,108,'ACI','41002',10,760.00);
INSERT INTO ORDERS VALUES (112975,'2007-10-12',2111,103,'REI','2A44G',6,2100.00);
INSERT INTO ORDERS VALUES (113055,'2008-02-15',2108,101,'ACI','4100X',6,150.00);
INSERT INTO ORDERS VALUES (113048,'2008-02-10',2120,102,'IMM','779C',2,3750.00);
INSERT INTO ORDERS VALUES (112993,'2007-01-04',2106,102,'REI','2A45C',24,1896.00);
INSERT INTO ORDERS VALUES (113065,'2008-02-27',2106,102,'QSA','XK47',6,2130.00);
INSERT INTO ORDERS VALUES (113003,'2008-01-25',2108,109,'IMM','779C',3,5625.00);
INSERT INTO ORDERS VALUES (113049,'2008-02-10',2118,108,'QSA','XK47',2,776.00);
INSERT INTO ORDERS VALUES (112987,'2007-12-31',2103,105,'ACI','4100Y',11,27500.00);
INSERT INTO ORDERS VALUES (113057,'2008-02-18',2111,103,'ACI','4100X',24,600.00);
INSERT INTO ORDERS VALUES (113042,'2008-02-20',2113,101,'REI','2A44R',5,22500.00);


--1.	����������� ������, ������� ������� ��� ������ � �������.
--select * from customers;
declare @cust_id int, @company varchar(20), @cust_rep int, @limit decimal (9, 2), @result varchar (100);

declare customer_cursor cursor for
	select cust_num, company, cust_rep, credit_limit from customers;
open customer_cursor;
fetch from customer_cursor into @cust_id, @company, @cust_rep, @limit;
print 'Customer information:';
while @@fetch_status = 0
begin
	select @result = cast(@cust_id as varchar(10)) + ' ' +
	@company + ' ' + cast(@cust_rep as varchar(10)) + ' ' + 
	cast(@limit as varchar(10));
	print @result;
	fetch from customer_cursor into @cust_id, @company, @cust_rep, @limit;
end;
close customer_cursor;
deallocate customer_cursor;

--2.	����������� ������, ������� ������� ��� ������ � ����������� ������ � �� ����������.
select * from offices;
select * from salesreps;

declare @office int, @city varchar(15), @region varchar(10), @output varchar(150), @count_message varchar(50);
declare @name varchar(50), @age int, @empl_num int, @rep_office int, @title varchar(80), @sales decimal(9, 2), @qty int;

print 'Employee information:';

declare office_cursor cursor for
select office, city, region
from offices;
open office_cursor;
	fetch next from office_cursor
	into @office, @city, @region;
	while @@fetch_status = 0
	begin
		select @output = 'Office ' + cast(@office as varchar(3)) + ', ' + @city + ', ' + @region;
		print @output;
		set @count_message = (select cast(count(empl_num) as varchar(5)) from salesreps where rep_office = @office);
		print @count_message + ' employees';
		print ' ';
		declare empl_cursor cursor for
		select name, age,empl_num, rep_office, title, sales from salesreps
		where rep_office = @office;
		open empl_cursor;
			fetch next from empl_cursor into @name, @age, @empl_num, @rep_office, @title, @sales;
			while @@fetch_status = 0
				begin
					select @output = @name + ' ' + cast(@age as varchar(8)) + ' ' + cast(@empl_num as varchar(15)) +
					' ' + cast(@rep_office as varchar(15)) + ' ' + @title + ' ' + cast(@sales as varchar(15));
					print @output;
					fetch next from empl_cursor into @name, @age, @empl_num, @rep_office, @title, @sales;
				end;
			print ' ';
		close empl_cursor;
		deallocate empl_cursor;
		fetch next from office_cursor into @office, @city, @region;
	end;
close office_cursor;
deallocate office_cursor;

--3.	����������� ��������� ������, ������� ������� ��� �������� � ������� � �� ������� ����.
declare @name_product varchar(5), @desc varchar(10), @name_mnf varchar(3), @price money, @on_hand int, @sales_qty int, @sales1 money;
declare @avg_price numeric(9,2), @message2 varchar(80);

declare manufacture_detail cursor local for 
select * from products;
open manufacture_detail;
	fetch next from manufacture_detail into @name_mnf, @name_product, @desc, @price, @on_hand;
	while @@fetch_status = 0
	begin
		set @avg_price = (select cast(sum(amount)/sum(qty) as numeric(9, 2)) from orders 
		where product = @name_product);
		select @message2 = 'Product ' + @name_product + ' is ' + cast(@avg_price as varchar(10)) + ' in average.';
		print @message2;
		declare additional_info cursor local for
		select qty, amount from orders where product = @name_product;
		open additional_info;
			fetch next from additional_info into @sales_qty, @sales1;
			while @@fetch_status = 0
				begin
					set @message2 = @desc + ' ' + @name_mnf + ' ' + cast(@price as varchar(10)) + ' ' 
					+ cast(@on_hand as varchar(3)) + ' ' + cast(@sales_qty as varchar(5)) + ' ' + cast(@sales1 as varchar(10));
					print @message2;
					fetch next from additional_info into @sales_qty, @sales1;
				end;
		close additional_info;
		deallocate additional_info;
		fetch next from manufacture_detail into @name_mnf, @name_product, @desc, @price, @on_hand;
	end;
close manufacture_detail;
deallocate manufacture_detail;

--4.	����������� ���������� ������, ������� ������� �������� � �������, ����������� � 2008 ����.
declare @order_num int, @date date, @cust int, @rep int, @mfr char(3), @prod varchar(8), @quantity int, @amount numeric(9, 2), @message1 varchar(80);
declare order_details cursor global for
select * from orders where year(order_date) = '2008';
open order_details;
	fetch from order_details into @order_num, @date, @cust, @rep, @mfr, @prod, @quantity, @amount;
		while @@fetch_status = 0
			begin
				set @message1 = cast(@order_num as varchar(10)) + ' ' + cast(@date as varchar(10)) + ' ' + cast(@cust as varchar(4))
				+ ' ' + cast(@rep as varchar(3)) + @mfr + ' ' + @prod + ' ' + cast(@quantity as varchar(5)) + ' ' + cast(@amount as varchar(10));
				print @message1;
				fetch next from order_details into @order_num, @date, @cust, @rep, @mfr, @prod, @quantity, @amount;
			end;
close order_details;
deallocate order_details;

--5.	����������� ����������� ������, ������� ������� �������� � ����������� � �� �������.
declare @cust_company varchar(20), @cust_num int, @cust_output varchar(150);
declare @order_number int, @order_date date, @product varchar(10), @quant int, @order_amount decimal(9, 2), @company_output varchar(150);

declare customer_detail cursor local scroll static for
select company, cust_num from customers;
open customer_detail;
	fetch from customer_detail into @cust_company, @cust_num;
	while @@fetch_status = 0
		begin
			select @cust_output = 'Detail about ' + @cust_company + ' customer: ';
			print @cust_output;
			declare company_detail cursor for
			select order_num, order_date, product, qty, amount from orders 
			where cust = @cust_num;
			open company_detail;
				fetch next from company_detail into @order_number, @order_date, @product, @quant, @order_amount;
				while @@fetch_status = 0
					begin
						select @company_output = cast(@order_number as varchar(10)) + ' ' + cast(@order_date as varchar(10)) + ' ' + @product + 
						cast(@quant as varchar(5)) + ' ' + cast(@order_amount as varchar(10));
						print @company_output;
						print ' ';
						fetch next from company_detail into @order_number, @order_date, @product, @quant, @order_amount;
					end;
			close company_detail;
			deallocate company_detail;
			fetch from customer_detail into @cust_company, @cust_num;
		end;
close customer_detail;
deallocate customer_detail;

--6.	����������� ������������ ������, ������� ��������� ������ � ���������� � ����������� �� ����� ����������� ������� (���� SALES).
declare @rep int, @sales decimal (9, 2);
declare update_cursor cursor local dynamic for
	select rep, sum(amount) as sales_order from orders
	group by rep;
open update_cursor;
	fetch from update_cursor into @rep, @sales;
	while @@fetch_status = 0
	begin
		update salesreps set sales = @sales
		where empl_num = @rep;
		fetch from update_cursor into @rep, @sales;
	end;
close update_cursor;
deallocate update_cursor;


--7.	������������������ �������� SCROLL.

declare cursor_scroll cursor scroll for
select * from salesreps;
open cursor_scroll
	fetch last from cursor_scroll; -- ��������� ������
	fetch prior from cursor_scroll; -- ���������� ������
	fetch first from cursor_scroll; -- ������ ������
	fetch absolute 3 from cursor_scroll; -- ������ �� ���. ������
	fetch relative 4 from cursor_scroll; -- ������ �� ��������� �� �������
close cursor_scroll;
deallocate cursor_scroll;







--3.1
USE Savelyeva_04;

create function COUNTORDERS(@rep int, @date_from date, @date_to date) returns int;
begin

declare @rc int = -1;

if (select empl_num from salesreps where emple_num = @rep) is null
return @rc;

set @rc = (select count(order_num) from orders where rep=@rep and order_date between @date_from and @date_to);
return @rc;

end;

--declare @rep int=0;
--set @rep = dbo.COUNTORDERS(189, '2007-12-31', '2008-12-31');
--select empl_num, name, dbo.COUNTORDERS(empl_num, 2008) from salesreps;
--print @rep;

select empl_num, name, dbo.COUNTORDERS(empl_num, '2007-12-31', '2008-12-31') from salesreps;
go


----------------------------------

select * from salesreps;
declare @age int;
declare age_cursor cursor for
	select age from salesreps;
open age_cursor;
	fetch from age_cursor into @age;
	while @@FETCH_STATUS=0
	begin
		print 'Old ' + cast(@age as varchar(10));
		update salesreps set age = age-1 where current of age_cursor;
		fetch from age_cursor into @age;
	end
close age_cursor;
deallocate age_cursor;




