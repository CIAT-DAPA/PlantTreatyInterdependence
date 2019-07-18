use genesys_2018;




    
    
    
create table CROP_COUNTRIES as(
select  distinct c.crop as crop, p.iso3 as country
	from CIAT_crop_taxon c,
	(select iso3 from COUNTRIES_SOLVER union select "" ) p
	order by crop, country
    
    
    );
    

    

create table EXPORT_FINAL_COUNTRIES as (

select c.crop as crop, 
c.country as country,
cig.count as genus_count_institution_supply,
cis.count as species_count_institution_supply,
gig.count as genus_count_gbif_research_supply,
gis.count as species_count_gbif_research_supply,
cog.count as genus_count_origin_supply,
cos.count as species_count_origin_supply,
cpg.count as upov_genus_varietal_release,
cps.count as upov_species_varietal_release
from CROP_COUNTRIES c
left join CROP_INSTITUTION_GENUS_LITE cig on (c.crop = cig.crop and c.country = cig.institution_country )
left join CROP_INSTITUTION_SPECIES_LITE cis on (c.crop = cis.crop  and c.country = cis.institution_country)
left join GBIF_INSTITUTION_GENUS_LITE gig on (c.crop = gig.crop and c.country = gig.institution_country )
left join GBIF_INSTITUTION_SPECIES_LITE gis on (c.crop = gis.crop  and c.country = gis.institution_country)
left join CROP_ORIGIN_GENUS_LITE cog on (c.crop = cog.crop  and c.country = cog.orig_country )
left join CROP_ORIGIN_SPECIES_LITE cos on (c.crop = cos.crop  and c.country = cos.orig_country)
left join CROP_PLUTO_GENUS_LITE cpg on (c.crop = cpg.crop and c.country = cpg.country )
left join CROP_PLUTO_SPECIES_LITE cps on (c.crop = cps.crop  and c.country = cps.country)
where 
	not (cig.count is null and 
	cis.count is null and 
    gig.count is null and 
	gis.count is null and 
	cog.count is null and 
	cos.count is null and 
	cpg.count is null and 
	cps.count is null  
)
order by c.crop

);


create table EXPORT_GROUP1_FINAL_WORLD as (

select c.crop as crop, 
"World" as country,
"2019" as year,
sum(genus_count_institution_supply) as genus_count_institution_supply,
sum(species_count_institution_supply) as species_count_institution_supply,
sum(genus_count_gbif_research_supply) as genus_count_gbif_research_supply,
sum(species_count_gbif_research_supply) as species_count_gbif_research_supply,
sum(genus_count_origin_supply) as genus_count_origin_supply,
sum(species_count_origin_supply) as species_count_origin_supply,
sum(upov_genus_varietal_release) as upov_genus_varietal_release,
sum(upov_species_varietal_release) as upov_species_varietal_release
from EXPORT_FINAL_COUNTRIES c
group by c.crop
order by c.crop

);








create table DENORMALIZED_GROUP2_COUNTRIES as (

select c.crop as crop,
c.country as country,
cig.count as genus_count_institution_supply,
cis.count as species_count_institution_supply,

cig_mls1.count  as genus_count_mls_supply_accessions,
cig_mls1_not.count  as genus_count_mls_supply_accessions_not,
cig_mls1_not2.count as genus_count_mls_supply_accessions_not2,
cis_mls1.count  as species_count_mls_supply_accessions,
cis_mls1_not.count  as species_count_mls_supply_accessions_not,
cis_mls1_not2.count as species_count_mls_supply_accessions_not2,

cig_mls2.count  as genus_count_mls_supply_institutions,
cig_mls2_not.count  as genus_count_mls_supply_institutions_not,
cis_mls2.count  as species_count_mls_supply_institutions,
cis_mls2_not.count  as species_count_mls_supply_institutions_not,


cig_sgsv.count as genus_accessions_sgsv,
cis_sgsv.count  as species_accessions_sgsv

from CROP_COUNTRIES c
left join CROP_INSTITUTION_GENUS_LITE cig on (c.crop = cig.crop and c.country = cig.institution_country )
left join CROP_INSTITUTION_SPECIES_LITE cis on (c.crop = cis.crop  and c.country = cis.institution_country)

left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_GENUS_MLS_metric1 where MLS_Status="Included" group by crop, institution_country) 
cig_mls1 on (c.crop = cig_mls1.crop and c.country = cig_mls1.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_GENUS_MLS_metric1 where MLS_Status="Not included"  group by crop, institution_country) 
cig_mls1_not on (c.crop = cig_mls1_not.crop and c.country = cig_mls1_not.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_GENUS_MLS_metric1 where MLS_Status=""  group by crop, institution_country) 
 cig_mls1_not2 on (c.crop = cig_mls1_not2.crop and c.country = cig_mls1_not2.institution_country)
 
 left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_SPECIES_MLS_metric1 where MLS_Status="Included" group by crop, institution_country) 
cis_mls1 on (c.crop = cis_mls1.crop and c.country = cis_mls1.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_SPECIES_MLS_metric1 where MLS_Status="Not included"  group by crop, institution_country) 
cis_mls1_not on (c.crop = cis_mls1_not.crop and c.country = cis_mls1_not.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_SPECIES_MLS_metric1 where MLS_Status=""  group by crop, institution_country) 
cis_mls1_not2 on (c.crop = cis_mls1_not2.crop and c.country = cis_mls1_not2.institution_country)


left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_GENUS_MLS_metric2 where MLS_status="Y" group by crop, institution_country) 
cig_mls2 on (c.crop = cig_mls2.crop and c.country = cig_mls2.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_GENUS_MLS_metric2 where MLS_status="N"  group by crop, institution_country) 
cig_mls2_not on (c.crop = cig_mls2_not.crop and c.country = cig_mls2_not.institution_country )
 
 left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_SPECIES_MLS_metric2 where MLS_Status="Y" group by crop, institution_country) 
cis_mls2 on (c.crop = cis_mls2.crop and c.country = cis_mls2.institution_country )
left join (select crop, institution_country, sum(count) as count from CROP_INSTITUTION_SPECIES_MLS_metric2 where MLS_Status="N"  group by crop, institution_country) 
cis_mls2_not on (c.crop = cis_mls2_not.crop and c.country = cis_mls2_not.institution_country )



left join CROP_INSTITUTION_GENUS_SGSV cig_sgsv on (c.crop = cig_sgsv.crop and c.country = cig_sgsv.institution_country )
left join CROP_INSTITUTION_SPECIES_SGSV cis_sgsv on (c.crop = cis_sgsv.crop  and c.country = cis_sgsv.institution_country)

where 
	not (cig.count is null and 
	cis.count is null and 
	cig_sgsv.count is null and 
    cis_sgsv.count is null 

)
order by c.crop

);








create table EXPORT_GROUP2_FINAL_WORLD as (

select c.crop as crop,
"World" as country, 
"2019" as year,
sum(genus_count_mls_supply_accessions) / NULLIF(sum(genus_count_mls_supply_accessions_not)+sum(genus_count_mls_supply_accessions_not2)+sum(genus_count_mls_supply_accessions), 0)  as genus_count_mls_supply_accessions,
sum(species_count_mls_supply_accessions) / NULLIF(sum(species_count_mls_supply_accessions_not)+sum(species_count_mls_supply_accessions_not2)+sum(species_count_mls_supply_accessions), 0)  as species_count_mls_supply_accessions,
sum(genus_count_mls_supply_institutions) / NULLIF(sum(genus_count_mls_supply_institutions_not)+sum(genus_count_mls_supply_institutions), 0)  as genus_count_mls_supply_institutions,
sum(species_count_mls_supply_institutions) / NULLIF(sum(species_count_mls_supply_institutions_not)+sum(species_count_mls_supply_institutions), 0)  as species_count_mls_supply_institutions,
sum(genus_accessions_sgsv) / NULLIF(sum(genus_count_institution_supply)+sum(genus_accessions_sgsv), 0) as genus_accessions_sgsv,
sum(genus_accessions_sgsv) / NULLIF(sum(species_count_institution_supply)+sum(genus_accessions_sgsv), 0) as species_accessions_sgsv
from DENORMALIZED_GROUP2_COUNTRIES c
where not(
 genus_count_mls_supply_accessions is null and
 species_count_mls_supply_accessions is null and
 genus_count_mls_supply_institutions is null and
 species_count_mls_supply_institutions is null and
 genus_accessions_sgsv is null and
 species_accessions_sgsv is null

)
group by crop

);



