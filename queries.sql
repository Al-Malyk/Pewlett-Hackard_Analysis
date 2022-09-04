-- retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- skill drills below
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- testing count method
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31'); 

--  creating table for retirement eligibility
SELECT first_name , last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- drop retirement info and recreate it. current retirement table has no common tables with dept_emp
-- no need for a CASCADE call because there's no relationship with the other tables

DROP TABLE retirement_info;

-- create a new table for retirement_info.
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- create a new table for retirement_info.
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- join the departments table to the managers table. no reason just practice
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm 
ON d.dept_no = dm.dept_no ;

--now join the retirement_info table to the dept_emp tables all data from ri to_date from dept_emp
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- get the count of the current about to retire employees and groupby their department
SELECT COUNT(ce.emp_no), de.dept_no
INTO retiree_bydept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

SELECT * FROM current_emp

-- create a table of current but retiring employees with their salaries
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND de.to_date = ('9999-01-01');

SELECT * FROM dept_manager

-- department managers and all the below info
SELECT dm.dept_no,
	dm.emp_no,
	dm.from_date,
	dm.to_date,
	d.dept_name,
	ce.first_name,
	ce.last_name
INTO manager_info
FROM dept_manager AS dm
INNER JOIN current_emp AS ce
ON dm.emp_no = ce.emp_no
INNER JOIN departments AS d 
ON dm.dept_no = d.dept_no;

-- deparment retirees. update the current_emp table by adding department names
-- there isn't a common column between ce and d so use dept_emp to bridge that gap
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- SALES TEAM TABLE OF RETIREES
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
--INTO retire_sales
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name = ('Sales');

--FOR BOTH SALES AND DEVELOPMENT TEAMS LIKE THAT DOUCHEBAG REQUESTED
-- easier way to think of (WHERE IN) below is. where x in tuple (y)
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO mentorship_program
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales' , 'Development')