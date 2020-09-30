/* 
1) каждая деталь состоит из операций
2) при изготовлении детали рабочий выполняет операции
3) при изготовлении детали указывается, какую именно деталь обрабатывает рабочий
*/

/* Таблица операций */
CREATE TABLE user39_PROCEDURE
(
  PROCNO INT NOT NULL,
  PROCNAME VARCHAR(25) NOT NULL,
  COMPLEX VARCHAR(15)
);

ALTER TABLE user39_PROCEDURE
  ADD CONSTRAINT user39_PROCEDURE_PK PRIMARY KEY (PROCNO);
ALTER TABLE user39_PROCEDURE
  ADD CONSTRAINT user39_PROCEDURE_UK UNIQUE (PROCNAME);

/* Таблица деталей */
CREATE TABLE user39_COMPONENT
(
  COMPNO INT NOT NULL,
  COMPNAME VARCHAR(20) NOT NULL
);

ALTER TABLE user39_COMPONENT
  ADD CONSTRAINT user39_COMPONENT_PK PRIMARY KEY (COMPNO);
ALTER TABLE user39_COMPONENT
  ADD CONSTRAINT user39_COMPONENT_UK UNIQUE (COMPNAME);

/* Промежуточная таблица */
CREATE TABLE user39_COMPPROC
(
  ID INT NOT NULL,
  COMPNO INT NOT NULL,
  PROCNO INT NOT NULL,
  NORM INT NOT NULL
);

ALTER TABLE user39_COMPPROC
  ADD CONSTRAINT user39_COMPPROC_PK PRIMARY KEY (ID);
ALTER TABLE user39_COMPPROC
  ADD CONSTRAINT user39_COMPPROC_PROCEDURE_FK FOREIGN KEY (PROCNO)
  REFERENCES user39_PROCEDURE (PROCNO);
ALTER TABLE user39_COMPPROC
  ADD CONSTRAINT user39_COMPPROC_COMPONENT_FK FOREIGN KEY (COMPNO)
  REFERENCES user39_COMPONENT (COMPNO);

/* Таблица работников */
CREATE TABLE user39_EMPLOYEE
(
  EMPNO INT NOT NULL,
  EMPNAME VARCHAR(30) NOT NULL,
  CELL INT,
  ADDR VARCHAR(30),
  EXPERIENCE INT NOT NULL
);

ALTER TABLE user39_EMPLOYEE
  ADD CONSTRAINT user39_EMPLOYEE_PK PRIMARY KEY (EMPNO);

/* Таблица рабочего времени */
CREATE TABLE user39_WORKHOURS
(
  ID INT NOT NULL,
  DATEW DATE NOT NULL,
  EMPNO INT NOT NULL,
  COMPNO INT NOT NULL,
  QUANTITY INT NOT NULL
);

ALTER TABLE user39_WORKHOURS
  ADD CONSTRAINT user39_WORKHOURS_PK PRIMARY KEY (ID);
ALTER TABLE user39_WORKHOURS
  ADD CONSTRAINT user39_WORKHOURS_EMPLOYEE_FK FOREIGN KEY (EMPNO)
  REFERENCES user39_EMPLOYEE (EMPNO);
ALTER TABLE user39_WORKHOURS
  ADD CONSTRAINT user39_WORKHOURS_COMPONENT_FK FOREIGN KEY (COMPNO)
  REFERENCES user39_COMPONENT (COMPNO);

/* Данные по операциям */
INSERT INTO user39_PROCEDURE VALUES (1,'Фрезерные работы','Высокая');
INSERT INTO user39_PROCEDURE VALUES (2,'Зубонарезные работы','Средняя');
INSERT INTO user39_PROCEDURE VALUES (3,'Токарные работы','Низкая');

/* Данные по деталям */
INSERT INTO user39_COMPONENT VALUES (1,'Втулка');
INSERT INTO user39_COMPONENT VALUES (2,'Клапан');
INSERT INTO user39_COMPONENT VALUES (3,'Дюбель');

/* Данные в промежуточной таблице */
INSERT INTO user39_COMPPROC VALUES (1, 1, 2, 16);
INSERT INTO user39_COMPPROC VALUES (2, 1, 3, 8);
INSERT INTO user39_COMPPROC VALUES (3, 2, 3, 9);

/* Данные по сотрудникам */
INSERT INTO user39_EMPLOYEE VALUES (1,'Иванов Иван Иванович', 1234567, 'ул. Красная, 5-122', 15);
INSERT INTO user39_EMPLOYEE VALUES (2,'Петров Петр Петрович', 3215647, 'ул. Ленина, 1-62', 15);
INSERT INTO user39_EMPLOYEE VALUES (3,'Алексеев Алексей Алексеевич', 6543217, 'ул. Победы, 16-9', 15);

/* Данные по рабочему времени */
INSERT INTO user39_WORKHOURS VALUES (1, '20120618 10:34:09 AM', 1, 2, 4);
INSERT INTO user39_WORKHOURS VALUES (2, '20120619 11:34:01 AM', 2, 3, 6);
INSERT INTO user39_WORKHOURS VALUES (3, '20120612 12:44:46 AM', 1, 1, 9);

/* Выборка всех данных */
select * from user39_PROCEDURE;
select * from user39_COMPONENT;
select * from user39_EMPLOYEE;
select * from user39_WORKHOURS;
select * from user39_COMPPROC;

-- определить фамилии сотрудников, чей стаж выше 10 лет;
select EMPNAME from user39_EMPLOYEE where EXPERIENCE > 10;

update user39_EMPLOYEE set EXPERIENCE = 9 where EMPNO = 1;
update user39_EMPLOYEE set EXPERIENCE = 21 where EMPNO = 2;

/* eugenia.blinova@gmail.com */
