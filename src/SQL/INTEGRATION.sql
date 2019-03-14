use genesys_2018;

select * from accession order by rand() limit 100;
select * from taxonomy2 order by rand() limit 100;
select * from WIEWS order by rand() limit 100;
select * from sgsv order by rand() limit 100;


create table GMERGE as (select 	a.acceNumb as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(acceNumb, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"GENESYS" as source,
                                        instCode as institution,
                                        origCty as country,
                                        t.genus as genus,
										t.taxonName as species
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
                                        REPLACE(SUBSTRING_INDEX(`Taxon`,' ',2), ' sp.', '')  as species
                                        from WIEWS
                                        where `Source of information` != "'GENESYS (https://www.genesys-pgr.org)'"
                                        and `Source of information` != "'EURISCO (http://eurisco.ipk-gatersleben.de)'"
                                        )
								union
								(select accession_number as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accession_number, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"SGSV" as source,
                                        institute_code as institution,
                                        country_of_collection_or_source as country,
                                        genus as genus,
                                        species
                                        from sgsv);




select count(*) as total, COUNT( DISTINCT id, genus ) as uniques
from GMERGE;

-- # total, uniques
-- '9576633', '4818718'



select *
from GMERGE
where id="19567";

create table GMERGE_duplicates as select * from (
	select id, count(*)  total
	from GMERGE
    group by id
)j
where total > 1;

select * from GMERGE_duplicates
order by total desc
limit 10000;


select count(*) from GMERGE_duplicates;











