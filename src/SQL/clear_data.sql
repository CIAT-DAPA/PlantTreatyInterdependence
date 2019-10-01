use planttreaty;

SET FOREIGN_KEY_CHECKS = 0; 

truncate table measures;
#truncate table crops;

ALTER TABLE measures AUTO_INCREMENT=0;
#ALTER TABLE crops AUTO_INCREMENT=0;

SET FOREIGN_KEY_CHECKS = 1;


use indicator;

SET FOREIGN_KEY_CHECKS = 0; 

truncate table measures;
truncate table metric;
truncate table `group`;
truncate table component;
truncate table domain;
truncate table crops;

ALTER TABLE measures AUTO_INCREMENT=0;
ALTER TABLE metric AUTO_INCREMENT=0;
ALTER TABLE `group` AUTO_INCREMENT=0;
ALTER TABLE component AUTO_INCREMENT=0;
ALTER TABLE domain AUTO_INCREMENT=0;
ALTER TABLE crops AUTO_INCREMENT=0;

SET FOREIGN_KEY_CHECKS = 1;