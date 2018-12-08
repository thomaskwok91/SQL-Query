set pagesize 200
set linesize 200

#/*1. Which stores have ordered ice cream?*/


select s.store_name 
from grocery.store_order o inner join grocery.belongs_to b using (product_id) 
	inner join grocery.store s using (store_id) 
where b.category_name = 'ice cream';



#/*2. Which salaried employees are over 20 and work at Manhattan 5?*/


select concat(e.fname, concat(' ', e.lname)) as "Full Name" 
from grocery.salaried s inner join grocery.employee e using (essn) 
	inner join grocery.works_in w using (essn) 
		inner join grocery.store s using (store_id) 
where s.store_name = 'Manhattan 5' and (current_date-bday)/365 > 20;




#/*3. What are the names and telephone numbers of the contacts at the vendors that sell ice cream?*/


select distinct vc.contact_name, vc.contact_phone 
from grocery.can_supply c inner join grocery.belongs_to b using (product_id) 
	inner join grocery.vendor_contact vc using (vendor_id) 
where b.category_name = 'ice cream';



#/*4. Has any product yet to arrive?*/


select pb.name 
from grocery.product_batch_purchased bp inner join grocery.product_batch pb using (product_id) 
where bp.actual_arrival_date > current_date or bp.actual_arrival_date is null;



#/*5. Who works at Manhattan 3?*/


select concat(e.fname, concat(' ', e.lname)) as "Name" 
from grocery.works_in w inner join grocery.store s using (store_id) 
	inner join grocery.employee e using (essn) 
where s.store_name = 'Manhattan 3';



#/*6. Which employees have both daughter and son?*/


select distinct concat(e.fname, concat(' ', e.lname)) as "Full Name" 
from grocery.dependent d1 inner join grocery.employee e on e.essn = d1.essn 
	inner join grocery.dependent d2 on d1.essn = d2.essn 
where d1.relationship = 'son' and d2.relationship = 'daughter';

