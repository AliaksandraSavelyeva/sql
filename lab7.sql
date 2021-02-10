use Savelyeva_04;
--1.	����������� ������, ��������������� ������ � ������ ������� ����������.

set implicit_transactions on;
select @@trancount as "TRANCOUNT"
insert into products values('ABC','4V03S','Pratchet Ink',79.00,210);
select @@trancount as "TRANCOUNT"
while (@@trancount > 0) commit transaction;

select * from products;

--2.	����������� ������, ��������������� �������� ACID ����� ����������. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 
--XACT_STATE is a function that returns to the user the state of a running transaction

begin try
	begin transaction;
	delete from products where product_id = '4V03S';
	--commit transaction
end try
begin catch
	if (xact_state()) = -1
	begin 
		print '���������� �� ���������'
		rollback transaction;
	end;
	if (xact_state()) = 1
	begin 
		print '���������� ���������'
		commit transaction;
	end;
end catch;

--3.	����������� ������, ��������������� ���������� ��������� SAVETRAN. � ����� CATCH ������������� ������ ��������������� ��������� �� �������. 

begin transaction;
	insert into products values('AA1','7FC33','Evil Corp',345.00,252);
	save transaction a;
	
	insert into products values('AAB','565DF','Sradfhet Ltd',79.00,210);
	save transaction b;
	
	insert into products values('AAA','98SDF','SpaceX',3258.00,751);
	rollback transaction b;

	insert into products values('AA2','98WD0','NASA',6523.00,521);

	rollback transaction a;
commit transaction;


select * from products;
delete from products where mfr_id = 'AA1';
delete from products where mfr_id = 'AAB';
delete from products where mfr_id = 'AAA';

--4.	����������� ��� ������� A � B. ������������������ ����������������, ��������������� � ��������� ������. �������� �������� ������� ���������������.

create table demo (
	col1 int,
	col2 varchar(255)
);
go
-------1
begin transaction;
	insert into demo(col1, col2)
	values (99, '���������� ����������');
commit transaction;
begin transaction;
	insert into demo(col1, col2)
	values (42, '������� ������');

-------2
set transaction isolation level read uncommitted;
select * from demo;

commit transaction;
drop table demo;
go

--5.	����������� ������, ��������������� �������� ��������� ����������. 
begin transaction t1
	insert into customers values(1100,'AAA Inc.',103,90000.00);
	begin transaction t2
		update customers set cust_num = 1110 
		where company = 'AAA Inc.'
	commit transaction t1;
commit transaction t2;

select * from customers;

