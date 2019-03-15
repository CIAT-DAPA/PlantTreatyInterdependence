SELECT * FROM genesys_2018.WIEWS W
where W.﻿Year = "0";

SELECT * FROM genesys_2018.WIEWS W
where W.﻿Year is null;

SELECT * FROM genesys_2018.WIEWS W
order by RAND()
 limit 1000;


SELECT * FROM mysql.user;

SELECT W.`Acquisition date (YYYY/MM)` FROM genesys_2018.WIEWS W
group by W.`Acquisition date (YYYY/MM)`;

SELECT W.`Source of information`, count(*) FROM genesys_2018.WIEWS W
group by W.`Source of information`;


SELECT count(*) FROM genesys_2018.WIEWS W
where `Source of information` != "'GENESYS (https://www.genesys-pgr.org)'"
;

