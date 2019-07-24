SELECT twp FROM genesys_2018.PLUTO
group by twp;

SELECT count(*) FROM genesys_2018.PLUTO;

SELECT cc FROM genesys_2018.PLUTO
group by cc;

SELECT submit_date FROM genesys_2018.PLUTO
group by submit_date;

SELECT common_name_en, count(*) count FROM genesys_2018.PLUTO
group by common_name_en
order by count desc;

SELECT uc, count(*) count FROM genesys_2018.PLUTO
group by uc
order by count desc;

SELECT party_breeder FROM genesys_2018.PLUTO
group by party_breeder;

SELECT * FROM genesys_2018.PLUTO
order by rand()
limit 300;


SELECT parties_text FROM genesys_2018.PLUTO
group by parties_text;

SELECT * FROM genesys_2018.PLUTO
where cc="CO";

select cleaned, count(*) from(
SELECT SUBSTR(trim(lower(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
party_titleHolder,'`',''),'-',''),'/',''),';',''),' ',''),',',''),':',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9',''),'0',''),'&','and'),'\'',''),'"',''),'.',''))) 
, 1, 20) 
as cleaned, party_titleHolder

 FROM genesys_2018.PLUTO  
 group by party_titleHolder) m 
 group by cleaned
;


