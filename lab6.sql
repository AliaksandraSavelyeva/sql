use Savelyeva_04;
select * from customers;
--���������������� T-SQL.
--1.	����������� �������� ���������: 
--1.1.	���������� ������ �������; ��� ������� ������������ ������ � ������� ��������� �� ������.

create procedure AddNewCustomer (@cust_num int, @company varchar(20), @cust_rep int, @limit decimal(9, 2))
as
declare @rc int = 0;
begin
begin try
	insert into customers (cust_num, company, cust_rep, credit_limit) values (@cust_num, @company, @cust_rep, @limit)
end try
begin catch
	set @rc = -1
	print '������';
end catch
return @rc;
end

declare @cust_num1 int, @company1 varchar(20), @cust_rep1 int, @limit1 decimal(9, 2);
	set @cust_num1 = 1234
	set @company1 = 'IBM'
	set @cust_rep1 = 103
	set @limit1 = 1250000.00
exec AddNewCustomer @cust_num1, @company1, @cust_rep1, @limit1;

drop procedure AddNewCustomer;
select * from customers;

--1.2.	������ ������� �� ����� ��������; ���� ������ �� ������� � ������� ���������.

create procedure FindCustomer @part_name varchar(4)
as
begin
	if not exists (select company from customers where company like '%' + @part_name + '%')
	print '������';
	else
	select company from customers where company like '%' + @part_name + '%'
end

exec FindCustomer @part_name = 'in';

drop procedure FindCustomer;

--1.3.	���������� ������ �������.
create procedure UpdateCustomer @id int
as
declare @rc int = 0;
begin
	begin try
		update customers set credit_limit = 30000.00
		where cust_rep = @id;
	end try
	begin catch
		set @rc = -1
		print '������';
	end catch
return @rc;
end

exec UpdateCustomer @id = 103;
drop procedure UpdateCustomer;

select * from customers where cust_rep = 103;

--1.4.	�������� ������ � �������; ���� � ������� ���� ������, � ��� ������ ������� � ������� ���������. 
select * from customers;
select * from orders;

create procedure DeleteCustomers
as
begin
	declare @done_orders_num int = (select count(c.cust_num) from customers c left join orders o
	on c.cust_num = o.cust where o.order_num is null);
	if @done_orders_num <> 0
	begin
		select cust_num as user_id into #temp_cust 
		from customers c left join orders o 
		on c.cust_num = o.cust
		where o.order_num is null;
		delete from customers where cust_num in (select user_id from #temp_cust);
	end
	else 
	begin 
		print '������';
	end
end

exec DeleteCustomers;

select * from customers;
drop procedure DeleteCustomers;

--insert into customers values (2105, 'AAA Investments', 101, 45000.00);
--insert into customers values (2115, 'Smithson Corp.', 101, 20000.00);
--insert into customers values (2119, 'Solomon Inc.', 109, 25000.00);
--insert into customers values (2121, 'QMA Assoc.', 103, 45000.00);
--insert into customers values (2122, 'Three Way Lines', 105, 30000.00); 
--insert into customers values (2123, 'Carter \& Sons', 102, 40000.00);
--insert into customers values (2125, 'Liuws',101,10000.00);

--3.	����������� ���������������� �������: 
--3.1.	���������� ���������� ������� ���������� � ������������ ������. ���� ������ ���������� ��� � ������� -1. ���� ��������� ����, 
--� ������� ��� � ������� 0.

create function CountOrders(@rep int, @datefrom date, @dateto date) returns int
begin
	declare @rc int = -1;
	
	if (select empl_num from salesreps where empl_num = @rep) is null
	return @rc;

	set @rc = (select count(order_num) from orders where rep = @rep and 
		order_date between @datefrom and @dateto);
	return @rc;
end;

declare @rep int = 0;
set @rep = dbo.CountOrders(189, '2006-01-12', '2008-01-01');
select empl_num, name, dbo.CountOrders(empl_num, '2006-01-12', '2008-01-01') from salesreps;
print @rep;

--3.2.	���������� ���������� ������� ��������� �������������� ����� ���� ���������. 

create function GoodCount() returns table
as return
(select mfr, count(product) as count_prod from orders where amount > 10000 group by mfr)
go

select * from GoodCount();
go


--3.3.	���������� ���������� ���������� ������� ��� ������������� �������������.
create function MfrGoodCount(@mfr varchar(10)) returns table
as return
(select mfr, count(product) as count_prod from orders
where mfr = @mfr group by mfr)
go

declare @mfr varchar(10) = 'IMM'
select * from MfrGoodCount(@mfr);



