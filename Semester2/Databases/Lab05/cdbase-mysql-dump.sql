CREATE DATABASE  IF NOT EXISTS `cdbase` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `cdbase`;
-- MySQL dump 10.13  Distrib 5.5.33, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: cdbase
-- ------------------------------------------------------
-- Server version	5.5.33-0+wheezy1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `track`
--

DROP TABLE IF EXISTS `track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `track` (
  `pid` int(10) NOT NULL,
  `cid` int(10) NOT NULL,
  `sid` int(10) NOT NULL,
  `pos` int(10) NOT NULL,
  PRIMARY KEY (`cid`,`pos`),
  KEY `track_ibfk_2` (`sid`),
  KEY `track_ibfk_3` (`pid`),
  CONSTRAINT `track_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `cd` (`cid`) ON UPDATE CASCADE,
  CONSTRAINT `track_ibfk_2` FOREIGN KEY (`sid`) REFERENCES `song` (`sid`) ON UPDATE CASCADE,
  CONSTRAINT `track_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `performer` (`pid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track`
--

LOCK TABLES `track` WRITE;
/*!40000 ALTER TABLE `track` DISABLE KEYS */;
INSERT INTO `track` VALUES (1,1,1,1),(1,1,2,2),(1,1,3,3),(1,1,4,4),(1,1,5,5),(1,1,6,6),(1,1,7,7),(1,1,8,8),(1,1,9,9),(1,1,10,10),(1,1,11,11),(1,1,12,12),(1,1,13,13),(2,2,14,1),(2,2,15,2),(2,2,16,3),(2,2,17,4),(2,2,18,5),(2,2,19,6),(2,2,20,7),(2,2,21,8),(2,2,22,9),(2,2,23,10),(2,2,24,11),(2,2,25,12),(2,2,26,13),(2,2,27,14),(2,2,28,15),(2,2,29,16),(2,2,30,17),(3,3,31,1),(3,3,32,2),(3,3,33,3),(3,3,34,4),(3,3,35,5),(3,3,36,6),(3,3,37,7),(3,3,38,8),(3,3,39,9),(3,3,40,10),(3,3,41,11),(3,3,42,12),(3,3,43,13),(3,3,44,14),(3,3,45,15),(3,3,46,16),(3,3,47,17),(3,3,48,18),(3,3,49,19),(3,3,50,20),(3,3,51,21),(3,3,52,22),(3,3,53,23),(3,3,54,24),(4,4,55,1),(4,4,56,2),(4,4,57,3),(4,4,58,4),(4,4,59,5),(4,4,60,6),(4,4,61,7),(4,4,62,8),(4,5,62,1),(4,5,63,2),(4,5,64,3),(4,5,65,4),(4,5,66,5),(4,5,67,6),(4,5,68,7),(5,6,69,1),(5,6,70,2),(5,6,71,3),(5,6,72,4),(5,6,73,5),(6,7,74,1),(6,7,75,2),(6,7,76,3),(6,7,77,4),(6,7,78,5),(6,7,79,6),(6,7,80,7),(6,7,81,8),(6,7,82,9),(6,7,83,10),(6,7,84,11),(1,8,85,1),(1,8,86,2),(1,8,87,3),(1,8,88,4),(1,8,89,5),(1,8,90,6),(1,8,91,7),(1,8,92,8),(1,8,93,9),(1,8,94,10),(1,8,95,11),(1,8,96,12),(7,9,97,1),(7,9,98,2),(7,9,99,3),(7,9,100,4),(7,9,101,5),(7,9,102,6),(7,9,103,7),(7,9,104,8),(7,9,105,9),(7,9,106,10),(7,9,107,11),(7,9,108,12),(8,10,109,1),(8,10,110,2),(8,10,111,3),(8,10,112,4),(8,10,113,5),(9,11,114,1),(9,11,115,2),(9,11,116,3),(9,11,117,4),(9,11,118,5),(9,11,119,6),(9,11,120,7),(9,11,121,8),(9,11,122,9),(9,11,123,10),(10,12,124,1),(10,12,125,2),(10,12,126,3),(10,12,127,4),(10,12,128,5),(10,12,129,6),(10,12,130,7),(10,12,131,8),(10,12,132,9),(11,13,133,1),(11,13,134,2),(11,13,135,3),(11,13,136,4),(11,13,137,5),(11,13,138,6),(11,13,139,7),(12,14,140,1),(12,14,141,2),(12,14,142,3),(12,14,143,4),(12,14,144,5),(12,14,145,6),(12,14,146,7),(12,14,147,8),(12,14,148,9),(12,14,149,10),(12,14,150,11),(12,14,151,12),(12,14,152,13),(12,14,153,14);
/*!40000 ALTER TABLE `track` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `comid` int(10) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`comid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'XL'),(2,'Shout! Factory'),(3,'Fuel 2000'),(4,'Impulse!'),(5,'ZYX Music'),(6,'Original Jazz Classics'),(7,'Decca'),(8,'Collectables'),(9,'Deram'),(10,'WEA'),(11,'Capitol'),(12,'Blue Note');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performer`
--

DROP TABLE IF EXISTS `performer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `performer` (
  `pid` int(10) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performer`
--

LOCK TABLES `performer` WRITE;
/*!40000 ALTER TABLE `performer` DISABLE KEYS */;
INSERT INTO `performer` VALUES (1,'Adele'),(2,'Buddy Guy'),(3,'Otis Rush'),(4,'John Coltrane'),(5,'Miles Davis'),(6,'Madeleine Peyroux'),(7,'The Staples Singers'),(8,'Camel'),(9,'Joy Division'),(10,'Cure'),(11,'Grand Funk Railroad'),(12,'Motörhead');
/*!40000 ALTER TABLE `performer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cd`
--

DROP TABLE IF EXISTS `cd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cd` (
  `cid` int(10) NOT NULL,
  `ctitle` varchar(100) DEFAULT NULL,
  `year` int(10) DEFAULT NULL,
  `comid` int(10) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `fk_cd_1` (`comid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cd`
--

LOCK TABLES `cd` WRITE;
/*!40000 ALTER TABLE `cd` DISABLE KEYS */;
INSERT INTO `cd` VALUES (1,'Adele 21',2011,1),(2,'The Definitive Buddy Guy',2009,2),(3,'The Essential Otis Rush - The Classic Cobra Recordings 1956 – 1958',2000,3),(4,'A Love Supreme',1964,4),(5,'Ballads Of John Coltrane',NULL,5),(6,'Cookin\' With The Miles Davis Quintet',1956,6),(7,'Blue Room',2013,7),(8,'Adele 19',2008,1),(9,'Swing Low Sweet Chariot',1961,8),(10,'Mirage',1974,9),(11,'Unknown Pleasures',1979,10),(12,'Seventeen Seconds',1980,20),(13,'E Pluribus Funk',1972,11),(14,'Aftershock',2013,21);
/*!40000 ALTER TABLE `cd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `song` (
  `sid` int(10) NOT NULL,
  `stitle` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'Rolling in the Deep'),(2,'Rumour Has It '),(3,'Turning Tables '),(4,'Don\'t You Remember '),(5,'Set Fire to the Rain'),(6,'He Won\'t Go '),(7,'Take It All '),(8,'I\'ll Be Waiting '),(9,'One and Only '),(10,'Lovesong '),(11,'Someone Like You '),(12,'If It Hadn\'t Been for Love '),(13,'Hiding My Heart '),(14,'Sit And Cry (The Blues)'),(15,'First Time I Met The Blues'),(16,'Ten Years Ago'),(17,'Stone Crazy'),(18,'When My Left Eye Jumps'),(19,'Hoodoo Man Blues'),(20,'A Man And The Blues'),(21,'I Got My Eyes on You (live)'),(22,'Five Long Years'),(23,'A Man Of Many Words'),(24,'The Things I Used To Do (live)'),(25,'When I Left Home'),(26,'Give Me My Coat And Shoes'),(27,'She Suits Me To A \"T\"'),(28,'Checkin\' On My Baby (live) '),(29,'Let Me Love You Baby (live)'),(30,'Baby Please Don\'t Leave Me'),(31,'I Can\'t Quit You Baby'),(32,'Sit Down Baby (1)'),(33,'Violent Love'),(34,'My Love Will Never Die'),(35,'Groaning The Blues'),(36,'If You Were Mine'),(37,'Love That Woman'),(38,'Jump Sister Bessie'),(39,'Three Times A Fool'),(40,'She\'s A Good \'Un'),(41,'It Takes Time'),(42,'Checking On My Baby'),(43,'Double Trouble'),(44,'Keep On Loving Me Baby'),(45,'All Your Love (I Miss Loving)'),(46,'My Baby Is A Good \'Un'),(47,'I Can\'t Quit You Baby (Take 3)'),(48,'Sit Down Baby (2)'),(49,'Groaning The Blues (Take 3)'),(50,'My Love Will Never Die (Take Unknown)'),(51,'She\'s A Good \'Un (Take 4)'),(52,'Three Times A Fool (Take Unknown)'),(53,'Double Trouble (Take 3)'),(54,'Sit Down Baby (Take Unknown)'),(55,'Acknowledgement'),(56,'Resolution'),(57,'Pursuance'),(58,'Psalm'),(59,'India'),(60,'Up agaisnt the wall'),(61,'Impressions'),(62,'After The Rain'),(63,'Dear Old Stockholm'),(64,'Greensleeves'),(65,'Nature Boy'),(66,'Dear Lord'),(67,'Welcome'),(68,'I Want To Talk About You'),(69,'My Funny Valentine'),(70,'Blues By Five-False Start'),(71,'Blues By Five'),(72,'Airegin'),(73,'Tune Up-When Lights Are Low'),(74,'Take These Chains'),(75,'Bye Bye Love'),(76,'Changing All Those Changes'),(77,'Born To Lose'),(78,'Guilty'),(79,'Bird On The Wire'),(80,'I Can\'t Stop Loving You'),(81,'Gentle On My Mind'),(82,'You Don\'t Know Me'),(83,'Desperados Under The Eaves'),(84,'I Love You So Much It Hurts'),(85,'Daydreamer'),(86,'Best For Last'),(87,'Chasing Pavements'),(88,'Cold Shoulder'),(89,'Crazy For You'),(90,'Melt My Heart To Stone'),(91,'First Love'),(92,'Right As Rain'),(93,'Make You Feel The Same'),(94,'My Same'),(95,'Tired'),(96,'Hometown Glory'),(97,'I\'m So Glad'),(98,'Swing Down Chariot'),(99,'The Old Landmark'),(100,'Good News'),(101,'Each Day'),(102,'Uncloudy Day'),(103,'Let\'s Go Home'),(104,'Pray On'),(105,'Help Me Jesus'),(106,'Going Away'),(107,'Don\'t Knock'),(108,'Swing Low Sweet Chariot'),(109,'Freefall '),(110,'Supertwister'),(111,'Nimrodel The Procession The White Rider '),(112,'Earthrise '),(113,'Enconter Smiles For You Lady Fantasy'),(114,'Disorder'),(115,'Day of the Lords'),(116,'Candidate'),(117,'Insight'),(118,'New Dawn Fades'),(119,'She\'s Lost Control'),(120,'Shadowplay'),(121,'Wilderness'),(122,'Interzone'),(123,'I Remember Nothing'),(124,'A Reflection'),(125,'Play For Today'),(126,'Secrets'),(127,'In Your House'),(128,'Three'),(129,'The Final Sound'),(130,'A Forest'),(131,'M'),(132,'At Night'),(133,'Foot Stompin\' Music'),(134,'People Let\'s Stop The War'),(135,'Upsetter'),(136,'I Come Tumblin\''),(137,'Save The Land'),(138,'No Lies'),(139,'Loneliness'),(140,'Heartbreaker'),(141,'Coup De Grace'),(142,'Lost Woman Blues'),(143,'End Of Time'),(144,'Do You Believe'),(145,'Death Machine'),(146,'Dust And Glass'),(147,'Going To Mexico'),(148,'Silence When You Speak To Me'),(149,'Crying Shame'),(150,'Queen Of The Damned'),(151,'Knife'),(152,'Keep Your Powder Dry'),(153,'Paralyzed');
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-04 15:46:50
