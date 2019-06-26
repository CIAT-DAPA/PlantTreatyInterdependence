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