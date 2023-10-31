-- EXCLUSÃO DE ENTIDADES

DROP database eshop_connect_a;

DROP TABLE users;
DROP TABLE buyer;
DROP TABLE Seller;
DROP TABLE bankCard ;
DROP TABLE creditCard;
DROP TABLE debitCard;

DROP TABLE store;
DROP TABLE brand;
DROP TABLE product;
DROP TABLE ordemItem;
DROP TABLE orders;
DROP TABLE adress;
DROP TABLE comments;
DROP TABLE servicePoint;
DROP TABLE save_to_Shopping_Cart;
DROP TABLE contain;
DROP TABLE payment;
DROP TABLE deliver_To;
DROP TABLE manage;
DROP TABLE After_Sales_Service_At;


-- CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE eshop_connect_a;

USE eshop_connect_a;


-- CRIAÇÃO DAS ENTIDADES

CREATE TABLE users(
	pk_userID			INT NOT NULL AUTO_INCREMENT,
    name			VARCHAR(40) NOT NULL,
    phoneNumber		VARCHAR(12),
    
    PRIMARY KEY (pk_userID)
    
);

CREATE TABLE buyer(
	pk_userID			INT NOT NULL AUTO_INCREMENT,
    
    PRIMARY KEY (pk_userID),
    FOREIGN KEY (pk_userID) REFERENCES users(pk_userID)
);

CREATE TABLE seller(
	pk_userID			INT NOT NULL AUTO_INCREMENT,
    
    PRIMARY KEY (pk_userID),
    FOREIGN KEY (pk_userID) REFERENCES users(pk_userID)
);

CREATE TABLE bankCard(
	pk_cardNumber		CHAR(19) NOT NULL,
    expiryDate			DATE NOT NULL,
    bank				VARCHAR(20),
    
    PRIMARY KEY (pk_cardNumber)
);

-- alter table bankCard update pk_cardNumber CHAR(19) NOT NULL;

CREATE TABLE creditCard(
	pk_cardNumber		CHAR(19) NOT NULL,
    fk_userID			INT NOT NULL,
	organization		VARCHAR(50),
    
    PRIMARY KEY (pk_cardNumber),
    FOREIGN KEY (pk_cardNumber) REFERENCES bankCard(pk_cardNumber),
    FOREIGN KEY (fk_userid) REFERENCES users(pk_userID)
);

-- Desabilita as verificações de FKS
SET FOREIGN_KEY_CHECKS = 0;

-- ALTERA O TIPO DE DADO DA FK DA TABELA BANK CARD
ALTER TABLE store
MODIFY COLUMN startTime DATE; 

-- Habilita as verificações de FKS
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE debitCard(
	pk_cardNumber		CHAR(19) NOT NULL,
    fk_userID			INT NOT NULL,
	organization		VARCHAR(50),
    
    PRIMARY KEY (pk_cardNumber),
    FOREIGN KEY (pk_cardNumber) REFERENCES bankCard(pk_cardNumber),
    FOREIGN KEY (fk_userid) REFERENCES users(pk_userID)
);

CREATE TABLE store(
	pk_sid 				INT NOT NULL,
    name				VARCHAR(50) NOT NULL,
    province			VARCHAR(35) NOT NULL,
    city				VARCHAR(40) NOT NULL,
    streetaddr 			VARCHAR(30),
    customderGrade		INT,
    startTime			DATE,
    
    PRIMARY KEY (pk_sid)
);

CREATE TABLE brand(
	pk_brandName		VARCHAR(50) NOT NULL,
    
    PRIMARY KEY 		(pk_brandName)
);

CREATE TABLE product(
	pk_pid				INT NOT NULL,
    fk_sid				INT NOT NULL,
    name				VARCHAR(120) NOT NULL,
    fk_brandName		VARCHAR(50) NOT NULL,
	type				VARCHAR(50),
    amount				INT DEFAULT NULL,
    price				DECIMAL(6,2) NOT NULL,
    color				VARCHAR(20),
    modelNumber			VARCHAR(50),
    
    PRIMARY KEY (pk_pid),
    FOREIGN KEY (fk_sid) REFERENCES	store(pk_sid),
    FOREIGN KEY (fk_brandName) REFERENCES brand(pk_brandName)
);

CREATE TABLE ordemitem(
	pk_itemID 			INT NOT NULL AUTO_INCREMENT,
    fk_pid 				INT NOT NULL,
    price				DECIMAL(6,2),
    creationTime		TIME NOT NULL,
    
    PRIMARY KEY (pk_itemID),
    FOREIGN KEY (fk_pid) REFERENCES product(pk_pid)
);

CREATE TABLE orders(
	pk_orderNumber		INT NOT NULL,
    payment_state		ENUM('Paid','Unpaid'),
    creation_time		TIME NOT NULL,
    totalAmount			DECIMAL(10,2),
    
    PRIMARY KEY 		(pk_orderNumber)
);

CREATE TABLE adress(
	pk_addID			INT NOT NULL,
    fk_userID			INT NOT NULL,
    name				VARCHAR(50),
    contactPhoneNumber	VARCHAR(20),
    province			VARCHAR(100),
    city				VARCHAR(100),
    streetaddr			VARCHAR(100),
    postCode			VARCHAR(12),
    
    PRIMARY KEY (pk_addID),
    FOREIGN KEY	(fk_userID) REFERENCES users(pk_userID)
);

CREATE TABLE comments( -- Entidade fraca
	creationTime		DATE NOT NULL,
    fk_userID			INT NOT NULL,
    fk_pid				INT NOT NULL,
    grade				FLOAT,
    content				VARCHAR(500),
    
    PRIMARY KEY (creationTime, fk_userID, fk_pid),
    FOREIGN KEY (fk_userID) REFERENCES users(pk_userID),
    FOREIGN KEY (fk_pid) REFERENCES	product(pk_pid)
    );


CREATE TABLE servicePoint(
	pk_sid				INT NOT NULL,
    streetaddr			VARCHAR(100) NOT NULL,
    city				VARCHAR(50),
    province			VARCHAR(50),
    startTime			VARCHAR(20),
    endTime				VARCHAR(20),
    
    PRIMARY KEY (pk_sid)
);

CREATE TABLE save_to_Shopping_Cart(
	fk_userID			INT NOT NULL,
    fk_pid				INT NOT NULL,
    addTime				DATE NOT NULL,
    quantity			INT,
    
    PRIMARY KEY(fk_userID, fk_pid),
    FOREIGN KEY (fk_userID) REFERENCES users(pk_userID),
    FOREIGN KEY (fk_pid) REFERENCES product(pk_pid)
);

CREATE TABLE contain(
	fk_orderNumber		INT NOT NULL,
    fk_itemID			INT NOT NULL,
    quantity			INT,
    
    PRIMARY KEY (fk_orderNumber, fk_itemID),
    FOREIGN KEY (fk_orderNumber) REFERENCES orders(pk_orderNumber),
    FOREIGN KEY (fk_itemID) REFERENCES ordemItem(pk_itemID)
);

CREATE TABLE payment(
	fk_orderNumber		INT NOT NULL,
    fk_creditcardNumber	VARCHAR(25) NOT NULL,
    payTime				DATE,
    
    PRIMARY KEY (fk_orderNumber, fk_creditcardNumber),
    FOREIGN KEY (fk_orderNumber) REFERENCES orders(pk_orderNumber),
    FOREIGN KEY (fk_creditcardNumber) REFERENCES bankCard(pk_cardNumber)
);

CREATE TABLE deliver_To(
    fk_addID            INT NOT NULL,
    fk_orderNumber         INT NOT NULL,
    TimeDelivered         DATE,
    
    PRIMARY KEY(fk_addID,fk_orderNumber),
    FOREIGN KEY(fk_addID) REFERENCES adress(pk_addID),
    FOREIGN KEY(fk_orderNumber) REFERENCES orders(pk_orderNumber)
);

 

CREATE TABLE manage (
    fk_userid             INT NOT NULL,
    fk_sid                 INT NOT NULL,
    setUpTime             DATE,
    
    PRIMARY KEY(fk_userid,fk_sid),
    FOREIGN KEY(fk_userid) REFERENCES seller(pk_userid),
    FOREIGN KEY(fk_sid) REFERENCES store (pk_sid)
);



CREATE TABLE After_Sales_Service_At(
    fk_brandName         VARCHAR(20) NOT NULL,
    fk_sid             INT NOT NULL,
    
    PRIMARY KEY(fk_brandName, fk_sid),
    FOREIGN KEY(fk_brandName) REFERENCES brand (pk_brandName),
    FOREIGN KEY(fk_sid) REFERENCES servicePoint(pk_sid)
);
