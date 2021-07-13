select W.`Holding institute name` as inst, SUBSTRING(W.`Holding institute code`, 1, 3) as country from WIEWS W
group by inst;