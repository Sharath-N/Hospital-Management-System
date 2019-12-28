\c hospital_mgmt_sys;

--Query 1 : In-Patient(s) who stayed more than 9 days in the hospital for the treatment.
SELECT pat_name, in_pid, disease
FROM in_patient, patient
WHERE pat_id = in_pid AND (SELECT(disch_date - arr_date) > 9);

--Query 2 : List of all employees whose experience is greater than 15 years.
SELECT emp_name, emp_type, join_date
FROM employee
WHERE (SELECT(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM join_date)) > 10);

--Query 3 : List the diseases cured/treated/taken by a particular department(till date).
CREATE VIEW doc_with_dept AS
SELECT p.pat_id, d.doc_id, dp.dept_name FROM doctor d, patient p, department dp WHERE p.doc_id = d.doc_id AND d.dept_id = dp.dept_id;
SELECT dept_name, disease FROM doc_with_dept, in_patient WHERE pat_id = in_pid
UNION
SELECT dept_name, med_problem FROM doc_with_dept, out_patient WHERE pat_id = out_pid
ORDER BY dept_name;
DROP VIEW doc_with_dept;

--Query 4 : List all the nurses who are appointed to a particular room.
SELECT emp_name AS nurse_name, room_id
FROM in_patient, room_alloc, employee
WHERE pat_id = in_pid AND n_id = emp_id;

--Query 5 : Total cost calculation in the bill of the patient.
ALTER TABLE bill ADD COLUMN total_cost int;
UPDATE bill
SET total_cost = test_cost + med_cost + room_cost + other_charges;
SELECT * FROM bill;

--Query 6 : Count of all employees in a department.
SELECT dept_name, COUNT(*)
FROM employee, department
WHERE employee.dept_id = department.dept_id
GROUP BY dept_name ORDER BY dept_name;

--Query 7 : Disease that affected to most and least number of people.
CREATE VIEW affection1 AS SELECT disease, COUNT(disease) AS number1 FROM in_patient GROUP BY disease;
CREATE VIEW affection2 AS SELECT med_problem, COUNT(med_problem) AS number2 FROM out_patient GROUP BY med_problem;

CREATE VIEW max_affection AS
SELECT disease, number1 AS disease_count FROM affection1 WHERE number1 = (SELECT MAX(number1) FROM affection1)
UNION
SELECT med_problem AS disease, number2 AS disease_count FROM affection2 WHERE number2 = (SELECT MAX(number2) FROM affection2);

SELECT disease, disease_count FROM max_affection WHERE disease_count = (SELECT MAX(disease_count) FROM max_affection);
DROP VIEW max_affection CASCADE;

CREATE VIEW min_affection AS
SELECT disease, number1 AS disease_count FROM affection1 WHERE number1 = (SELECT MIN(number1) FROM affection1)
UNION
SELECT med_problem AS disease, number2 AS disease_count FROM affection2 WHERE number2 = (SELECT MIN(number2) FROM affection2);

SELECT disease, disease_count FROM min_affection WHERE disease_count = (SELECT MIN(disease_count) FROM min_affection);
DROP VIEW min_affection CASCADE;
DROP VIEW affection1 CASCADE;
DROP VIEW affection2 CASCADE;

--Query 8 : Rooms that are empty.
SELECT room_id, room_type FROM room
WHERE room_id NOT IN (SELECT room_id FROM room_alloc);

--Query 9 : List the doctors who are available.
SELECT d.doc_id, e.emp_name
FROM doctor d, employee e
WHERE d.availability = 'YES' AND d.doc_id=e.emp_id;

--Query 10 : List all the patients whose blood group is 'O'
SELECT pat_name
FROM patient
WHERE blood_gp LIKE '%O_';

--Query 11 : List all the rooms that are vacant
SELECT *
FROM room r
WHERE r.room_id NOT IN (SELECT ra.room_id FROM room_alloc ra);

--Query 12 : Find all the nurses who treats more than one patient.
SELECT ip.n_id, COUNT(ip.n_id)
FROM in_patient ip, nurse n
WHERE ip.n_id = n.n_id
GROUP BY ip.n_id
HAVING COUNT(ip.n_id) > 1;

--Query 13 : List all the heads of the department.
SELECT emp_name, emp_type, dept_name
FROM department, employee
WHERE dept_head = emp_id
ORDER BY dept_name;

--Query 14 : List of patients who are admitted on date 26 Jan 2018.
SELECT in_pid AS pat_id, pat_name
FROM in_patient, patient
WHERE arr_date = '2018-01-26' AND in_pid = pat_id
UNION
SELECT out_pid, pat_name
FROM out_patient, patient
WHERE arrival_date = '2018-01-26' AND out_pid = pat_id;

--Query 15 : List all the relatives details of patients.
SELECT r.pat_id, room_id, rel_name, relation, ph_no
FROM room_alloc rc, relative r
WHERE rc.pat_id = r.pat_id;

SELECT b.pat_name, b.pat_id, a.total_cost from bill a, patient b
WHERE a.pat_id = b.pat_id AND a.total_cost>10000;

SELECT p2.pat_id, p2.pat_name, m.med_name
FROM out_patient, patient p2, medicine m, takes p
WHERE out_pid =  p2.pat_id AND p.pat_id = p2.pat_id AND p.med_id = m.med_id AND m.med_cost>500; 
