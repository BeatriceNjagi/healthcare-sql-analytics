--4. Prepare a list that shows all patients together with any treatments they have received, ensuring that patients without treatments also appear in the results.

with treatment_summary as (
select *
from 
	appointments a 
right join 
	treatments t 
	on a.appointmentid = t.appointmentid)
select 
	p.patientid , 
	p.firstname , 
	p.lastname , 
	c.treatmenttype , 
	c.outcome 
from 
	patients p 
left join treatment_summary t
	on p.patientid = t.patientid;

--14. Using a temporary query structure, calculate the average, minimum, and maximum total bill amount, and then return these values in a single result set.

with bill_summary as (
    select 
        avg(totalamount) as avg_bill,
        min(totalamount) as min_bill,
        max(totalamount) as max_bill
    from bills
)
select avg_bill, min_bill, max_bill
from bill_summary;
