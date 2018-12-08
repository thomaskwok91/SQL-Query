set pagesize 200

set linesize 200



#/*1. How many vendors are in New York state?*/


select count(vendor_id) as "Vendors" 
from grocery.vendor_address 
where state_territory_province = 'New York';



#/*2. What baked goods were ordered before the current date?*/


select p.name, p.order_date 
from grocery.product_batch p inner join grocery.belongs_to b on p.product_id = b.product_id 
where b.category_name = 'baked goods' and order_date < current_date;



#/*3. Which employee(s) (outputting their full names in one single column) have son(s)?*/


select distinct concat(e.fname, concat(' ',  e.lname)) as "Full Name" 
from grocery.employee e inner join grocery.dependent d on e.essn = d.essn 
where d.relationship = 'son';



#/*4. Which vendors have contact phone numbers with area code 234?*/


select contact_name, contact_phone 
from grocery.vendor_contact 
where contact_phone like '234%';



#/*5. Which salaried employees have a phone number with area code 333?*/


select concat(e.fname, concat(' ', e.lname)) as "Name", phone1 
from grocery.employee e inner join grocery.salaried s on e.essn = s.essn 
where phone1 like '333%' or phone2 like '333%';



#/*6. What is the product name that is not expired and whose in-store price per item is less than $5.00? (If
 there is no expired date, the product will be considered to last forever)*/


select p.name, p.expiration_date, b.instore_price_per_item 
from grocery.product_batch p inner join grocery.product_batch_purchased b on b.product_id = p.product_id 
where (p.expiration_date is NULL or p.expiration_date > current_date) and b.instore_price_per_item < 5;

