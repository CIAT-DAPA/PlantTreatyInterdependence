use genesys_2018;


create table EXPORT_FINAL as (

select distinct c.crop as crop, 
c.country as country,
cig.count as genus_count_institution_supply,
cis.count as species_count_institution_supply,
cog.count as genus_count_origin_supply,
cos.count as species_count_origin_supply
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
where 
	not (cig.count is null and 
	cis.count is null and 
	cog.count is null and 
	cos.count is  null 
)
order by c.crop

);

