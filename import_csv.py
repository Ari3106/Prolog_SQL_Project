import csv
from pathlib import Path


# ============================================================
# FILE LOCATIONS
# ============================================================

DATA_DIR = Path("data")

DEPT_FILE = DATA_DIR / "dept.csv"
EMP_FILE = DATA_DIR / "emp.csv"

OUTPUT_FILE = Path("generated_facts.pl")


# ============================================================
# CONVERT VALUES TO PROLOG SYNTAX
# ============================================================

def prolog_value(value):
    """
    Convert CSV text into valid Prolog syntax.
    """

    value = value.strip()

    # Empty CSV value becomes the Prolog atom none.
    if value == "":
        return "none"

    # Keep numbers as numbers.
    try:
        int(value)
        return value
    except ValueError:
        pass

    # Escape special characters in text.
    value = value.replace("\\", "\\\\")
    value = value.replace("'", "\\'")

    return f"'{value}'"


# ============================================================
# READ DEPARTMENT CSV
# ============================================================

def read_departments():
    departments = []

    with DEPT_FILE.open(
        newline="",
        encoding="utf-8-sig"
    ) as file:

        reader = csv.DictReader(file)

        for row in reader:
            departments.append(row)

    return departments


# ============================================================
# READ EMPLOYEE CSV
# ============================================================

def read_employees():
    employees = []

    with EMP_FILE.open(
        newline="",
        encoding="utf-8-sig"
    ) as file:

        reader = csv.DictReader(file)

        for row in reader:
            employees.append(row)

    return employees


# ============================================================
# CREATE DEPARTMENT FACTS
# ============================================================

def create_department_facts(departments):
    facts = []

    for row in departments:

        fact = (
            "dept("
            f"{prolog_value(row['DEPTNO'])}, "
            f"{prolog_value(row['DNAME'])}, "
            f"{prolog_value(row['LOC'])}"
            ")."
        )

        facts.append(fact)

    return facts


# ============================================================
# CREATE EMPLOYEE FACTS
# ============================================================

def create_employee_facts(employees):
    facts = []

    for row in employees:

        fact = (
            "emp("
            f"{prolog_value(row['EMPNO'])}, "
            f"{prolog_value(row['ENAME'])}, "
            f"{prolog_value(row['JOB'])}, "
            f"{prolog_value(row['MGR'])}, "
            f"{prolog_value(row['SAL'])}, "
            f"{prolog_value(row['DEPTNO'])}"
            ")."
        )

        facts.append(fact)

    return facts


# ============================================================
# WRITE PROLOG FILE
# ============================================================

def write_prolog_file(
    department_facts,
    employee_facts
):

    with OUTPUT_FILE.open(
        "w",
        encoding="utf-8"
    ) as file:

        file.write(
            "% ============================================================\n"
        )

        file.write(
            "% AUTO-GENERATED FROM CSV TABLE DATA\n"
        )

        file.write(
            "% Do not manually edit this file.\n"
        )

        file.write(
            "% Run import_csv.py to regenerate it.\n"
        )

        file.write(
            "% ============================================================\n\n"
        )

        file.write(
            "% ---------------- DEPARTMENTS ----------------\n\n"
        )

        for fact in department_facts:
            file.write(fact + "\n")

        file.write(
            "\n% ---------------- EMPLOYEES ----------------\n\n"
        )

        for fact in employee_facts:
            file.write(fact + "\n")


# ============================================================
# MAIN
# ============================================================

def main():

    print("Reading CSV tables...")

    departments = read_departments()
    employees = read_employees()

    print(
        f"Departments read: {len(departments)}"
    )

    print(
        f"Employees read: {len(employees)}"
    )

    department_facts = create_department_facts(
        departments
    )

    employee_facts = create_employee_facts(
        employees
    )

    write_prolog_file(
        department_facts,
        employee_facts
    )

    print()
    print(
        f"Created: {OUTPUT_FILE}"
    )

    print(
        "CSV data successfully converted "
        "to Prolog facts."
    )


if __name__ == "__main__":
    main()