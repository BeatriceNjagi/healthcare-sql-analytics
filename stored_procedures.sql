--20. Create a stored procedure that adds a new record to the Doctors table. The procedure should accept the doctor’s ID, first name, last name, specialization, email, and phone number as input parameters. After creating the procedure, call it using a set of sample doctor details to insert a new doctor into the database.
 
create or replace procedure insert_record (
	doctorid varchar (50),
	firstname varchar (50),
	lastname varchar (50),
	specialization varchar (50),
	email varchar(50),
	phonenumber varchar(50))	
language plpgsql
as $$ 
begin
	insert into doctors (doctorid, firstname, lastname, specialization, email, phonenumber)
	values (doctorid, firstname, lastname, specialization, email, phonenumber);
end;
$$;

--calling the procedure

call insert_record
('D1002', 'Jack' , 'Wall', 'Cardiology', 'jackwall@example.com', '555-03004');


--21. Create a stored procedure that records a new appointment and automatically performs validation before inserting. --The procedure should accept an appointment ID, patient ID, doctor ID, appointment date, status, and nurse ID. Inside the procedure, implement the following logic: * Verify that the patient exists in the Patients table. * Verify that the doctor exists in the Doctors table. * If either does not exist, prevent the insertion and return an error message. * If both exist, insert the appointment into the Appointments table.After creating the procedure, call it with sample data to demonstrate both a successful and a failed insertion attempt.

CREATE OR REPLACE PROCEDURE insert_appointment(
    p_appointmentid VARCHAR(50),
    p_patientid     VARCHAR(50),
    p_doctorid      VARCHAR(50),
    p_appointmentdate DATE,
    p_status        VARCHAR(50),
    p_nurseid       VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if patient exists
    IF NOT EXISTS (
        SELECT 1 
        FROM patients 
        WHERE patientid = p_patientid
    ) THEN
        RAISE EXCEPTION 'Patient % does not exist.', p_patientid;
    END IF;

    -- Check if doctor exists
    IF NOT EXISTS (
        SELECT 1 
        FROM doctors 
        WHERE doctorid = p_doctorid
    ) THEN
        RAISE EXCEPTION 'Doctor % does not exist.', p_doctorid;
    END IF;

    -- Insert record
    INSERT INTO appointments (
        appointmentid, patientid, doctorid, appointmentdate, status, nurseid
    )
    VALUES (
        p_appointmentid, p_patientid, p_doctorid, p_appointmentdate, p_status, p_nurseid
    );

    RAISE NOTICE 'Appointment % inserted successfully.', p_appointmentid;
END;
$$;

-- Calling the procedure

call insert_appointment('A1001', 'P0164', 'D0117', '2021-11-15', 'Scheduled', 'N0357');
