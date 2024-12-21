CREATE DATABASE  IF NOT EXISTS `ArtGallery` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ArtGallery`;

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `Company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Company (
    comp_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    comp_name VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    address VARCHAR(255),
    zip_code VARCHAR(20)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY NOT NULL auto_increment,
    emp_name VARCHAR(255),
    surname VARCHAR(255),
    email VARCHAR(255),
    job_title VARCHAR(100),
    comp_ID INT,
    dept_name VARCHAR(100),
    FOREIGN KEY (comp_ID)
        REFERENCES Company (comp_id),
    FOREIGN KEY (dept_name)
        REFERENCES Department (dept_name)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Department (
    dept_name VARCHAR(100) PRIMARY KEY NOT NULL,
    budget DECIMAL(19 , 4 )
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Gallery (
    gallery_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    gallery_name VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    address VARCHAR(100)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Employee_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Employee_gallery (
    emp_ID INT,
    gallery_ID INT,
    PRIMARY KEY (emp_ID , gallery_ID),
    FOREIGN KEY (emp_ID)
        REFERENCES Employee (emp_ID),
    FOREIGN KEY (gallery_ID)
        REFERENCES Gallery (gallery_ID)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Artist (
    artist_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    date_of_birth DATE,
    email VARCHAR(255),
    style VARCHAR(100),
    date_of_death DATE
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Artist_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Artist_phone (
    artist_id INT PRIMARY KEY NOT NULL,
    phone VARCHAR(100),
    FOREIGN KEY (artist_id)
        REFERENCES Artist (artist_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Buyers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Buyers (
    buyer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    email VARCHAR(255)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Buyer_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Buyer_phone (
    buyer_id INT NOT NULL,
    phone VARCHAR(100) NOT NULL,
    PRIMARY KEY (buyer_id, phone),
    FOREIGN KEY (buyer_id)
        REFERENCES Buyers (buyer_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Artwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Artwork (
    artwork_id INT PRIMARY KEY NOT NULL auto_increment,
    buyer_id INT NOT NULL,
    artist_id INT,
    title VARCHAR(100),
    date_of_creation DATE,
    type VARCHAR(100),
    FOREIGN KEY (artist_id)
        REFERENCES Artist (artist_id),
    FOREIGN KEY (buyer_id)
        REFERENCES Buyers (buyer_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Exhibition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Exhibition (
    exib_id INT PRIMARY KEY AUTO_INCREMENT,
    exib_date DATE,
    exib_name VARCHAR(255),
    theme VARCHAR(100),
    gallery_id INT,
    FOREIGN KEY (gallery_id)
        REFERENCES Gallery (gallery_ID)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Artist_exhibition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Artist_exhibition (
    artist_id INT,
    exib_id INT,
    date_attended DATE,
    PRIMARY KEY (artist_id , exib_id),
    FOREIGN KEY (artist_id)
        REFERENCES Artist (artist_id),
    FOREIGN KEY (exib_id)
        REFERENCES Exhibition (exib_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Artwork_Exhibition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Artwork_Exhibition (
    artwork_id INT NOT NULL,
    exib_id INT,
    PRIMARY KEY (artwork_id , exib_id),
    FOREIGN KEY (artwork_id)
        REFERENCES Artwork (artwork_id),
    FOREIGN KEY (exib_id)
        REFERENCES Exhibition (exib_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE Loan (
	loan_id INT NOT NULL AUTO_INCREMENT,
    buyer_id INT,
    loan_amount DECIMAL(19 , 4 ),
    loan_date DATE,
    PRIMARY KEY (loan_id),
    FOREIGN KEY (buyer_id)
        REFERENCES Buyers (buyer_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

