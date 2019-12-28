\c hospital_mgmt_sys;

--Query 1 : List the doctors who are available.
SELECT d.doc_id, e.emp_name
FROM doctor d, employee e
WHERE d.availability = 'YES' AND d.doc_id=e.emp_id;

--Query 2 : List all the patients whose blood group is 'O'
SELECT pat_name
FROM patient
WHERE blood_gp LIKE '%O_';

--Query 3 : List all the rooms that are vacant
SELECT *
FROM room r
WHERE r.room_id NOT IN (SELECT ra.room_id FROM room_alloc ra);

--Query 4: Find all the nurses who treats more than one patient.
SELECT ip.n_id, COUNT(ip.n_id)
FROM in_patient ip, nurse n
WHERE ip.n_id = n.n_id
GROUP BY ip.n_id
HAVING COUNT(ip.n_id) > 1;
