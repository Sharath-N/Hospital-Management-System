DROP DATABASE hospital_mgmt_sys;
CREATE DATABASE hospital_mgmt_sys;

\c hospital_mgmt_sys;

DROP TABLE department CASCADE;
CREATE TABLE department(
dept_id varchar(15) PRIMARY KEY,
dept_name varchar(30) NOT NULL,
dept_head varchar(15) UNIQUE
);

DROP TABLE employee CASCADE;
CREATE TABLE employee(
emp_id varchar(15) PRIMARY KEY,
emp_name varchar(30) NOT NULL,
emp_type varchar(15) NOT NULL,
dept_id varchar(15),
dob date NOT NULL,
address varchar(30),
email varchar(30),
join_date date NOT NULL,
FOREIGN KEY (dept_id) REFERENCES department ON DELETE SET NULL
);

DROP TABLE test CASCADE;
CREATE TABLE test(
test_id varchar(15) PRIMARY KEY NOT NULL,
test_name varchar(20) NOT NULL,
test_cost int
);

DROP TABLE doctor CASCADE;
CREATE TABLE doctor(
doc_id varchar(15) PRIMARY KEY REFERENCES employee(emp_id),
dept_id varchar(15),
qualification varchar(20) NOT NULL,
availability varchar(5),
--CONSTRAINT PK_doc_id PRIMARY KEY(doc_id),
FOREIGN KEY (doc_id) REFERENCES employee(emp_id) ON DELETE SET NULL,
FOREIGN KEY (dept_id) REFERENCES department ON DELETE SET NULL
);

DROP TABLE nurse CASCADE;
CREATE TABLE nurse(
n_id varchar(15) PRIMARY KEY,
dept_id varchar(15),
time_allotment varchar(15) NOT NULL,
FOREIGN KEY (n_id) REFERENCES employee ON DELETE SET NULL,
FOREIGN KEY (dept_id) REFERENCES department ON DELETE SET NULL
);

DROP TABLE medicine CASCADE;
CREATE TABLE medicine(
med_id varchar(15) PRIMARY KEY NOT NULL,
med_name varchar(20) NOT NULL,
med_cost int
);

DROP TABLE patient CASCADE;
CREATE TABLE patient(
pat_id varchar(15) PRIMARY KEY,
pat_name varchar(30),
doc_id varchar(15),
test_id varchar(15),
gender varchar(1) NOT NULL,
dob date NOT NULL,
address varchar(50),
ph_no varchar(15) NOT NULL,
blood_gp varchar(4),
email varchar(30),
FOREIGN KEY (test_id) REFERENCES test ON DELETE SET NULL,
FOREIGN KEY (doc_id) REFERENCES doctor ON DELETE SET NULL --Check whether employee/doctor
);

DROP TABLE out_patient CASCADE;
CREATE TABLE out_patient(
out_pid varchar(15) PRIMARY KEY,
arrival_date date NOT NULL,
test_id varchar(15) NOT NULL,
med_problem varchar(30) NOT NULL,
FOREIGN KEY (out_pid) REFERENCES patient ON DELETE SET NULL,
FOREIGN KEY (test_id) REFERENCES test ON DELETE SET NULL
);

DROP TABLE in_patient CASCADE;
CREATE TABLE in_patient(
in_pid varchar(15) PRIMARY KEY,
test_id varchar(15) NOT NULL,
n_id varchar(15),
arr_date date NOT NULL,
disch_date date,
disease varchar(15) NOT NULL,
FOREIGN KEY (in_pid) REFERENCES patient ON DELETE SET NULL,
FOREIGN KEY (test_id) REFERENCES test ON DELETE SET NULL,
FOREIGN KEY (n_id) REFERENCES nurse ON DELETE SET NULL  --Check whether nurse/employee
);

DROP TABLE room CASCADE;
CREATE TABLE room(
room_id varchar(15) PRIMARY KEY NOT NULL,
room_type varchar(12) NOT NULL,
room_cost int NOT NULL
);

DROP TABLE room_alloc CASCADE;
CREATE TABLE room_alloc(
room_id varchar(15),
pat_id varchar(15),
FOREIGN KEY (pat_id) REFERENCES in_patient ON DELETE SET NULL --Check whether in_patient/patient
);

DROP TABLE bill CASCADE;
CREATE TABLE bill(
bill_date date,
pat_id varchar(15),
test_cost int NOT NULL,
med_cost int,
room_cost int,
other_charges int,
FOREIGN KEY (pat_id) REFERENCES patient ON DELETE SET NULL
);

DROP TABLE takes CASCADE;
CREATE TABLE takes(
pat_id varchar(15),
med_id varchar(15),
FOREIGN KEY (med_id) REFERENCES medicine ON DELETE SET NULL,
FOREIGN KEY (pat_id) REFERENCES patient ON DELETE SET NULL
);

DROP TABLE relative CASCADE;
CREATE TABLE relative(
rel_name varchar(20) NOT NULL,
pat_id varchar(15) NOT NULL,
relation varchar(12) NOT NULL,
ph_no varchar(15) NOT NULL,
FOREIGN KEY (pat_id) REFERENCES patient ON DELETE SET NULL --Check whether in_patient/patient
);


SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM test;
SELECT * FROM doctor;
SELECT * FROM nurse;
SELECT * FROM patient;
SELECT * FROM bill;
SELECT * FROM medicine;
SELECT * FROM takes;
SELECT * FROM out_patient;
SELECT * FROM in_patient;
SELECT * FROM relative;
SELECT * FROM room;
SELECT * FROM room_alloc;
