create table CROP_INSTITUTION_GENUS_MLS as 
(select c.crop, g.institution_country, MLS_Status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.genus=c.taxon)
where c.rank="genus"
group by c.crop, g.institution_country, MLS_Status);


create table CROP_INSTITUTION_SPECIES_MLS as 
(select c.crop,  g.institution_country, MLS_Status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country, MLS_Status);


