-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: student
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcement_views`
--

DROP TABLE IF EXISTS `announcement_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement_views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `announcement_id` int NOT NULL,
  `student_id` int NOT NULL,
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_announcement_student` (`announcement_id`,`student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `announcement_views_ibfk_1` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `announcement_views_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student` (`id_student`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement_views`
--

LOCK TABLES `announcement_views` WRITE;
/*!40000 ALTER TABLE `announcement_views` DISABLE KEYS */;
INSERT INTO `announcement_views` VALUES (1,1,1,'2025-08-18 12:20:20');
/*!40000 ALTER TABLE `announcement_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `class_name` varchar(100) NOT NULL,
  `teacher_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_ann_teacher` (`teacher_id`),
  CONSTRAINT `fk_ann_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,'Namaste','Wht uppp','Class 10A',1,'2025-08-18 12:16:08');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `link` text NOT NULL,
  `class_name` varchar(100) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignments`
--

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
INSERT INTO `assignments` VALUES (1,'Hello Habibj','https://classroom.google.com/c/Nzk4Njk1OTY3NzQ4/a/Nzk4Njk1OTg4MjY5/details','Class 10A','Maths','2025-08-17 08:34:36');
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_links`
--

DROP TABLE IF EXISTS `class_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_links` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class` varchar(100) NOT NULL,
  `url` varchar(500) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `class` (`class`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_links`
--

LOCK TABLES `class_links` WRITE;
/*!40000 ALTER TABLE `class_links` DISABLE KEYS */;
INSERT INTO `class_links` VALUES (1,'Class 10A','https://drive.google.com/drive/folders/1x_BmqJ1hS3Lv1O8m_Lhjrjo9waE7l4rJ','2025-08-19 11:35:22');
/*!40000 ALTER TABLE `class_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress_report_subjects`
--

DROP TABLE IF EXISTS `progress_report_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress_report_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_id` int NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `grade` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_id` (`report_id`),
  CONSTRAINT `progress_report_subjects_ibfk_1` FOREIGN KEY (`report_id`) REFERENCES `progress_reports` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_report_subjects`
--

LOCK TABLES `progress_report_subjects` WRITE;
/*!40000 ALTER TABLE `progress_report_subjects` DISABLE KEYS */;
INSERT INTO `progress_report_subjects` VALUES (1,1,'maths','a+'),(2,2,'Maths','A');
/*!40000 ALTER TABLE `progress_report_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress_reports`
--

DROP TABLE IF EXISTS `progress_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `term` varchar(50) DEFAULT NULL,
  `remarks` text,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `progress_reports_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id_student`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_reports`
--

LOCK TABLES `progress_reports` WRITE;
/*!40000 ALTER TABLE `progress_reports` DISABLE KEYS */;
INSERT INTO `progress_reports` VALUES (1,1,'Hello','great job','2025-08-15'),(2,2,'First','Great work','2025-08-07');
/*!40000 ALTER TABLE `progress_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','answered') DEFAULT 'pending',
  `teacher_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_questions`
--

DROP TABLE IF EXISTS `quiz_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `question` text NOT NULL,
  `option_a` varchar(255) NOT NULL,
  `option_b` varchar(255) NOT NULL,
  `option_c` varchar(255) NOT NULL,
  `option_d` varchar(255) NOT NULL,
  `correct_option` enum('A','B','C','D') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `quiz_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_questions`
--

LOCK TABLES `quiz_questions` WRITE;
/*!40000 ALTER TABLE `quiz_questions` DISABLE KEYS */;
INSERT INTO `quiz_questions` VALUES (1,1,'Jj','s','s','s','s','B'),(2,2,'hh','e','e','e','e','D');
/*!40000 ALTER TABLE `quiz_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_results`
--

DROP TABLE IF EXISTS `quiz_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `student_name` varchar(100) DEFAULT NULL,
  `score` int NOT NULL,
  `total_questions` int NOT NULL,
  `completed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `quiz_results_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_results`
--

LOCK TABLES `quiz_results` WRITE;
/*!40000 ALTER TABLE `quiz_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `quiz_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
INSERT INTO `quizzes` VALUES (1,'New Quiz','2025-08-19 17:06:37'),(2,'New Quiz 2','2025-08-19 17:06:57');
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `id_student` int NOT NULL AUTO_INCREMENT,
  `student_name` varchar(45) NOT NULL,
  `user_id` int NOT NULL,
  `class` varchar(45) NOT NULL DEFAULT '2',
  PRIMARY KEY (`id_student`),
  KEY `fk_student_user` (`user_id`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'Student01',1,'Class 10A'),(2,'Student03',5,'Class 10A');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assignment_id` int NOT NULL,
  `id_student` int NOT NULL,
  `status` enum('done','not_done') NOT NULL DEFAULT 'done',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assignment_student` (`assignment_id`,`id_student`),
  KEY `id_student` (`id_student`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`id_student`) REFERENCES `student` (`id_student`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
INSERT INTO `submissions` VALUES (1,1,1,'done','2025-08-18 04:42:25');
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `teacher_id` int NOT NULL AUTO_INCREMENT,
  `teacher_name` varchar(45) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`teacher_id`),
  KEY `fk_teacher_user` (`user_id`),
  CONSTRAINT `fk_teacher_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (1,'Teacher01',2),(2,'Student02',3),(3,'Teacher02',4);
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class` varchar(50) NOT NULL,
  `day` varchar(20) NOT NULL,
  `time_slot` varchar(20) NOT NULL,
  `subject` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES (1,'Class 10A','Monday','08:00 - 09:00','Maths'),(2,'Class 10A','Monday','09:00 - 10:00','Maths'),(3,'Class 10A','Monday','10:00 - 11:00','Maths'),(4,'Class 10A','Monday','11:00 - 12:00','Maths'),(5,'Class 10A','Monday','12:00 - 13:00','Lunch'),(6,'Class 10A','Monday','13:00 - 14:00','History'),(7,'Class 10A','Monday','14:00 - 15:00','Geography'),(8,'Class 10A','Monday','15:00 - 16:00','Art'),(9,'Class 10A','Tuesday','08:00 - 09:00','Maths'),(10,'Class 10A','Tuesday','09:00 - 10:00','Science'),(11,'Class 10A','Tuesday','10:00 - 11:00','History'),(12,'Class 10A','Tuesday','11:00 - 12:00','PE'),(13,'Class 10A','Tuesday','12:00 - 13:00','Lunch'),(14,'Class 10A','Tuesday','13:00 - 14:00','ICT'),(15,'Class 10A','Tuesday','14:00 - 15:00','Music'),(16,'Class 10A','Tuesday','15:00 - 16:00','Language'),(17,'Class 10A','Wednesday','08:00 - 09:00','Science'),(18,'Class 10A','Wednesday','09:00 - 10:00','ICT'),(19,'Class 10A','Wednesday','10:00 - 11:00','Maths'),(20,'Class 10A','Wednesday','11:00 - 12:00','English'),(21,'Class 10A','Wednesday','12:00 - 13:00','Lunch'),(22,'Class 10A','Wednesday','13:00 - 14:00','Art'),(23,'Class 10A','Wednesday','14:00 - 15:00','History'),(24,'Class 10A','Wednesday','15:00 - 16:00','Geography'),(25,'Class 10A','Thursday','08:00 - 09:00','Maths'),(26,'Class 10A','Thursday','09:00 - 10:00','English'),(27,'Class 10A','Thursday','10:00 - 11:00','History'),(28,'Class 10A','Thursday','11:00 - 12:00','Science'),(29,'Class 10A','Thursday','12:00 - 13:00','Lunch'),(30,'Class 10A','Thursday','13:00 - 14:00','Geography'),(31,'Class 10A','Thursday','14:00 - 15:00','History'),(32,'Class 10A','Thursday','15:00 - 16:00','History'),(33,'Class 10A','Friday','08:00 - 09:00','Maths'),(34,'Class 10A','Friday','09:00 - 10:00','Science'),(35,'Class 10A','Friday','10:00 - 11:00','English'),(36,'Class 10A','Friday','11:00 - 12:00','Sinhala'),(37,'Class 10A','Friday','12:00 - 13:00','Lunch'),(38,'Class 10A','Friday','13:00 - 14:00','Sinhala'),(39,'Class 10A','Friday','14:00 - 15:00','Art'),(40,'Class 10A','Friday','15:00 - 16:00','Art'),(41,'Class 10B','Monday','08:00 - 09:00','English'),(42,'Class 10B','Monday','09:00 - 10:00','Maths'),(43,'Class 10B','Monday','10:00 - 11:00','Science'),(44,'Class 10B','Monday','11:00 - 12:00','ICT'),(45,'Class 10B','Monday','12:00 - 13:00','Lunch'),(46,'Class 10B','Monday','13:00 - 14:00','History'),(47,'Class 10B','Monday','14:00 - 15:00','Geography'),(48,'Class 10B','Monday','15:00 - 16:00','Art'),(49,'Class 10B','Tuesday','08:00 - 09:00','Maths'),(50,'Class 10B','Tuesday','09:00 - 10:00','Science'),(51,'Class 10B','Tuesday','10:00 - 11:00','English'),(52,'Class 10B','Tuesday','11:00 - 12:00','PE'),(53,'Class 10B','Tuesday','12:00 - 13:00','Lunch'),(54,'Class 10B','Tuesday','13:00 - 14:00','ICT'),(55,'Class 10B','Tuesday','14:00 - 15:00','Music'),(56,'Class 10B','Tuesday','15:00 - 16:00','Language'),(57,'Class 10B','Wednesday','08:00 - 09:00','Science'),(58,'Class 10B','Wednesday','09:00 - 10:00','ICT'),(59,'Class 10B','Wednesday','10:00 - 11:00','Maths'),(60,'Class 10B','Wednesday','11:00 - 12:00','English'),(61,'Class 10B','Wednesday','12:00 - 13:00','Lunch'),(62,'Class 10B','Wednesday','13:00 - 14:00','Art'),(63,'Class 10B','Wednesday','14:00 - 15:00','History'),(64,'Class 10B','Wednesday','15:00 - 16:00','Geography'),(65,'Class 10B','Thursday','08:00 - 09:00','Maths'),(66,'Class 10B','Thursday','09:00 - 10:00','English'),(67,'Class 10B','Thursday','10:00 - 11:00','ICT'),(68,'Class 10B','Thursday','11:00 - 12:00','Science'),(69,'Class 10B','Thursday','12:00 - 13:00','Lunch'),(70,'Class 10B','Thursday','13:00 - 14:00','Geography'),(71,'Class 10B','Thursday','14:00 - 15:00','History'),(72,'Class 10B','Thursday','15:00 - 16:00','Art'),(73,'Class 10B','Friday','08:00 - 09:00','Maths'),(74,'Class 10B','Friday','09:00 - 10:00','English'),(75,'Class 10B','Friday','10:00 - 11:00','ICT'),(76,'Class 10B','Friday','11:00 - 12:00','Science'),(77,'Class 10B','Friday','12:00 - 13:00','Lunch'),(78,'Class 10B','Friday','13:00 - 14:00','Geography'),(79,'Class 10B','Friday','14:00 - 15:00','History'),(80,'Class 10B','Friday','15:00 - 16:00','Art');
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','teacher') NOT NULL DEFAULT 'student',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Student01','student123','student'),(2,'Teacher01','teacher123','teacher'),(3,'Student02','student123','teacher'),(4,'Teacher02','Teacher234','teacher'),(5,'Student03','student123','student');
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

-- Dump completed on 2025-08-20 12:11:21
