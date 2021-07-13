use genesys_2018;


create table PLUTO_CLEAN as (
select p.id, p.uc, p.cc as iso2, c.iso3 as iso3, p.party_titleHolder as institution, SUBSTRING_INDEX(p.app_date,'-',1)  as year,
 p.latin_name,  SUBSTRING_INDEX(p.latin_name,' ',1) as genus, SUBSTRING_INDEX(p.latin_name,' ',2) as species
from PLUTO p
left join planttreaty.countries c on (p.cc=c.iso2)
where p.status != "rejected"
);

update PLUTO_CLEAN
set iso3="USA"
where iso2="QM";

update PLUTO_CLEAN
set iso3=""
where iso2="QZ";

update PLUTO_CLEAN
set iso3=""
where iso3 is null;



create table CROP_PLUTO_SPECIES_COUNTRIES as 
(select c.crop,  g.iso3 as country, year, count(*) count
FROM PLUTO_CLEAN g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.iso3, year);

create table CROP_PLUTO_GENUS_COUNTRIES as 
(select c.crop, g.iso3 as country, year, count(*) count
FROM PLUTO_CLEAN g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.iso3, year);


create table CROP_PLUTO_GENUS_WORLD as 
(select c.crop, year, count(*) count
FROM PLUTO_CLEAN g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop,year);



create table CROP_PLUTO_SPECIES_WORLD as 
(select c.crop, year, count(*) count
FROM PLUTO_CLEAN g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, year);





