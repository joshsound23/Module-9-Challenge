SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries	
SELECT * FROM titles;

CREATE TABLE "dept_manager"(
	"dept_no" VARCHAR NOT NULL,
	"emp_no" INT NOT NULL
);
CREATE TABLE "departments"(
	"dept_no" VARCHAR NOT NULL,
	"dept_name" VARCHAR NOT NULL,
	CONSTRAINT "pk_departments" PRIMARY KEY ("dept_no")
);

CREATE TABLE "employees" (
	"emp_no" INT NOT NULL,
	"title_id" VARCHAR  NOT NULL,
	"birth_date" date  NOT NULL,
	"first_name" VARCHAR  NOT NULL,
	"last_name" VARCHAR  NOT NULL,
	"sex" VARCHAR  NOT NULL,
	"hire_date" date NOT NULL,
	CONSTRAINT "pk_employees" PRIMARY KEY (
	"emp_no"
	)
);

CREATE TABLE "dept_emp"(
	"emp_no" INTEGER NOT NULL,
	"dept_no" VARCHAR NOT NULL
);

CREATE TABLE "titles"(
	"title_id" VARCHAR NOT NULL,
	"title" VARCHAR NOT NULL,
	CONSTRAINT "pk_titles" PRIMARY KEY(
	"title_id"
	)
);

CREATE TABLE "salaries"(
	"emp_no" INT NOT NULL,
	"salary" INT NOT NULL
	
);

--FOREIGN KEYS

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp"
FOREIGN KEY ("emp_no") REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_title_id"
FOREIGN KEY ("title_id") REFERENCES "titles" (title_id);

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_mananger_dept_no"
FOREIGN KEY ("dept_no") REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" 
FOREIGN KEY ("dept_no") REFERENCES "departments" (dept_no);

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no"
FOREIGN KEY ("emp_no") REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no"
FOREIGN KEY ("emp_no") REFERENCES "employees" ("emp_no");

--Data Analysis Part

--List the employee number, last name, first name, sex, and salary of each employee
SELECT employees.first_name, employees.last_name, employees.sex, salaries.salary
FROM employees JOIN salaries 
ON employees.emp_no=salaries.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986
Select first_name, last_name, hire_date
FROM employees
WHERE EXTRACT (YEAR FROM hire_date) = 1986;

--List the manager of each department along with their department number, 
--department name, employee number, last name, and first name 
SELECT departments.dept_no, departments.dept_name, dept_manager.dept_no,
employees.last_name, employees.first_name
FROM dept_manager
JOIN employees on dept_manager.emp_no = employees.emp_no
JOIN departments on dept_manager.dept_no = departments.dept_no;

--List first name, last name, and sex of each employee whose first name 
--is Hercules and whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%' ; 

--List each employee in the Sales department, including their employee number, last name,
--and first name
SELECT employees.emp_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_emp
JOIN employees ON employees.emp_no = dept_emp.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name IN ('Sales')

--List each employee in the Sales and Development departments, including their employee number,
--last name, first name, and department name
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON employees.emp_no = dept_emp.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

-- List the frequency counts, in descending order, of all the employee
--last names (that is, how many employees share each last name)
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;