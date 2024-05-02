--DROP TABLE departments;
--DROP TABLE titles;
--DROP TABLE employees;
--DROP TABLE dept_emp;
--DROP TABLE dept_manager;
--DROP TABLE salaries;

--Data Engineering
--Create tables and insert data (through import CSV and insert statements)

CREATE TABLE departments(
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(255) NOT NULL
);

select * from departments;


INSERT INTO departments (dept_no, dept_name)
VALUES
('d001','Marketing'),
('d002','Finance'),
('d003','Human Resources'),
('d004','Production'),
('d005','Development'),
('d006','Quality Management'),
('d007','Sales'),
('d008','Research'),
('d009','Customer Service');



CREATE TABLE employees(
    emp_no INTEGER PRIMARY KEY,
    emp_title_id VARCHAR(5) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    sex CHAR(1) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

SELECT * FROM employees;


CREATE TABLE titles(
title_id VARCHAR(5) PRIMARY KEY,
title VARCHAR(255) NOT NULL
);

SELECT * FROM titles;

INSERT INTO titles (title_id,title)
VALUES
('s0001','Staff'),
('s0002','Senior Staff'),
('e0001','Assistant Engineer'),
('e0002','Engineer'),
('e0003','Senior Engineer'),
('e0004','Technique Leader'),
('m0001','Manager');

CREATE TABLE dept_emp(
emp_no INTEGER REFERENCES employees(emp_no),
dept_no VARCHAR(4) REFERENCES departments(dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE dept_manager(
dept_no VARCHAR(4) REFERENCES departments(dept_no) NOT NULL,
emp_no INTEGER REFERENCES employees(emp_no) NOT NULL
);

SELECT * FROM dept_manager



CREATE TABLE salaries(
    emp_no INTEGER NOT NULL,
    salary INTEGER NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM salaries

--# Data Analysis

--1. List the employee number, last name, first name, sex, and salary of each employee

SELECT emp.emp_no,emp.last_name,emp.first_name,emp.sex,sal.salary FROM employees emp
INNER JOIN salaries sal ON emp.emp_no = sal.emp_no;

--2. List the first name, last name, and hire date for the employees who were hired in 1986 (2 points)

SELECT first_name,last_name, hire_date FROM employees
WHERE EXTRACT(YEAR from hire_date) = 1986;

--3 List the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)


SELECT a.emp_no,a.last_name,a.first_name,a.dept_no,b.dept_name
FROM departments b,(SELECT emp.emp_no,last_name,first_name,mgr.dept_no
FROM employees emp, dept_manager mgr
where emp.emp_no = mgr.emp_no) a 
where a.dept_no = b.dept_no

--4 List the department number for each employee along with that employee’s employee number, last name, first name, and department name

SELECT a.dept_no,a.emp_no,a.last_name,a.first_name,b.dept_name
FROM departments b,(
SELECT de.dept_no, emp.emp_no, emp.last_name, emp.first_name
FROM employees emp, dept_emp de
WHERE emp.emp_no = de.emp_no) a  
WHERE b.dept_no = a.dept_no

--5 List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B 

SELECT first_name,last_name,sex 
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6 List each employee in the Sales department, including their employee number, last name, and first name (2 points)

SELECT emp_no,last_name,first_name
FROM employees 
WHERE emp_no IN (
SELECT emp_no FROM dept_emp
WHERE dept_no IN ( 
SELECT dept_no 
FROM departments WHERE dept_name = 'Sales'));

--7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name


SELECT c.emp_no,c.last_name,c.first_name, d.dept_name
FROM employees c, ( 
SELECT a.emp_no, b.dept_name
FROM dept_emp a, (
SELECT dept_no, dept_name
FROM departments WHERE dept_name IN ('Sales','Development')) b 
WHERE a.dept_no = b.dept_no) d
where c.emp_no = d.emp_no

 --8 List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)

 SELECT COUNT(*) as frequency_counts, last_name
 FROM employees
 GROUP BY last_name
 ORDER BY last_name DESC