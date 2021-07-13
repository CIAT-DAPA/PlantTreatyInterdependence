use genesys_2018;

select count(*)
from accession ;
-- 4216179





select a.id, a.instCode, a.acceNumb, a.historic, a.acqDate, a.origCty, 
t.id, t.genus, t.species, t.spAuthor, t.subTaxa, t.subtAuthor, t.taxonName, 
g.longitude, g.latitude, g.datum, g.method, g.uncertainty, g.elevation
from accession a, taxonomy2 t, accession_geo g, acce
where acce.id = a.id
and acce.geoId=g.id
and a.taxonomyId2 =  t.id;



select t.taxonName, count(*)
from (select * from accession limit 100000) a , taxonomy2 t
where a.taxonomyId2 =  t.id
group by t.taxonName;



select t.taxonName, count(*)
from accession a , taxonomy2 t
where a.taxonomyId2 =  t.id
group by t.taxonName;


select t.taxonName, a.origCty, count(*)
from accession a , taxonomy2 t
where a.taxonomyId2 =  t.id
group by t.taxonName,a.origCty;


select a.id, a.instCode, a.acceNumb, a.historic, a.acqDate, a.origCty, 
t.id, t.genus, t.species, t.spAuthor, t.subTaxa, t.subtAuthor, t.taxonName, 
g.longitude, g.latitude, g.datum, g.method, g.uncertainty, g.elevation
from accession a, taxonomy2 t, accession_geo g, acce
where acce.id = a.id
and acce.geoId=g.id
and a.taxonomyId2 =  t.id;


