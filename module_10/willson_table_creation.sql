-- drop database user if exists
  
DROP USER IF EXISTS 'financial_user'@'localhost'; 

-- create financial_user and grant them all privileges to the movies database 
 
CREATE USER 'financial_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'financing'; 

-- grant all privileges to the willson_financial database to user financial_user on localhost 
 
GRANT ALL PRIVILEGES ON willson_financial.* TO 'financial_user'@'localhost'; 

-- drop tables if they are present 

DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS advisor; 
DROP TABLE IF EXISTS assets; 
DROP TABLE IF EXISTS account; 
DROP TABLE IF EXISTS client; 

-- create the client table
  
CREATE TABLE client ( 
	client_id	INT			NOT NULL	AUTO_INCREMENT, 
	f_name		VARCHAR(75)		NOT NULL, 
	l_name		VARCHAR(75)		NOT NULL, 
	join_date	DATE			NOT NULL, 
	PRIMARY KEY(client_id) 
); 

-- create the account table  

CREATE TABLE account ( 
	account_id	INT			NOT NULL	AUTO_INCREMENT, 
	account_name	VARCHAR(100)		NOT NULL, 
	client_id	INT			NOT NULL, 
	PRIMARY KEY(account_id), 

	CONSTRAINT fk_client 
	FOREIGN KEY(client_id) 
		REFERENCES client(client_id) 
); 

-- create the assets table  

CREATE TABLE assets ( 
	assets_id	INT			NOT NULL	AUTO_INCREMENT, 
	account_id	INT			NOT NULL, 
	assets_type	VARCHAR(100)		NOT NULL, 
	assets_currency	DOUBLE			NOT NULL, 
	PRIMARY KEY(assets_id), 

	CONSTRAINT fk_account 
	FOREIGN KEY(account_id) 
		REFERENCES account(account_id) 

); 

-- create the advisor table  

CREATE TABLE advisor ( 
	advisor_id	INT			NOT NULL	AUTO_INCREMENT, 
	f_name		VARCHAR(75)		NOT NULL, 
	l_name		VARCHAR(75)		NOT NULL, 
	PRIMARY KEY(advisor_id) 
); 

-- create the transaction table  

CREATE TABLE transaction ( 
	transaction_id	INT			NOT NULL	AUTO_INCREMENT, 
	t_date		DATE			NOT NULL, 
	t_summary	VARCHAR(225), 
	advisor_id	INT			NOT NULL, 
	account_id	INT			NOT NULL, 
	assets_id	INT			NOT NULL, 
	value_start	DOUBLE		NOT NULL, 
	value_end	DOUBLE		NOT NULL, 
	PRIMARY KEY(transaction_id), 
 
	CONSTRAINT fk_advisor 
	FOREIGN KEY(advisor_id) 
		REFERENCES advisor(advisor_id), 

	CONSTRAINT fk_account2 
	FOREIGN KEY(account_id) 
		REFERENCES account(account_id), 

	CONSTRAINT fk_assets 
	FOREIGN KEY(assets_id) 
		REFERENCES assets(assets_id) 

);
 
-- insert client records 

INSERT INTO client(f_name, l_name, join_date)
	VALUES('John', 'Smith', '2023-10-12'); 

INSERT INTO client(f_name, l_name, join_date) 
	VALUES('Karen', 'Winter', '2022-04-27'); 

INSERT INTO client(f_name, l_name, join_date) 
	VALUES('Lenny', 'Roid', '2023-02-13'); 

INSERT INTO client(f_name, l_name, join_date) 
	VALUES('Darren', 'Loid', '2021-10-05'); 

INSERT INTO client(f_name, l_name, join_date) 
	VALUES('Sally', 'Sue', '2023-05-20'); 

INSERT INTO client(f_name, l_name, join_date) 
	VALUES('Carol', 'Reeves', '2021-03-14'); 

-- insert account records 

INSERT INTO account(account_name, client_id) 
	VALUES('Wildwood Ranch', (SELECT client_id FROM client WHERE f_name = 'John')); 

INSERT INTO account(account_name, client_id) 
	VALUES('Karen Winter', (SELECT client_id FROM client WHERE f_name = 'Karen')); 

INSERT INTO account(account_name, client_id) 
	VALUES('Lenny Roid', (SELECT client_id FROM client WHERE f_name = 'Lenny')); 

INSERT INTO account(account_name, client_id) 
	VALUES('Horseshoe Acres', (SELECT client_id FROM client WHERE f_name = 'Darren')); 

INSERT INTO account(account_name, client_id) 
	VALUES('Whisperwood Farm', (SELECT client_id FROM client WHERE f_name = 'Sally')); 

INSERT INTO account(account_name, client_id) 
	VALUES('Carol Reeves', (SELECT client_id FROM client WHERE f_name = 'Carol')); 

-- insert assets records 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Wildwood Ranch'), 'Wildwood Ranch Checking', 40000.67); 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Karen Winter'), 'Karen Winter Savings', 754950.98); 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Lenny Roid'), 'Lenny Roid Investing', 5.28); 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), 'Horseshoe Acres Checking', 853324.67); 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Whisperwood Farm'), 'Whisperwood Farm Checking', 1890453.67); 

INSERT INTO assets(account_id, assets_type, assets_currency) 
	VALUES((SELECT account_id FROM account WHERE account_name = 'Carol Reeves'), 'Carol Reeves Checking', -453.32); 

-- insert advisor records 

INSERT INTO advisor(f_name, l_name) 
	VALUES('Jake', 'Wilson'); 
INSERT INTO advisor(f_name, l_name) 
	VALUES('Ned', 'Wilson');

-- insert transaction records 

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
	VALUES('2022-05-16', 'Deposit', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 853024.67, 853324.67); 

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
	VALUES('2023-04-12', 'Withdrawal', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 832324.67, 832321.67); 

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
	VALUES('2023-05-16', 'Deposit', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 753024.67, 756324.43); 

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
	VALUES('2023-01-15', 'Deposit', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 853024.67, 853527.37);

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
    VALUES('2023-01-17', 'Deposit', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 853527.37, 854527.37);

INSERT INTO transaction(t_date, t_summary, advisor_id, account_id, assets_id, value_start, value_end) 
    VALUES('2023-01-19', 'Deposit', (SELECT advisor_id FROM advisor WHERE f_name = 'Jake'), (SELECT account_id FROM account WHERE account_name = 'Horseshoe Acres'), (SELECT assets_id FROM assets WHERE assets_type = 'Horseshoe Acres Checking'), 854527.37, 852927.37);  