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
                                        t.genus as genus_raw,
                                        t.taxonName as species_raw,
                                        REPLACE(t.genus,' ','') as genus,
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
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species_raw,
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
                                        genus as genus_raw,
                                        species as species_raw,
                                        REPLACE(genus,' ','') as genus,
                                        SUBSTRING_INDEX(species,' ',2) as species
                                        from SGSV);


-- remove line break character
UPDATE GMERGE
SET species = REPLACE(species,UNHEX('C2A0'),'');

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














