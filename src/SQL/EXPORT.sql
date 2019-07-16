use genesys_2018;


create table CROP_COUNTRIES as(
select  distinct c.crop as crop, p.iso3 as country
	from CIAT_crop_taxon c,
	planttreaty.countries p
	order by crop, country);

create table EXPORT_FINAL_COUNTRIES as (

select c.crop as crop, 
c.country as country,
cig.count as genus_count_institution_supply,
cis.count as species_count_institution_supply,
cog.count as genus_count_origin_supply,
cos.count as species_count_origin_supply,
cpg.count as upov_genus_varietal_release,
cps.count as upov_species_varietal_release
from CROP_COUNTRIES c
left join CROP_INSTITUTION_GENUS_LITE cig on (c.crop = cig.crop and c.country = cig.institution_country )
left join CROP_INSTITUTION_SPECIES_LITE cis on (c.crop = cis.crop  and c.country = cis.institution_country)
left join CROP_ORIGIN_GENUS_LITE cog on (c.crop = cog.crop  and c.country = cog.orig_country )
left join CROP_ORIGIN_SPECIES_LITE cos on (c.crop = cos.crop  and c.country = cos.orig_country)
left join CROP_PLUTO_GENUS_LITE cpg on (c.crop = cpg.crop and c.country = cpg.country )
left join CROP_PLUTO_SPECIES_LITE cps on (c.crop = cps.crop  and c.country = cps.country)
where 
	not (cig.count is null and 
	cis.count is null and 
	cog.count is null and 
	cos.count is null and 
	cpg.count is null and 
	cps.count is null  
)
order by c.crop

);




create table EXPORT_FINAL_WORLD as (

select c.crop as crop,
"World" as country, 
sum(cig.count) as genus_count_institution_supply,
sum(cis.count) as species_count_institution_supply,
sum(cog.count) as genus_count_origin_supply,
sum(cos.count) as species_count_origin_supply,
sum(cig_mls1.count) / NULLIF(sum(cig_mls1_not.count), 0)  as genus_count_mls_supply_accessions,
sum(cis_mls1.count) / NULLIF(sum(cis_mls1_not.count), 0)  as species_count_mls_supply_accessions,
sum(cig_mls2.count) / NULLIF(sum(cig_mls2_not.count), 0)  as genus_count_mls_supply_institutions,
sum(cis_mls2.count) / NULLIF(sum(cis_mls2_not.count), 0)  as species_count_mls_supply_institutions,
sum(cig_sgsv.count) / NULLIF(sum(cig.count), 0) as genus_accessions_sgsv,
sum(cis_sgsv.count) / NULLIF(sum(cis.count), 0) as species_accessions_sgsv,
sum(cpg.count)  as upov_genus_varietal_release,
sum(cps.count)  as upov_species_varietal_release
from CROP_COUNTRIES c
left join CROP_INSTITUTION_GENUS_LITE cig on (c.crop = cig.crop and c.country = cig.institution_country )
left join CROP_INSTITUTION_SPECIES_LITE cis on (c.crop = cis.crop  and c.country = cis.institution_country)
left join CROP_ORIGIN_GENUS_LITE cog on (c.crop = cog.crop  and c.country = cog.orig_country )
left join CROP_ORIGIN_SPECIES_LITE cos on (c.crop = cos.crop  and c.country = cos.orig_country)
left join CROP_INSTITUTION_GENUS_MLS_metric1 cig_mls1 on (c.crop = cig_mls1.crop and c.country = cig_mls1.institution_country and cig_mls1.MLS_Status="Included")
left join CROP_INSTITUTION_SPECIES_MLS_metric1 cis_mls1 on (c.crop = cis_mls1.crop  and c.country = cis_mls1.institution_country and cis_mls1.MLS_Status="Included")
left join CROP_INSTITUTION_GENUS_MLS_metric2 cig_mls2 on (c.crop = cig_mls2.crop and c.country = cig_mls2.institution_country and cig_mls2.MLS_status="Y")
left join CROP_INSTITUTION_SPECIES_MLS_metric2 cis_mls2 on (c.crop = cis_mls2.crop  and c.country = cis_mls2.institution_country and cis_mls2.MLS_status="Y")
left join CROP_INSTITUTION_GENUS_MLS_metric1 cig_mls1_not on (c.crop = cig_mls1_not.crop and c.country = cig_mls1_not.institution_country and (cig_mls1_not.MLS_Status="Not included" or cig_mls1_not.MLS_Status=""))
left join CROP_INSTITUTION_SPECIES_MLS_metric1 cis_mls1_not on (c.crop = cis_mls1_not.crop  and c.country = cis_mls1_not.institution_country and (cis_mls1_not.MLS_Status="Not included" or cis_mls1_not.MLS_Status=""))
left join CROP_INSTITUTION_GENUS_MLS_metric2 cig_mls2_not on (c.crop = cig_mls2_not.crop and c.country = cig_mls2_not.institution_country and cig_mls2_not.MLS_status="N")
left join CROP_INSTITUTION_SPECIES_MLS_metric2 cis_mls2_not on (c.crop = cis_mls2_not.crop  and c.country = cis_mls2_not.institution_country and cis_mls2_not.MLS_status="N")
left join CROP_INSTITUTION_GENUS_SGSV cig_sgsv on (c.crop = cig_sgsv.crop and c.country = cig_sgsv.institution_country )
left join CROP_INSTITUTION_SPECIES_SGSV cis_sgsv on (c.crop = cis_sgsv.crop  and c.country = cis_sgsv.institution_country)
left join CROP_PLUTO_GENUS_LITE cpg on (c.crop = cpg.crop and c.country = cpg.country )
left join CROP_PLUTO_SPECIES_LITE cps on (c.crop = cps.crop  and c.country = cps.country)
where 
	not (cig.count is null and 
	cis.count is null and 
	cog.count is null and 
	cos.count is null and 
	cig_sgsv.count is null and 
    cis_sgsv.count is null and
	cpg.count is null and 
	cps.count is null  
)
group by c.crop
order by c.crop

);





