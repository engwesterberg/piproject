DROP DATABASE IF EXISTS internetbanken;
CREATE DATABASE internetbanken;
USE internetbanken;
SHOW GRANTS;
DROP USER  'user1'@'localhost';
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'pass';
GRANT ALL PRIVILEGES ON * . * TO 'user1'@'localhost';

-- ----------------------------------------- tabeller ---------------------------------------------

DROP TABLE IF EXISTS Account;
CREATE TABLE Account
(
	accountNumber INT PRIMARY KEY AUTO_INCREMENT,
    balance INT
)
AUTO_INCREMENT=1000;




DROP TABLE IF EXISTS AccountHolder;
CREATE TABLE AccountHolder
(
	userId INT PRIMARY KEY AUTO_INCREMENT,
    pincode INT(4),
    name CHAR(20),
    birth DATE,
    street VARCHAR(50),
    city VARCHAR(50)
)
AUTO_INCREMENT=100000;




DROP TABLE IF EXISTS AccountHolder_Account;
CREATE TABLE AccountHolder_Account
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    accountNumber INT,
    userId INT,
    FOREIGN KEY (accountNumber) REFERENCES Account(accountNumber),
    FOREIGN KEY (userId) REFERENCES AccountHolder(userId)
);
show tables;

use skolan;
select * from logg2;


DROP TABLE IF EXISTS Interest;
CREATE TABLE Interest
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    accountNumber INT(6),
    interest DECIMAL (20, 5),
    dateOfCalculation DATE,
    FOREIGN KEY (accountNumber) REFERENCES Account(accountNumber)
);

DROP TABLE IF EXISTS Log;
CREATE TABLE Log
(
	accountNumber INT(6),
    currentBalance DECIMAL (20, 5),
    amountChanged DECIMAL (20, 5),
    time DATETIME
);




-- välj ut alla konton och visa användare
DROP VIEW IF EXISTS accountsAndUserNames;
CREATE VIEW accountsAndUserNames AS
SELECT 
	aha.accountNumber,
    a.balance,
    GROUP_CONCAT((select name from AccountHolder AS ah where ah.userId = aha.userId )) AS userId
FROM AccountHolder_Account AS aha, Account AS a
where a.accountNumber = aha.accountNumber
GROUP BY accountNumber
;
select * from accountsAndUserNames;

-- -------------------------------------------------------------------------------- lagrade procedurer --------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS createAccountHolder;
DELIMITER //
CREATE PROCEDURE createAccountHolder
(
	aName CHAR(20),
    aPincode INT(4),
    aBirth DATE,
    aStreet VARCHAR(50),
    aCity VARCHAR(50)
)
INSERT INTO AccountHolder (name, pincode, birth, street, city)
VALUES
	(aName, aPincode, aBirth, aStreet, aCity);
//
DELIMITER ;




DROP PROCEDURE IF EXISTS createAccount;
DELIMITER //
CREATE PROCEDURE createAccount
(
	balance INT
)
INSERT INTO Account (balance)
VALUES
	(balance);
//
DELIMITER ;




DROP PROCEDURE IF EXISTS connectAccount;
DELIMITER //
CREATE PROCEDURE connectAccount
(
	aAccountNumber INT(4),
    aUserId INT(6)
)
BEGIN
	INSERT INTO AccountHolder_Account (accountNumber, userId)
	VALUES
		(aAccountNumber, aUserId);
END
//
DELIMITER ;





DROP PROCEDURE IF EXISTS showAccountsOfUser; -- denna
DELIMITER //
CREATE PROCEDURE showAccountsOfUser
(
	aUserId INT(6)
)
select
	distinct aha.accountNumber,
    a.balance,
    v.userId as owners
from 
	accountsAndUserNames AS v
JOIN AccountHolder_Account AS aha
	ON v.accountNumber = aha.accountNumber
JOIN Account AS a
	ON a.accountNumber = aha.accountNumber
WHERE 
	aha.accountNumber IN (select aha.accountNumber WHERE aha.userId = aUserId )
//
DELIMITER ;

CALL showAccountsOfUser(100001);




DROP PROCEDURE IF EXISTS showUsersAndAccounts;
DELIMITER //
CREATE PROCEDURE showUsersAndAccounts
()
SELECT 
	aha.userId,
    GROUP_CONCAT(CONCAT(aha.accountNumber)) AS Konton,
    ah.name,
    ah.pincode,
    ah.birth,
    ah.street,
    ah.city
FROM AccountHolder_Account AS aha
JOIN AccountHolder AS ah
	ON ah.userId = aha.userId
GROUP BY userId
;
//
DELIMITER ;
CALL showUsersAndAccounts();



-- test ----------

SELECT 
	aha.userId,
    GROUP_CONCAT(CONCAT(aha.accountNumber)) AS Konton,
    ah.name,
    ah.pincode,
    ah.birth,
    ah.street,
    ah.city
FROM AccountHolder_Account AS aha
JOIN AccountHolder AS ah
	ON ah.userId = aha.userId
GROUP BY userId
;




DROP PROCEDURE IF EXISTS calculateInterest;
DELIMITER //
CREATE PROCEDURE calculateInterest
(
	interestRate DECIMAL(3,2),
    dateOfCalculation DATE
)
INSERT INTO Interest (accountNumber, interest, dateOfCalculation)
SELECT accountNumber, interestRate * balance / 365, dateOfCalculation  FROM Account;
//
DELIMITER ;

CALL calculateInterest(0.01, '2017-10-15');




DROP PROCEDURE IF EXISTS showAccountsAndInterest;
DELIMITER //
CREATE PROCEDURE showAccountsAndInterest()
SELECT
	accountNumber AS accountNumber, SUM(interest) AS interest
    FROM Interest
    GROUP BY accountNumber;
//
DELIMITER ;
    
call showAccountsAndInterest();



DROP PROCEDURE IF EXISTS moveMoney;
DELIMITER //
CREATE PROCEDURE moveMoney
(
	fromAccountNumber INT(4),
    toAccountNumber INT(4),
    amount DECIMAL
)
BEGIN
	UPDATE Account
		SET balance = balance - amount*1.03
		WHERE accountNumber = fromAccountNumber;
	UPDATE Account
		SET balance = balance + amount
		WHERE accountNumber = toAccountNumber;
	UPDATE Account
		SET balance = balance + amount*0.03
        WHERE accountNumber = 1000;
	END
//
DELIMITER ;
CALL moveMoney(1001, 1002, 50);




DROP PROCEDURE IF EXISTS showInterestDay;
DELIMITER //
CREATE PROCEDURE showInterestDay
(
	aDay DATE
)
BEGIN
	SELECT
		*
	FROM
		Interest
	WHERE
		dateOfCalculation = aDay;
END
//
DELIMITER ;

call showInterestDay('1992-01-16');



DROP PROCEDURE IF EXISTS showAccountInterest;
DELIMITER //
CREATE PROCEDURE showAccountInterest
(
	aAccountNumber INT(4)
)
BEGIN
	SELECT
    accountNumber,
		SUM(interest) AS interest
	FROM
		Interest
	WHERE
		accountNumber = aAccountNumber
	GROUP BY AccountNumber;
END
//
DELIMITER ;

CALL showAccountInterest(1000);




DROP PROCEDURE IF EXISTS showAccumulatedInterestDay;
DELIMITER //
CREATE PROCEDURE showAccumulatedInterestDay
(
	day DATE
)
BEGIN
	SELECT
		dateOfCalculation,
		SUM(interest)
	FROM
		Interest
	WHERE
		dateOfCalculation = day
	GROUP BY dateOfCalculation;
END
//
DELIMITER ;





DROP PROCEDURE IF EXISTS showAccumulatedInterestYear;
DELIMITER //
CREATE PROCEDURE showAccumulatedInterestYear
(
	aYear YEAR
)
BEGIN
	SELECT
		distinct year(dateOfCalculation) AS year,
		SUM(interest) as interestYear
	FROM
		Interest
	WHERE
		YEAR(dateOfCalculation) = aYear
	GROUP BY year;
END
//
DELIMITER ;

call showAccumulatedInterestYear(2008);




DROP PROCEDURE IF EXISTS showUserInterest;
DELIMITER //
CREATE PROCEDURE showUserInterest
(
	aUserId INT(6)
)
BEGIN
	SELECT 
		aha.accountNumber,
		SUM(interest) AS interest
	from 
		AccountHolder_Account AS aha
	JOIN Interest  AS i
		ON i.accountNumber = aha.accountNumber
		WHERE userId = aUserId
	GROUP BY accountNumber
	;
END
//
DELIMITER ;

call showUserinterest(100000);
-- ----------------------------------------- funktioner ---------------------------------------------




DELIMITER //
DROP FUNCTION IF EXISTS swishMoney //
CREATE FUNCTION swishMoney(
    aUserId INT(6),
    aPincode INT(4),
    fromAccountNumber INT(4),
    amount DECIMAL,
    toAccountNumber INT(4)
)
RETURNS BOOL
BEGIN
    IF
		aPincode = (SELECT pincode FROM AccountHolder WHERE userId = aUserId) 
        AND 
        (SELECT balance from Account WHERE accountNumber = fromAccountNumber) > amount THEN
			UPDATE Account
				SET balance = balance - amount*1.02
					WHERE  accountNumber = fromAccountNumber;
			UPDATE Account
				SET balance = balance + amount
					WHERE accountNumber = toAccountNumber;
			UPDATE Account
				SET balance = balance + amount*0.02
			WHERE accountNumber = 1000;
			RETURN true;
		ELSE 
			RETURN false;
		END IF;
END
//
DELIMITER ;

use skolan;
select * from kurstillfalle2;


-- ----------------------------------------- triggers ---------------------------------------------

DROP TRIGGER IF EXISTS LogBalanceUpdate;
CREATE TRIGGER LogBalanceUpdate
AFTER UPDATE
ON Account FOR EACH ROW
	INSERT INTO Log (`accountNumber`,`currentBalance`,`amountChanged`,`time`)
		VALUES (OLD.accountNumber, NEW.balance, NEW.balance - OLD.balance, CURTIME());
select * from interest;
SELECT * FROM Account WHERE accountNumber = 1000;

select * from log where accountNumber = 1003;

