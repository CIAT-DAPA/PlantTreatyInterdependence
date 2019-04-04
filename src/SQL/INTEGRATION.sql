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
                                        origCty as country_raw,
                                        c.iso3 as country,
                                        t.genus as genus_raw,
                                        t.taxonName as species_raw,
                                        REPLACE(t.genus,' ','') as genus,
                                        SUBSTRING_INDEX(t.taxonName ,' ',2) as species
                                        from accession a
                                        left join taxonomy2 t on a.taxonomyId2 = t.id
                                        left join COUNTRIES_SOLVER c on origCty = c.original
                                        )
								union
								(select `Accession number` as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`Accession number`, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"WIEWS" as source,
                                        `Holding institute code` as institution,
                                        `Country of origin` as country_raw,
                                        c.iso3 as country,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species
                                        from WIEWS
                                        left join COUNTRIES_SOLVER c on `Country of origin` = c.original
                                        where `Source of information` like "%GENESYS%"
                                        and `Source of information` like "%EURISCO%"
                                        )
								union
								(select accession_number as original_id, 
										LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accession_number, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
										"SGSV" as source,
                                        institute_code as institution,
                                        country_of_collection_or_source as country_raw,
                                        c.iso3 as country,
                                        genus as genus_raw,
                                        species as species_raw,
                                        REPLACE(genus,' ','') as genus,
                                        SUBSTRING_INDEX(species,' ',2) as species
                                        from SGSV
                                        left join COUNTRIES_SOLVER c on country_of_collection_or_source = c.original
                                        );


-- remove line break character
UPDATE GMERGE
SET species = REPLACE(species,UNHEX('C2A0'),'');

-- remove line break character
UPDATE GMERGE
SET species = REPLACE(species,'?','');

-- remove line break character
UPDATE GMERGE
SET species = SUBSTRING_INDEX(species,'(',1);


-- updating as Zea and Zea mays
UPDATE GMERGE
SET genus= "Zea" , species = "Zea mays"
WHERE genus = "Zea.mays" or genus ="Zea mays.";

UPDATE GMERGE
SET species = "Zea mays"
WHERE species = "Zea z.mays";

-- updating as Oryza

UPDATE GMERGE
SET species = REPLACE(species, "O.", "Oryza"), genus= "Oryza"
WHERE genus="O." and species like "O.%";

-- updating as Solanum

UPDATE GMERGE
SET species = REPLACE(species, "S.", "Solanum"), genus= "Solanum"
WHERE genus="S." and species like "S.%";

-- updating as Tritucum, please take in count that order matters

UPDATE GMERGE
SET species = REPLACE(species, "Tr. ", "Tritucum "), genus= "Tritucum"
WHERE species like "Tr. %";

UPDATE GMERGE
SET species = REPLACE(species, "Tr.. ", "Tritucum "), genus= "Tritucum"
WHERE species like "Tr..%";

UPDATE GMERGE
SET species = REPLACE(species, "Tr.", "Tritucum "), genus= "Tritucum"
WHERE species like "Tr.%";

UPDATE GMERGE
SET species = REPLACE(species, "T.", "Tritucum "), genus= "Tritucum"
WHERE species like "T.%";


-- updating as Gossypium, please take in count that order matters

UPDATE GMERGE
SET species = REPLACE(species, "G. ", "Gossypium "), genus= "Gossypium"
WHERE species like "G. %";

UPDATE GMERGE
SET species = REPLACE(species, "G.", "Gossypium "), genus= "Gossypium"
WHERE species like "G.%";

UPDATE GMERGE
SET species = "Gossypium hirsutum", genus= "Gossypium"
WHERE species like "2(g.%";

UPDATE GMERGE
SET species = "Gossypium hirsutum", genus= "Gossypium"
WHERE species like "2(g.%";

-- updating as Fagopyrum

UPDATE GMERGE
SET species = REPLACE(species, "Fagopyrum f.", "Fagopyrum "), genus= "Fagopyrum"
WHERE species like "Fagopyrum f.%";

UPDATE GMERGE
SET species = "Hordeum vulgare"
WHERE species like "Hordeum v.%"
or species like "Hordeum. v%"
or species like "Hordeum.v%";


-- Reformating to two words after replacements

UPDATE GMERGE
SET species = SUBSTRING_INDEX(species,' ',2) ;


-- duplicates
create table GMERGE_duplicates as select * from (
	select id, genus, count(*)  total
	from GMERGE
    group by id, genus
)j
where total > 1;

-- uniques
create table GMERGE_UNI as select * from (
	select * 
	from GMERGE
    group by id, genus
)j;


create table CROP_genus_counts as 
(select c.crop, g.genus, g.country, count(*)
FROM GMERGE_UNI g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.genus, g.country);

create table CROP_species_counts as 
(select c.crop, g.species, g.country, count(*)
FROM GMERGE_UNI g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="taxonName"
group by c.crop, g.genus, g.country);



select * from CROP_genus_counts;

select * from CROP_species_counts;



















