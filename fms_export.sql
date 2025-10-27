-- MySQL dump 10.13  Distrib 9.4.0, for macos15.4 (arm64)
--
-- Host: localhost    Database: fms
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `FlightID` int NOT NULL AUTO_INCREMENT,
  `RouteID` int NOT NULL,
  `TotalSeats` int NOT NULL,
  `ArrivalTime` datetime NOT NULL,
  `DepartureTime` datetime NOT NULL,
  `FlightName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`FlightID`),
  KEY `RouteID` (`RouteID`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`RouteID`) REFERENCES `route` (`RouteID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=996 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES (1,1,5,'2025-10-12 11:00:00','2025-10-12 09:00:00','Indigo'),(2,1,5,'2025-10-12 16:00:00','2025-10-12 14:00:00','Air India'),(3,2,5,'2025-10-12 13:30:00','2025-10-12 10:00:00','Spice Jet'),(4,3,5,'2025-10-12 15:00:00','2025-10-12 12:30:00','Vistara');
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `TransactionID` varchar(50) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `Status` enum('Success','Pending','Failed') NOT NULL,
  `PaymentMode` enum('Card','UPI','NetBanking') NOT NULL,
  PRIMARY KEY (`TransactionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES ('TXN1002',5000.00,'Success','UPI'),('TXN1003',8000.00,'Pending','NetBanking');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pilot`
--

DROP TABLE IF EXISTS `pilot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pilot` (
  `PilotID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  PRIMARY KEY (`PilotID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pilot`
--

LOCK TABLES `pilot` WRITE;
/*!40000 ALTER TABLE `pilot` DISABLE KEYS */;
INSERT INTO `pilot` VALUES (1,'Captain Rajesh Kumar'),(2,'Captain Priya Sharma'),(3,'Captain Anil Verma');
/*!40000 ALTER TABLE `pilot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pilot_assignment`
--

DROP TABLE IF EXISTS `pilot_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pilot_assignment` (
  `FlightID` int NOT NULL,
  `PilotID` int NOT NULL,
  PRIMARY KEY (`FlightID`,`PilotID`),
  KEY `PilotID` (`PilotID`),
  CONSTRAINT `pilot_assignment_ibfk_1` FOREIGN KEY (`FlightID`) REFERENCES `flight` (`FlightID`) ON DELETE CASCADE,
  CONSTRAINT `pilot_assignment_ibfk_2` FOREIGN KEY (`PilotID`) REFERENCES `pilot` (`PilotID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pilot_assignment`
--

LOCK TABLES `pilot_assignment` WRITE;
/*!40000 ALTER TABLE `pilot_assignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `pilot_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(500) NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES (29,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjIsImlhdCI6MTc2MTQ4NzY4MSwiZXhwIjoxNzYyMDkyNDgxfQ.F9MUf27EdGD5SvncjnU63j0kPQr1jPMHf4iLzxKjSPg','2025-11-02 19:38:01');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route` (
  `RouteID` int NOT NULL AUTO_INCREMENT,
  `Source` varchar(100) NOT NULL,
  `Destination` varchar(100) NOT NULL,
  `Duration` time DEFAULT NULL,
  `Distance` float DEFAULT NULL,
  PRIMARY KEY (`RouteID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES (1,'Delhi','Mumbai','02:00:00',1400),(2,'Delhi','Bangalore','03:30:00',2150),(3,'Mumbai','Chennai','02:30:00',1230),(4,'Kolkata','Delhi','02:45:00',1500),(5,'Hyderabad','Mumbai','01:50:00',710);
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `SeatID` int NOT NULL AUTO_INCREMENT,
  `FlightID` int NOT NULL,
  `SeatNumber` varchar(10) NOT NULL,
  `Category` enum('Economy','Business','First') NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Status` enum('Available','Booked') NOT NULL DEFAULT 'Available',
  PRIMARY KEY (`SeatID`),
  KEY `FlightID` (`FlightID`),
  CONSTRAINT `seat_ibfk_1` FOREIGN KEY (`FlightID`) REFERENCES `flight` (`FlightID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` VALUES (5,1,'2B','Business',8000.00,'Booked'),(6,2,'3B','Economy',5000.00,'Booked'),(14,3,'2A','Business',9000.00,'Booked'),(17,4,'2B','Economy',4500.00,'Booked'),(21,1,'1E','Business',8000.00,'Booked'),(22,1,'1F','Business',8000.00,'Booked'),(23,1,'1E','Business',8000.00,'Booked'),(24,1,'1F','Business',8000.00,'Booked'),(25,1,'1B','Business',8000.00,'Booked'),(26,1,'1B','Business',8000.00,'Booked'),(27,2,'5E','Economy',3000.00,'Booked'),(28,2,'5E','Economy',3000.00,'Booked'),(29,2,'6E','Economy',3000.00,'Booked'),(30,2,'6E','Economy',3000.00,'Booked'),(31,2,'6F','Economy',3000.00,'Booked'),(32,2,'6F','Economy',3000.00,'Booked'),(33,2,'5F','Economy',3000.00,'Booked'),(34,2,'5F','Economy',3000.00,'Booked'),(35,1,'6F','Economy',3000.00,'Booked'),(36,1,'6F','Economy',3000.00,'Booked');
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'Menhaz','menhazul12345@gmail.com','$2b$10$htQ86oF7m7La2kDdX46tLuRr0reo4Gf7vaTKyPy2I3g4JxnxBmGV2','user','2025-10-23 17:41:45'),(3,'Ruchika','ruchikasharma030504@gmail.com','$2b$10$hiU8e1Vef6weqSyELaMLCOzEG265yePXRSWGM6Swq75XpWSHVah2.','user','2025-10-25 16:05:46'),(4,'Raj','raj@gmail.com','$2b$10$uYXYTS4kIcIVzHoE9q45wOuPwsgd/azysLmwpecfmFvHmwIsTAgVC','user','2025-10-25 16:17:43'),(5,'Temp','w@gmail.com','$2b$10$I/uMf015IVBpfo7kgX9Jo.rEstoy84xov58Hq/37jAaSENvs0BqyO','user','2025-10-25 16:20:54'),(6,'temp','q@gmail.com','$2b$10$E5VpRaAPpd0p6xgDnRm/2exnSjYX6Dv8/y9jMB33fZfswqJzhNbpq','user','2025-10-25 16:22:20'),(7,'ruchika','ruchika9265@gmail.com','$2b$10$9s7B3G/xv9gI2AHDWVXtMu.3Gbzi9tUAOwoRkRVK6TeWSf9HHbQjK','user','2025-10-26 08:55:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-27 23:00:22
