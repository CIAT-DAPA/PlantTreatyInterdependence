use genesys_2018;


                               
                                

-- GMERGE 
DROP TABLE IF EXISTS GMERGE; create table GMERGE as (select     a.acceNumb as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(acceNumb, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GENESYS" as source,
                                        instCode as institution,
                                        SUBSTR(trim(instCode), 1, 3) as institution_country,
                                        origCty as orig_country_raw,
                                        c.iso3 as orig_country,
                                        t.genus as genus_raw,
                                        t.taxonName as species_raw,
                                        REPLACE(t.genus,' ','') as genus,
                                        SUBSTRING_INDEX(t.taxonName ,' ',2) as species,
                                        convert(mlsStat, char(50)) as MLS_status
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
                                        SUBSTRING_INDEX(`Taxon`,' ',2) as species,
                                        `Status under the Multilateral System` as MLS_status
                                        from WIEWS
                                        left join COUNTRIES_SOLVER c on `Country of origin` = c.original
                                        where `Source of information` not like "%GENESYS%"
                                        and `Source of information` not like "%EURISCO%"
                                        )
                                union
                                (select recordNumber as original_id, 
                                        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(recordNumber, ';', ''), '_', ''), '\'', ''), '\"', ''), '@', ''), ':', ''), '.', ''), '-', ''), ' ', ''))  as id,
                                        "GBIF" as source,
                                        g.publishingOrgKey  as institution,
                                        o.country as institution_country,
                                        ct.iso3 as orig_country_raw,
                                        ct.iso3  as orig_country,
                                        genus as genus_raw,
                                        species as species_raw,
                                        genus as genus,
                                        species as species,
                                        "" as MLS_status
                                        from GBIF2019_G g
                                        left join GBIF_ORGANISATIONS o on g.publishingOrgKey = o.uuid
                                        left join COUNTRIES_SOLVER ct on g.countrycode = ct.iso2
                                        
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
SET institution_country = "ROU"
WHERE institution_country = "ROM";

UPDATE GMERGE
SET institution_country = "MKD"
WHERE institution_country = "YUG";

UPDATE GMERGE
SET orig_country = "ROU"
WHERE orig_country = "ROM";

UPDATE GMERGE
SET orig_country = "MKD"
WHERE orig_country = "YUG";

UPDATE GMERGE
SET institution_country = SUBSTR(trim(institution), 1, 3)
WHERE institution_country = "" and source !="GBIF";


-- International institutions
 UPDATE GMERGE SET institution_country = "" WHERE institution 
 IN ("BEL084","COL003","ETH013","IND002","CIV033","KEN056","MEX002","NGA039","PER001","PHL001","SYR002","BEN089","CIV033","NER074","NER037","THA069","TWN001","TZA055","TWN012","TWN020","TWN016","UZB112",
"PHL598" , "THA128","TWN024","VNM126","VNM133","BGD069","BTN047","CMR147","ETH096","BEL084","BEN084","CMR195","ITA406","KEN207","TGO168","NPL095",
"TZA105","UGA332","GTM085","CRI001","CRI029","CRI026","CRI027","CRI085","CRI136","CRI134","CRI135","CRI142","CRI062","CRI033","HND020",
"PAN132","SLV092","BOL061","BOL009","BOL228","COL003","ETH038","ETH015","HND119","MWI034","ARG1306","BOL230","CUB546","KEN179","LAO073",
"PAN185","NIC036","PHL100","RWA011","THA126","TZA027","UGA034","PER334","TZA052","UGA139","ETH092","BFA035","BGD020","CRI063","ECU065",
"GHA026","IND346","KAZ008","KEN030","MEX129","MEX052","MEX002","MEX064","AUS172","BEN080","DZA079","ECU070","ECU069","UGA466","NGA044",
"NPL023","PHL094","PRY007","SYR035","THA065","TUR027","URY035","ZWE033","SLV062","SLV061","BOL038","MWI064","BDI007","BGD021","COL044",
"CYP018","ECU057","IDN065","IDN165","IND232","KEN031","MWI067","ARG1305","PAN183","PER863","PER001","PER721","PHL097","RWA039","RWA012",
"PER073","UGA252","VNM146","JOR090","EGY078","EGY217","LBN002","MEX126","AUS172","DZA052","OMN012","SYR035","SYR002","SYR043","UZB067",
"MLI219","CMR081","CMR080","IDN172","KEN056","KEN023","KEN028","KEN207","SEN039","TZA078","PER486","IND922","ETH097","BFA001","IND132",
"IND135","IND134","IND136","IND223","IND002","IND133","KEN032","MEX030","MLI072","MWI023","NER015","NER047","UGA480","NGA051","SDN019",
"SEN108","SEN107","USA659","ZWE034","TGO092","USA646","CMR154","BEN027","BEN016","BFA034","BFA009","CIV065","CMR023","CMR057","COD014",
"GBR055","GHA048","MWI065","TGO091","NGA042","NGA057","NGA039","NGA043","NGA081","RWA013","SLE008","UGA033","ZWE035","NGA119","ETH013",
"KEN095","BEN055","ETH098","IND1308","UZB108","LKA189","BGD022","IDN066","IND296","KHM005","MDG012","MMR008","MMR122","MMR057","IDN153",
"IND685","JPN089","LAO015","MYS167","NER092","UGA532","UGA173","NGA045","PHL001","PHL096","THA117","TZA028","VNM077");

UPDATE GMERGE
SET MLS_Status = "Not included"
WHERE MLS_Status = 0;

UPDATE GMERGE
SET MLS_Status = "Included"
WHERE MLS_Status = 1 ;

UPDATE GMERGE
SET MLS_Status = ""
WHERE MLS_Status is NULL;




-- uniques

DROP TABLE IF EXISTS GMERGE_uniques; create table GMERGE_uniques as select * from (
    select * 
    from GMERGE
    group by id, genus
)j;

-- Query OK, 5477240 rows affected (5 min 59.24 sec)


-- summary lite

DROP TABLE IF EXISTS CROP_ORIGIN_GENUS_LITE; create table CROP_ORIGIN_GENUS_LITE as 
(select c.crop, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.orig_country);



DROP TABLE IF EXISTS CROP_ORIGIN_SPECIES_LITE; create table CROP_ORIGIN_SPECIES_LITE as 
(select c.crop, g.orig_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.orig_country);



DROP TABLE IF EXISTS CROP_INSTITUTION_GENUS_LITE; create table CROP_INSTITUTION_GENUS_LITE as 
(select c.crop, g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.institution_country);



DROP TABLE IF EXISTS GBIF_INSTITUTION_SPECIES_LITE; create table GBIF_INSTITUTION_SPECIES_LITE as 
(select c.crop,  g.institution_country, count(*) count
FROM GMERGE g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
and g.source="GBIF"
group by c.crop, g.institution_country);

DROP TABLE IF EXISTS GBIF_INSTITUTION_GENUS_LITE; create table GBIF_INSTITUTION_GENUS_LITE as 
(select c.crop, g.institution_country, count(*) count
FROM GMERGE g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
and g.source="GBIF"
group by c.crop, g.institution_country);



DROP TABLE IF EXISTS CROP_INSTITUTION_SPECIES_LITE; create table CROP_INSTITUTION_SPECIES_LITE as 
(select c.crop,  g.institution_country, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country);



-- MLS metric 1 

DROP TABLE IF EXISTS CROP_INSTITUTION_GENUS_MLS_metric1; create table CROP_INSTITUTION_GENUS_MLS_metric1 as 
(select c.crop, g.institution_country, MLS_Status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.institution_country, MLS_Status);


DROP TABLE IF EXISTS CROP_INSTITUTION_SPECIES_MLS_metric1; create table CROP_INSTITUTION_SPECIES_MLS_metric1 as 
(select c.crop,  g.institution_country, MLS_Status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country, MLS_Status);


-- MLS metric 2

DROP TABLE IF EXISTS CROP_INSTITUTION_GENUS_MLS_metric2; create table CROP_INSTITUTION_GENUS_MLS_metric2 as 
(select c.crop, g.institution_country, g.institution, 'N' as MLS_status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.institution_country, g.institution);

-- Query OK, 17130 rows affected (6 min 24.18 sec)

update CROP_INSTITUTION_GENUS_MLS_metric2 m
set MLS_status ='Y'
where m.crop in (select cl.Common_name_standard from CROP_MLS cl where cl.`MLS Annex 1`='Y' ) 
and m.institution in (select inst.instcode from INSTITUTION_MLS inst  where inst.MLS=1 ) ;

update CROP_INSTITUTION_GENUS_MLS_metric2 m
set MLS_status ='Y'
where m.institution_country in ("BEL084","COL003","ETH013","IND002","CIV033","KEN056","MEX002","NGA039","PER001","PHL001","SYR002","BEN089","CIV033","NER074","NER037","THA069","TWN001","TZA055","TWN012","TWN020","TWN016","UZB112",
"PHL598" , "THA128","TWN024","VNM126","VNM133","BGD069","BTN047","CMR147","ETH096","BEL084","BEN084","CMR195","ITA406","KEN207","TGO168","NPL095",
"TZA105","UGA332","GTM085","CRI001","CRI029","CRI026","CRI027","CRI085","CRI136","CRI134","CRI135","CRI142","CRI062","CRI033","HND020",
"PAN132","SLV092","BOL061","BOL009","BOL228","COL003","ETH038","ETH015","HND119","MWI034","ARG1306","BOL230","CUB546","KEN179","LAO073",
"PAN185","NIC036","PHL100","RWA011","THA126","TZA027","UGA034","PER334","TZA052","UGA139","ETH092","BFA035","BGD020","CRI063","ECU065",
"GHA026","IND346","KAZ008","KEN030","MEX129","MEX052","MEX002","MEX064","AUS172","BEN080","DZA079","ECU070","ECU069","UGA466","NGA044",
"NPL023","PHL094","PRY007","SYR035","THA065","TUR027","URY035","ZWE033","SLV062","SLV061","BOL038","MWI064","BDI007","BGD021","COL044",
"CYP018","ECU057","IDN065","IDN165","IND232","KEN031","MWI067","ARG1305","PAN183","PER863","PER001","PER721","PHL097","RWA039","RWA012",
"PER073","UGA252","VNM146","JOR090","EGY078","EGY217","LBN002","MEX126","AUS172","DZA052","OMN012","SYR035","SYR002","SYR043","UZB067",
"MLI219","CMR081","CMR080","IDN172","KEN056","KEN023","KEN028","KEN207","SEN039","TZA078","PER486","IND922","ETH097","BFA001","IND132",
"IND135","IND134","IND136","IND223","IND002","IND133","KEN032","MEX030","MLI072","MWI023","NER015","NER047","UGA480","NGA051","SDN019",
"SEN108","SEN107","USA659","ZWE034","TGO092","USA646","CMR154","BEN027","BEN016","BFA034","BFA009","CIV065","CMR023","CMR057","COD014",
"GBR055","GHA048","MWI065","TGO091","NGA042","NGA057","NGA039","NGA043","NGA081","RWA013","SLE008","UGA033","ZWE035","NGA119","ETH013",
"KEN095","BEN055","ETH098","IND1308","UZB108","LKA189","BGD022","IDN066","IND296","KHM005","MDG012","MMR008","MMR122","MMR057","IDN153",
"IND685","JPN089","LAO015","MYS167","NER092","UGA532","UGA173","NGA045","PHL001","PHL096","THA117","TZA028","VNM077");


-- Query OK, 4999 rows affected (4.74 sec)


DROP TABLE IF EXISTS CROP_INSTITUTION_SPECIES_MLS_metric2; create table CROP_INSTITUTION_SPECIES_MLS_metric2 as 
(select c.crop, g.institution_country, g.institution, 'N' as MLS_status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country, g.institution);


update CROP_INSTITUTION_SPECIES_MLS_metric2 m
set MLS_status ='Y'
where m.crop in (select cl.Common_name_standard from CROP_MLS cl where cl.`MLS Annex 1`='Y' ) 
and m.institution in (select inst.instcode from INSTITUTION_MLS inst  where inst.MLS=1 ) ;

update CROP_INSTITUTION_SPECIES_MLS_metric2 m
set MLS_status ='Y'
where m.institution_country in ("BEL084","COL003","ETH013","IND002","CIV033","KEN056","MEX002","NGA039","PER001","PHL001","SYR002","BEN089","CIV033","NER074","NER037","THA069","TWN001","TZA055","TWN012","TWN020","TWN016","UZB112",
"PHL598" , "THA128","TWN024","VNM126","VNM133","BGD069","BTN047","CMR147","ETH096","BEL084","BEN084","CMR195","ITA406","KEN207","TGO168","NPL095",
"TZA105","UGA332","GTM085","CRI001","CRI029","CRI026","CRI027","CRI085","CRI136","CRI134","CRI135","CRI142","CRI062","CRI033","HND020",
"PAN132","SLV092","BOL061","BOL009","BOL228","COL003","ETH038","ETH015","HND119","MWI034","ARG1306","BOL230","CUB546","KEN179","LAO073",
"PAN185","NIC036","PHL100","RWA011","THA126","TZA027","UGA034","PER334","TZA052","UGA139","ETH092","BFA035","BGD020","CRI063","ECU065",
"GHA026","IND346","KAZ008","KEN030","MEX129","MEX052","MEX002","MEX064","AUS172","BEN080","DZA079","ECU070","ECU069","UGA466","NGA044",
"NPL023","PHL094","PRY007","SYR035","THA065","TUR027","URY035","ZWE033","SLV062","SLV061","BOL038","MWI064","BDI007","BGD021","COL044",
"CYP018","ECU057","IDN065","IDN165","IND232","KEN031","MWI067","ARG1305","PAN183","PER863","PER001","PER721","PHL097","RWA039","RWA012",
"PER073","UGA252","VNM146","JOR090","EGY078","EGY217","LBN002","MEX126","AUS172","DZA052","OMN012","SYR035","SYR002","SYR043","UZB067",
"MLI219","CMR081","CMR080","IDN172","KEN056","KEN023","KEN028","KEN207","SEN039","TZA078","PER486","IND922","ETH097","BFA001","IND132",
"IND135","IND134","IND136","IND223","IND002","IND133","KEN032","MEX030","MLI072","MWI023","NER015","NER047","UGA480","NGA051","SDN019",
"SEN108","SEN107","USA659","ZWE034","TGO092","USA646","CMR154","BEN027","BEN016","BFA034","BFA009","CIV065","CMR023","CMR057","COD014",
"GBR055","GHA048","MWI065","TGO091","NGA042","NGA057","NGA039","NGA043","NGA081","RWA013","SLE008","UGA033","ZWE035","NGA119","ETH013",
"KEN095","BEN055","ETH098","IND1308","UZB108","LKA189","BGD022","IDN066","IND296","KHM005","MDG012","MMR008","MMR122","MMR057","IDN153",
"IND685","JPN089","LAO015","MYS167","NER092","UGA532","UGA173","NGA045","PHL001","PHL096","THA117","TZA028","VNM077");


DROP TABLE IF EXISTS CROP_PLUTO_SPECIES; create table CROP_PLUTO_SPECIES as (

select c.crop as crop, 
"World" as country,
p.year as year,
COUNT(*) as upov_species_varietal_release
from PLUTO_CLEAN p
left join CIAT_crop_taxon c on (p.species=c.taxon)
where c.rank="species"
 p.year IN ("2018","2017","2016","2015","2014")
group by c.crop, p.year
order by c.crop, p.year


);





