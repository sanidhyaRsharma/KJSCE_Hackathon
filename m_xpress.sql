# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.3.9-MariaDB)
# Database: m_xpress
# Generation Time: 2018-10-06 01:36:53 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table admin
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `admin_id` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `ward` varchar(20) NOT NULL DEFAULT '',
  `position` varchar(30) DEFAULT NULL,
  `contact_num` varchar(15) DEFAULT '',
  PRIMARY KEY (`admin_id`),
  KEY `Fk_admin_ward` (`ward`),
  CONSTRAINT `Fk_admin_ward` FOREIGN KEY (`ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;

INSERT INTO `admin` (`admin_id`, `name`, `password`, `ward`, `position`, `contact_num`)
VALUES
	('admin@example.com','Admin','7110eda4d09e062aa5e4a390b0a572ac0d2c0220','Ward B','ADMIN','0000'),
	('aemt02.a@mcgm.gov.in','Shri Kulbhushan Vora','46f8093b35f07cc029231369b52504dc53228419','Ward A','AE (Maintenance)','8898950168'),
	('co.rs@mcgm.gov.in','Shri Surendranath Naik','46f8093b35f07cc029231369b52504dc53228419','Ward R South','Complaint Officer','7738683069');

/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table card
# ------------------------------------------------------------

DROP TABLE IF EXISTS `card`;

CREATE TABLE `card` (
  `card_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `title` varchar(50) NOT NULL DEFAULT '',
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `image` varchar(100) DEFAULT '',
  `category` enum('ROAD','CRIME','SERVICES','MISC') NOT NULL DEFAULT 'MISC',
  `ward` varchar(10) NOT NULL DEFAULT '',
  `user_id` varchar(50) NOT NULL,
  `status` enum('PENDING','COMPLETED','IN PROGRESS') DEFAULT 'PENDING',
  PRIMARY KEY (`card_id`),
  KEY `Fk_card_ward` (`ward`),
  KEY `Fk_card_user` (`user_id`),
  CONSTRAINT `Fk_card_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `Fk_card_ward` FOREIGN KEY (`ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `card` WRITE;
/*!40000 ALTER TABLE `card` DISABLE KEYS */;

INSERT INTO `card` (`card_id`, `timestamp`, `title`, `lat`, `lng`, `description`, `image`, `category`, `ward`, `user_id`, `status`)
VALUES
	(1,'2018-10-05 22:47:11','Card1',72.8403,18.9488,'This is Card 1','image','MISC','Ward A','1','COMPLETED'),
	(2,'2018-10-05 23:35:20','Card2',27.8403,18.9488,'This is Card 2','image','SERVICES','Ward C','2','COMPLETED');

/*!40000 ALTER TABLE `card` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `comment_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `card_id` int(11) unsigned NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL,
  `description` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`comment_id`),
  KEY `Fk_comment_card` (`card_id`),
  KEY `FK_comment_user` (`user_id`),
  CONSTRAINT `FK_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `Fk_comment_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;

INSERT INTO `comment` (`comment_id`, `card_id`, `user_id`, `timestamp`, `description`)
VALUES
	(1,1,'1','2018-10-05 23:35:47','Oh good'),
	(2,1,'1','2018-10-05 23:36:07','Nice');

/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table spam
# ------------------------------------------------------------

DROP TABLE IF EXISTS `spam`;

CREATE TABLE `spam` (
  `card_id` int(11) unsigned NOT NULL,
  `user_id` varchar(50) NOT NULL,
  PRIMARY KEY (`card_id`,`user_id`),
  KEY `FK_spam_user` (`user_id`),
  CONSTRAINT `FK_spam_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `Fk_spam_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table upvote
# ------------------------------------------------------------

DROP TABLE IF EXISTS `upvote`;

CREATE TABLE `upvote` (
  `card_id` int(11) unsigned NOT NULL,
  `user_id` varchar(50) NOT NULL,
  PRIMARY KEY (`card_id`,`user_id`),
  KEY `Fk_upvote_user` (`user_id`),
  CONSTRAINT `Fk_upvote_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` varchar(50) NOT NULL,
  `username` varchar(30) DEFAULT '',
  `email_id` varchar(50) DEFAULT '',
  `oauth_provider` enum('GOOGLE','FACEBOOK') DEFAULT 'GOOGLE',
  `oauth_id` int(11) DEFAULT NULL,
  `default_ward` varchar(10) DEFAULT 'Ward A',
  PRIMARY KEY (`user_id`),
  KEY `FK_user_Ward` (`default_ward`),
  CONSTRAINT `FK_user_Ward` FOREIGN KEY (`default_ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`user_id`, `username`, `email_id`, `oauth_provider`, `oauth_id`, `default_ward`)
VALUES
	('1','sagar','anon@google.com','GOOGLE',0,'Ward B'),
	('2','Sanidhya','anon@google.com','GOOGLE',0,'Ward C');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ward
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ward`;

CREATE TABLE `ward` (
  `ward_name` varchar(30) NOT NULL DEFAULT '',
  `office_address` varchar(200) DEFAULT '',
  `ward_region` varchar(60) DEFAULT NULL,
  `post_code` int(6) DEFAULT NULL,
  PRIMARY KEY (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `ward` WRITE;
/*!40000 ALTER TABLE `ward` DISABLE KEYS */;

INSERT INTO `ward` (`ward_name`, `office_address`, `ward_region`, `post_code`)
VALUES
	('Ward A','‘A’ Ward Office Building, 134 ‘E’ Shahid Bhagat Singh Marg, Near R.B.I., Fort, Mumbai-400001.','Fort',400001),
	('Ward B','‘B’ Ward Office Building, 121, Ramchandra Bhatt Marg , Opp.J.J.Hospital , Mumbai-400 009.','Opp.J.J.Hospital',400009),
	('Ward C','‘C’ ward Office Building, 76, Shrikant Palekar Marg, Sonapur Street, Chira Bazar-Kalbadevi, Mumbai – 400002, Near Marine Lines Railway Station, Chandanwadi.','Chira Bazar-Kalbadevi',400002),
	('Ward D','‘D’ ward Office Building, Jobanputra Compound, Nana Chowk, Mumbai-400 007.','Nana Chowk',400007),
	('Ward E','‘E’ ward Office Building, 10, Shaikh Haffizuddin Marg, Byculla, Mumbai-400 008.','Byculla',400008),
	('Ward F North','‘F/N’ ward Office Building, Plot, No.96, Bhau Daji Marg, Matunga, Mumbai-400 019.','Matunga',400019),
	('Ward F South','‘F/S’ ward Office Building, Jagganath Bhatankar Marg, &amp; Dr.B.A.Road Junction, Parel Naka, Mumbai-400 012.','Parel Naka',400012),
	('Ward G North','‘G/N’ ward Office Building, Harischandra Yewale Marg, Behind Plaza Cinema, Dadar, Mumbai-400 028.','Dadar',400028),
	('Ward G South','‘G/S’ ward Office Building, N.M.Joshi Marg, Elphinstone, Mumbai-400 018.','Elphinstone',400018),
	('Ward H East','H/E ward Office Building, Plot No.137 TPS-5 Prabhat Colony, Santacruz (E), Mumbai-400 051.','Santacruz (E)',400051),
	('Ward H West','‘H/W’ ward office Building, Saint Martin Road, Behind, Bandra Police Station , Bandra (West), Mumbai-400050.','Bandra (West)',400050),
	('Ward K East','K/E, ward Office Building, Azad Road, Gundavali, Andheri(East), Mumbai-400 069.','Andheri(East)',400069),
	('Ward K West','K/West ward Office Building, Paliram Road, Near, S.V. Road, Opp. Andheri Railway Station, Andheri(W), Mumbai-400 058.','Andheri(W)',400058),
	('Ward L','Municipal Market Building, S.G.Barve Road, Kurla (West) , Mumbai – 400070.','Kurla (West)',400070),
	('Ward M East','M/E Ward Office Bldg., Building Flat no.38 &amp; 39, Village Devnar, M.T. Kadam Marg, Peri Feri Road, Devnar Landmark Devnar Colony, Mumabi-400 043','Devnar Landmark Devnar Colony',400043),
	('Ward M West','M/W ward Office Building, Sharadbhau Acharya Marg, Near Natraj Cinema, Chember, Mumbai-400 071.','Chember',400071),
	('Ward N','N ward Annex Building, Jawahar Road, Ghatkopar (E), Mumbai-400 077.','Ghatkopar (E)',400077),
	('Ward P North','P/N Ward Office Building, Liberty Garden, Mamletdarwadi Marg, Malad (West), Mumbai-400 064.','Malad (West)',400064),
	('Ward P South','P/S Ward Office Building, Opp.City Center Shopping Mall, S.V. Road, Goregaon, Mumbai-400 064.','Goregaon',400064),
	('Ward R Central','R/C Ward Office Building, Palika Mandai Buiding, S.V. Raod, Near Boriwali, Railway Station, Borivali (West), Mumbai – 400092.','Borivali (West)',400092),
	('Ward R North','R/N Ward Office Building, Sangeetkar Sudhir Phadkey Flyover Bridge, Jaywant Sawant Marg, Dahisar (West), Mumbai-400 068.','Dahisar (West)',400068),
	('Ward R South','R/South Ward Office Building, Mahatma Gandhi Cross Road No.2, Near S.V.P. Swimming Pool, Kandivali (West), Mumbai – 400 067.','Kandivali (West)',400067),
	('Ward S','S Ward Office Building, Lalbahadur Shashtri Marg, Near Mangatram Petrol Pump, Bhandup (West), Mumbai – 400078.','Bhandup (West)',400078),
	('Ward T','T Ward Office Building, Lala Devidayal Marg, Mulund (W), Mumbai – 400080.','Mulund (W)',400080);

/*!40000 ALTER TABLE `ward` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
