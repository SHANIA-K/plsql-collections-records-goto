CREATE OR REPLACE PACKAGE payroll_pkg IS
  TYPE emp_rec IS RECORD(id NUMBER, name VARCHAR2(100), sal NUMBER);

  PROCEDURE load_data;
  PROCEDURE show_varray;
  PROCEDURE apply_bonus(b bonus_table);
  PROCEDURE assoc_demo;
  PROCEDURE cursor_demo;
  PROCEDURE goto_demo;
END;
/
CREATE OR REPLACE PACKAGE BODY payroll_pkg IS

  g_sals salary_varray := salary_varray();
  TYPE name_map IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
  g_names name_map;

  PROCEDURE load_data IS
  BEGIN
    DELETE FROM employees;
    INSERT INTO employees VALUES(1,'Alice','K',5000);
    INSERT INTO employees VALUES(2,'Bob','U',6000);
    INSERT INTO employees VALUES(3,'Chris','M',4000);
    COMMIT;

    g_sals := salary_varray(5000,6000,4000);
  END;

  PROCEDURE show_varray IS
  BEGIN
    FOR i IN 1..g_sals.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('Salary '||i||'='||g_sals(i));
    END LOOP;
  END;

  PROCEDURE apply_bonus(b bonus_table) IS
  BEGIN
    FOR i IN 1..b.COUNT LOOP
      UPDATE employees SET salary = salary + b(i)
      WHERE employee_id = i;
    END LOOP;
    COMMIT;
  END;

  PROCEDURE assoc_demo IS
  BEGIN
    FOR r IN (SELECT employee_id, first_name||' '||last_name name FROM employees) LOOP
      g_names(r.employee_id) := r.name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Name for ID 1: '||g_names(1));
  END;

  PROCEDURE cursor_demo IS
    CURSOR c IS SELECT * FROM employees;
    rec c%ROWTYPE;
  BEGIN
    OPEN c;
    LOOP
      FETCH c INTO rec;
      EXIT WHEN c%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Emp: '||rec.employee_id||' '||rec.first_name);
    END LOOP;
    CLOSE c;
  END;

  PROCEDURE goto_demo IS
    CURSOR c IS SELECT employee_id, salary FROM employees;
  BEGIN
    FOR r IN c LOOP
      IF r.salary < 5000 THEN
        GOTO skip_row;
      END IF;

      DBMS_OUTPUT.PUT_LINE('Processing '||r.employee_id);

<<skip_row>>
      NULL;
    END LOOP;
  END;

END;
/
SET SERVEROUTPUT ON

BEGIN
  payroll_pkg.load_data;
  payroll_pkg.show_varray;

  DECLARE b bonus_table := bonus_table(200,100,0); BEGIN
    payroll_pkg.apply_bonus(b);
  END;

  payroll_pkg.assoc_demo;
  payroll_pkg.cursor_demo;
  payroll_pkg.goto_demo;
END;
/
