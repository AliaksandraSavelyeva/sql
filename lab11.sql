use Savelyeva_04;

--Специальные типы данных в SQL Server - XML.
--1.	Создайте XML файл из таблиц базы данных следующего вида:
--1.1.	Иерархия XML: Office List – Region – City – Employee.
--1.2.	Корневым элементом является «Office List», атрибут – Employee_Count (общее количество сотрудников).
--1.3.	Элемент Region, атрибуты – Region_Name (наименование региона), Region_Employee_Count (общее количество сотрудников в регионе).
--1.4.	Элемент City, атрибуты – City_Name (наименование города), City_Employee_Count (общее количество сотрудников в городе), City_Chef (фамилия руководителя подразделения).
--1.5.	Элемент Employee, атрибуты – Employee_Name (имя сотрудника), Employee_Title (должность сотрудника), Hire_Date (дата найма).
--1.6.	Элементы должны быть отсортированы по алфавиту.

create view office_count as
select count(empl_num) as employee_count from salesreps;
select * from office_count;

create view region_office_count as
select region, count(empl_num) as region_employee_count
from offices o join salesreps s
on o.office = s.rep_office
group by region;
select * from region_office_count;

create view office_chef as
select o.city as city, o.region as region, 
s.name as city_chef, o.office as office
from offices o join salesreps s
on o.mgr = s.empl_num;
select * from office_chef;

create view city_office_count as
select o.city, count(s.empl_num) as city_employee_count,
min(o.region) as region, min(o.city_chef) as city_chef, min(o.office) as office
from office_chef o join salesreps s
on o.office = s.rep_office
group by city;
select * from city_office_count;

drop view office_chef;

-------

select
	employee_count as '@employee_count',
	(select 
		o1.region as '@region_name',
		region_employee_count as '@region_employee_count',
		(select o2.city as '@city_name',
			o2.city_employee_count as '@city_employee_count',
			o2.city_chef as 'city_chef',
			(select s.name as '@employee_name',
				s.title as '@employee_title',
				s.hire_date as '@hire_date'
			from salesreps s
			where s.rep_office = o2.office
			order by s.name
			for xml path ('employee'), type)
		from city_office_count o2
		where o2.region = o1.region
		order by o2.city
		for xml path ('city'), type)
	from region_office_count o1
	order by o1.region
	for xml path ('region'), type)
from office_count v
for xml path ('office_list');

--2.	Отредактируйте полученный XML файл.

declare @xml_table xml;
set @xml_table = 
	'<office_list employee_count="10">
	  <region region_name="Eastern" region_employee_count="6">
		<city city_name="Atlanta" city_employee_count="1">
		  <city_chef>Bill Adams</city_chef>
		  <employee employee_name="Bill Adams" employee_title="Sales Rep" hire_date="2006-02-12" />
		</city>
		<city city_name="Chicago123" city_employee_count="3">
		  <city_chef>Bob Smith</city_chef>
		  <employee employee_name="Bob Smith" employee_title="Sales Mgr" hire_date="2005-05-19" />
		  <employee employee_name="Dan Roberts" employee_title="Sales Rep" hire_date="2004-10-20" />
		  <employee employee_name="Paul Cruz" employee_title="Sales Rep" hire_date="2005-03-01" />
		</city>
		<city city_name="New York" city_employee_count="2">
		  <city_chef>Sam Clark</city_chef>
		  <employee employee_name="Mary Jones" employee_title="Sales Rep" hire_date="2007-10-12" />
		  <employee employee_name="Sam Clark" employee_title="VP Sales" hire_date="2006-06-14" />
		</city>
	  </region>
	  <region region_name="Western" region_employee_count="3">
		<city city_name="Denver" city_employee_count="1">
		  <city_chef>Larry Fitch</city_chef>
		  <employee employee_name="Nancy Angelli" employee_title="Sales Rep" hire_date="2006-11-14" />
		</city>
		<city city_name="Los Angeles" city_employee_count="2">
		  <city_chef>Larry Fitch</city_chef>
		  <employee employee_name="Larry Fitch" employee_title="Sales Mgr" hire_date="2007-10-12" />
		  <employee employee_name="Sue Smith" employee_title="Sales Rep" hire_date="2004-12-10" />
		</city>
	  </region>
	</office_list>';

set @xml_table.modify('
	insert <employee employee_name="John Doe" employee_title="Sales Mgr" hire_date="2020-03-01" />
	into (/office_list/region/city)[1]
');

set @xml_table.modify('
	replace value of (/office_list/region/@region_employee_count)[1]
	with 666
');

set @xml_table.modify('
	delete (/office_list/region/city/employee)[1]
');

select @xml_table;

--3.	Преобразуйте отредактированный XML файл в таблицы базы данных.

declare @hdoc int;
declare @doc varchar(max);
set @doc = '<?xml version="1.0" encoding="UTF-8" ?>
	<office_list employee_count="10">
	  <region region_name="Eastern" region_employee_count="6">
		<city city_name="Atlanta" city_employee_count="1">
		  <city_chef>Bill Adams</city_chef>
		  <employee employee_name="Bill Adams" employee_title="Sales Rep" hire_date="2006-02-12" />
		</city>
		<city city_name="Chicago123" city_employee_count="3">
		  <city_chef>Bob Smith</city_chef>
		  <employee employee_name="Bob Smith" employee_title="Sales Mgr" hire_date="2005-05-19" />
		  <employee employee_name="Dan Roberts" employee_title="Sales Rep" hire_date="2004-10-20" />
		  <employee employee_name="Paul Cruz" employee_title="Sales Rep" hire_date="2005-03-01" />
		</city>
		<city city_name="New York" city_employee_count="2">
		  <city_chef>Sam Clark</city_chef>
		  <employee employee_name="Mary Jones" employee_title="Sales Rep" hire_date="2007-10-12" />
		  <employee employee_name="Sam Clark" employee_title="VP Sales" hire_date="2006-06-14" />
		</city>
	  </region>
	  <region region_name="Western" region_employee_count="3">
		<city city_name="Denver" city_employee_count="1">
		  <city_chef>Larry Fitch</city_chef>
		  <employee employee_name="Nancy Angelli" employee_title="Sales Rep" hire_date="2006-11-14" />
		</city>
		<city city_name="Los Angeles" city_employee_count="2">
		  <city_chef>Larry Fitch</city_chef>
		  <employee employee_name="Larry Fitch" employee_title="Sales Mgr" hire_date="2007-10-12" />
		  <employee employee_name="Sue Smith" employee_title="Sales Rep" hire_date="2004-12-10" />
		</city>
	  </region>
	</office_list>';
exec sp_xml_preparedocument @hdoc output, @doc;

select * from openxml (@hdoc, '/office_list/region', 1)
with (region varchar(20) '@region_name',
count_reg int '@region_employee_count');

--4.	Создайте XML-схему из Приложения 1, предварительно внесите какие-нибудь изменения.

create xml schema collection EmployeeSchema as
'<?xml version="1.0" encoding="UTF-8" ?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="order">
      <xs:complexType>
         <xs:sequence>
            <xs:element name="customer" type="xs:string"/>
            <xs:element name="address">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="factaddress" type="xs:string"/>
                     <xs:element name="city" type="xs:string"/>
                     <xs:element name="country" type="xs:string"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
            <xs:element name="item" maxOccurs="unbounded">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="partnumber" type="xs:string"/>
                     <xs:element name="description" type="xs:string" minOccurs="0"/>
                     <xs:element name="quantity" type="xs:positiveInteger"/>
                     <xs:element name="price" type="xs:decimal"/>
					 <xs:element name="discount" type="xs:decimal"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
         </xs:sequence>
         <xs:attribute name="orderid" type="xs:string" use="required"/>
         <xs:attribute name="orderdate" type="xs:date" use="required"/>
      </xs:complexType>
   </xs:element>
</xs:schema>'

--5.	Создайте таблицу Imported_XML (столбцы – Id, Import_Date, XML_Text). Назначьте созданную схему для XML-столбца.

create table Imported_XML (id int primary key, import_date date, xml_text xml (EmployeeSchema));
select * from Imported_XML;

select xml_text.query('/order/customer') from Imported_XML
for xml auto, type;

drop table Imported_xml;
--6.	Создайте три XML файла ((1), (2), (3)), два из которых должны соответствовать схеме, а один не соответствует.
--7.	Загрузите созданные XML файлы (1), (2) в столбец XML_Text таблицы Imported_XML. Поясните ошибку при загрузке файла (3), не соответствующего схеме. 
--8.	Исправьте XML файл (3) и загрузите его в столбец XML_Text таблицы Imported_XML.

--select xml_text from Imported_XML for xml path ('order');

declare @xml_1 xml;
set @xml_1 = 
'<order orderid="1" orderdate="2005-03-01">
	<customer>John Doe</customer>
	<address>
		<factaddress>test111</factaddress>
		<city>New York</city>
		<country>USA</country>
	</address>
	<item>
		<partnumber>13243</partnumber>
		<description>Item1</description>
		<quantity>11</quantity>
		<price>54567</price>
		<discount>100</discount>
	</item>
</order>';
insert into Imported_XML values (1,'2021-01-01', @xml_1);

declare @xml_2 xml;
set @xml_2 = 
'<order orderid="2" orderdate="2005-03-01">
	<customer>Jane Doe</customer>
	<address>
		<factaddress>test222</factaddress>
		<city>New York</city>
		<country>USA</country>
	</address>
	<item>
		<partnumber>13243</partnumber>
		<description>Item2</description>
		<quantity>11</quantity>
		<price>54567</price>
		<discount>100</discount>
	</item>
</order>';
insert into Imported_XML values (2,'2021-01-01', @xml_2);

declare @xml_3 xml;
set @xml_3 = 
'<order orderid="3" orderdate="2005-03-01">
	<customer>Johanna Doe</customer>
	<address>
		<factaddress>test333</factaddress>
		<city>New York</city>
		<country>USA</country>
	</address>
	<item>
		<partnumber>13243</partnumber>
		<description>Item1</description>
		<quantity>11</quantity>
		<price>54567</price>
	</item>
</order>';
insert into Imported_XML values (3,'2021-01-01', @xml_3);
--XML Validation: Invalid content. Expected element(s): 'discount'. Location: /*:order[1]/*:item[1]
--исправленный вариант
declare @xml_3 xml;
set @xml_3 = 
'<order orderid="3" orderdate="2005-03-01">
	<customer>Johanna Doe</customer>
	<address>
		<factaddress>test333</factaddress>
		<city>New York</city>
		<country>USA</country>
	</address>
	<item>
		<partnumber>13243</partnumber>
		<description>Item1</description>
		<quantity>11</quantity>
		<price>54567</price>
		<discount>100</discount>
	</item>
</order>';
insert into Imported_XML values (3,'2021-01-01', @xml_3);

declare @xml_sch xml (EmployeeSchema);
set @xml_sch = '<order orderid="4" orderdate="2025-02-12"/>' 

--9.	Создайте индекс по XML-столбцу для таблицы Imported_XML.

create primary xml index i_imported_xml on Imported_xml(xml_text);
select * from sys.xml_indexes;

--10.	Найдите: 
--10.1.	значения определенного узла для (3).

select xml_text.query('/order[@orderid="3"]/address')
from Imported_xml for xml auto, type;

--10.2.	значения определенного узла для всех файлов.

select xml_text.query('/order/address/*')
from Imported_xml for xml auto, type;

--10.3.	значения определенного атрибута для (1), (2).

select xml_text.query('/order[@orderid = "1" or @orderid = "2"]/address')
from Imported_xml for xml auto, type;

--10.4.	значения определенного атрибута для всех файлов.

select xml_text.query('/order[@orderdate]') 
from Imported_xml for xml auto, type;
