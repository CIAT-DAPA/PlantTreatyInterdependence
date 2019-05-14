use genesys_2018;

select * from accession order by rand() limit 100;
select * from taxonomy2 order by rand() limit 10;
select * from WIEWS order by rand() limit 100;
select * from SGSV order by rand() limit 100;




create table GMERGE as (select     a.acceNumb as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(acceNumb, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GENESYS" as source,
                                        instCode as institution,
                                        SUBSTR(trim(instCode), 1, 3) as institution_country,
                                        origCty as orig_country_raw,
                                        c.iso3 as orig_country,
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
                                        SUBSTR(trim(`Holding institute code`), 1, 3) as institution_country,
                                        `Country of origin` as orig_country_raw,
                                        c.iso3 as orig_country,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species
                                        from WIEWS
                                        left join COUNTRIES_SOLVER c on `Country of origin` = c.original
                                        where `Source of information` not like "%GENESYS%"
                                        and `Source of information` not like "%EURISCO%"
                                        )
                                union
                                (select accessionNumber as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accessionNumber, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GBIF" as source,
                                        institution as institution,
                                        institution_country as institution_country,
                                        countrycode as orig_country_raw,
                                        countrycode  as orig_country,
                                        genus as genus_raw,
                                        species as species_raw,
                                        genus as genus,
                                        species as species
                                        from GBIF_G
                                )
                                union
                                (select accession_number as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accession_number, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "SGSV" as source,
                                        institute_code as institution,
                                        SUBSTR(trim(institute_code), 1, 3) as institution_country,
                                        country_of_collection_or_source as orig_country_raw,
                                        c.iso3 as orig_country,
                                        genus as genus_raw,
                                        species as species_raw,
                                        REPLACE(genus,' ','') as genus,
                                        SUBSTRING_INDEX(species,' ',2) as species
                                        from SGSV
                                        left join COUNTRIES_SOLVER c on country_of_collection_or_source = c.original
                                        );
                                        
                                        
-- Query OK, 7094107 rows affected (21 min 29.63 sec)
-- Query OK, 7124030 rows affected (21 min 43.54 sec)
-- Query OK, 7124030 rows affected (21 min 43.42 sec)


-- GMERGE without SGSV
create table GMERGE as (select     a.acceNumb as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(acceNumb, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GENESYS" as source,
                                        instCode as institution,
                                        SUBSTR(trim(instCode), 1, 3) as institution_country,
                                        origCty as orig_country_raw,
                                        c.iso3 as orig_country,
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
                                        SUBSTR(trim(`Holding institute code`), 1, 3) as institution_country,
                                        `Country of origin` as orig_country_raw,
                                        c.iso3 as orig_country,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species_raw,
                                        SUBSTRING_INDEX(`Taxon`,' ',1) as genus,
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species
                                        from WIEWS
                                        left join COUNTRIES_SOLVER c on `Country of origin` = c.original
                                        where `Source of information` not like "%GENESYS%"
                                        and `Source of information` not like "%EURISCO%"
                                        )
                                union
                                (select accessionNumber as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(accessionNumber, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GBIF" as source,
                                        institution as institution,
                                        institution_country as institution_country,
                                        countrycode as orig_country_raw,
                                        countrycode  as orig_country,
                                        genus as genus_raw,
                                        species as species_raw,
                                        genus as genus,
                                        species as species
                                        from GBIF_G
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

UPDATE GMERGE
SET institution_country = ""
WHERE institution_country = "ZZZ";

UPDATE GMERGE
SET institution_country = ""
WHERE institution_country is null;

UPDATE GMERGE
SET orig_country = ""
WHERE orig_country = "ZZZ";

UPDATE GMERGE
SET orig_country = ""
WHERE orig_country is null;

UPDATE GMERGE
SET institution_country = SUBSTR(trim(institution), 1, 3)
WHERE institution_country = "" and source !="GBIF";


-- International institutions
 UPDATE GMERGE SET institution_country = "" WHERE institution = "BEN089" OR institution = "CIV033" OR institution = "NER074" OR institution = "NER037" OR institution = "THA069" OR institution = "TWN001" OR institution = "TZA055" OR institution = "TWN012" OR institution = "TWN020" OR institution = "TWN016" OR institution = "UZB112" OR institution = "PHL598" OR institution = "THA128" OR institution = "TWN024" OR institution = "VNM126" OR institution = "VNM133" OR institution = "BGD069" OR institution = "BTN047" OR institution = "CMR147" OR institution = "ETH096" OR institution = "BEL084" OR institution = "BEN084" OR institution = "CMR195" OR institution = "ITA406" OR institution = "KEN207" OR institution = "TGO168" OR institution = "NPL095" OR institution = "TZA105" OR institution = "UGA332" OR institution = "GTM085" OR institution = "CRI001" OR institution = "CRI029" OR institution = "CRI026" OR institution = "CRI027" OR institution = "CRI085" OR institution = "CRI136" OR institution = "CRI134" OR institution = "CRI135" OR institution = "CRI142" OR institution = "CRI062" OR institution = "CRI033" OR institution = "HND020" OR institution = "PAN132" OR institution = "SLV092" OR institution = "BOL061" OR institution = "BOL009" OR institution = "BOL228" OR institution = "COL003" OR institution = "ETH038" OR institution = "ETH015" OR institution = "HND119" OR institution = "MWI034" OR institution = "ARG1306" OR institution = "BOL230" OR institution = "CUB546" OR institution = "KEN179" OR institution = "LAO073" OR institution = "PAN185" OR institution = "NIC036" OR institution = "PHL100" OR institution = "RWA011" OR institution = "THA126" OR institution = "TZA027" OR institution = "UGA034" OR institution = "PER334" OR institution = "TZA052" OR institution = "UGA139" OR institution = "ETH092" OR institution = "BFA035" OR institution = "BGD020" OR institution = "CRI063" OR institution = "ECU065" OR institution = "GHA026" OR institution = "IND346" OR institution = "KAZ008" OR institution = "KEN030" OR institution = "MEX129" OR institution = "MEX052" OR institution = "MEX002" OR institution = "MEX064" OR institution = "AUS172" OR institution = "BEN080" OR institution = "DZA079" OR institution = "ECU070" OR institution = "ECU069" OR institution = "UGA466" OR institution = "NGA044" OR institution = "NPL023" OR institution = "PHL094" OR institution = "PRY007" OR institution = "SYR035" OR institution = "THA065" OR institution = "TUR027" OR institution = "URY035" OR institution = "ZWE033" OR institution = "SLV062" OR institution = "SLV061" OR institution = "BOL038" OR institution = "MWI064" OR institution = "BDI007" OR institution = "BGD021" OR institution = "COL044" OR institution = "CYP018" OR institution = "ECU057" OR institution = "IDN065" OR institution = "IDN165" OR institution = "IND232" OR institution = "KEN031" OR institution = "MWI067" OR institution = "ARG1305" OR institution = "PAN183" OR institution = "PER863" OR institution = "PER001" OR institution = "PER721" OR institution = "PHL097" OR institution = "RWA039" OR institution = "RWA012" OR institution = "PER073" OR institution = "UGA252" OR institution = "VNM146" OR institution = "JOR090" OR institution = "EGY078" OR institution = "EGY217" OR institution = "LBN002" OR institution = "MEX126" OR institution = "AUS172" OR institution = "DZA052" OR institution = "OMN012" OR institution = "SYR035" OR institution = "SYR002" OR institution = "SYR043" OR institution = "UZB067" OR institution = "MLI219" OR institution = "CMR081" OR institution = "CMR080" OR institution = "IDN172" OR institution = "KEN056" OR institution = "KEN023" OR institution = "KEN028" OR institution = "KEN207" OR institution = "SEN039" OR institution = "TZA078" OR institution = "PER486" OR institution = "IND922" OR institution = "ETH097" OR institution = "BFA001" OR institution = "IND132" OR institution = "IND135" OR institution = "IND134" OR institution = "IND136" OR institution = "IND223" OR institution = "IND002" OR institution = "IND133" OR institution = "KEN032" OR institution = "MEX030" OR institution = "MLI072" OR institution = "MWI023" OR institution = "NER015" OR institution = "NER047" OR institution = "UGA480" OR institution = "NGA051" OR institution = "SDN019" OR institution = "SEN108" OR institution = "SEN107" OR institution = "USA659" OR institution = "ZWE034" OR institution = "TGO092" OR institution = "USA646" OR institution = "CMR154" OR institution = "BEN027" OR institution = "BEN016" OR institution = "BFA034" OR institution = "BFA009" OR institution = "CIV065" OR institution = "CMR023" OR institution = "CMR057" OR institution = "COD014" OR institution = "GBR055" OR institution = "GHA048" OR institution = "MWI065" OR institution = "TGO091" OR institution = "NGA042" OR institution = "NGA057" OR institution = "NGA039" OR institution = "NGA043" OR institution = "NGA081" OR institution = "RWA013" OR institution = "SLE008" OR institution = "UGA033" OR institution = "ZWE035" OR institution = "NGA119" OR institution = "ETH013" OR institution = "KEN095" OR institution = "BEN055" OR institution = "ETH098" OR institution = "IND1308" OR institution = "UZB108" OR institution = "LKA189" OR institution = "BGD022" OR institution = "IDN066" OR institution = "IND296" OR institution = "KHM005" OR institution = "MDG012" OR institution = "MMR008" OR institution = "MMR122" OR institution = "MMR057" OR institution = "IDN153" OR institution = "IND685" OR institution = "JPN089" OR institution = "LAO015" OR institution = "MYS167" OR institution = "NER092" OR institution = "UGA532" OR institution = "UGA173" OR institution = "NGA045" OR institution = "PHL001" OR institution = "PHL096" OR institution = "THA117" OR institution = "TZA028" OR institution = "VNM077";



-- duplicates
create table GMERGE_duplicates as select * from (
    select id, genus, count(*)  total
    from GMERGE
    group by id, genus
)j
where total > 1;

-- uniques
create table GMERGE_uniques as select * from (
    select * 
    from GMERGE
    group by id, genus
)j;

-- Query OK, 5477240 rows affected (5 min 59.24 sec)


-- summary lite

create table CROP_ORIGIN_GENUS_LITE as 
(select c.crop, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.orig_country);



create table CROP_ORIGIN_SPECIES_LITE as 
(select c.crop, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.orig_country);



create table CROP_INSTITUTION_GENUS_LITE as 
(select c.crop, g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.institution_country);



create table CROP_INSTITUTION_SPECIES_LITE as 
(select c.crop,  g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country);



-- crop summary


create table CROP_GENUS as 
(select c.crop,  count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop);

create table CROP_SPECIES as 
(select c.crop,  count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop);



-- summary full

create table CROP_ORIGIN_GENUS_FULL as 
(select c.crop, g.genus, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.genus, g.orig_country);

-- Query OK, 21455 rows affected (6 min 28.80 sec)

create table CROP_ORIGIN_GENUS_FULL as 
(select c.crop, g.species, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.species, g.orig_country);


-- Query OK, 15884 rows affected (9 min 39.23 sec)


create table CROP_INSTITUTION_GENUS_FULL as 
(select c.crop, g.genus, g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.genus, g.institution_country);

-- Query OK, 10793 rows affected (6 min 20.10 sec)


create table CROP_INSTITUTION_SPECIES_FULL as 
(select c.crop, g.species, g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.species, g.institution_country);

-- Query OK, 8896 rows affected (9 min 41.17 sec)



-- Counts per source

create table CROP_SOURCE_GENUS as 
select total.crop, gbif.count as gbif,  sgsv.count as sgsv,  genesys.count as genesys, wiews.count as wiews 
from (select c.crop
FROM GMERGE g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop) total


left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.genus=c.taxon)
    where c.rank="genus"
    and g.source="GBIF"
    group by c.crop
) gbif

on total.crop = gbif.crop 

left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.genus=c.taxon)
    where c.rank="genus"
    and g.source="SGSV"
    group by c.crop
) sgsv

on total.crop = sgsv.crop 


left join (
    select c.crop,  count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.genus=c.taxon)
    where c.rank="genus"
    and g.source="GENESYS"
    group by c.crop
) genesys

on total.crop = genesys.crop 

left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.genus=c.taxon)
    where c.rank="genus"
    and g.source="WIEWS"
    group by c.crop
) wiews

on total.crop = wiews.crop ;




create table CROP_SOURCE_SPECIES as 
select total.crop, gbif.count as gbif,  sgsv.count as sgsv,  genesys.count as genesys, wiews.count as wiews 
from (select c.crop
FROM GMERGE g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop) total


left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.species=c.taxon)
    where c.rank="species"
    and g.source="GBIF"
    group by c.crop
) gbif

on total.crop = gbif.crop 

left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.species=c.taxon)
    where c.rank="species"
    and g.source="SGSV"
    group by c.crop
) sgsv

on total.crop = sgsv.crop 


left join (
    select c.crop,  count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.species=c.taxon)
    where c.rank="species"
    and g.source="GENESYS"
    group by c.crop
) genesys

on total.crop = genesys.crop 

left join (
    select c.crop, count(*) count
    FROM GMERGE g
    left join CIAT_crop_taxon c on (g.species=c.taxon)
    where c.rank="species"
    and g.source="WIEWS"
    group by c.crop
) wiews

on total.crop = wiews.crop ;










