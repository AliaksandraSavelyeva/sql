use Savelyeva_04;

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


--1.1.	Выбрать все заказы, выполненные определенным покупателем.
select order_num from orders 
where cust = (
select cust_num from customers where company = 'Orion Corp.')

--1.2.	Выбрать всех покупателей в порядке уменьшения обшей стоимости заказов.
select c.cust_num, 
	   SumCount = (select sum(amount) from orders o where o.cust = c.cust_num)
from customers c
order by SumCount desc;

--1.3.	Выбрать все заказы, которые оформлялись менеджерами из восточного региона.
select order_num from orders
where rep in (select empl_num from salesreps 
where rep_office in (
select office from offices where region = 'Eastern'))

--1.4.	Найти описания товаров, приобретенные покупателем First Corp.
select description from products 
where product_id in (select product from orders
where cust = (
select cust_num from customers where company = 'First Corp.'))

--1.5.	Выбрать всех сотрудников из Восточного региона и отсортировать по параметру Quota.
select empl_num, quota from salesreps 
where rep_office in (
select office from offices where region = 'Eastern')
order by quota desc;

--1.6.	Выбрать заказы, сумма которых больше среднего значения.
select order_num, amount from orders
where amount > (select avg(amount) from orders)

--1.7.	Выбрать менеджеров, которые обслуживали одних и тех же покупателей.

select first.rep, second.rep, first.cust 
from orders first, orders second 
where first.cust = second.cust
and first.rep > second.rep;

--1.8.	Выбрать покупателей с одинаковым кредитным лимитом.

select first.cust_num, second.cust_num, first.credit_limit
from customers first, customers second
where first.credit_limit = second.credit_limit
and first.cust_num > second.cust_num;

--1.9.	Выбрать покупателей, сделавших заказы в один день.

select first.cust, second.cust, first.order_date
from orders first, orders second
where first.order_date = second.order_date
and first.cust > second.cust;

--1.10.	Подсчитать, на какую сумму каждый офис выполнил заказы, и отсортировать их в порядке убывания.
select * from offices;
select * from orders;
select * from salesreps;

select a.rep_office, sum(b.amount) as 'summ amount'
from orders b join salesreps a
on a.empl_num = b.rep
group by a.rep_office
order by sum(b.amount) desc;

--1.11.	Выбрать сотрудников, которые являются начальниками (у которых есть подчиненные).

select f.mgr from offices f
where f.mgr in (select s.manager from salesreps s 
where s.empl_num is not null)

--1.12.	Выбрать сотрудников, которые не являются начальниками (у которых нет подчиненных).

select f.mgr from offices f
where not exists (select s.manager from salesreps s 
where f.mgr = s.manager);

--1.13.	Выбрать всех продукты, продаваемые менеджерами из восточного региона.

select f.product from orders f
where f.rep in (select s.empl_num from salesreps s 
where s.manager in (select t.mgr from offices t where t.region = 'Eastern'))

--1.14.	Выбрать фамилии и даты найма всех сотрудников и отсортировать по сумме заказов, которые они выполнили.

select f.name, f.hire_date, s.amount 
from salesreps f, orders s
-- where s.amount = (select sum(s.amount) from orders 
-- where s.rep = )
-- order by s.amount;

--1.15.	Выбрать заказы, выполненные менеджерами из  восточного региона и отсортировать по количеству заказанного по возрастанию.
select f.order_num, f.qty from orders f
where f.rep in (select s.mgr from offices s 
where s.region = 'Eastern')
order by f.qty;

--1.16.	Выбрать товары, которые дороже товаров, заказанных компанией First Corp.
select * from customers;

select product_id from products
where product_id in (select product from orders
where amount > any(select amount from orders 
where cust = (select cust_num from customers where 
company = 'Acme Mfg.')))

select product_id, price from products
where price > any(select amount from orders
where cust = (select cust_num from customers
where company = 'Acme Mfg.'))

--1.17.	Выбрать товары, которые не входят в товары, заказанные компанией First Corp.

select product_id from products
where product_id in (select product from orders
where cust <> (select cust_num from customers where 
company = 'First Corp.'));

--1.18.	Выбрать товары, которые по стоимости ниже среднего значения стоимости заказа по покупателю.
select product_id, price from products 
where price < (select avg(amount) from orders);

--1.19.	Найти сотрудников, кто выполнял заказы в 2008, но не выполнял в 2007 (как минимум 2-мя разными способами).

select f.empl_num, f.name from salesreps f
where not exists (select s.rep from orders s 
where s.rep = f.empl_num and year(s.order_date) = 2007);

--1.20.	Найти организации, которые не делали заказы в 2008, но делали в 2007 (как минимум 2-мя разными способами).

select f.cust_num, f.company from customers f
where not exists (select s.cust from orders s
where s.cust = f.cust_num and year(s.order_date) = 2008);

--1.21.	Найти организации, которые делали заказы в 2008 и в 2007 (как минимум 2-мя разными способами).
select f.cust_num, f.company from customers f
where not exists (select s.cust from orders s
where s.cust = f.cust_num and (year(s.order_date) = 2007 or year(s.order_date) = 2008));


--2.1.	Создайте таблицу Аудит (дата, операция, производитель, код) – она будет использоваться для контроля записи в таблицу PRODUCTS.
create table audit
(audit_date date not null,
operation varchar(30),
mfr_id char(5),
product_id char(5) not null,
primary key (mfr_id, product_id));

INSERT INTO audit VALUES('2006-06-14', 'operation1', 'REI','2A45C');
INSERT INTO audit VALUES('2007-06-13', 'operation2', 'ACI','4100Y');
INSERT INTO audit VALUES('2008-06-12', 'operation3', 'QSA','XK47 ');
INSERT INTO audit VALUES('2009-06-11', 'operation1', 'BIC','41627');
INSERT INTO audit VALUES('2008-06-14', 'operation2', 'IMM','779C ');
INSERT INTO audit VALUES('2007-06-5', 'operation3', 'ACI','41003');
INSERT INTO audit VALUES('2006-06-4', 'operation4', 'ACI','41004');
INSERT INTO audit VALUES('2005-06-24', 'operation3', 'BIC','41003');
INSERT INTO audit VALUES('2004-06-30', 'operation1', 'IMM','887P ');
INSERT INTO audit VALUES('2003-06-14', 'operation1', 'QSA','XK48 ');
INSERT INTO audit VALUES('2005-06-7', 'operation2', 'REI','2A44L');
INSERT INTO audit VALUES('2006-06-11', 'operation5', 'FEA','112  ');
INSERT INTO audit VALUES('2007-06-14', 'operation3', 'IMM','887H ');
INSERT INTO audit VALUES('2008-06-9', 'operation1', 'BIC','41089');
INSERT INTO audit VALUES('2009-06-10', 'operation2', 'ACI','41001');
INSERT INTO audit VALUES('2008-06-11', 'operation3', 'IMM','775C ');
INSERT INTO audit VALUES('2007-06-12', 'operation5', 'ACI','4100Z');
INSERT INTO audit VALUES('2006-06-13', 'operation4', 'QSA','XK48A');
INSERT INTO audit VALUES('2005-06-14', 'operation4', 'ACI','41002');
INSERT INTO audit VALUES('2004-06-14', 'operation3', 'REI','2A44R');
INSERT INTO audit VALUES('2006-06-15', 'operation2', 'IMM','773C ');
INSERT INTO audit VALUES('2006-06-16', 'operation2', 'ACI','4100X');
INSERT INTO audit VALUES('2006-06-17', 'operation1', 'FEA','114  ');
INSERT INTO audit VALUES('2006-06-18', 'operation4', 'IMM','887X ');
INSERT INTO audit VALUES('2006-06-19', 'operation5', 'REI','2A44G');

--2.2.	Добавьте во временную таблицу все товары.
CREATE TABLE #PRODUCTS
     (MFR_ID CHAR(3) NOT NULL,
  PRODUCT_ID CHAR(5) NOT NULL,
 DESCRIPTION VARCHAR(20) NOT NULL,
       PRICE MONEY NOT NULL,
 QTY_ON_HAND INTEGER NOT NULL,
 PRIMARY KEY (MFR_ID, PRODUCT_ID));

INSERT INTO #PRODUCTS VALUES('REI','2A45C','Ratchet Link',79.00,210);
INSERT INTO #PRODUCTS VALUES('ACI','4100Y','Widget Remover',2750.00,25);
INSERT INTO #PRODUCTS VALUES('QSA','XK47 ','Reducer',355.00,38);
INSERT INTO #PRODUCTS VALUES('BIC','41627','Plate',180.00,0);
INSERT INTO #PRODUCTS VALUES('IMM','779C ','900-LB Brace',1875.00,9);
INSERT INTO #PRODUCTS VALUES('ACI','41003','Size 3 Widget',107.00,207);
INSERT INTO #PRODUCTS VALUES('ACI','41004','Size 4 Widget',117.00,139);
INSERT INTO #PRODUCTS VALUES('BIC','41003','Handle',652.00,3);
INSERT INTO #PRODUCTS VALUES('IMM','887P ','Brace Pin',250.00,24);
INSERT INTO #PRODUCTS VALUES('QSA','XK48 ','Reducer',134.00,203);
INSERT INTO #PRODUCTS VALUES('REI','2A44L','Left Hinge',4500.00,12);
INSERT INTO #PRODUCTS VALUES('FEA','112  ','Housing',148.00,115);
INSERT INTO #PRODUCTS VALUES('IMM','887H ','Brace Holder',54.00,223);
INSERT INTO #PRODUCTS VALUES('BIC','41089','Retainer',225.00,78);
INSERT INTO #PRODUCTS VALUES('ACI','41001','Size 1 Wiget',55.00,277);
INSERT INTO #PRODUCTS VALUES('IMM','775C ','500-lb Brace',1425.00,5);
INSERT INTO #PRODUCTS VALUES('ACI','4100Z','Widget Installer',2500.00,28);
INSERT INTO #PRODUCTS VALUES('QSA','XK48A','Reducer',177.00,37);
INSERT INTO #PRODUCTS VALUES('ACI','41002','Size 2 Widget',76.00,167);
INSERT INTO #PRODUCTS VALUES('REI','2A44R','Right Hinge',4500.00,12);
INSERT INTO #PRODUCTS VALUES('IMM','773C ','300-lb Brace',975.00,28);
INSERT INTO #PRODUCTS VALUES('ACI','4100X','Widget Adjuster',25.00,37);
INSERT INTO #PRODUCTS VALUES('FEA','114  ','Motor Mount',243.00,15);
INSERT INTO #PRODUCTS VALUES('IMM','887X ','Brace Retainer',475.00,32);
INSERT INTO #PRODUCTS VALUES('REI','2A44G','Hinge Pin',350.00,14);

--2.3.	Добавьте в эту же временную таблицу запись о товаре, используя ограничения NULL и DEFAULT.
INSERT INTO #PRODUCTS VALUES('FEA','2A73S','Pinge Hin',350.00,23);


--2.4.	Добавьте в эту же временную таблицу запись о товаре, и одновременно добавьте эти же данные в таблицу аудита (в столбце операция укажите INSERT, в столбце даты – текущую дату).
INSERT INTO #PRODUCTS VALUES('ISA','347P ','Prace Bin',250.00,31);
INSERT INTO audit VALUES(getdate(), 'INSERT', 'ISA','2A44G');

--2.5.	Обновите данные о товарах во временной таблице – добавьте 20% к цене.
UPDATE #PRODUCTS SET PRICE = (PRICE * 1.2) WHERE MFR_ID IN ('REI', 'ACI', 'IMM', 'FEA', 'IMM', 'QSA');

--2.7.	Обновите данные о товаре во временной таблице, и одновременно добавьте эти же данные в таблицу аудита (в столбце операция укажите UPDATE, в столбце даты – текущую дату).
UPDATE #PRODUCTS SET PRICE = (PRICE * 1.1) WHERE MFR_ID = 'QSA';
INSERT INTO audit VALUES(getdate(), 'UPDATE', 'QSA', 'test');

--2.9.	Удалите данные о каком-либо товаре во временной таблице, и одновременно добавьте эти данные в таблицу аудита (в столбце операция укажите DELETE, в столбце даты – текущую дату).

delete from #products where mfr_id = 'BIC';
INSERT INTO audit VALUES(getdate(), 'DELETE', 'BIC','test');

--3.	Создайте представления:
--3.1.	Покупателей, у которых есть заказы выше определенной суммы.

create view CustomerPrice
	as select order_num, cust, amount from orders
	where amount > 30000;

select * from CustomerPrice;

--3.2.	Сотрудников, у которых офисы находятся в восточном регионе.
create view EmplEast
	as select empl_num from salesreps 
	where rep_office in (
	select office from offices where region = 'Eastern');

select * from EmplEast;

--3.3.	Заказы, оформленные в 2008 году.

create view Orders2008
	as select order_num, order_date from orders
	where order_date between '2008-01-01' and '2008-12-31';

select * from Orders2008;

--3.4.	Сотрудники, которые не оформили ни одного заказа.

create view LazyEmpl
	as select f.empl_num, f.name from salesreps f
	where not exists (select s.rep from orders s 
	where s.rep = f.empl_num);

select * from LazyEmpl;


select * from audit;
select * from salesreps;
select * from offices;
select * from products;
select * from orders;
select * from customers;
drop table #audit;
select * from #products;
