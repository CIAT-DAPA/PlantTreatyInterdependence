use genesys_2018;


create table EXPORT_FINAL_FULL as (

select distinct c.crop as crop, 
c.country as country,
cig.count as genus_count_institution_supply,
cis.count as species_count_institution_supply,
cog.count as genus_count_origin_supply,
cos.count as species_count_origin_supply,
cig_mls1.count as genus_count_mls_supply_accessions,
cis_mls1.count as species_count_mls_supply_accessions,
cig_mls2.count as genus_count_mls_supply_institutions,
cis_mls2.count as species_count_mls_supply_institutions,
cig_sgsv.count as genus_accessions_sgsv,
cis_sgsv.count as species_accessions_sgsv,
cpg.count as upov_genus_varietal_release,
cps.count as upov_species_varietal_release
from (
	select  distinct c.crop as crop, p.iso3 as country
	from CIAT_crop_taxon c,
	planttreaty.countries p
	order by crop
) c
left join CROP_INSTITUTION_GENUS_LITE cig on (c.crop = cig.crop and c.country = cig.institution_country )
left join CROP_INSTITUTION_SPECIES_LITE cis on (c.crop = cis.crop  and c.country = cis.institution_country)
left join CROP_ORIGIN_GENUS_LITE cog on (c.crop = cog.crop  and c.country = cog.orig_country )
left join CROP_ORIGIN_SPECIES_LITE cos on (c.crop = cos.crop  and c.country = cos.orig_country)
left join CROP_INSTITUTION_GENUS_MLS cig_mls1 on (c.crop = cig_mls1.crop and c.country = cig_mls1.institution_country )
left join CROP_INSTITUTION_SPECIES_MLS cis_mls1 on (c.crop = cis_mls1.crop  and c.country = cis_mls1.institution_country)
left join CROP_INSTITUTION_GENUS_MLS_metric2 cig_mls2 on (c.crop = cig_mls2.crop and c.country = cig_mls2.institution_country )
left join CROP_INSTITUTION_SPECIES_MLS_metric2 cis_mls2 on (c.crop = cis_mls2.crop  and c.country = cis_mls2.institution_country)
left join CROP_INSTITUTION_GENUS_SGSV cig_sgsv on (c.crop = cig_sgsv.crop and c.country = cig_sgsv.institution_country )
left join CROP_INSTITUTION_SPECIES_SGSV cis_sgsv on (c.crop = cis_sgsv.crop  and c.country = cis_sgsv.institution_country)
left join CROP_PLUTO_GENUS_LITE cpg on (c.crop = cpg.crop and c.country = cpg.country )
left join CROP_PLUTO_SPECIES_LITE cps on (c.crop = cps.crop  and c.country = cps.country)
where 
	not (cig.count is null and 
	cis.count is null and 
	cog.count is null and 
	cos.count is null and 
    cig_mls1.count is null and 
    cis_mls1.count is null and 
	cig_mls2.count is null and 
    cis_mls2.count is null and
	cig_sgsv.count is null and 
    cis_sgsv.count is null and
	cpg.count is null and 
	cps.count is null  
)
order by c.crop

);

