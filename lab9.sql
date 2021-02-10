use Savelyeva_04;

--Индексы в T-SQL.
--1.	Найдите все индексы для таблиц базы данных.

--представления индексов
select * from sys.indexes;
select * from sys.index_columns;
select * from sys.dm_db_index_usage_stats;
select * from sys.dm_db_missing_index_details exec sp_helpindex 'customers'

--2.	Создайте индекс для таблицы для одного столбца и продемонстрируйте его применение.

select * from offices exec sp_helpindex 'offices';

--0.00146685 до создания индекса
select * from offices 
where target between 350000 and 730000
order by target;
--0.006897 после создания индекса
create index OfficeIndex on offices(target);

drop index OfficeIndex on offices;

--3.	Создайте индекс для таблицы для нескольких столбцов и продемонстрируйте его применение.

--0.0067678 до создания индекса
select * from orders where cust = (
select cust_num from customers where company = 'Orion Corp.')
order by order_num;
--0.0067678 после создания индекса
create index OrdersIndex on orders(cust, amount)
exec sp_helpindex 'orders';

drop index OrdersIndex on orders;
select * from orders;

--4.	Создайте фильтрующий индекс для таблицы и продемонстрируйте его применение.
--5.	Создайте индекс покрытия для таблицы и продемонстрируйте его применение.
--6.	Создайте индекс для запроса с соединением таблиц и продемонстрируйте его применение.

--0.014702 до создания индекса
select city, target, sales from offices
where sales > 10000 order by sales;
--0.0078774 после создания индекса
create index OfficesFilter on offices(sales) include(target) where sales >= 9000;

drop index OfficesFilter on offices;

--7.	Покажите состояние индексов для таблицы и продемонстрируйте их перестройку и реорганизацию.

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('offices'), null, null, null)
alter index OfficesFilter on offices reorganize;

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('orders'),null, null, null)
alter index OrdersIndex on orders rebuild with (online = off);

--8.	Для запросов, разработанных в лабораторной работе № 3, покажите и проанализируйте планы запросов.
--9.	Создайте индексы для оптимизации запросов из лабораторной работы № 3.
--10.	Создайте необходимые индексы для базы данных своего варианта.

-- 3.27.	Найти всех покупателей и их заказы.
--0.0119195 до создания индекса
select a.company, b.product, b.mfr, b.amount 
from customers a join orders b on b.cust = a.cust_num
order by company;
--0.0119195 после создания индекса

select * from sys.dm_db_index_physical_stats(DB_ID('Savelyeva_04'), OBJECT_ID('customers'), null, null, null);
create index CustomersIndex on customers(company);
create index OrdersIndex1 on orders(product);

drop index CustomersIndex on customers;
drop index OrdersIndex1 on orders;