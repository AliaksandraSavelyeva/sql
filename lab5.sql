use Savelyeva_04;

select * from PRODUCTS;

--1.	����������� T-SQL-������  ���������� ����������: 
--1.1.	�������� ���������� ����: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
--1.2.	������ ��� ���������� ������������������� � ��������� ����������.

declare @var1 char(20) = 'test variable',
	@var2 varchar(50) = 'test varchar variable',
	@var3 datetime,
	@var4 time,
	@var5 int,
	@var6 smallint,
	@var7 tinyint,
	@var8 numeric(12, 5);

--1.3.	���������  ������������ �������� ��������� ���� ���������� � ������� ��������� SET, ����� ��  ���� ����������  ��������� ��������, ���������� � ���������� ������� SELECT.

set @var3 = '2015-03-15 21:36:45';
select @var4 = '05:32:49';
--select @var3, @var4;
--go

--1.4.	���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, ���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT;

--select * from products;

declare @quantity int = (select sum(QTY_ON_HAND) as int from products),
		@profit numeric(10, 2) = (select cast(avg(PRICE) as numeric(10, 2)) from products),
		@max_price smallint = (select cast(max(PRICE) as smallint) from products);
--select @quantity as qty, @profit as income, @max_price as maxprice;
--go

--1.5.	�������� �������� ���������� ������� � ������� ��������� SELECT, �������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 

select @var1 'test', @var2 'test1', @var3 'datetime';
print cast(@quantity as varchar(10)) + ' ' + cast(@profit as varchar(10)) + ' ' + cast(@max_price as varchar(5));
go

--2.	����������� ������, � ������� ������������ ������� ��������� ��������. ���� ������� ��������� �������� ��������� 10, �� ������� ���������� ���������, ������� ��������� ��������, ������������ ��������� ��������. ���� ������� ��������� �������� ������ 10, �� ������� ����������� ��������� ��������. 

--select * from products;

declare @avg_price decimal(9, 2),
		@amount int,
		@max_price decimal(9, 2),
		@min_price decimal(9, 2);

set @avg_price = (select cast(avg(price) as decimal(9, 2)) from products);
set @amount = (select cast(count(product_id) as int) from products);
set @max_price = (select cast(max(price) as decimal(9, 2)) from products);
set @min_price = (select cast(min(price) as decimal(9, 2)) from products);

if @avg_price>10 print '���������� ���������: ' + cast(@amount as varchar(5)) + 
', ������� ��������� ��������: ' + cast(@avg_price as varchar(10)) + 
', ������������ ��������� ��������: ' + cast(@max_price as varchar(10))
else if @avg_price<10 print '����������� ��������� ��������: ' + cast(@min_price as varchar(10))
else print '������� ��������� �������� = 10';
go

--3.	���������� ���������� ������� ���������� � ������������ ������. 
--select * from orders;

select rep, count(order_num) as order_amount from orders
where year(order_date) = 2007
group by rep;

--4.	����������� T-SQL-�������, �����������: 
--4.1.	�������������� ����� ���������� � ��������.
--len() - ���������� �������� � ������ (�������� - ������)
--substring() - ���������� ��������� (��������� - ������, ��������� ������, ����� ���������)
--charindex() - ���������� ������ ������� ��������� ��������� � ������ (��������� - ���������, ������)

--select * from salesreps;

select substring(name, 1, 1) + '. ' 
+ substring(name, charindex(' ', name) + 1, len(name) - charindex(' ', name))
as rep_name from salesreps;

--4.2.	����� �����������, � ������� ���� ����� � ��������� ������.
--dateadd() - ���������� datetime, ������� ���������� ���� ����������� � ���� ������-�� ���������

select * from salesreps where month(hire_date) = month(dateadd(month, 1, getdate())); 

--4.3.	����� �����������, ������� ����������� ����� 10 ���.
--datediff() - ���������� ������� ����� ����� ������

select * from salesreps where datediff(year, hire_date, getdate()) > 10;

--4.4.	����� ��� ������, � ������� �������� ������.
--datename() - ���������� ����� ���� � ���� ������

select datename(weekday, order_date) as order_day from orders;

--6.	������������������ ���������� ��������� CASE.
select name, age, 'retirement' = 
	case 
		when age < 60 then 'is working'
		else 'is retired'
	end
from salesreps
order by age;
go

--7.	������������������ ���������� ��������� WHILE
declare @number int, @factorial int
set @factorial = 1;
set @number = 5;
 
while @number > 0
    begin
        set @factorial = @factorial * @number
        set @number = @number - 1
	end 
print @factorial;
go




declare @number int, @x int
set @number = 0;
set @x = 1;

while @number < 10 
	begin
		print @x;
		if (@x % 2 = 0) print '����� ������� �� ���' 
		set @x = @x + 1;
		set @number = @number + 1;
	end
go
		 
