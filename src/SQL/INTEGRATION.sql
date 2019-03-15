use genesys_2018;

select * from accession order by rand() limit 100;
select * from taxonomy2 order by rand() limit 10;
select * from WIEWS order by rand() limit 100;
select * from SGSV order by rand() limit 100;


-- Tr. Triticum  
-- S. Solanum
-- O. Oryza

create table GMERGE as (select 	a.acceNumb as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(acceNumb, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"GENESYS" as source,
                                        instCode as institution,
                                        origCty as country,
                                        t.genus as genus,
                                        SUBSTRING_INDEX(t.taxonName ,' ',2) as species
                                        from accession a
                                        left join taxonomy2 t on a.taxonomyId2 = t.id
                                        )
								union
								(select `Accession number` as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`Accession number`, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"WIEWS" as source,
                                        `Holding institute code` as institution,
                                        `Country of origin` as country,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species
                                        from WIEWS
                                        where `Source of information` like "%GENESYS%"
                                        and `Source of information` like "%EURISCO%"
                                        )
								union
								(select accession_number as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accession_number, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"SGSV" as source,
                                        institute_code as institution,
                                        country_of_collection_or_source as country,
                                        genus as genus,
                                        SUBSTRING_INDEX(species,' ',2) as species
                                        from SGSV);




select count(*) as total, COUNT( DISTINCT id, genus ) as uniques
from GMERGE;

-- # total, uniques
-- '5181751', '4332803'


select *
from GMERGE
where id="19567";

select * from SGSV
where species like "Beta vulgaris%";


select species, source, count(*)
from GMERGE
where species not like "%sp." and species not like "%spp." and species not like "%hybr." 
and species like "%.%"
group by species, source;

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











