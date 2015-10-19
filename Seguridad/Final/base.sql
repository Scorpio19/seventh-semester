-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.7-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for electricity
CREATE DATABASE IF NOT EXISTS `electricity` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `electricity`;


-- Dumping structure for table electricity.status
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` varchar(30) NOT NULL,
  `payment_date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `UserID` (`user_id`),
  CONSTRAINT `UserID` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table electricity.status: ~12 rows (approximately)
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` (`id`, `user_id`, `status`, `payment_date`) VALUES
	(1, 1, 'paid', '2014-06-18'),
	(2, 1, 'paid', '2014-12-18'),
	(3, 1, 'overdue', '2015-06-18'),
	(4, 2, 'paid', '2014-06-18'),
	(5, 2, 'paid', '2014-12-18'),
	(6, 2, 'paid', '2015-06-18'),
	(7, 3, 'overdue', '2014-06-18'),
	(8, 3, 'paid', '2014-12-18'),
	(9, 3, 'paid', '2015-12-18'),
	(10, 4, 'overdue', '2014-06-18'),
	(11, 4, 'overdue', '2014-12-18'),
	(12, 4, 'overdue', '2015-12-18');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;


-- Dumping structure for table electricity.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `username` varchar(300) NOT NULL,
  `password` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table electricity.users: ~4 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `password`) VALUES
	(1, 'diego', 'password'),
	(2, 'azuri', 'password'),
	(3, 'quin', 'password'),
	(4, 'munris', 'password');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
