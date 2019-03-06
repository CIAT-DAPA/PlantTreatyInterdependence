use genesys_2018;



-- create species relationship
CREATE table `CIAT_crop_species_subspecies` AS select ct.crop, ct.taxon as species, t.taxonName as subspecies
from CIAT_crop_taxon ct, genesys_2018.taxonomy2 t 
							where ct.rank="taxonName" 
							and t.taxonName like concat( ct.taxon,'%') 
                            and ct.rank = "taxonName";
-- 22 seconds


-- subspecies counts by country
CREATE table `CIAT_subspecies_counts` AS (select t.taxonName as specie ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(taxonName in  (select subspecies from CIAT_crop_species_subspecies group by subspecies)
        )
	group by taxonName, a.origCty);
-- Query OK, 63933 rows affected (4 min 51.29 sec)


-- genus counts by country
CREATE table `CIAT_genus_counts` AS (select t.genus as genus ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	left join accession a on a.taxonomyId2 = t.id
	where
		(t.genus in  (select taxon from CIAT_crop_taxon where rank="genus" group by taxon)
        )
	group by t.genus, a.origCty);
    
-- Query OK, 13501 rows affected (25.30 sec)




