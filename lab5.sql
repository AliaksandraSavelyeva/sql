use Savelyeva_04;

select * from PRODUCTS;

--1.	Разработать T-SQL-скрипт  следующего содержания: 
--1.1.	объявить переменные типа: char, varchar, datetime, time, int, smallint,  tinint, numeric(12, 5).
--1.2.	первые две переменные проинициализировать в операторе объявления.

declare @var1 char(20) = 'test variable',
	@var2 varchar(50) = 'test varchar variable',
	@var3 datetime,
	@var4 time,
	@var5 int,
	@var6 smallint,
	@var7 tinyint,
	@var8 numeric(12, 5);

--1.3.	присвоить  произвольные значения следующим двум переменным с помощью оператора SET, одной из  этих переменных  присвоить значение, полученное в результате запроса SELECT.

set @var3 = '2015-03-15 21:36:45';
select @var4 = '05:32:49';
--select @var3, @var4;
--go

--1.4.	одну из переменных оставить без инициализации и не присваивать ей значения, оставшимся переменным присвоить некоторые значения с помощью оператора SELECT;

--select * from products;

declare @quantity int = (select sum(QTY_ON_HAND) as int from products),
		@profit numeric(10, 2) = (select cast(avg(PRICE) as numeric(10, 2)) from products),
		@max_price smallint = (select cast(max(PRICE) as smallint) from products);
--select @quantity as qty, @profit as income, @max_price as maxprice;
--go

--1.5.	значения половины переменных вывести с помощью оператора SELECT, значения другой половины переменных распечатать с помощью оператора PRINT. 

select @var1 'test', @var2 'test1', @var3 'datetime';
print cast(@quantity as varchar(10)) + ' ' + cast(@profit as varchar(10)) + ' ' + cast(@max_price as varchar(5));
go

--2.	Разработать скрипт, в котором определяется средняя стоимость продукта. Если средняя стоимость продукта превышает 10, то вывести количество продуктов, среднюю стоимость продукта, максимальную стоимость продукта. Если средняя стоимость продукта меньше 10, то вывести минимальную стоимость продукта. 

--select * from products;

declare @avg_price decimal(9, 2),
		@amount int,
		@max_price decimal(9, 2),
		@min_price decimal(9, 2);

set @avg_price = (select cast(avg(price) as decimal(9, 2)) from products);
set @amount = (select cast(count(product_id) as int) from products);
set @max_price = (select cast(max(price) as decimal(9, 2)) from products);
set @min_price = (select cast(min(price) as decimal(9, 2)) from products);

if @avg_price>10 print 'Количество продуктов: ' + cast(@amount as varchar(5)) + 
', средняя стоимость продукта: ' + cast(@avg_price as varchar(10)) + 
', максимальная стоимость продукта: ' + cast(@max_price as varchar(10))
else if @avg_price<10 print 'Минимальная стоимость продукта: ' + cast(@min_price as varchar(10))
else print 'Средняя стоимость продукта = 10';
go

--3.	Подсчитать количество заказов сотрудника в определенный период. 
--select * from orders;

select rep, count(order_num) as order_amount from orders
where year(order_date) = 2007
group by rep;

--4.	Разработать T-SQL-скрипты, выполняющие: 
--4.1.	преобразование имени сотрудника в инициалы.
--len() - количество символов в строке (параметр - строка)
--substring() - возвращает подстроку (параметры - строка, начальный индекс, длина подстроки)
--charindex() - возвращает индекс первого вхождения подстроки в строке (параметры - подстрока, строка)

--select * from salesreps;

select substring(name, 1, 1) + '. ' 
+ substring(name, charindex(' ', name) + 1, len(name) - charindex(' ', name))
as rep_name from salesreps;

--4.2.	поиск сотрудников, у которых дата найма в следующем месяце.
--dateadd() - возвращает datetime, которое получается путём прибавления к дате какого-то интервала

select * from salesreps where month(hire_date) = month(dateadd(month, 1, getdate())); 

--4.3.	поиск сотрудников, которые проработали более 10 лет.
--datediff() - возвращает разницу между двумя датами

select * from salesreps where datediff(year, hire_date, getdate()) > 10;

--4.4.	поиск дня недели, в который делались заказы.
--datename() - возвращает часть даты в виде строки

select datename(weekday, order_date) as order_day from orders;

--6.	Продемонстрировать применение оператора CASE.
select name, age, 'retirement' = 
	case 
		when age < 60 then 'is working'
		else 'is retired'
	end
from salesreps
order by age;
go

--7.	Продемонстрировать применение оператора WHILE
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
		if (@x % 2 = 0) print 'Число делится на два' 
		set @x = @x + 1;
		set @number = @number + 1;
	end
go
		 
