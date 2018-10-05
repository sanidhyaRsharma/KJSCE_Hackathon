# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.3.9-MariaDB)
# Database: m_xpress
# Generation Time: 2018-10-05 10:17:34 +0000
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



# Dump of table ward
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ward`;

CREATE TABLE `ward` (
  `ward_name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`ward_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
