--Use the information you have to create a table schema for each of the six CSV files. Remember to specify data types, primary keys, foreign keys, and other constraints.--For the primary keys check to see if the column is unique, otherwise create a composite key. Which takes to primary keys in order to uniquely identify a row.
--For the primary keys check to see if the column is unique, otherwise create a composite key. Which takes to primary keys in order to uniquely identify a row.
--Be sure to create tables in the correct order to handle foreign keys.
--Import each CSV file into the corresponding SQL table. Note be sure to import the data in the same order that the tables were created and account for the headers when importing to avoid errors.
 
 --Create Table for employee
 CREATE TABLE public.employee (
"emp_no" int   NOT NULL,
"emp_title" varchar(10)   NOT NULL,
"birth_date" date   NOT NULL,
"first_name" varchar(50)   NOT NULL,
"last_name" varchar(50)   NOT NULL,
"gender" varchar(1)   NOT NULL,
"hire_date" date   NOT NULL,
CONSTRAINT "pk_employee"
PRIMARY KEY (emp_no) 
);

--Create table for titles
CREATE TABLE public.titles (
"title_id" varchar(10)   NOT NULL,
"title" varchar(50)   NOT NULL,
CONSTRAINT "pk_titles"
PRIMARY KEY (title_id) 
);

--Create table for Salaries
CREATE TABLE public.salaries (
 "emp_no" int   NOT NULL,
 "salary" int   NOT NULL
);

--Create table for departments
CREATE TABLE public.departments (
 "dept_no" varchar(10)   NOT NULL,
 "dept_name" varchar(50)   NOT NULL,
  CONSTRAINT "pk_departments" PRIMARY KEY (
  dept_no )
);

--Create table for department "employee"
CREATE TABLE public.dept_employee (
 "emp_no" int   NOT NULL,
 "dept_no" varchar(10)   NOT NULL
);

--Create table for department manager
CREATE TABLE public.dept_manager (
 "dept_no" varchar(10)   NOT NULL,
 "emp_no" int   NOT NULL
);

--Alter table function department employee references
ALTER TABLE dept_employee
ADD CONSTRAINT fk_dept_employee_emp_no
FOREIGN KEY (emp_no) 
REFERENCES employee(emp_no);

-- Alter table fuction department employee for departments
ALTER TABLE dept_employee
ADD CONSTRAINT fk_dept_employee_dept_no
FOREIGN KEY (dept_no) 
REFERENCES departments(dept_no);

-- Alter table fuction department managerdepartments
ALTER TABLE dept_manager
ADD CONSTRAINT fk_dept_manager_dept_no
FOREIGN KEY (dept_no) 
REFERENCES departments(dept_no);

-- Alter table fuction department manager employee reference
ALTER TABLE dept_manager
ADD CONSTRAINT fk_dept_manager_emp_no
FOREIGN KEY (emp_no) 
REFERENCES employee(emp_no);
  
-- Alter table fuction for employee titles  
ALTER TABLE employee
ADD CONSTRAINT fk_employee_emp_title
FOREIGN KEY (emp_title) 
REFERENCES titles(title_id);
 
-- Alter table fuction for employee Salaries
ALTER TABLE salaries
ADD CONSTRAINT fk_salaries_emp_no
FOREIGN KEY (emp_no) 
REFERENCES employee(emp_no);

-- Data Analysis Questions for homework

-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
select e.emp_no, e.last_name, e.first_name, e.gender, s.salary
From employee as e join salaries as s on e.emp_no = s.emp_no;

-- 2. List employees who were hired in 1986.
SELECT  first_name, last_name, hire_date
FROM employee
WHERE (hire_date BETWEEN '1986-01-01' AND '1986-12-31');

-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments AS d
INNER JOIN dept_manager AS dm
ON (d.dept_no=dm.dept_no)
INNER JOIN
employee AS e
ON (dm.emp_no = e.emp_no);

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employee AS e
INNER JOIN
dept_employee AS de
ON (e.emp_no = de.emp_no)
--add departments
INNER JOIN
departments AS d
ON (d.dept_no = de.dept_no);

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
select * from employee where first_name = 'Hercules' AND last_name LIKE 'B%';


-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employee AS e
INNER JOIN
dept_employee AS de
ON (e.emp_no = de.emp_no)
INNER JOIN
departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employee AS e
INNER JOIN
dept_employee AS de
ON (e.emp_no = de.emp_no)
--Add departments for sales and development
INNER JOIN
departments AS d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name IN ('Sales', 'Development'));

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select last_name, count(last_name)
From employee
Group by last_name
order by count(last_name) desc;