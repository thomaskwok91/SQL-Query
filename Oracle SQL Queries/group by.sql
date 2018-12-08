

set pagesize 200

set linesize 200



#/*1. What is the pending balance in all non-business customers’ checking accounts? */


select a.pending_balance 
from bank.account a inner join bank.individual i on a.cust_id = i.cust_id 
where product_cd = 'CHK';



#/*2. What are the full names of all vendors who can supply more than one item or are based in Illinois?*/


select v.name, count(cs.product_id), va.state_territory_province 
from grocery.vendor v inner join grocery.vendor_address va on v.vendor_id = va.vendor_id 
	inner join grocery.can_supply cs on v.vendor_id = cs.vendor_id 
group by v.name, va.state_territory_province 
	having count(cs.product_id) > 1 
		or va.state_territory_province = 'Illinois';



#/*3. What is the minimum available balance in all accounts for each customer and overall for all customers?*/


select tmp.name, min(tmp.bal) 
from 
	(select concat(i.fname, concat(' ', i.lname)) name, a.avail_balance bal from bank.account a inner join bank.individual i on i.cust_id = a.cust_id union select b.name, a.avail_balance from bank.account a inner join bank.business b on b.cust_id = a.cust_id) tmp 
group by rollup (tmp.name);




#/*4. What is the full name of the countries that have more than 3 official languages, and how many does each one have?*/


select co.name, mul_lan.num_ol 
from world.country co inner join(select ol.countrycode code, count(ol.language) num_ol from(select countrycode, language from world.countrylanguage 
	where isofficial = 'T') ol 
group by ol.countrycode having count(ol.language) > 3) mul_lan on co.code = mul_lan.code;



#/*5. Display the number of countries that speak 1 official language, 2 official languages, and so on. */


select ol_grp.num_lan, count(ol_grp.cc) 
from (select ol.countrycode cc, count(ol.language) num_lan 
	from (select countrycode, language from world.countrylanguage where isofficial = 'T') ol 
group by ol.countrycode) ol_grp 
	group by ol_grp.num_lan;



#/*6. Which cities of over three million people are in countries where English is an official language? */


select ci.name, cl.language, cl.isofficial 
from world.city ci inner join world.country co on ci.countrycode = co.code 
	inner join world.countrylanguage cl on co.code = cl.countrycode 
where ci.population >= 3000000 
	and cl.language = 'English' 
		and cl.isofficial = 'T';



#/*7. What is the number of large cities on each continent such that the total “large city population” on the continent is at least 25 million? */


select cont, count(cityname) from 
	(select ci.name as cityname, co.continent as cont, ci.population as pop from world.city ci inner join world.country co on ci.countrycode = co.code where ci.population >= 3000000) 
group by cont 
	having sum(pop) >= 25000000;



#/*8. Which large cities are in countries with no more than 2 languages spoken? */


select ci.name, ci.population 
from world.city ci inner join world.countrylanguage cl on cl.countrycode = ci.countrycode 
group by ci.name, ci.population 
	having count(cl.language) <= 2 
		and ci.population >= 3000000;



#/*9. In order of number of languages, what are the names of the countries where 10 or more languages are spoken and how many languages are spoken in each? Use a single query. */


select co.name, count(cl.language) 
	from world.country co inner join world.countrylanguage cl on co.code = cl.countrycode 
group by co.name 
	having count(cl.language) >=10;



#/*10. Which countries have average city populations for the cities recorded in the database of at least 3 million but no more than 7 million? */


select co.name, ci.avg_pop 
	from world.country co inner join 
		(select countrycode, avg(population) avg_pop from world.city group by countrycode having avg (population) between 3000000 and 7000000) ci 
			on ci.countrycode = co.code;