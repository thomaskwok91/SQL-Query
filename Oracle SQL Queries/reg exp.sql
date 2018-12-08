set pagesize 200
set linesize 200

#/*Useful things for self*/


select table_name from all_tables where owner='GENOME';


#/*1. How many contigs have a name that begins with the letters lp?*/


select distinct count(mol_name) 
from genome.contig 
where mol_name like 'lp%';




#/*2. How many contigs are not plasmids? (Hint: have a look at their names.)*/


select count(distinct mol_id) 
from genome.contig 
where mol_name not like '%plasmid%';



#/*3. What is the longest contig?*/


select mol_name, length(dna_sequence) 
from genome.contig 
where length(dna_sequence) = (select max(length(dna_sequence)) from genome.contig);



#/*4. How many ORFs begin after the first 150 positions of their contig?*/


select count(distinct orf_id) 
from genome.orf 
where orf_begin_coord > 150;



#/*5. Which ORFs occupy at least 10% of the length of their contig?*/


select distinct o.orf_id 
from genome.orf o inner join genome.contig c using (mol_id) 
where (o.orf_end_coord - o.orf_begin_coord)/length(c.dna_sequence) >= .1;



#/*6. Which ORFs begin with a TC followed by 3 nucleotides and then followed by a TG?*/


select o.orf_id, c.dna_sequence 
FROM genome.orf o INNER JOIN genome.contig c ON o.mol_id=c.mol_id 
WHERE regexp_like (SUBSTR(c.dna_sequence, o.orf_begin_coord, o.orf_end_coord- o.orf_begin_coord + 1), '^TC...TG', 'i');



#/*7. What are the names of the contigs that contain ORFs that begin with 2 C’s separated from each other by 2 nucleotides and then followed by a G?*/


select c.mol_name 
FROM genome.orf o INNER JOIN genome.contig c ON o.mol_id=c.mol_id 
WHERE regexp_like (SUBSTR(c.dna_sequence, o.orf_begin_coord, o.orf_end_coord- o.orf_begin_coord + 1), '^C..CG.', 'i');




#/*8. Which contigs contain ORFs that end in a T and C with one nucleotide between them?*/


select distinct c.mol_name, c.mol_id 
FROM genome.orf o INNER JOIN genome.contig c ON o.mol_id=c.mol_id 
WHERE regexp_like (SUBSTR(c.dna_sequence, o.orf_begin_coord, o.orf_end_coord- o.orf_begin_coord + 1), 't.c$', 'i');



#/*9. How many ORFs contain at least 4 A’s followed immediately by at least 3 C’?*/


select count(c.mol_id) 
FROM genome.orf o INNER JOIN genome.contig c ON o.mol_id=c.mol_id 
WHERE regexp_like (SUBSTR(c.dna_sequence, o.orf_begin_coord, o.orf_end_coord- o.orf_begin_coord + 1), '.(a){4}(c){3}.', 'i');

