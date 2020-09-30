/* 
1) ������ ������ ������� �� ��������
2) ��� ������������ ������ ������� ��������� ��������
3) ��� ������������ ������ �����������, ����� ������ ������ ������������ �������
*/

/* ������� �������� */
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

/* ������� ������� */
CREATE TABLE user39_COMPONENT
(
  COMPNO INT NOT NULL,
  COMPNAME VARCHAR(20) NOT NULL
);

ALTER TABLE user39_COMPONENT
  ADD CONSTRAINT user39_COMPONENT_PK PRIMARY KEY (COMPNO);
ALTER TABLE user39_COMPONENT
  ADD CONSTRAINT user39_COMPONENT_UK UNIQUE (COMPNAME);

/* ������������� ������� */
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

/* ������� ���������� */
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

/* ������� �������� ������� */
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

/* ������ �� ��������� */
INSERT INTO user39_PROCEDURE VALUES (1,'��������� ������','�������');
INSERT INTO user39_PROCEDURE VALUES (2,'������������ ������','�������');
INSERT INTO user39_PROCEDURE VALUES (3,'�������� ������','������');

/* ������ �� ������� */
INSERT INTO user39_COMPONENT VALUES (1,'������');
INSERT INTO user39_COMPONENT VALUES (2,'������');
INSERT INTO user39_COMPONENT VALUES (3,'������');

/* ������ � ������������� ������� */
INSERT INTO user39_COMPPROC VALUES (1, 1, 2, 16);
INSERT INTO user39_COMPPROC VALUES (2, 1, 3, 8);
INSERT INTO user39_COMPPROC VALUES (3, 2, 3, 9);

/* ������ �� ����������� */
INSERT INTO user39_EMPLOYEE VALUES (1,'������ ���� ��������', 1234567, '��. �������, 5-122', 15);
INSERT INTO user39_EMPLOYEE VALUES (2,'������ ���� ��������', 3215647, '��. ������, 1-62', 15);
INSERT INTO user39_EMPLOYEE VALUES (3,'�������� ������� ����������', 6543217, '��. ������, 16-9', 15);

/* ������ �� �������� ������� */
INSERT INTO user39_WORKHOURS VALUES (1, '20120618 10:34:09 AM', 1, 2, 4);
INSERT INTO user39_WORKHOURS VALUES (2, '20120619 11:34:01 AM', 2, 3, 6);
INSERT INTO user39_WORKHOURS VALUES (3, '20120612 12:44:46 AM', 1, 1, 9);

/* ������� ���� ������ */
select * from user39_PROCEDURE;
select * from user39_COMPONENT;
select * from user39_EMPLOYEE;
select * from user39_WORKHOURS;
select * from user39_COMPPROC;

-- ���������� ������� �����������, ��� ���� ���� 10 ���;
select EMPNAME from user39_EMPLOYEE where EXPERIENCE > 10;

update user39_EMPLOYEE set EXPERIENCE = 9 where EMPNO = 1;
update user39_EMPLOYEE set EXPERIENCE = 21 where EMPNO = 2;

/* eugenia.blinova@gmail.com */
