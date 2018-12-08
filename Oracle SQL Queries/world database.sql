

set pagesize 200

set linesize 200




#/*1. How many California cities are on record? */


select distinct count(name) as "Question 1" 
from world.city 
where district = 'California';



#/*2. Which East Coast cities (Maine, New Hampshire, Massachusetts, Rhode Island, Connecticut, New York, New Jersey, Delaware, Maryland, Virginia, North Carolina, South Carolina, Georgia, and Florida) have less than a million people? */


select name as "Question 2 Name", population 
from world.city 
where district in ('Maine', 'New Hampshire', 'Massachusetts', 'Rhode Island', 'Connecticut', 'New York', 'New Jersey', 'Delaware', 'Maryland', 'Virginia', 'North Carolina', 'South Carolina', 'Georgia', 'Florida')
	and population < 1000000;



#/*3. Which Asian cities have more than 8 million people and are in a country where the life expectancy is under 65? */


select i.name as "Question 3 Name" 
from world.country c inner join world.city i on c.code = i.countrycode 
where c.continent = 'Asia' and c.lifeexpectancy < 65 
	and i.population >= 8000000;



#/*4. How many countries outside Europe have French as their official language?*/


select count(distinct c.code) as "Question 4" 
from world.country c inner join world.countrylanguage l on c.code = l.countrycode 
where (c.continent not in 'Europe' 
	and language = 'French' 
		and isofficial = 'T');



#/*5. Which cities of at least 750,000 but no more than a million people are in countries where Spanish is the official language? */


select i.name as "Question 5 Name" 
from world.city i inner join world.countrylanguage l on i.countrycode = l.countrycode 
where i.population between 750000 
	and 1000000 and l.language = 'Spanish' 
		and isofficial = 'T';



#/*6. How many countries are in the continent of North America?*/


select count(distinct name) as "Question 6" 
from world.country 
where continent = 'North America';



#/*7. What are the names and capitals of the countries in Oceania?*/


select o.name as "Question 7 Country Name", i.name as "Capital Name" 
from world.country o inner join world.city i on o.capital = i.id 
where o.continent = 'Oceania';



#/*8. What different forms of government are there in South America? */


select distinct governmentform as "Question 8 Government Form" 
from world.country 
where continent = 'South America';



#/*9. What country has the smallest GNP and how small is it?*/


select name as "Question 9 Country Name", gnp 
from world.country 
where gnp = (select min(gnp) from world.country);
