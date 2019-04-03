use genesys_2018;
-- ############# control queries

select count(*) as total, COUNT( DISTINCT id, genus ) as uniques
from GMERGE;

-- # total, uniques
-- '5181751', '4332803'
-- '5181751', '4330196' aftes updates



select *
from GMERGE
where id="19567";


select species, source, count(*)
from GMERGE
where species not like "%sp." and species not like "%spp." and species not like "%hybr." 
and species like "%.%"
group by species, source;

select genus, source, count(*)
from GMERGE
where species like "% %"
group by genus, source;

select genus, species, source, count(*)
from GMERGE
where genus like "%mays"
group by genus, species, source;

select genus, species, count(*)
from GMERGE
where species like "%Z.%"
group by genus, species;

select genus, species, count(*)
from GMERGE
where species like "%O.%"
group by genus, species;

select genus, species, count(*)
from GMERGE
where species like "%S.%"
group by genus, species;

select genus, species, count(*)
from GMERGE
where species like "%T.%"
group by genus, species;

select genus, species, count(*)
from GMERGE
where species like "%G.%"
group by genus, species;


select genus, species, source, count(*)
from GMERGE
where species like "%x(p.%"
group by genus, species, source;

select genus, species, source, count(*)
from GMERGE
where species like "%Fagopyrum f.%"
group by genus, species, source;

select genus, species, source, count(*)
from GMERGE
where species like "Hordeum v.%"
or species like "Hordeum. v%"
or species like "Hordeum.v%"
group by genus, species, source;

select genus, species, count(*)
from GMERGE
where species not like "%sp." and species not like "%spp." and species not like "%hybr." 
and species like "%.%"
and species not like "%Z.%"
and species not like "%O.%"
and species not like "%S.%"
and species not like "%T.%"
and species not like "%Tr.%"
and species not like "%G.%"
and species not like "%x(p.%"
and species not like "Fagopyrum f.%"
and species not like "Hordeum v.%"
and species not like "Hordeum. v%"
and species not like "Hordeum.v%"
group by genus, species;

select genus, count(*)
from GMERGE
where  genus like "%.%"
group by genus;

select genus, count(*)
from GMERGE
where  (genus like "%.%" or genus like "%?%" or genus like "% %")
and genus not like "%Gossypium%"
and genus not like "%Hordeum%"
and genus not like "%Phaseolus%"
group by genus;


select genus, count(*)x	
from GMERGE
where  not (genus like "%.%" or genus like "%?%" or genus like "% %")
group by genus;


-- this query can be enhanced in MySQL 8.0 with REGEXP_REPLACE()
-- https://dev.mysql.com/doc/refman/8.0/en/regexp.html#function_regexp-replace
select * from(
select genus,clean, LENGTH(clean) lenght, count from(
select genus, 
REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
lower(genus),'a','0'),'b','0')
,'c','0')
,'d','0')
,'e','0')
,'f','0')
,'g','0')
,'h','0')
,'i','0')
,'j','0')
,'k','0')
,'l','0')
,'m','0')
,'n','0')
,'o','0')
,'p','0')
,'q','0')
,'r','0')
,'s','0')
,'t','0')
,'u','0')
,'v','0')
,'w','0')
,'x','0')
,'y','0')
,'z','0')
,' ','0')

,'0','') as clean, count(*) as count
from GMERGE
group by genus) m) n
where lenght>0;

select * from(
select species,clean, LENGTH(clean) lenght, count from(
select species, 
REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
lower(species),'a','0'),'b','0')
,'c','0')
,'d','0')
,'e','0')
,'f','0')
,'g','0')
,'h','0')
,'i','0')
,'j','0')
,'k','0')
,'l','0')
,'m','0')
,'n','0')
,'o','0')
,'p','0')
,'q','0')
,'r','0')
,'s','0')
,'t','0')
,'u','0')
,'v','0')
,'w','0')
,'x','0')
,'y','0')
,'z','0')
,' ','0')

,'0','') as clean, count(*) as count
from GMERGE
group by species) m) n
where lenght>1;






SELECT species from GMERGE
group by species;

SELECT genus from GMERGE
group by genus;


-- duplicates

select * from GMERGE_duplicates
order by total desc;


select count(*) from GMERGE_duplicates;


-- uniques

select * from GMERGE_uniques limit 10;

Select country, source from GMERGE
where LENGTH(country) >3
group by country;


select g.country, c.name, c.iso3, count(*) count
from genesys_2018.GMERGE g
left join  planttreaty.countries c
on (g.country = c.name || g.country = c.iso3)
group by g.country, c.name, c.iso3;

select c.iso3
from genesys_2018.GMERGE g
left join  planttreaty.countries c
on (g.country = c.name || g.country = c.iso3)
where g.country ="Colombia" limit 1;


select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "DDR"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "%YUGOSLAVIA (YUG)%"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "CSK"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "SUN"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "UNK"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "SCG"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "GER"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country like "KO-"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "PAL"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "Korea"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "AME"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "AMERICA"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "MOR"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "JAN"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "IB."
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "Africa"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "YU"
group by country, institution, source;

select  country, institution, source, count(*)
from genesys_2018.GMERGE g
where g.country = "ZAR"
group by country, institution, source;


select country
from GMERGE
group by COUNTRY;

-- update country codes
UPDATE GMERGE as g
inner join  COUNTRIES_SOLVER c
	on (g.country_raw = c.original) 
SET country = c.iso3
where country = "";



    

    
    













