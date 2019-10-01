use genesys_2018;

select c.crop, sum(u.`count samples distributed`)  as count from CIAT_crop_taxon c
left join USDA_demand u on c.taxon = u.Genus
where c.rank="genus"
group by c.crop;

select c.crop, sum(u.`count samples distributed`) as count from  CIAT_crop_taxon c
left join USDA_demand u on c.taxon = u.Species
where c.rank="species"
group by c.crop;


select c.crop, u.country_code, u.year, sum(u.`count samples distributed`)  as count
from CIAT_crop_taxon c 
left join USDA_demand u on c.taxon = u.Genus
where c.rank="genus"
and u.country_code is not null
group by c.crop, u.country_code, u.year;

select c.crop, u.country_code, u.year, sum(u.`count samples distributed`) as count 
from CIAT_crop_taxon c
left join USDA_demand u on c.taxon = u.Species
where c.rank="species"
and u.country_code is not null
group by c.crop, u.country_code, u.year;

