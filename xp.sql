CREATE TABLE `boss_reputation` (
	`id` INT NOT NULL,
	`cid` VARCHAR(50) NOT NULL,
	`rep` INT,
	PRIMARY KEY (`cid`)
) ENGINE=InnoDB;