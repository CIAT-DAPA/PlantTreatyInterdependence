use genesys_2018;
select * from CROP_ORIGIN_GENUS_LITE
order by crop, count;

select * from CROP_ORIGIN_SPECIES_LITE
order by crop, count;

select * from CROP_INSTITUTION_SPECIES_LITE
order by crop, count;

select * from CROP_INSTITUTION_GENUS_LITE
order by crop, count;