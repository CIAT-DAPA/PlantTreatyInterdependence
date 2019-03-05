use genesys_2018;

select name, country, sum(count)
from CIAT_crop_taxa c
left join ((
	select t.taxonName as taxa ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(taxonName in (select taxa from CIAT_crop_taxa where level="taxonName" group by taxa))
	group by taxonName, a.origCty
 ) UNION(
	select t.taxonName as taxa , REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(t.genus in (select taxa from CIAT_crop_taxa where level="genus" group by taxa)) 
	group by t.genus,a.origCty
) )m

on c.taxa = m.taxa
where m.count is not null

group by c.name, m.country;




select crop, country, sum(count)
from CIAT_crop_taxa c
left join ((
	select t.taxonName as taxa ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(taxonName in ((select taxonName from CIAT_crop_taxa ct, genesys_2018.taxonomy2 t 
							where ct.rank="taxonName" 
							and t.taxonName like concat( ct.taxa,'%') 
					   ))
		)
	group by taxonName, a.origCty
 )  )m

on c.taxa = m.taxa
where m.count is not null

group by c.crop, m.country;



select crop, country, sum(count)
from CIAT_crop_taxa c
left join ((
	select t.taxonName as taxa , REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(t.genus in (select taxa from CIAT_crop_taxa where rank="genus" group by taxa)) 
	group by t.genus,a.origCty
) )m

on c.taxa = m.taxa
where m.count is not null

group by c.crop, m.country;



