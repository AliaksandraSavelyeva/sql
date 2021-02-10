use Savelyeva_04;

--Триггеры в T-SQL.
--1.	Разработать следующие DML триггеры и продемонстрировать работоспособность триггеров: 
--1.1.	При добавлении нового офиса добавлять строку с данными офиса в таблицу Audit.

create table audit_tr (
	audit_date date not null,
	operation char(15),
	office int,
	city varchar(15) not null,
	region varchar(15) not null,
	mng int null,
	limit decimal(9, 2) null,
	sales decimal(9, 2) not null
);

create trigger UpdateOffice
on offices
after insert
as
begin
	declare 
		@office int, 
		@city varchar(15),
		@region varchar(15),
		@mng int,
		@limit decimal(9, 2),
		@sales decimal(9, 2);

	select @office = (select office from inserted);
	select @city = (select city from inserted);
	select @region = (select region from inserted);
	select @mng = (select mgr from inserted);
	select @limit = (select target from inserted);
	select @sales = (select sales from inserted);

	insert into audit_tr values (getdate(), 'INSERT', 
	@office, @city, @region, @mng, @limit, @sales)
end;

insert into offices values(18, 'City1', 'Western', 104, 95000.00, 12345.00);
insert into offices values(19, 'City2', 'Eastern', 105, 105000.00, 12345.00);
insert into offices values(20, 'City3', 'Western', 108, 45000.00, 12345.00);

select * from offices;
select * from audit_tr;

drop trigger UpdateOffice;

--1.2.	При обновлении данных офиса добавлять строку с предыдущими данными офиса в таблицу Audit.

create trigger UpdateOffice2
on offices
after update
as
begin 
	declare 
		@office int, 
		@city varchar(15),
		@region varchar(15),
		@mng int,
		@limit decimal(9, 2),
		@sales decimal(9, 2);

	select @office = (select office from deleted);
	select @city = (select city from deleted);
	select @region = (select region from deleted);
	select @mng = (select mgr from deleted);
	select @limit = (select target from deleted);
	select @sales = (select sales from deleted);

	insert into audit_tr values (getdate(), 'UPDATE', 
	@office, @city, @region, @mng, @limit, @sales)
end;

update offices set city = 'Moscow' where city = 'City1';

select * from audit_tr;

drop trigger UpdateOffice2;

--1.3.	При удалении данных о офиса добавлять строку с данными офиса в таблицу Audit. 
create trigger UpdateOffice3
on offices
after delete
as
begin 
	declare 
			@office int, 
			@city varchar(15),
			@region varchar(15),
			@mng int,
			@limit decimal(9, 2),
			@sales decimal(9, 2);

	select @office = (select office from deleted);
	select @city = (select city from deleted);
	select @region = (select region from deleted);
	select @mng = (select mgr from deleted);
	select @limit = (select target from deleted);
	select @sales = (select sales from deleted);

	insert into audit_tr values (getdate(), 'DELETE', 
	@office, @city, @region, @mng, @limit, @sales)
end;

delete offices where office = 14;

select * from audit_tr;
select * from offices;

drop trigger UpdateOffice3;

--2.	Разработать скрипт, который демонстрирует, что проверка ограничения целостности выполняется до срабатывания AFTER-триггера.
create table temp (
	id int primary key,
	val varchar(16)
);

create table #temp_tr (
	id int,
	val varchar(16)
);

create trigger DemoTrigger
on temp
after insert
as
begin
	declare @id int, @val varchar(16);
	select @id = (select id from inserted);
	select @val = (select val from inserted);
	insert into #temp_tr values (@id, @val)
end;

--Violation of PRIMARY KEY constraint 'PK__temp__3213E83FB4BDA565'. Cannot insert duplicate key in object 'dbo.temp'. The duplicate key value is (1).
--The statement has been terminated.
insert into temp values (1, 'Test1');

select * from temp;
select * from #temp_tr;

drop table temp;
drop table #temp_tr;
drop trigger DemoTrigger;

--3.	 Создать 3 триггера, срабатывающих на событие удаления в таблице и упорядочить их.

create table audit_tr1 (
	empl_num int not null,
	operation char(15),
	NAME VARCHAR(15) NOT NULL,
    AGE INTEGER,
	REP_OFFICE INTEGER,
    QUOTA DECIMAL(9,2),
    SALES DECIMAL(9,2) NOT NULL
);

create trigger UpdateSalesRep1
on salesreps
after delete
as
begin 
	declare 
			@empl_num int, 
			@name varchar(15),
			@age int,
			@rep_office int,
			@quota decimal(9, 2),
			@sales decimal(9, 2);

	select @empl_num = (select empl_num from deleted);
	select @name = (select name from deleted);
	select @age = (select age from deleted);
	select @rep_office = (select rep_office from deleted);
	select @quota = (select quota from deleted);
	select @sales = (select sales from deleted);

	insert into audit_tr1 values (@empl_num, 'DELETE', 
	@name, @age, @rep_office, @quota, @sales)
end;

delete salesreps where empl_num = 104;

select * from audit_tr1;
select * from salesreps;

--4.	Разработать скрипт, демонстрирующий, что AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший триггер.
--5.	 Создать триггер на обновление для представления. Продемонстрировать работоспособность триггера.

create view EmplEastView (empl_num, name, rep_office, city)
	as select salesreps.empl_num, salesreps.name, salesreps.rep_office, offices.city
	from salesreps, offices
	where salesreps.rep_office = offices.office;

select * from EmplEastView;

--операторы DML не допускаются в сложном представлении
update EmplEastView set city = 'Chicago123'
where empl_num = 101;

create trigger UpdateView 
on EmplEastView
instead of update
as
begin
	update offices set city = 'Chicago123'
	where office = 12;
end;

update EmplEastView set city = 'Chicago123'
where rep_office = 12;

select * from EmplEastView;
select * from salesreps;
select * from offices;
drop view EmplEastView;

--6.	Создать триггер уровня базы данных. Продемонстрировать работоспособность триггера.
--7.	Удалить все триггеры.

drop trigger UpdateOffice;
drop trigger UpdateOffice2;
drop trigger UpdateOffice3;
drop trigger DemoTrigger;
drop trigger UpdateView;
