CREATE DATABASE Eventbooking;
USE Eventbooking;

/************************ Create venue table *********************/
CREATE TABLE Venue (
	venue_id       INTEGER IDENTITY(1,1)        NOT NULL,
	name           VARCHAR(25)                  NOT NULL  UNIQUE,
	address_line_1 VARCHAR(100)                 NOT NULL,
	city           VARCHAR(25)                  NOT NULL,
	postal_code    VARCHAR(25)                  NOT NULL,
	website        VARCHAR(50)                  NULL,
	description    VARCHAR(MAX)                 NULL,
	open_time      TIME(7)                      NULL,
	close_time     TIME(7)                      NULL,
	phone          NUMERIC(12, 0)               NOT NULL UNIQUE,
	PRIMARY KEY    ( venue_id ),
);


/************************ Create manager table *********************/
CREATE TABLE Manager(
	manager_id      INTEGER IDENTITY(1,1)        NOT NULL,
	first_name      VARCHAR(25)                  NOT NULL,
	last_name       VARCHAR(25)                  NOT NULL,
	email           VARCHAR(50)                  NOT NULL UNIQUE,
	phone           NUMERIC(12, 0)               NULL     UNIQUE,
	password        VARCHAR(16)                  NOT NULL,
	profile_picture VARCHAR(500)                 NULL,
	dob             DATE                         NULL,
	venue_id        INTEGER                      NOT NULL UNIQUE,
	PRIMARY KEY     (manager_id)
);

/*add constraint to check that date of birth is less than current date*/
ALTER TABLE Manager
	ADD CONSTRAINT check_date_of_birth_constraint 
	CHECK (dob < GETDATE());


/************************ Add venue id as foreign key in manager*********************/
ALTER TABLE Manager
  ADD CONSTRAINT manager_venue_id
      FOREIGN KEY( venue_id )
      REFERENCES Venue(venue_id);


/************************ Create customer table *********************/
CREATE TABLE Customer
(
	customer_id     INTEGER IDENTITY(1,1) PRIMARY KEY,
	first_name      VARCHAR(25)           NOT NULL,
	last_name       VARCHAR(25)           NOT NULL,
	email           VARCHAR(50)           NULL       UNIQUE,
	phone           NUMERIC(12, 0)        NOT NULL   UNIQUE,
	password        VARCHAR(16)           NOT NULL,
	profile_picture VARCHAR(500)          NULL,
	city            VARCHAR(25)           NULL,
	dob             DATE                  NULL,
	gender          VARCHAR(10)           NULL,
);


/************************ Constraint to check gender*********************/
ALTER TABLE Customer
  ADD CONSTRAINT customer_gender
      CHECK (gender IN ('Male', 'Female'));


/************************ Constraint to check date of birth is less than equal to current date *********************/
ALTER TABLE Customer
  ADD CONSTRAINT check_date_of_birth_cutomer_constraint 
      CHECK (dob < GETDATE());


/************************ Create artist table *********************/
CREATE TABLE Artist
(	artist_id       INTEGER IDENTITY(1,1)        NOT NULL,
	first_name      VARCHAR(25)                  NOT NULL,
	last_name       VARCHAR(25)                  NOT NULL,
	description     VARCHAR(max)                 NULL,
	profile_picture VARCHAR(500)                 NULL,
	date_of_birth   DATE                         NULL,
	gender          VARCHAR(10)                  NULL,
	email           VARCHAR(50)                  NOT NULL  UNIQUE,
	phone           NUMERIC(12, 0)               NULL      UNIQUE,
	PRIMARY KEY     (artist_id ),
);

ALTER TABLE Artist
  ADD CONSTRAINT gender_artist
      CHECK (gender IN ('Male', 'Female'));

ALTER TABLE Artist
  ADD CONSTRAINT check_artist_date_of_birth_constraint 
      CHECK (date_of_birth < GETDATE());

	  
/************************ Create event table *********************/
CREATE TABLE Event
(	event_id        INTEGER IDENTITY(1,1)      NOT NULL,
	name            VARCHAR(25)                NOT NULL,
	description     VARCHAR(MAX)               NOT NULL,
	start_date_time DATETIME                   NOT NULL,
	end_date_time   DATETIME                   NOT NULL,
	venue_id        INTEGER                    NOT NULL,
	category        VARCHAR(25)                NOT NULL,
	event_posture   VARCHAR(25)                NULL,
	sponsorer       VARCHAR(25)                NULL,
	PRIMARY KEY     (event_id),
);


/************************ Constarint to check event categry *********************/
ALTER TABLE Event
  ADD CONSTRAINT category
      CHECK (category IN ('Music', 'Party', 'Mime Show'));


/************************ Constarint to check event start time is less than end time *********************/
ALTER TABLE Event
  ADD CONSTRAINT check_time
      CHECK (start_date_time < end_date_time AND start_date_time > GETDATE());



/************************ Create event_ticket table *********************/
CREATE TABLE Event_Ticket(
	event_ticket_id INTEGER IDENTITY(1,1)      NOT NULL,
	name            VARCHAR(100)               NOT NULL,
	price           NUMERIC                    NOT NULL  DEFAULT(0),
	begin_sale      DATETIME                   NOT NULL,
	end_sale        DATETIME                   NOT NULL,
	issued_tickets  INTEGER                    NOT NULL,
	sold_tickets    INTEGER                    NULL,
	description     VARCHAR(MAX)               NULL,
	event_id        INTEGER                    NOT NULL,
	PRIMARY KEY     (event_ticket_id),
);

/************************ Constarint to check sold tickets is less than tickets issued *********************/
ALTER TABLE Event_Ticket
   ADD CONSTRAINT check_sold_tickets_constraint 
       CHECK (sold_tickets <= issued_tickets );

	   
/************************ Constraint to check begin sale is less than end sale *********************/
ALTER TABLE Event_Ticket
   ADD CONSTRAINT check_begin_sale_end_sale 
	   CHECK (begin_sale <= end_sale AND begin_sale >= GETDATE());

ALTER TABLE Event_Ticket
  ADD CONSTRAINT event_ticket_event_id
      FOREIGN KEY( event_id )
      REFERENCES Event(event_id);

ALTER TABLE Event_Ticket
    ADD CONSTRAINT tickets_price
      CHECK (price>=0) ;

	  
/************************ Create artist_event table *********************/
CREATE TABLE Artist_Event
(	event_id  INTEGER NOT NULL,
	artist_id INTEGER NOT NULL,
	PRIMARY KEY(artist_id, event_id ),
);

ALTER TABLE Artist_Event
  ADD CONSTRAINT artist_event_id
      FOREIGN KEY( artist_id )
      REFERENCES Artist( artist_id );

ALTER TABLE Artist_Event
  ADD CONSTRAINT artist_event_event_id
      FOREIGN KEY( event_id )
      REFERENCES Event(event_id);

	  
/************************ Create booking table *********************/
CREATE TABLE Booking
(	booking_id     INTEGER IDENTITY(1,1)               PRIMARY KEY,
	customer_id    INTEGER               NOT NULL,
	venue_id       INTEGER               NOT NULL,
	payment_status VARCHAR(10)           NOT NULL,
	booking_date   DATETIME              NOT NULL,
	payment_type   VARCHAR(10)           NULL,
	transaction_id VARCHAR(50)           NULL,
	CHECK (payment_status IN ('Pending', 'Completed')) 
);


/************************ Constrait to check payment type *********************/
ALTER TABLE Booking
    ADD CONSTRAINT payment_type
      CHECK (payment_type IN ('Debit', 'Credit')) 

/************************ Constrait to check if payment done than transaction_id and payment_type is not null *********************/	  
ALTER TABLE Booking
   ADD CONSTRAINT booking_transaction_payment
       CHECK ((transaction_id IS NOT NULL AND payment_type IS NOT NULL)  OR (payment_type IS NULL AND transaction_id IS NULL));

ALTER TABLE Booking
  ADD CONSTRAINT booking_customer_id
      FOREIGN KEY( customer_id )
      REFERENCES Customer(customer_id);

ALTER TABLE Booking
  ADD CONSTRAINT booking_venue_id
      FOREIGN KEY( venue_id )
      REFERENCES Venue(venue_id);



/************************ Create booking_has_tickets table *********************/
CREATE TABLE Booking_Has_Tickets
(	event_ticket_id INTEGER               NOT NULL,
	booking_id      INTEGER               NOT NULL,
	quantity        INTEGER               NOT NULL
	PRIMARY KEY( event_ticket_id, booking_id ),
);

ALTER TABLE Booking_Has_Tickets
  ADD CONSTRAINT booking_has_tickets_event_ticket_id
      FOREIGN KEY( event_ticket_id )
      REFERENCES Event_Ticket(event_ticket_id);

ALTER TABLE Booking_Has_Tickets
  ADD CONSTRAINT booking_has_tickets_booking_id
      FOREIGN KEY( booking_id )
      REFERENCES Booking(booking_id);

ALTER TABLE Booking_Has_Tickets
    ADD CONSTRAINT quantity_tickets
      CHECK (quantity>=1) ;



/************************ Create booking_refund table *********************/
CREATE TABLE Booking_Refund
(	booking_refund_id INTEGER IDENTITY(1,1)       NOT NULL,
	refund_reason     VARCHAR(100)                NULL,
	booking_id        INTEGER                     NOT NULL,
	status            VARCHAR(10)                 NOT NULL,
	comments          VARCHAR(MAX)                NULL,
	PRIMARY KEY(booking_refund_id),
	CHECK (status IN ('Pending', 'Refunded'))   
);

ALTER TABLE Booking_Refund
  ADD CONSTRAINT booking_refund_booking_id
      FOREIGN KEY( booking_id )
      REFERENCES Booking(booking_id);



/************************ Insert values into venue table *********************/
INSERT INTO Venue VALUES ('Rajputh Club'  , 'SG Highway Road', 'Ahmedabad', 382350   , 'www.apple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375578832);
INSERT INTO Venue VALUES ('Heritage Villa', 'CG Highway Road', 'Surat'    , 'M1W 2S9', 'www.jpple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375568832);
INSERT INTO Venue VALUES ('Lincon Drive'  , 'Progress Avenue', 'Toronto'  , 'M1W 2U9', 'www.cpple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375598832);
INSERT INTO Venue VALUES ('York Club'     , 'Warden Avenue'  , 'Ottawa'   , 382350   , 'www.kpple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375548832);
INSERT INTO Venue VALUES ('Ras Raj Park'  , 'Finch West'     , 'Ahmedabad', 382350   , 'www.mpple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375868832);


/************************ Insert values into manager table *********************/
INSERT INTO Manager VALUES ('Rajeshbhai', 'Patel', 'rajeshpatel@gmail.com', 9879081905, 'naval_123', 'www.google.com', '2011-02-28', 1);
INSERT INTO Manager VALUES ('Nareshbhai', 'Patel', 'nareshpatel@gmail.com', 9879081906, 'naval_126', 'www.google.com', '2011-02-28', 2);
INSERT INTO Manager VALUES ('Lino'      , 'Ved'  , 'linoved@gmail.com'    , 9879081908, 'naval_128', 'www.google.com', '2011-02-28', 3);
INSERT INTO Manager VALUES ('Dino'      , 'James', 'dinojames@gmail.com'  , 9879081909, 'naval_129', 'www.google.com', '2011-02-28', 4);
INSERT INTO Manager VALUES ('Ramesh'    , 'Patel', 'rameshpatel@gmail.com', 9879081901, 'naval_122', 'www.google.com', '2011-02-28', 5);


/************************ Insert values into customer table *********************/
INSERT INTO Customer VALUES ( 'Nirav'  , 'Kathiria', 'nirav1106@gmail.com'   , 9878781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');
INSERT INTO Customer VALUES ( 'Niv'    , 'Gandhvi' , 'niv6@gmail.com'        , 9876781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Female');
INSERT INTO Customer VALUES ( 'Niraj'  , 'Patel'   , 'niraj@gmail.com'       , 9876783905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');
INSERT INTO Customer VALUES ( 'Nishant', 'Patel'   , 'nishant@gmail.com'     , 9875781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Female');
INSERT INTO Customer VALUES ( 'Jay'    , 'Singh'   , 'jay1106@gmail.com'     , 8876781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');
INSERT INTO Customer VALUES ( 'Raj'    , 'Patel'   , 'rajpatel1106@gmail.com', 4876781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Female');
INSERT INTO Customer VALUES ( 'Vishal' , 'Panchal' , 'vishalv1106@gmail.com' , 9676781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');
INSERT INTO Customer VALUES ( 'Shripal', 'Mehta'   , 'nishripal@gmail.com'   , 9876881905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Female');
INSERT INTO Customer VALUES ( 'Daivik' , 'Kathiria', 'daivik1106@gmail.com'  , 9476781905, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');


/************************ Insert values into artist table *********************/
INSERT INTO Artist VALUES ('Arijit', 'Singh', 'Indian Playback Singer', 'https://www.google.com/', '2000-08-11', 'Male', 'arijitsingh@gmail.com', 4375590268);
INSERT INTO Artist VALUES ('Manpreet', 'Singh', 'Indian Playback Singer', 'https://www.google.com/', '2000-08-11', 'Female', 'manpreentsingh@gmail.com', 4375580268);


/************************ Insert values into event table *********************/
INSERT INTO Event VALUES ( 'Live Concert'   , 'Perform By Indian Singer', '2023-12-12 05:00:00', '2023-12-30 08:00:00', 1, 'Music', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Live Mime Show' , 'Perform By Indian Singer', '2023-12-12 05:00:00', '2023-12-30 08:00:00', 2, 'Party', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Garba'          , 'Perform By Indian Singer', '2023-12-12 05:00:00', '2023-12-30 08:00:00', 4, 'Music', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Christmas Party', 'Perform By Indian Singer', '2023-12-12 05:00:00', '2023-12-30 08:00:00', 3, 'Party', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Concert'        , 'Perform By Indian Singer', '2023-12-12 05:00:00', '2023-12-30 08:00:00', 5, 'Music', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Jonas Brothers' , 'Perform By Indian Singer', '2023-12-12 11:00:00', '2023-12-30 18:00:00', 1, 'Party', 'www.google.com', 'Zomato');
INSERT INTO Event VALUES ( 'Singing Show'   , 'Perform By Indian Singer', '2023-12-12 15:00:00', '2023-12-30 23:00:00', 1, 'Music', 'www.google.com', 'Zomato');


/************************ Insert values into event_ticket table *********************/
INSERT INTO Event_Ticket VALUES ( 'Arijit-Live Concert'       , 06, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 1);
INSERT INTO Event_Ticket VALUES ( 'General Admission-Male'    , 02, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 2);
INSERT INTO Event_Ticket VALUES ( 'General Admission-Female'  , 20, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 5);
INSERT INTO Event_Ticket VALUES ( 'General Admission-Children', 25, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 6);
INSERT INTO Event_Ticket VALUES ( 'Skip The Line'             , 30, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 4);
INSERT INTO Event_Ticket VALUES ( 'Mime Show'                 , 20, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 2);
INSERT INTO Event_Ticket VALUES ( 'General Admission'         , 35, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 800, 200, 'Music Show By Arijit Singh', 5);
INSERT INTO Event_Ticket VALUES ( 'Early Bird'                , 20, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 5);

/************************ Insert values into artist_event table *********************/
INSERT INTO Artist_Event  VALUES (1, 1);
INSERT INTO Artist_Event  VALUES (1, 2);


/************************ Insert values into booking table *********************/
INSERT INTO Booking  VALUES ( 1,1,'Pending'  , '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Completed', '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Completed', '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Completed', '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Completed', '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Pending'  , '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Pending'  , '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Pending'  , '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Completed', '2023-12-11', NULL, NULL);
INSERT INTO Booking  VALUES ( 1,1,'Pending'  , '2023-12-11', NULL, NULL);


/************************ Insert values into booking_has_tickets table *********************/
INSERT INTO Booking_Has_Tickets  VALUES (1, 1, 2);
INSERT INTO Booking_Has_Tickets  VALUES (1, 2, 2);
INSERT INTO Booking_Has_Tickets  VALUES (2, 2, 1);
INSERT INTO Booking_Has_Tickets  VALUES (2, 1, 2);
INSERT INTO Booking_Has_Tickets  VALUES (3, 5, 2);
INSERT INTO Booking_Has_Tickets  VALUES (6, 6, 5);
INSERT INTO Booking_Has_Tickets  VALUES (7, 3, 2);
INSERT INTO Booking_Has_Tickets  VALUES (8, 4, 2);
INSERT INTO Booking_Has_Tickets  VALUES (5, 5, 2);
INSERT INTO Booking_Has_Tickets  VALUES (2, 5, 2);


/************************ Insert values into booking_refund table *********************/
INSERT INTO Booking_Refund (refund_reason , booking_id, status) VALUES ( 'some reason', 1,'Pending');
INSERT INTO Booking_Refund (refund_reason , booking_id, status) VALUES ( 'some reason', 4,'Refunded');


/*********************************************************************************************************/
/****************************************** Constraint Testing*************************************************/

/*INSERT INTO Manager VALUES ('Rajeshbhai', 'Patel', 'rajeshpatel@gmail.com', 9879081905, 'naval_123', 'www.google.com', '2024-02-28', 1);*/
/*In the above insert query getting error as i am entering future date as date of birth */

/*INSERT INTO Manager VALUES ('Rajeshbhai', 'Patel', 'rajeshpatel@gmail.com', 9879081905, 'naval_123', 'www.google.com', '2020-02-28', 1);*/
/*In the above insert query getting error as i am entering same email and phone number which is already exist in the database */

/*INSERT INTO Venue VALUES ('Park'  , 'Finch West'     , 'Ahmedabad', 382350   , 'www.mpple.com', 'Club For Celebrations Of Party', '05:00:00', '12:00:00', 4375868837);
INSERT INTO Manager VALUES ('Sushant', 'Patel', 'sushant@gmail.com', 9838081905, 'naval_123', 'www.google.com', '2020-02-28', 6);*/
/*Here I needed to added new venue as one manager will always have one and only one venue*/

/*INSERT INTO Customer VALUES ( 'Nirav'  , 'Kathiria', 'nirav@gmail.com'   , NULL, 'nirav11@23', 'www.google.com', 'Surat', '2012-02-28', 'Male');*/
/* Unable to enter data in customer table because i am entering NULL in phone number column*/

/*INSERT INTO Event_Ticket(name  , begin_sale, end_sale, issued_tickets, sold_tickets, description, event_id) 
VALUES ( 'Early Bird-2','2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 5);*/
/*Here i am not entering price in the event ticket and we kept default as zero so it is taking zero value as a price*/


/*INSERT INTO Event_Ticket VALUES ( 'Early Bird-3',-4,'2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 5);*/
/*Error thrown as i am entering negative value in the price column*/


/*INSERT INTO Booking_Has_Tickets  VALUES (2, 5, 2);*/
/*Throwing error for primary key constraint as it is combined primary key and this combination is already exist in the database*/

/*INSERT INTO Artist_Event  VALUES (1, 2);*/
/*Throwing error for primary key constraint as it is combined primary key and this combination is already exist in the database*/

/*INSERT INTO Manager VALUES ('Rajbhai', 'Patel', 'rajpatel@gmail.com', 98790819064, 'naval_123', 'www.google.com', '2020-02-28', 7);*/
/*Throwing error for foreign key constarint as venue with id 7 doesn't exist in venue table */

/*INSERT INTO Artist_Event  VALUES (1, 3);*/
/*Throwing error for foreign key constarint as artist with id 3 doesn't exist in artist table */

/*INSERT INTO Booking  VALUES ( 11,7,'Pending'  , '2023-12-11', NULL, NULL);*/
/*Throwing error for foreign key constarint as customer with id 11 doesn't exist in customer table */

/*INSERT INTO Event_Ticket VALUES ( 'Arijit-Live Concert', 06, '2023-12-01 04:00:00', '2023-12-10 04:00:00', 600, 200, 'Music Show By Arijit Singh', 9);*/
/*Throwing error for foreign key constarint as event with id 9 doesn't exist in customer table */

/*INSERT INTO Booking  VALUES ( 10,2,'sdfsgg'  , '2023-12-11', NULL, NULL);*/
/*Throwing error for check constarint as payment_status will only allow values pending and completed */

