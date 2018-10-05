# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.3.9-MariaDB)
# Database: m_xpress
# Generation Time: 2018-10-05 12:58:03 +0000
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
  `admin_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `ward` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`admin_id`),
  KEY `Fk_admin_ward` (`ward`),
  CONSTRAINT `Fk_admin_ward` FOREIGN KEY (`ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



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
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`card_id`),
  KEY `Fk_card_ward` (`ward`),
  CONSTRAINT `Fk_card_user` FOREIGN KEY (`card_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `Fk_card_ward` FOREIGN KEY (`ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `card` WRITE;
/*!40000 ALTER TABLE `card` DISABLE KEYS */;

INSERT INTO `card` (`card_id`, `timestamp`, `title`, `lat`, `lng`, `description`, `image`, `category`, `ward`, `user_id`)
VALUES
	(1,'2018-10-05 16:45:56','h1',0,0,'asd','fff','CRIME','A',0);

/*!40000 ALTER TABLE `card` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `comment_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `card_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `description` varchar(256) NOT NULL DEFAULT '',
  `likes` int(11) unsigned DEFAULT NULL,
  `dislikes` int(11) unsigned NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `Fk_comment_card` (`card_id`),
  KEY `Fk_comment_user` (`user_id`),
  CONSTRAINT `Fk_comment_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`),
  CONSTRAINT `Fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table spam
# ------------------------------------------------------------

DROP TABLE IF EXISTS `spam`;

CREATE TABLE `spam` (
  `card_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`card_id`,`user_id`),
  KEY `Fk_spam_user` (`user_id`),
  CONSTRAINT `Fk_spam_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`),
  CONSTRAINT `Fk_spam_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table upvote
# ------------------------------------------------------------

DROP TABLE IF EXISTS `upvote`;

CREATE TABLE `upvote` (
  `card_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`card_id`,`user_id`),
  KEY `Fk_upvote_user` (`user_id`),
  CONSTRAINT `Fk_upvote_card` FOREIGN KEY (`card_id`) REFERENCES `card` (`card_id`),
  CONSTRAINT `Fk_upvote_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL DEFAULT '',
  `email_id` varchar(50) NOT NULL DEFAULT '',
  `oauth_provider` enum('GOOGLE','FACEBOOK') NOT NULL DEFAULT 'GOOGLE',
  `oauth_id` int(11) NOT NULL,
  `default_ward` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`),
  KEY `Fk_user_ward` (`default_ward`),
  CONSTRAINT `Fk_user_ward` FOREIGN KEY (`default_ward`) REFERENCES `ward` (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`user_id`, `username`, `email_id`, `oauth_provider`, `oauth_id`, `default_ward`)
VALUES
	(1,'sagar','anon@google.com','GOOGLE',0,'A');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ward
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ward`;

CREATE TABLE `ward` (
  `ward_name` varchar(30) NOT NULL DEFAULT '',
  `office_address` varchar(200) DEFAULT '',
  PRIMARY KEY (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `ward` WRITE;
/*!40000 ALTER TABLE `ward` DISABLE KEYS */;

INSERT INTO `ward` (`ward_name`, `office_address`)
VALUES
	('',''),
	('A',NULL),
	('Ward B','‘B’ Ward Office Building, 121, Ramchandra Bhatt Marg , Opp.J.J.Hospital , Mumbai-400 009.'),
	('Ward C','‘C’ ward Office Building, 76, Shrikant Palekar Marg, Sonapur Street, Chira Bazar-Kalbadevi, Mumbai – 400002, Near Marine Lines Railway Station, Chandanwadi.'),
	('Ward D','‘D’ ward Office Building, Jobanputra Compound, Nana Chowk, Mumbai-400 007.'),
	('Ward E','‘E’ ward Office Building, 10, Shaikh Haffizuddin Marg, Byculla, Mumbai-400 008.'),
	('Ward F North','‘F/N’ ward Office Building, Plot, No.96, Bhau Daji Marg, Matunga, Mumbai-400 019.'),
	('Ward F South','‘F/S’ ward Office Building, Jagganath Bhatankar Marg, &amp; Dr.B.A.Road Junction, Parel Naka, Mumbai-400 012.'),
	('Ward G North','‘G/N’ ward Office Building, Harischandra Yewale Marg, Behind Plaza Cinema, Dadar, Mumbai-400 028.'),
	('Ward G South','‘G/S’ ward Office Building, N.M.Joshi Marg, Elphinstone, Mumbai-400 018.'),
	('Ward H East','H/E ward Office Building, Plot No.137 TPS-5 Prabhat Colony, Santacruz (E), Mumbai-400 051.'),
	('Ward H West','‘H/W’ ward office Building, Saint Martin Road, Behind, Bandra Police Station , Bandra (West), Mumbai-400050.'),
	('Ward K East','K/E, ward Office Building, Azad Road, Gundavali, Andheri(East), Mumbai-400 069.'),
	('Ward K West','K/West ward Office Building, Paliram Road, Near, S.V. Road, Opp. Andheri Railway Station, Andheri(W), Mumbai-400 058.'),
	('Ward L','Municipal Market Building, S.G.Barve Road, Kurla (West) , Mumbai – 400070.'),
	('Ward M East','M/E Ward Office Bldg., Building Flat no.38 &amp; 39, Village Devnar, M.T. Kadam Marg, Peri Feri Road, Devnar Landmark Devnar Colony, Mumabi-400 043'),
	('Ward M/ West','M/W ward Office Building, Sharadbhau Acharya Marg, Near Natraj Cinema, Chember, Mumbai-400 071.'),
	('Ward N','N ward Annex Building, Jawahar Road, Ghatkopar (E), Mumbai-400 077.'),
	('Ward P North','P/N Ward Office Building, Liberty Garden, Mamletdarwadi Marg, Malad (West), Mumbai-400 064.'),
	('Ward P South','P/S Ward Office Building, Opp.City Center Shopping Mall, S.V. Road, Goregaon, Mumbai-400 064.'),
	('Ward R Central','R/C Ward Office Building, Palika Mandai Buiding, S.V. Raod, Near Boriwali, Railway Station, Borivali (West), Mumbai – 400092.'),
	('Ward R North','R/N Ward Office Building, Sangeetkar Sudhir Phadkey Flyover Bridge, Jaywant Sawant Marg, Dahisar (West), Mumbai-400 068.'),
	('Ward R South','R/South Ward Office Building, Mahatma Gandhi Cross Road No.2, Near S.V.P. Swimming Pool, Kandivali (West), Mumbai – 400 067.'),
	('Ward S','S Ward Office Building, Lalbahadur Shashtri Marg, Near Mangatram Petrol Pump, Bhandup (West), Mumbai – 400078.'),
	('Ward T','T Ward Office Building, Lala Devidayal Marg, Mulund (W), Mumbai – 400080.');

/*!40000 ALTER TABLE `ward` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
