use genesys_2018;


create table CROP_INSTITUTION_GENUS_MLS_metric2 as 
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

-- Query OK, 4999 rows affected (4.74 sec)


create table CROP_INSTITUTION_SPECIES_MLS_metric2 as 
(select c.crop, g.institution_country, g.institution, 'N' as MLS_status, count(*) count
FROM GMERGE_uniques g
left join CIAT_crop_taxon c on (g.species=c.taxon)
where c.rank="species"
group by c.crop, g.institution_country, g.institution);


update CROP_INSTITUTION_SPECIES_MLS_metric2 m
set MLS_status ='Y'
where m.crop in (select cl.Common_name_standard from CROP_MLS cl where cl.`MLS Annex 1`='Y' ) 
and m.institution in (select inst.instcode from INSTITUTION_MLS inst  where inst.MLS=1 ) ;

