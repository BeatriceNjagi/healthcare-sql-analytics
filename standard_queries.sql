--1. Retrieve the list of all male patients who were born after 1990, including their patient ID, first name, last name, and date of birth.

select  
	p.patientid , 
	p.firstname , 
	p.lastname, 
	p.dateofbirth 
from 
	hospital.patients p 
where
	p.dateofbirth > '1990-01-01'
	and p.gender = 'M';


--2. Produce a report showing the ten most recent appointments in the system, ordered from the newest to the oldest.

select 
	*
from 
	appointments a 
order by 
	a.appointmentdate desc
limit 10;

--3. Generate a report that shows all appointments along with the full names of the patients and doctors involved.

select 
	a.appointmentid , 
	a.appointmentdate , 
	concat(p.firstname , ' ',  p.lastname ) as patients_name,
	concat( d.firstname , ' ' , d.lastname) as doctors_name , 
	concat(n.firstname, ' ', n.lastname ) as nurses_name
from 
	appointments a 
join 
	patients p 
on 
	p.patientid = a.patientid 
join 
	doctors d 
on 
	a.doctorid = d.doctorid
join 
	nurses n 
on 
	a.nurseid = n.nurseid;

--5. Identify any treatments recorded in the system that do not have a matching appointment.

select 
    t.treatmentid , 
    a.appointmentid , 
    t.treatmenttype , 
    t.outcome 
from 
    treatments t 
left join 
    appointments a 
on 
    t.appointmentid = a.appointmentid
where 
    a.appointmentid is null or a.appointmentid = '';

--6. Create a summary that shows how many appointments each doctor has handled, ordered from the highest to the lowest count.

select  
    a.doctorid ,  
    count (a.appointmentid)
from 
    appointments a 
group by 
    a.doctorid 
order by 
    count (a.appointmentid) desc;


--7. Produce a list of doctors who have handled more than twenty appointments, showing their doctor ID, specialization, and total appointment count.

select  
    d.doctorid , 
    d.specialization , 
    count(a.appointmentid ) as total_appointments
from 
    appointments a 
join 
    doctors d 
on 
    a.doctorid  = d.doctorid 
group by 
    d.doctorid , 
    d.specialization 
having 
    count(a.appointmentid ) > 20
order by count(a.appointmentid) desc; 


--8. Retrieve the details of all patients who have had appointments with doctors whose specialization is “Cardiology.”

select 
    p.firstname , 
    p.lastname , d.specialization 
from 
    patients p 
left join 
    appointments a 
on 
    p.patientid = a.patientid  
left join 
    doctors d 
on 
    a.doctorid = d.doctorid 
where 
    d.specialization = 'Cardiology';


--9. Produce a list of patients who have at least one bill that remains unpaid.

select 
    p.patientid , 
    p.firstname , 
    p.lastname , 
    count(b.outstandingamount )
from 
    patients p 
left join 
    admissions a 
on 
    p.patientid = a.patientid 
left join 
    bills b 
on 
    a.admission_id = b.admissionid
group by 
    p.patientid ,
    p.firstname , 
    p.lastname
having 
    count(b.outstandingamount) >= 1;

--10. Retrieve all bills whose total amount is higher than the average total amount for all bills in the system.

select 
    b.billid , 
    b.totalamount 
from 
    bills b 
where 
    b.totalamount > 
    (select avg(totalamount)
    from bills b );
--11. For each patient in the database, identify their most recent appointment and list it along with the patient’s ID.

select 
	a.patientid , 
	max(a.appointmentdate ) as most_recent_app
from 
	appointments a 
group by 
	a.patientid;


--12. For every appointment in the system, assign a sequence number that ranks each patient’s appointments from most recent to oldest.
 
select  
	a.patientid, 
	a.appointmentid, 
	a.appointmentdate,
	row_number() over ( partition by a.patientid  order by a.appointmentdate desc)
from 
	appointments a
group by 
	a.patientid, 
	a.appointmentid,
	a.appointmentdate;

--13. Generate a report showing the number of appointments per day for October 2021, including a running total across the month.

select 
	appointmentdate ,
	count(a.appointmentid) as total_appointments ,
	sum(count(a.appointmentid )) over (order by appointmentdate) as running_total
from 
	appointments a 
where 
	date_part('month', a.appointmentdate ) = 10
group by 
	a.appointmentdate ; 


--15. Build a query that identifies all patients who currently have an outstanding balance, based on information from admissions and billing records.

 select  
 	a.patientid , 
 	sum(b.outstandingamount) 
 from 
 	admissions a 
 join 
 	bills b 
 on 
 	a.admissionid = b.admissionid 
 where 
 	b.outstandingamount is not null 
 group by 
 	a.patientid;
 
--16. Create a query that generates all dates from January 1 to January 15, 2021, and show how many appointments occurred on each of those dates.

select  
	a.appointmentdate ,
	count(*) as appointment_count
from 
	appointments a 
where 
	a.appointmentdate  between '2021-01-01' and  '2021-01-15'
group by 
	a.appointmentdate 
order by 
	appointment_count  desc;
 
 
--17. Add a new patient record to the Patients table, providing appropriate information for all required fields.

insert into patients 
values('P1001', 'Jack', 'Wilson', 'M', '1990-05-30', 'jack.wilson@example.com', '555-011001' );


--18. Modify the appointments table so that any appointment with a NULL status is updated to show “Scheduled.”

update appointments 
set status = 'Scheduled'
where status = '';

--19. Remove all prescription records that belong to appointments marked as “Cancelled.”

delete from 
	prescriptions 
using 
	appointments 
where 
	prescriptions.appointmentid = appointments.appointmentid
	and status = 'Cancelled';

