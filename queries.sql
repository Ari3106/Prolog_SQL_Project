-- ============================================================
-- PROLOG / SQL EXERCISES
-- SQL versions of the five queries from the handout
-- ============================================================


-- ============================================================
-- EXERCISE 1
-- Print number and name of the department in Boston.
-- ============================================================

SELECT
    DEPTNO,
    DNAME
FROM DEPT
WHERE LOC = 'BOSTON';


-- ============================================================
-- EXERCISE 2
-- List number and name of all employees
-- in the RESEARCH department.
-- ============================================================

SELECT
    E.EMPNO,
    E.ENAME
FROM EMP E
JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME = 'RESEARCH';


-- ============================================================
-- EXERCISE 3
-- List the names of all employees
-- who are MANAGER or PRESIDENT.
-- ============================================================

SELECT
    ENAME
FROM EMP
WHERE JOB IN ('MANAGER', 'PRESIDENT');


-- ============================================================
-- EXERCISE 4
-- List all employees who earn more
-- than their direct supervisor.
-- ============================================================

SELECT
    E.ENAME AS Employee,
    E.SAL AS EmployeeSalary,
    M.ENAME AS Supervisor,
    M.SAL AS SupervisorSalary
FROM EMP E
JOIN EMP M
    ON E.MGR = M.EMPNO
WHERE E.SAL > M.SAL;


-- ============================================================
-- EXERCISE 5
-- List all employees who are directly or indirectly
-- managed by JONES.
-- ============================================================

WITH RECURSIVE ManagedByJones AS (

    -- Directly managed by JONES
    SELECT
        E.EMPNO,
        E.ENAME
    FROM EMP E
    JOIN EMP J
        ON E.MGR = J.EMPNO
    WHERE J.ENAME = 'JONES'

    UNION ALL

    -- Employees managed by someone who is
    -- already managed by JONES
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