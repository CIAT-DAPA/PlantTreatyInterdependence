
-- ############# control queries

select count(*) as total, COUNT( DISTINCT id, genus ) as uniques
from GMERGE;

-- # total, uniques
-- '5181751', '4332803'


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
where species not like "%sp." and species not like "%spp." and species not like "%hybr." 
and species like "%.%"
and species not like "%Z.%"
and species not like "%O.%"
and species not like "%S.%"
and species not like "%T.%"
and species not like "%Tr.%"
and species not like "%G.%"
and species not like "%x(p.%"
group by genus, species, source;









create table GMERGE_duplicates as select * from (
	select id, genus, count(*)  total
	from GMERGE
    group by id, genus
)j
where total > 1;

select * from GMERGE_duplicates
order by total desc
limit 10000;


select count(*) from GMERGE_duplicates;
