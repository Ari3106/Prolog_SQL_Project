# Prolog SQL Project

## Overview

This project demonstrates how relational table data can be converted into Prolog facts and queried using both Prolog and SQL.

The project uses the `DEPT` and `EMP` example tables from the Prolog tutorial exercises. The department table contains department numbers, department names, and locations. The employee table contains employee numbers, names, job titles, manager numbers, salaries, and department numbers.

The CSV files are used as the data source. A Python script reads the CSV files and automatically generates Prolog facts in `generated_facts.pl`.

The Prolog rules then answer the five required exercises from the handout, while `queries.sql` contains the SQL version of the same five questions.

---

## Project Structure

```text
Prolog_SQL_Project/
│
├── data/
│   ├── dept.csv
│   └── emp.csv
│
├── import_csv.py
├── generated_facts.pl
├── rules.pl
├── queries.sql
└── README.md
```

### File Descriptions

- `data/dept.csv`  
  Contains the department table data.

- `data/emp.csv`  
  Contains the employee table data.

- `import_csv.py`  
  Reads both CSV files and automatically converts the rows into Prolog facts.

- `generated_facts.pl`  
  Contains the Prolog facts generated from the CSV data. This file should not be edited manually.

- `rules.pl`  
  Contains the Prolog rules used to solve the five exercises.

- `queries.sql`  
  Contains the SQL version of the five required exercises.

- `README.md`  
  Explains the project and how to run it.

---

## Data Used

The `DEPT` table contains:

```text
DEPTNO | DNAME       | LOC
10     | ACCOUNTING  | NEW YORK
20     | RESEARCH    | DALLAS
30     | SALES       | CHICAGO
40     | OPERATIONS  | BOSTON
```

The `EMP` table contains the employee data provided in the assignment, including employee number, employee name, job, manager number, salary, and department number.

---

## Requirements

The project requires:

- Python
- SWI-Prolog
- VS Code or another code editor

No additional Python packages are required because Python's built-in `csv` module is used.

---

## Step 1 — Generate the Prolog Facts

Open a terminal in the project folder.

Run:

```powershell
python import_csv.py
```

The program should display:

```text
Reading CSV tables...
Departments read: 4
Employees read: 14

Created: generated_facts.pl
CSV data successfully converted to Prolog facts.
```

The generated file will contain facts such as:

```prolog
dept(20, 'RESEARCH', 'DALLAS').

emp(7566, 'JONES', 'MANAGER', 7839, 2975, 20).
```

If the CSV data changes, running `import_csv.py` again will regenerate the Prolog facts using the updated data.

---

## Step 2 — Start SWI-Prolog

In the project folder, run:

```powershell
swipl
```

At the Prolog prompt:

```text
?-
```

load the rules file:

```prolog
[rules].
```

If the program loads correctly, Prolog should return:

```text
true.
```

The `rules.pl` file automatically loads `generated_facts.pl`.

---

# Required Exercises

## Exercise 1 — Department in Boston

The first exercise asks for the number and name of the department located in Boston.

### Prolog

```prolog
boston_department(DeptNo, DeptName).
```

Expected result:

```text
DeptNo = 40,
DeptName = 'OPERATIONS'.
```

### SQL

```sql
SELECT
    DEPTNO,
    DNAME
FROM DEPT
WHERE LOC = 'BOSTON';
```

---

## Exercise 2 — Employees in the Research Department

This query lists the employee number and name of every employee in the Research department.

### Prolog

```prolog
research_employee(EmpNo, EmpName).
```

Press `;` to view additional results.

Expected employees include:

```text
SMITH
JONES
SCOTT
ADAMS
FORD
```

### SQL

```sql
SELECT
    E.EMPNO,
    E.ENAME
FROM EMP E
JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME = 'RESEARCH';
```

---

## Exercise 3 — Managers or President

This query lists employees whose job is either Manager or President.

### Prolog

```prolog
manager_or_president(Name).
```

Expected results include:

```text
JONES
BLAKE
CLARK
KING
```

### SQL

```sql
SELECT
    ENAME
FROM EMP
WHERE JOB IN ('MANAGER', 'PRESIDENT');
```

---

## Exercise 4 — Employees Who Earn More Than Their Supervisor

This query compares each employee's salary with the salary of their direct supervisor.

### Prolog

```prolog
earns_more_than_supervisor(
    Employee,
    EmployeeSalary,
    Supervisor,
    SupervisorSalary
).
```

Expected results include:

```text
SCOTT earns 3000
JONES earns 2975
```

and:

```text
FORD earns 3000
JONES earns 2975
```

### SQL

```sql
SELECT
    E.ENAME AS Employee,
    E.SAL AS EmployeeSalary,
    M.ENAME AS Supervisor,
    M.SAL AS SupervisorSalary
FROM EMP E
JOIN EMP M
    ON E.MGR = M.EMPNO
WHERE E.SAL > M.SAL;
```

---

## Exercise 5 — Employees Directly or Indirectly Managed by JONES

This exercise uses recursion.

The program first checks whether an employee is directly managed by JONES.

If not, it checks whether the employee is managed by someone who is themselves managed by JONES.

### Prolog

```prolog
managed_by(Employee, 'JONES').
```

Expected results include:

```text
SCOTT
FORD
ADAMS
SMITH
```

The management structure is:

```text
JONES
├── SCOTT
│   └── ADAMS
└── FORD
    └── SMITH
```

SCOTT and FORD are directly managed by JONES.

ADAMS and SMITH are indirectly managed by JONES.

### SQL

```sql
WITH RECURSIVE ManagedByJones AS (

    SELECT
        E.EMPNO,
        E.ENAME
    FROM EMP E
    JOIN EMP J
        ON E.MGR = J.EMPNO
    WHERE J.ENAME = 'JONES'

    UNION ALL

    SELECT
        E.EMPNO,
        E.ENAME
    FROM EMP E
    JOIN ManagedByJones M
        ON E.MGR = M.EMPNO
)

SELECT
    EMPNO,
    ENAME
FROM ManagedByJones;
```

---

## How the Data Flow Works

```text
dept.csv + emp.csv
        ↓
   import_csv.py
        ↓
 generated_facts.pl
        ↓
      rules.pl
        ↓
   Prolog queries
```

The CSV files contain the source table data.

Python converts that table data into Prolog facts.

The Prolog rules perform the logic and reasoning required for the exercises.

The SQL file contains equivalent SQL queries for comparison.

---

## Important Prolog Commands

Load the project:

```prolog
[rules].
```

Ask for another solution:

```text
;
```

Exit SWI-Prolog:

```prolog
halt.
```

---

## Summary

This project demonstrates how database-style table data can be represented and queried using Prolog.

The program:

- reads department and employee data from CSV files
- automatically generates Prolog facts
- separates data from Prolog reasoning rules
- answers all five required Prolog exercises
- provides equivalent SQL queries
- uses recursion to determine indirect management relationships