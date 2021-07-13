-- mls institution reporting bad
use genesys_2018;

create table CROP_SPECIES_MLS_STATUS_VS_REPORTED as 
(select c.crop, g.institution, g.source, MLS_Status as 'reported', cm.`MLS Annex 1`, count(*) count
FROM GMERGE g
left join CIAT_crop_taxon c on (g.species=c.taxon)
left join CROP_MLS cm on (c.crop=cm.Common_name_standard)
where c.rank="species"
and g.institution in (select instcode from INSTITUTION_MLS)
group by c.crop, g.institution_country, MLS_Status);
