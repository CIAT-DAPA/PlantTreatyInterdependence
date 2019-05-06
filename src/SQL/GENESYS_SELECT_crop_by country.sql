use genesys_2018;



-- create species relationship
CREATE table `CIAT_crop_species_subspecies` AS select ct.crop, ct.taxon as species, t.taxonName as subspecies
from CIAT_crop_taxon ct, genesys_2018.taxonomy2 t 
							where ct.rank="taxonName" 
							and t.taxonName like concat( ct.taxon,'%') 
                            and ct.rank = "taxonName";
-- 22 seconds


-- subspecies counts by origin country
CREATE table `CIAT_subspecies_origin_counts` AS (select t.taxonName as subspecies ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	inner join accession a on a.taxonomyId2 = t.id
	where
		(taxonName in  (select subspecies from CIAT_crop_species_subspecies group by subspecies)
        )
	group by taxonName, country);
-- Query OK, 63933 rows affected (4 min 51.29 sec)

-- genus counts by origin country
CREATE table `CIAT_genus_origin_counts` AS (select t.genus as genus ,  REPLACE(REPLACE(REPLACE(IFNULL(a.origCty , ''), '31', ''), '32', ''), '33', '')  as country, count(*) count
	from  taxonomy2 t
	inner join accession a on a.taxonomyId2 = t.id
	where
		(t.genus in  (select taxon from CIAT_crop_taxon where rank="genus" group by taxon)
        )
	group by t.genus, country);
-- Query OK, 13501 rows affected (25.30 sec)
    


-- subspecies counts by institution country
CREATE table `CIAT_subspecies_institutions_counts` AS (select t.taxonName as subspecies ,  SUBSTRING(instCode, 1, 3)  as country, count(*) count
	from  taxonomy2 t
	inner join accession a on a.taxonomyId2 = t.id
	where
		(taxonName in  (select subspecies from CIAT_crop_species_subspecies group by subspecies)
        )
	group by taxonName, country);
    
-- genus counts by origin country
CREATE table `CIAT_genus_institutions_counts` AS (select t.genus as genus ,  SUBSTRING(instCode, 1, 3)  as country, count(*) count
	from  taxonomy2 t
	inner join accession a on a.taxonomyId2 = t.id
	where
		(t.genus in  (select taxon from CIAT_crop_taxon where rank="genus" group by taxon)
        )
	group by t.genus, country);




-- counts of crop as species
select c.crop, sum(s.count) as count
from CIAT_crop_species_subspecies c
inner join CIAT_subspecies_origin_counts s on s.subspecies=c.subspecies
group by crop;


-- counts of crop as genus
select c.crop, sum(g.count) as count
from CIAT_crop_taxon c
inner join CIAT_genus_origin_counts g on g.genus=c.taxon
where c.rank = "genus"
group by crop;

-- counts of crop by species by origin country
select c.crop, c.species, s.country, sum(s.count) as count
from CIAT_crop_species_subspecies c
inner join CIAT_subspecies_origin_counts s on s.subspecies=c.subspecies
group by crop, c.species, country ;

-- counts of crop by genus by origin country
select c.crop, g.genus, g.country, sum(g.count) as count
from CIAT_crop_taxon c
inner join CIAT_genus_origin_counts g on g.genus=c.taxon
where c.rank = "genus"
group by crop, g.genus, country;

-- counts of crop by species by institution country
select c.crop, c.species, s.country, sum(s.count) as count
from CIAT_crop_species_subspecies c
inner join CIAT_subspecies_institutions_counts s on s.subspecies=c.subspecies
group by crop, c.species, country;

-- counts of genus by species by institution country
select c.crop, g.genus, g.country, sum(g.count) as count
from CIAT_crop_taxon c
inner join CIAT_genus_institutions_counts g on g.genus=c.taxon
where c.rank = "genus"
group by crop, g.genus, country;


select instCode from accession
group by instCodeaccession







