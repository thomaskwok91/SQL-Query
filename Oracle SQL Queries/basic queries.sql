set pagesize 200

set linesize 200


#/*1. Which movies’ show times are longer than “I Know What You Did.” but shorter than “Wonton Soup”?*/


select title as "movie", runningtime as "show time" 
from films.movie 
where runningtime between (select runningtime from films.movie where title = 'I Know What You Did.') and (select runningtime from films.movie where title = 'Wonton Soup');



#/*2.What are movie titles that start with letter ‘T’ and are released between 2000 and 2005?*/

select title, year_ 
from films.movie 
where title like 'T%' and year_ between 2000 and 2005;



#/*3. How many movie people are not actors?*/

select count(firstname) as "Number Not Actors" 
from films.movieperson 
where 'actor' not in occupation;



#/*4. How many theatres are in New York or Connecticut?*/

select count(name) as "Number of Theatres" 
from films.theatre 
where locationid IN (select locationid from films.location where state = 'NY' or state = 'CT');



#/*5. Find all actors whose last name contains an ‘a’ in the second position or first name ends with an ‘a’.*/

select firstname, lastname 
from films.movieperson 
where occupation = 'actor' and (firstname like '%a' or lastname like '_a%');



#/*6. Find all theatres whose names have the pattern of ‘name Theatre’ (e.g. ‘Worst Theatre’ where ‘Worst’ is the name), and extract the name (e.g. Worst, use SUBSTR).*/

select substr(name, 1, length(name)-length('Theatre')) as "Name of Theatre"
from films.theatre 
where instr(name, 'Theatre')>0;



#/*8. Which individual (not business) customer has the maximum available balance in all of his or her accounts (means the total of his or her balance), print out his or her full name with column heading “Full Name” (concatenating the first name and last name, with a space in between, e.g. ‘Di He’ not ‘DiHe’)*/


select concat(fname, concat(' ', lname)) as "Full Name" 
from bank.individual 
where cust_id in 
	(select cust_id from
		(select cust_id, sum(avail_balance) as avail_balance 
			from bank.account 
				where cust_id in (select cust_id from bank.individual) 
					group by cust_id) 
where avail_balance 
	in (select max(avail_balance) from (select cust_id, sum(avail_balance) as avail_balance from bank.account 
		where cust_id IN (select cust_id from bank.individual) group by cust_id)));

