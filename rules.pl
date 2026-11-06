% ============================================================
% PROLOG / SQL EXERCISES
% Uses facts generated from the CSV tables
% ============================================================

:- consult('generated_facts.pl').


% ============================================================
% EXERCISE 1
%
% Print number and name of the department in Boston.
% ============================================================

boston_department(DeptNo, DeptName) :-
    dept(
        DeptNo,
        DeptName,
        'BOSTON'
    ).


% ============================================================
% EXERCISE 2
%
% List number and name of all employees
% in the RESEARCH department.
% ============================================================

research_employee(EmpNo, EmpName) :-
    dept(
        DeptNo,
        'RESEARCH',
        _
    ),

    emp(
        EmpNo,
        EmpName,
        _,
        _,
        _,
        DeptNo
    ).


% ============================================================
% EXERCISE 3
%
% List the names of all employees
% who are MANAGER or PRESIDENT.
% ============================================================

manager_or_president(EmpName) :-
    emp(
        _,
        EmpName,
        'MANAGER',
        _,
        _,
        _
    ).


manager_or_president(EmpName) :-
    emp(
        _,
        EmpName,
        'PRESIDENT',
        _,
        _,
        _
    ).


% ============================================================
% EXERCISE 4
%
% List employees who earn more than
% their direct supervisor.
% ============================================================

earns_more_than_supervisor(
    Employee,
    EmployeeSalary,
    Supervisor,
    SupervisorSalary
) :-

    emp(
        _,
        Employee,
        _,
        SupervisorNo,
        EmployeeSalary,
        _
    ),

    emp(
        SupervisorNo,
        Supervisor,
        _,
        _,
        SupervisorSalary,
        _
    ),

    EmployeeSalary > SupervisorSalary.


% ============================================================
% DIRECT MANAGEMENT RELATIONSHIP
%
% Employee is directly managed by Manager
% when the employee's MGR number equals
% the manager's EMPNO.
% ============================================================

directly_managed_by(
    Employee,
    Manager
) :-

    emp(
        _,
        Employee,
        _,
        ManagerNo,
        _,
        _
    ),

    emp(
        ManagerNo,
        Manager,
        _,
        _,
        _,
        _
    ).


% ============================================================
% EXERCISE 5
%
% Directly OR indirectly managed by someone.
%
% BASE CASE:
% Employee is directly managed by Manager.
%
% RECURSIVE CASE:
% Employee is managed by DirectManager,
% and DirectManager is managed by Manager.
% ============================================================

managed_by(
    Employee,
    Manager
) :-
    directly_managed_by(
        Employee,
        Manager
    ).


managed_by(
    Employee,
    Manager
) :-

    directly_managed_by(
        Employee,
        DirectManager
    ),

    managed_by(
        DirectManager,
        Manager
    ).