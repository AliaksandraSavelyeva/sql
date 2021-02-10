use Savelyeva_04;

--������� � T-SQL.
--1.	������� ��� ������� ��� ������ ���� ������.

--������������� ��������
select * from sys.indexes;
select * from sys.index_columns;
select * from sys.dm_db_index_usage_stats;
select * from sys.dm_db_missing_index_details exec sp_helpindex 'customers'

--2.	�������� ������ ��� ������� ��� ������ ������� � ����������������� ��� ����������.

select * from offices exec sp_helpindex 'offices';

--0.00146685 �� �������� �������
select * from offices 
where target between 350000 and 730000
order by target;
--0.006897 ����� �������� �������
create index OfficeIndex on offices(target);

drop index OfficeIndex on offices;

--3.	�������� ������ ��� ������� ��� ���������� �������� � ����������������� ��� ����������.

--0.0067678 �� �������� �������
select * from orders where cust = (
select cust_num from customers where company = 'Orion Corp.')
order by order_num;
--0.0067678 ����� �������� �������
create index OrdersIndex on orders(cust, amount)
exec sp_helpindex 'orders';

drop index OrdersIndex on orders;
select * from orders;

--4.	�������� ����������� ������ ��� ������� � ����������������� ��� ����������.
--5.	�������� ������ �������� ��� ������� � ����������������� ��� ����������.
--6.	�������� ������ ��� ������� � ����������� ������ � ����������������� ��� ����������.

--0.014702 �� �������� �������
select city, target, sales from offices
where sales > 10000 order by sales;
--0.0078774 ����� �������� �������
create index OfficesFilter on offices(sales) include(target) where sales >= 9000;

drop index OfficesFilter on offices;

--7.	�������� ��������� �������� ��� ������� � ����������������� �� ����������� � �������������.

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('offices'), null, null, null)
alter index OfficesFilter on offices reorganize;

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('orders'),null, null, null)
alter index OrdersIndex on orders rebuild with (online = off);

--8.	��� ��������, ������������� � ������������ ������ � 3, �������� � ��������������� ����� ��������.
--9.	�������� ������� ��� ����������� �������� �� ������������ ������ � 3.
--10.	�������� ����������� ������� ��� ���� ������ ������ ��������.

-- 3.27.	����� ���� ����������� � �� ������.
--0.0119195 �� �������� �������
select a.company, b.product, b.mfr, b.amount 
from customers a join orders b on b.cust = a.cust_num
order by company;
--0.0119195 ����� �������� �������

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('customers'), null, null, null);
create index CustomersIndex on customers(company);
create index OrdersIndex1 on orders(product);

drop index CustomersIndex on customers;
drop index OrdersIndex1 on orders;