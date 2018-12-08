

set pagesize 200

set linesize 200



#/*1. Which directors have no movie data associated with them?*/


select mp.firstname, mp.lastname, d.movieid 
from films.movieperson mp left outer join films.directs d on mp.moviepersonid = d.moviepersonid 
where d.movieid is null 
	and mp.occupation = 'director';



#/*2.  Generate a table with the names of studios that do not produce any movie*/


select f.name, m.title 
from films.filmstudio f left outer join films.movie m on f.filmstudioid = m.filmstudioid 
where m.title is null;



#/*3. Which countries have no language recorded for them?*/


select c.name, cl.language 
from world.country c left outer join world.countrylanguage cl on c.code = cl.countrycode
where cl.language is null;



#/*4. Find the number of products for each store ordered from each vendor in 2010. Show NULL if
 a store does not order products from a vendor. The full table includes many rows. You only need
to list (1) top 10 the most number of products, and (2) write down the total number of rows in
the full table.*/


/*1. Produce top 10 the most number of products*/

select * from 
	(SELECT s.store_id, v.vendor_id, 
		CASE WHEN so2010.num IS NULL 
			THEN 0 
		ELSE so2010.num 
		END num 
	FROM grocery.Store s CROSS JOIN grocery.Vendor v LEFT OUTER JOIN 
		(SELECT so.store_id, so.vendor_id, COUNT(so.product_id) num 
		FROM grocery.Store_order so INNER JOIN grocery.Product_Batch pb ON so.product_id=pb.product_id 
			WHERE EXTRACT(YEAR FROM pb.order_date)=2010 
			GROUP BY so.store_id, so.vendor_id) so2010 ON so2010.vendor_id = v.vendor_id 
				AND so2010.store_id = s.store_id ORDER BY num DESC) 
where rownum <= 10;



/*2. Wrote down the total number of rows in the full table*/

select count(*) from 
	(SELECT s.store_id, v.vendor_id, 
		CASE WHEN so2010.num IS NULL 
			THEN 0 
		ELSE so2010.num 
		END num 
	FROM grocery.Store s CROSS JOIN grocery.Vendor v LEFT OUTER JOIN 
		(SELECT so.store_id, so.vendor_id, COUNT(so.product_id) num FROM grocery.Store_order so INNER JOIN grocery.Product_Batch pb ON so.product_id=pb.product_id WHERE EXTRACT(YEAR FROM pb.order_date)=2010 GROUP BY so.store_id, so.vendor_id) so2010 
			ON so2010.vendor_id = v.vendor_id 
				AND so2010.store_id = s.store_id 
ORDER BY num DESC);



#/*5.  For each	US state on record in the world database, how many cities are recorded and what	is their total	population? 
Characterize them as a few (0 to 2), several (anything	from 3	to 5),	or lots	(6 or more). 
You may	not assume that	you “know” the	code for the US.*/



select ci.district, sum(ci.population), 
	case when count(distinct ci.name) <= 2 
		then 'few' 
		when count(distinct ci.name) between 3 and 5 
			then 'several' 
	else 'lots' 
	end 
from world.city ci inner join world.country co on ci.countrycode = co.code 
where co.name = 'United States' 
group by ci.district 
order by count(distinct ci.name);