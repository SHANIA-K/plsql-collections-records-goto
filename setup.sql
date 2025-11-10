CREATE TABLE employees(
  employee_id NUMBER PRIMARY KEY,
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  salary NUMBER
);

CREATE OR REPLACE TYPE salary_varray IS VARRAY(5) OF NUMBER;
/
CREATE OR REPLACE TYPE bonus_table IS TABLE OF NUMBER;
/
