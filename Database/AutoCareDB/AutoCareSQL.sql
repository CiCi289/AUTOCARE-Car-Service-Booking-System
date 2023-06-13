/*Creating Tables from Strongest ones*/

/*--- 1. Customers ---*/
CREATE TABLE Customers
(
	CustomerID VARCHAR(15) NOT NULL UNIQUE,
	CustomerName VARCHAR(100) NOT NULL,
	CustomerEmail VARCHAR(100),
	CustomerPassword VARCHAR(50) NOT NULL,
	CustomerPhone VARCHAR(20),
	CustomerAddress VARCHAR(150),
	PRIMARY KEY (CustomerID),
	CHECK (CustomerID LIKE ('Cus-%') AND
	CustomerEmail LIKE ('%gmail.com'))
);

/*--- 2. Branches ---*/
CREATE TABLE Branches
(
	BranchID VARCHAR(15) NOT NULL UNIQUE,
	BranchName VARCHAR(50),
	BranchLocation VARCHAR(150),
	GarageSpaceCapacity TINYINT,
	AvailableSpaces TINYINT,
	PRIMARY KEY (BranchID),
	CHECK (BranchID LIKE ('Br-%'))
);

/*--- 3. Promotions ---*/
CREATE TABLE Promotions
(
	PromotionID VARCHAR(15) NOT NULL UNIQUE,
	PromotionCode VARCHAR(15) NOT NULL,
	MinimumCosts DECIMAL(10,2),
	PromotionDiscount DECIMAL(5,2),
	PromotionStartDate DATE,
	PromotionEndDate DATE,
	PromotionDescription VARCHAR(200),
	PromotionActive VARCHAR(10),
	PRIMARY KEY (PromotionID),
	CHECK (PromotionID LIKE ('Promo-%') AND
	PromotionActive IN ('Active','Expired'))
);

/*--- 4. ServiceTypes ---*/
CREATE TABLE ServiceTypes
(
	ServiceTypeID VARCHAR(15) NOT NULL UNIQUE,
	ServiceTypeName VARCHAR(30),
	ServiceTypeDescription VARCHAR(200),
	PRIMARY KEY (ServiceTypeID),
	CHECK (ServiceTypeID LIKE ('St-%'))
);

/*--- 5. VehicleTypes ---*/
CREATE TABLE VehicleTypes
(
	VehicleTypeID VARCHAR(15) NOT NULL UNIQUE,
	VehicleTypeName VARCHAR(50),
	VehicleTypeDescription VARCHAR(200),
	PRIMARY KEY (VehicleTypeID),
	CHECK (VehicleTypeID LIKE ('Vt-%'))
);

/*--- 6. Employees ---*/
CREATE TABLE Employees
(
	EmployeeID VARCHAR(15) NOT NULL UNIQUE,
	EmployeeName VARCHAR(100),
	Gender VARCHAR(20),
	BranchID VARCHAR(15) NOT NULL,
	EmployeePosition VARCHAR(30),
	DateOfBirth DATE,
	EmployeeAddress VARCHAR(150),
	EmployeePhone VARCHAR(20),
	PRIMARY KEY (EmployeeID),
	FOREIGN KEY (BranchID) REFERENCES Branches (BranchID) ON UPDATE CASCADE,
	CHECK (EmployeeID LIKE ('Emp-%') AND
	BranchID LIKE ('Br-%') AND
	Gender IN ('Male' ,'Female' ,'LGBTIQ'))
);

/*--- 7. Vehicles ---*/
CREATE TABLE Vehicles
(
	VehicleID VARCHAR(15) NOT NULL UNIQUE,
	VehicleName VARCHAR(100),
	VehicleTypeID VARCHAR(15),
	VehicleModel VARCHAR(30),
	VehicleLicenseNumber VARCHAR(8),
	VehicleImage VARBINARY(MAX),
	VehicleMainColor VARCHAR(20),
	PRIMARY KEY (VehicleID),
	FOREIGN KEY (VehicleTypeID) REFERENCES VehicleTypes (VehicleTypeID) ON UPDATE CASCADE,
	CHECK (VehicleID LIKE ('V-%') AND
	VehicleTypeID LIKE ('Vt-%'))
);

/*--- 8. Services ---*/
CREATE TABLE Services
(
	ServiceID VARCHAR(15) NOT NULL UNIQUE,
	ServiceName VARCHAR(50),
	ServiceTypeID VARCHAR(15) NOT NULL,
	VehicleTypeID VARCHAR(15),
	ServiceDescription VARCHAR(200),
	ServiceDuration TIME,
	ServiceStatus VARCHAR(20),
	ServicePrice DECIMAL(10,2),
	PRIMARY KEY (ServiceID),
	FOREIGN KEY (ServiceTypeID) REFERENCES ServiceTypes (ServiceTypeID) ON UPDATE CASCADE,
	FOREIGN KEY (VehicleTypeID) REFERENCES VehicleTypes (VehicleTypeID) ON UPDATE CASCADE,
	CHECK (ServiceID LIKE ('S-%') AND
	ServiceTypeID LIKE ('St-%') AND
	VehicleTypeID LIKE ('Vt-%') AND
	ServiceStatus IN ('Active', 'Temporarily paused', 'Terminated'))
);

/*--- 9. VehicleTypeServices ---*/
CREATE TABLE VehicleTypeServices
(
	ServiceID VARCHAR(15),
	VehicleTypeID VARCHAR(15),
	Primary Key (ServiceID, VehicleTypeID),
	FOREIGN KEY (ServiceID) REFERENCES  Services (ServiceID) ON UPDATE CASCADE,
	FOREIGN KEY (VehicleTypeID) REFERENCES VehicleTypes (VehicleTypeID),
	CHECK (ServiceID LIKE ('S-%') AND
	VehicleTypeID LIKE ('Vt-%'))
);

/*--- 10. Ratings ---*/
CREATE TABLE Ratings
(
	RatingID VARCHAR(15) NOT NULL UNIQUE,
	CustomerID VARCHAR(15) NOT NULL,
	ServiceID VARCHAR(15) NOT NULL,
	RatingAmount TINYINT NOT NULL,
	RatingDate DATE,
	PRIMARY KEY (RatingID),
	FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON UPDATE CASCADE,
	FOREIGN KEY (ServiceID) REFERENCES Services (ServiceID) ON UPDATE CASCADE,
	CHECK (RatingID LIKE ('Rt-%') AND
	CustomerID LIKE ('Cus-%') AND
	ServiceID LIKE ('S-%') AND
	RatingAmount IN (1,2,3,4,5))
);

/*--- 11. GarageSpaces ---*/
CREATE TABLE GarageSpaces
(
	GarageSpaceID VARCHAR(15) NOT NULL UNIQUE,
	BranchID VARCHAR(15) NOT NULL,
	GarageSpaceNumber VARCHAR(10), /*change to varchar*/
	GarageSpaceStatus VARCHAR(15),
	PRIMARY KEY (GarageSpaceID),
	FOREIGN KEY (BranchID) REFERENCES Branches (BranchID) ON UPDATE CASCADE,
	CHECK (GarageSpaceID LIKE ('Gs-%') AND
	BranchID LIKE ('Br-%') AND
	GarageSpaceStatus IN ('Free', 'Taken', 'Disabled'))
);

/*--- 12. Bookings ---*/
CREATE TABLE Bookings
(
	BookingID VARCHAR(15) NOT NULL UNIQUE,
	CustomerID VARCHAR(15) NOT NULL,
	BookingDate DATE,
	ServedLocation VARCHAR(15),
	GarageSpaceID VARCHAR(15),
	BookingStartTime TIME, /*Domain*/
	BookingEndTime TIME,
	BookingStatus VARCHAR(20),
	CancellationReason VARCHAR(150),
	TotalCosts DECIMAL(10,2),
	PromotionID VARCHAR(15),
	PromotionDiscountAmount DECIMAL(10,2),
	NetCosts DECIMAL(10,2),
	PaymentDueDate DATE,
	RemainingAmount DECIMAL(10,2),
	PaymentStatus VARCHAR(20),
	PRIMARY KEY (BookingID),
	FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON UPDATE CASCADE,
	FOREIGN KEY (GarageSpaceID) REFERENCES GarageSpaces (GarageSpaceID) ON UPDATE CASCADE,
	FOREIGN KEY (PromotionID) REFERENCES Promotions (PromotionID) ON UPDATE CASCADE,
	CHECK (BookingID LIKE ('Bk-%') AND
	CustomerID LIKE ('Cus-%') AND
	GarageSpaceID LIKE ('Gs-%') AND
	PromotionID LIKE ('Promo-%') AND
	ServedLocation IN ('Home', 'Garage') AND
	BookingStatus IN ('Pending', 'Accepted', 'Cancelled', 'On The Way', 'Work In Progress', 'Final Checked', 'All Finished') AND
	PaymentStatus IN ('Fully Paid', 'Partially Paid', 'No Payment Made', 'Refunded'))
);

/*--- 13. BookedServices ---*/
CREATE TABLE BookedServices
(
	BookingID VARCHAR(15) NOT NULL,
	ServiceID VARCHAR(15) NOT NULL,
	PRIMARY KEY (BookingID, ServiceID),
	FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (ServiceID) REFERENCES Services (ServiceID) ON UPDATE CASCADE,
	CHECK (BookingID LIKE ('Bk-%') AND
	ServiceID LIKE ('S-%'))
);

/*--- 14. Comments ---*/
CREATE TABLE Comments
(
	CommentID VARCHAR(15) NOT NULL UNIQUE,
	BookingID VARCHAR(15) NOT NULL,
	CommentText VARCHAR(200),
	CommentTimestamp DATETIME,
	PRIMARY KEY (CommentID),
	FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON UPDATE CASCADE,
	CHECK (CommentID LIKE ('Cmt-%') AND
	BookingID LIKE ('Bk-%'))
);

/*--- 15. Payments ---*/
CREATE TABLE Payments
(
	PaymentID VARCHAR(15) NOT NULL UNIQUE,
	BookingID VARCHAR(15) NOT NULL,
	PaymentDate DATE,
	PaymentType VARCHAR(10),
	PaymentMethod VARCHAR(15),
	PaymentAmount DECIMAL(10,2),
	PRIMARY KEY (PaymentID),
	FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON UPDATE CASCADE,
	CHECK (PaymentID LIKE ('Pay-%') AND
	BookingID LIKE ('Bk-%') AND
	PaymentType IN ('Full', 'Partial') AND
	PaymentMethod IN ('Cash', 'CB Pay', 'KBZ Pay', 'Wave Pay', 'JCB MPU'))
);

/*--- 16. AdminReplies ---*/
CREATE TABLE AdminReplies
(
	ReplyID VARCHAR(15) NOT NULL UNIQUE,
	CommentID VARCHAR(15) NOT NULL,
	EmployeeID VARCHAR(15) NOT NULL,
	ReplyText VARCHAR(200),
	ReplyTimestamp DATETIME,
	PRIMARY KEY (ReplyID),
	FOREIGN KEY (CommentID) REFERENCES Comments (CommentID) ON UPDATE CASCADE,
	FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
	CHECK (ReplyID LIKE ('Rp-%') AND
	CommentID LIKE ('Cmt-%') AND
	EmployeeID LIKE ('Emp-%'))
);



/*Insert into/ Create new rows into Tables*/
/* 1. Customers */
INSERT INTO Customers
		(CustomerID,
		CustomerName,
		CustomerEmail,
		CustomerPassword,
		CustomerPhone,
		CustomerAddress)

VALUES	('Cus-001',
		'CiCi289',
		'Cihtinaung289.cha@gmail.com',
		'cici289',
		'09798457867',
		'No.15/201, ATP street, MGTN Township, Yangon.'),

		('Cus-002',
		'U Aung Aung',
		'AungAung183@gmail.com',
		'aungaung183',
		'09572426746',
		'No.34/G, 124th street, MGTN Township, Yangon.'),

		('Cus-003',
		'Kyaw Thet',
		'KyawT.KT123@gmail.com',
		'KyawThet123',
		'09798356246',
		'No.20/ 201, Sapal street, AL Township, Yangon.'),

		('Cus-004',
		'U Aung Min Thein',
		'AungMT.235@gmail.com',
		'AungMT235',
		'095188325',
		'No.124/ 301, 51st street, BTH Township, Yangon.'),

		('Cus-005',
		'Ko Kan Kaung',
		'KKKLucky.123@gmail.com',
		'KKKLucky!',
		'09756835626',
		'No.9/ 501, 140th street, TM Township, Yangon.');

SELECT * FROM Customers;


/* 2. Branches */
INSERT INTO Branches
		(BranchID,
		BranchName,
		BranchLocation,
		GarageSpaceCapacity,
		AvailableSpaces)

VALUES	('Br-001',
		'Pansoedan Branch',
		'No.77, Upper Pansoedan Road, MGTN Township, Yangon.',
		15,
		14),

		('Br-002',
		'North Dagon Branch',
		'No.269, Pyi Htaung Su Road, ND Township, Yangon.',
		15,
		14),

		('Br-003',
		'South Oakkalapa Branch',
		'No.333, Thit Sar Road, SOK Township, Yangon.',
		15,
		14);

SELECT * FROM Branches;


/* 3. Promotions */
INSERT INTO Promotions
		(PromotionID,
		PromotionCode,
		MinimumCosts,
		PromotionDiscount,
		PromotionStartDate,
		PromotionEndDate,
		PromotionDescription,
		PromotionActive)

VALUES ('Promo-001',
		'XmasAC',
		30000,
		0.1,
		'2022-12-25',
		'2022-12-26',
		'Promotion event of AutoCare for Christmas. Customers with spending of 30000 and above will gain 10 percent discount within promo days.',
		'Expired'),

		('Promo-002',
		'NYAC2023',
		50000,
		0.1,
		'2022-12-31',
		'2023-1-5',
		'Promotion event of AutoCare for New Year 2023. Customers with spending of 50000 and above will gain 10 percent discount within promo days.',
		'Expired'),

		('Promo-003',
		'CNYAC2023',
		30000,
		0.1,
		'2023-1-22',
		'2023-1-31',
		'Promotion event of AutoCare for Chinese New Year. Customers with spending of 30000 and above will gain 10 percent discount within promo days.',
		'Active');

SELECT * FROM Promotions;


/* 4. ServiceTypes */
INSERT INTO ServiceTypes
		(ServiceTypeID,
		ServiceTypeName,
		ServiceTypeDescription)

VALUES	('St-001',
		'In-Garage',
		'A wide range of services will be offered at our branches garage, if customers chooses this In-Garage Service. Prices may vary.'),

		('St-002',
		'Home',
		'A limited range of services will be offered in this type. We will send fleets to your home or driveway of car location and offer services. Duration may be longer and Prices may vary.'),

		('St-003',
		'Pick Up',
		'A wide range of services will be offered. We will send fleets to your location to pick up your car.');

SELECT * FROM ServiceTypes;


/* 5. VehicleTypes */
INSERT INTO VehicleTypes
		(VehicleTypeID,
		VehicleTypeName,
		VehicleTypeDescription)

VALUES ('Vt-001',
		'Compact',
		'Smallest overall dimension, Smallest engine capacity, HP'),

		('Vt-002',
		'Medium',
		'Larger overall dimension, Similar/Larger engine capacity, HP'),

		('Vt-003',
		'Van/SUV',
		'Larger overall dimension, Larger engine capacity, HP'),

		('Vt-004',
		'Compact Truck',
		'Largest overall dimension, Larger engine capacity, HP with a storage container.');

SELECT * FROM VehicleTypes;


/* 6. Employees */
INSERT INTO Employees
		(EmployeeID,
		EmployeeName,
		Gender,
		BranchID,
		EmployeePosition,
		DateOfBirth,
		EmployeeAddress,
		EmployeePhone)

VALUES ('Emp-001',
		'U Aung Thin',
		'Male',
		'Br-001',
		'Manager',
		'1976-10-12',
		'No.23/ 201, Kant Kaw Street, YG Township, Yangon.',
		'09751748673'),

		('Emp-002',
		'Ko Kyaw Khin',
		'Male',
		'Br-001',
		'Technician',
		'1990-9-18',
		'No.213, Wutt Kyaung Street, YK Township, Yangon.',
		'0951756846'),

		('Emp-003',
		'Ko Aung Kyaw',
		'Male',
		'Br-001',
		'Admin',
		'1995-4-25',
		'No.24/ 201, 124th Street, MGTN Township, Yangon.',
		'0951446643'),

		('Emp-004',
		'U Aung Hein',
		'Male',
		'Br-002',
		'Admin',
		'1980-5-28',
		'No.102/ A, 30th Street, BTH Township, Yangon.',
		'09894538673'),

		('Emp-005',
		'Ko Myat Tun',
		'Male',
		'Br-002',
		'Detail Technician',
		'1985-10-1',
		'No.23/ 201, 150th Street, MGTN Township, Yangon.',
		'09798465713'),

		('Emp-006',
		'Ko Tun Tun',
		'Male',
		'Br-002',
		'Manager',
		'1990-12-1',
		'No.123/ 201, 132nd Street, MGTN Township, Yangon.',
		'095155836'),

		('Emp-007',
		'Ko Jone Lwin',
		'Male',
		'Br-003',
		'Admin',
		'1995-8-16',
		'No.24/ B, 31st Street, YK Township, Yangon.',
		'098945862867'),

		('Emp-008',
		'Ma Saw Sandar',
		'Female',
		'Br-003',
		'Manager',
		'1980-12-2',
		'No.50, 160th Street, TM Township, Yangon.',
		'0951684867'),

		('Emp-009',
		'Ko Aung Thaw',
        'Male',
        'Br-003',
        'Technician',
        '1986-6-6',
        'No.27/201, 90th Street, MGTN Township, Yangon.',
        '09894585385');

SELECT * FROM Employees;


/* 7. Vehicles */
INSERT INTO Vehicles
        (VehicleID,
        VehicleName,
        VehicleTypeID,
        VehicleModel,
        VehicleLicenseNumber,
        VehicleImage,
        VehicleMainColor)

VALUES ('V-001',
        'Volkswagen Beetle',
        'Vt-001',
        '2020',
        '9Q-6969',
        NULL,
        'Cyan'),

        ('V-002',
        'Honda Civic',
        'Vt-001',
        '2019',
        '5H-1122',
        NULL,
        'Black'),

        ('V-003',
        'Chevrolet Silverado',
        'Vt-002',
        '2019',
        '4M-5678',
        NULL,
        'Ultramarine'),

        ('V-004',
        'Toyota Tundra',
        'Vt-002',
        '2020',
        '5H-3264',
        NULL,
        'White'),

        ('V-005',
        'Ford Ranger',
        'Vt-004',
        '2018',
        '7F-1236',
        NULL,
        'Crimson Red');

SELECT * FROM Vehicles;


/* 8. Services */
INSERT INTO Services
        (ServiceID,
        ServiceName,
        ServiceTypeID,
        VehicleTypeID,
        ServiceDescription,
        ServiceDuration,
        ServiceStatus,
        ServicePrice)

VALUES ('S-001',
        'Car Wash for Compacts(Garage)',
        'St-001',
        'Vt-001',
        'Car wash service for Compact cars, Done at our branches garages.',
        '00:30:00',
        'Active',
        5000),

        ('S-002',
        'Car Wash for Mediums(Garage)',
        'St-001',
        'Vt-002',
        'Car wash service for Medium cars, Done at our branches garages.',
        '00:35:00',
        'Active',
        6000),

        ('S-003',
        'Car Wash for Van/SUVs(Garage)',
        'St-001',
        'Vt-003',
        'Car wash service for Van/SUVs cars, Done at our branches garages.',
        '00:45:00',
        'Active',
        7000),

        ('S-004',
        'Car Wash for Compact Trucks(Garage)',
        'St-001',
        'Vt-004',
        'Car wash service for Compact Trucks, Done at our branches garages.',
        '00:45:00',
        'Active',
        9000),

        ('S-005',
        'Car Wash for Compacts(Home)',
        'St-002',
        'Vt-001',
        'Car wash service for Compact cars, Done at your location. Transportation fees added.',
        '00:45:00',
        'Active',
        7000),

        ('S-006',
        'Car Wash for Mediums(Home)',
        'St-002',
        'Vt-002',
        'Car wash service for Medium cars, Done at your location. Transportation fees added.',
        '00:50:00',
        'Active',
        8000),

        ('S-007',
        'Car Wash for Van/Suvs(Home)',
        'St-002',
        'Vt-003',
        'Car wash service for Van/SUVs cars, Done at your location. Transportation fees added.',
        '1:00:00',
        'Active',
        9000),

        ('S-008',
        'Car Wash for Compact Trucks(Home)',
        'St-002',
        'Vt-004',
        'Car wash service for Compact Trucks, Done at your location. Transportation fees added.',
        '1:10:00',
        'Temporarily paused',
        11000),

        ('S-009',
        'Car Polish for Compact(Garage)',
        'St-001',
        'Vt-001',
        'Car polish service for Compact cars, Done at our branches garages.',
        '1:30:00',
        'Active',
        13000),

        ('S-010',
        'Car Polish for Medium(Garage)',
        'St-001',
        'Vt-002',
        'Car polish service for Medium cars, Done at our branches garages.',
        '1:35:00',
        'Active',
        14000),

        ('S-011',
        'Car Polish for Van/SUVs(Garage)',
        'St-001',
        'Vt-003',
        'Car polish service for Vans/SUVs cars, Done at our branches garages.',
        '2:00:00',
        'Active',
        16000),

        ('S-012',
        'Car Polish for Compact(Home)',
        'St-002',
        'Vt-001',
        'Car Polish service for Compact cars, Done at your location. Transportation fees added.',
        '1:45:00',
        'Active',
        15000),

        ('S-013',
        'Car Polish for Medium(Home)',
        'St-002',
        'Vt-002',
        'Car wash service for Medium cars, Done at your location. Transportation fees added.',
        '1:50:00',
        'Active',
        16000),

        ('S-014',
        'Interior Cleaning for Compact(Garage)',
        'St-001',
        'Vt-001',
        'Interior cleaning service for Compact cars, Done at our branches garages.',
        '1:15:00',
        'Active',
        10000),

        ('S-015',
        'Interior Cleaning for Medium(Garage)',
        'St-001',
        'Vt-002',
        'Interior cleaning service for Medium cars, Done at our branches garages.',
        '1:15:00',
        'Active',
        12000),

        ('S-016',
        'Interior Cleaning for Van/SUV(Garage)',
        'St-001',
        'Vt-003',
        'Interior cleaning service for Van/SUVs cars, Done at our branches garages.',
        '1:45:00',
        'Active',
        15000),

        ('S-017',
        '3D wheel alignment for Compact(Garage)',
        'St-001',
        'Vt-001',
        '3D wheel alignment service for Compact cars, Done at our branches garages.',
        '1:00:00',
        'Active',
        20000),

        ('S-018',
        '3D wheel alignment for Medium(Garage)',
        'St-001',
        'Vt-001',
        '3D wheel alignment service for Medium cars, Done at our branches garages.',
        '1:00:00',
        'Active',
        20000);

SELECT * FROM Services;
SELECT ServiceID, VehicleTypeID FROM Services
Order BY ServiceID;

/* 9. VehicleTypeServices */
INSERT INTO VehicleTypeServices
        (ServiceID,
        VehicleTypeID)

VALUES ('S-001',
        'Vt-001'),

        ('S-002',
        'Vt-002'),

        ('S-003',
        'Vt-003'),

        ('S-004',
        'Vt-004'),

        ('S-005',
        'Vt-001'),

        ('S-006',
        'Vt-002'),

        ('S-007',
        'Vt-003'),

        ('S-008',
        'Vt-004'),

        ('S-009',
        'Vt-001'),

        ('S-010',
        'Vt-002'),

        ('S-011',
        'Vt-003'),

        ('S-012',
        'Vt-001'),

        ('S-013',
        'Vt-002'),

        ('S-014',
        'Vt-001'),

        ('S-015',
        'Vt-002'),

        ('S-016',
        'Vt-003'),

        ('S-017',
        'Vt-001'),

        ('S-018',
        'Vt-002');

SELECT * FROM VehicleTypeServices;


/* 10. GarageSpaces */
INSERT INTO GarageSpaces
        (GarageSpaceID,
        BranchID,
        GarageSpaceNumber,
        GarageSpaceStatus)

VALUES ('Gs-001',
        'Br-001',
        '1', 
        'Taken'),

        ('Gs-002',
        'Br-001',
        '2',
        'Free'),

        ('Gs-003',
        'Br-001',
        '3',
        'Free'),

        ('Gs-004',
        'Br-001',
        '4',
        'Free'),

        ('Gs-005',
        'Br-001',
        '5',
        'Free'),

        ('Gs-006',
        'Br-001',
        '6',
        'Free'),

        ('Gs-007',
        'Br-001',
        '7',
        'Free'),

        ('Gs-008',
        'Br-001',
        '8',
        'Free'),

        ('Gs-009',
        'Br-001',
        '9',
        'Free'),

        ('Gs-010',
        'Br-001',
        '10',
        'Free'),

        ('Gs-011',
        'Br-001',
        '11',
        'Free'),

        ('Gs-012',
        'Br-001',
        '12',
        'Free'),

        ('Gs-013',
        'Br-001',
        '13',
        'Free'),

        ('Gs-014',
        'Br-001',
        '14',
        'Free'),

        ('Gs-015',
        'Br-001',
        '15',
        'Free'),

        ('Gs-016',
        'Br-002',
        '1',
        'Taken'),

        ('Gs-017',
        'Br-002',
        '2',
        'Free'),

        ('Gs-018',
        'Br-002',
        '3',
        'Free'),

        ('Gs-019',
        'Br-002',
        '4',
        'Free'),

        ('Gs-020',
        'Br-002',
        '5',
        'Free'),

        ('Gs-021',
        'Br-002',
        '6',
        'Free'),

        ('Gs-022',
        'Br-002',
        '7',
        'Free'),

        ('Gs-023',
        'Br-002',
        '8',
        'Free'),

        ('Gs-024',
        'Br-002',
        '9',
        'Free'),

        ('Gs-025',
        'Br-002',
        '10',
        'Free'),

        ('Gs-026',
        'Br-002',
        '11',
        'Free'),

        ('Gs-027',
        'Br-002',
        '12',
        'Free'),

        ('Gs-028',
        'Br-002',
        '13',
        'Free'),

        ('Gs-029',
        'Br-002',
        '14',
        'Free'),

        ('Gs-030',
        'Br-002',
        '15',
        'Free'),

        ('Gs-031',
        'Br-003',
        '1',
        'Free'),

        ('Gs-032',
        'Br-003',
        '2',
        'Free'),

        ('Gs-033',
        'Br-003',
        '3',
        'Free'),

        ('Gs-034',
        'Br-003',
        '4',
        'Free'),

        ('Gs-035',
        'Br-003',
        '5',
        'Free'),

        ('Gs-036',
        'Br-003',
        '6',
        'Free'),

        ('Gs-037',
        'Br-003',
        '7',
        'Free'),

        ('Gs-038',
        'Br-003',
        '8',
        'Free'),

        ('Gs-039',
        'Br-003',
        '9',
        'Free'),

        ('Gs-040',
        'Br-003',
        '10',
        'Free'),

        ('Gs-041',
        'Br-003',
        '11',
        'Free'),

        ('Gs-042',
        'Br-003',
        12,
        'Free'),

        ('Gs-043',
        'Br-003',
        '13',
        'Free'),

        ('Gs-044',
        'Br-003',
        '14',
        'Free'),

        ('Gs-045',
        'Br-003',
        '15',
        'Free');

SELECT * FROM GarageSpaces;


/* 11. Bookings */
INSERT INTO Bookings
        (BookingID,
        CustomerID,
        BookingDate,
        ServedLocation,
        GarageSpaceID,
        BookingStartTime,
        BookingEndTime,
        BookingStatus,
        CancellationReason,
        TotalCosts,
        PromotionID,
        PromotionDiscountAmount,
        NetCosts,
        PaymentDueDate,
        RemainingAmount,
        PaymentStatus)

VALUES ('Bk-001',
        'Cus-001',
        '2022-12-25',
        'Garage',
        'Gs-001',
        '10:00:00',
        '13:00:00',
        'All Finished',
        NULL,
        38000,
        'Promo-001',
        3800,
        34200,
        '2023-2-1',
        NULL,
        'Fully Paid'),

        ('Bk-002',
        'Cus-002',
        '2023-1-6',
        'Home',
        NULL,
        '13:00:00',
        '15:30:00',
        'All Finished',
        NULL,
        22000,
        NULL,
        NULL,
        22000,
        '2023-1-13',
        NULL,
        'Fully Paid'),

        ('Bk-003',
        'Cus-001',
        '2023-1-24',
        'Garage',
        'Gs-016',
        '9:00:00',
        '13:15:00',
        'All Finished',
        NULL,
        48000,
        'Promo-003',
        4800,
        43200,
        '2023-1-31',
        19200,
        'Partially Paid'),

        ('Bk-004',
        'Cus-002',
        '2023-1-30',
        'Garage',
        NULL,
        '13:00:00',
        '16:45:00',
        'Pending',
        NULL,
        31000,
        'Promo-003',
        3100,
        27900,
        '2023-2-6',
        27900,
        'No Payment Made'),

        ('Bk-005',
        'Cus-001',
        '2023-1-31',
        'Home',
        NULL,
        '10:00:00',
        '11:00:00',
        'Accepted',
        NULL,
        9000,
        NULL,
        NULL,
        9000,
        '2023-2-7',
        NULL,
        'Fully Paid'),

        ('Bk-006',
        'Cus-003',
        '2023-1-27',
        'Garage',
        'Gs-002',
        '9:00:00',
        '11:10:00',
        'Work In Progress',
        NULL,
        20000,
        NULL,
        NULL,
        20000,
        '2023-2-3',
        NULL,
        'Fully Paid'),
        
        ('Bk-007',
        'Cus-005',
        '2023-1-15',
        'Garage',
        'Gs-003',
        '10:00:00',
        '12:00:00',
        'All Finished',
        NULL,
        20000,
        NULL,
        NULL,
        20000,
        '2023-1-22',
        NULL,
        'Fully Paid');

SELECT * FROM Bookings;


/* 12. BookedServices */
INSERT INTO BookedServices
        (BookingID,
        ServiceID)

VALUES ('Bk-001',
        'S-001'),

        ('Bk-001',
        'S-009'),

        ('Bk-001',
        'S-017'),

        ('Bk-002',
        'S-005'),

        ('Bk-002',
        'S-012'),

        ('Bk-003',
        'S-001'),

        ('Bk-003',
        'S-009'),

        ('Bk-003',
        'S-014'),

        ('Bk-003',
        'S-017'),

        ('Bk-004',
        'S-011'),

        ('Bk-004',
        'S-016'),

        ('Bk-005',
        'S-007'),

        ('Bk-006',
        'S-002'),

        ('Bk-006',
        'S-010'),
        
        ('Bk-007',
        'S-002'),
        
        ('Bk-007',
        'S-010');

SELECT * FROM BookedServices;


/* 13. Payments */
INSERT INTO Payments
        (PaymentID,
        BookingID,
        PaymentDate,
        PaymentType,
        PaymentMethod,
        PaymentAmount)

VALUES  ('Pay-001',
        'Bk-001',
        '2022-12-25',
        'Full',
        'CB Pay',
        34200),

        ('Pay-002',
        'Bk-002',
        '2023-1-6',
        'Full',
        'Cash',
        22000),

        ('Pay-003',
        'Bk-003',
        '2023-1-25',
        'Partial',
        'CB Pay',
        24000),

        ('Pay-004',
        'Bk-005',
        '2023-1-31',
        'Full',
        'Cash',
        9000),

        ('Pay-005',
        'Bk-006',
        '2023-1-27',
        'Full',
        'Cash',
        20000),
        
        ('Pay-006',
        'Bk-007',
        '2023-1-16',
        'Full',
        'Cash',
        20000);

SELECT * FROM Payments;
SELECT * FROM BookedServices;
SELECT B.CustomerID, B.BookingID, BS.ServiceID, S.ServiceName, B.BookingDate, B.BookingEndTime FROM BookedServices BS
JOIN Bookings B ON BS.BookingID = B.BookingID
JOIN Services S ON BS.ServiceID = S.ServiceID
WHERE  B.BookingStatus='All Finished';

/* 14. Ratings */
INSERT INTO Ratings
        (RatingID,
        CustomerID,
        ServiceID,
        RatingAmount,
        RatingDate)

VALUES ('Rt-001',
        'Cus-001',
        'S-001',
        5,
        '2022-12-26'),

        ('Rt-002',
        'Cus-001',
        'S-009',
        4,
        '2022-12-26'),

        ('Rt-003',
        'Cus-001',
        'S-017',
        4,
        '2022-12-26'),

        ('Rt-004',
        'Cus-002',
        'S-005',
        5,
        '2023-1-06'),

        ('Rt-005',
        'Cus-002',
        'S-012',
        3,
        '2023-1-06'),

        ('Rt-006',
        'Cus-001',
        'S-001',
        5,
        '2023-1-25'),

        ('Rt-007',
        'Cus-001',
        'S-009',
        4,
        '2023-1-25'),

        ('Rt-008',
        'Cus-001',
        'S-014',
        2,
        '2023-1-25'),

        ('Rt-009',
        'Cus-001',
        'S-017',
        4,
        '2023-1-25');

SELECT * FROM Ratings;


/* 15. Comments */
INSERT INTO Comments
        (CommentID,
        BookingID,
        CommentText,
        CommentTimestamp)

VALUES ('Cmt-001',
        'Bk-001',
        'Overall, I am very satisfied with the services. The workers did really good job!',
        '2022-12-26 16:00:00'),

        ('Cmt-002',
        'Bk-002',
        'Satisfied with other services. But the workers forgot some spots to clean in Interior Cleaning.',
        '2023-1-06 18:00:00'),

        ('Cmt-003',
        'Bk-003',
        'The services were good. But I found the workers left a cleaning cloth in my car just now. That is bad and careless manner.',
        '2023-1-25 7:00:00');

SELECT * FROM Comments;
SELECT * FROM Employees WHERE BranchID = 'Br-002' AND EmployeePosition = 'Admin';
SELECT B.CustomerID, B.BookingID, B.GarageSpaceID, BS.ServiceID, S.ServiceName, B.BookingDate, B.BookingEndTime FROM BookedServices BS
JOIN Bookings B ON BS.BookingID = B.BookingID
JOIN Services S ON BS.ServiceID = S.ServiceID
WHERE  B.BookingStatus='All Finished';


/* 16. AdminReplies */
INSERT INTO AdminReplies
        (ReplyID,
        CommentID,
        EmployeeID,
        ReplyText,
        ReplyTimestamp)

VALUES ('Rp-001',
        'Cmt-001',
        'Emp-003',
        'We are glad to hear your satisfied feedbacks. Thank you and please do visit us more :)',
        '2022-12-26 18:00:00'),

        ('Rp-002',
        'Cmt-002',
        'Emp-003',
        'We are sorry to hear and would like to apologize for the inconveniences in our services. We will try to be better in your next visits!',
        '2023-1-6 20:00:00'),

        ('Rp-003',
        'Cmt-003',
        'Emp-004',
        'We would like to deeply apologize for the mistake in our services. We promise we will not let such mistake happen again by our workers in your next visits. ',
        '2023-1-25 8:00:00');

SELECT * FROM AdminReplies;



/*Customers*/
/*  View customer lists w/o passwords   */
SELECT CustomerID, CustomerName, CustomerEmail, CustomerPhone, CustomerAddress 
FROM Customers;

/*  Update specific customer information    */
UPDATE Customers
SET CustomerPhone = '09756970487'
WHERE CustomerID = 'Cus-001';

/*  Generate report on most frequently visited customers within 2 months    */
SELECT C.CustomerName, COUNT(B.CustomerID) as 'Frequency of Visit' 
FROM Bookings as B
JOIN Customers as C ON B.CustomerID = C.CustomerID
WHERE B.BookingDate BETWEEN '2022-12-1' AND '2023-1-31'
GROUP BY C.CustomerName
ORDER BY COUNT(B.CustomerID) DESC;

/*  Generate report on Top 3 most spending customer of the month   */
SELECT TOP 3 C.CustomerName, SUM(B.NetCosts) as 'Total Spendings' 
FROM Bookings as B
JOIN Customers as C ON B.CustomerID = C.CustomerID
WHERE B.BookingDate BETWEEN '2023-1-1' AND '2023-1-31'
GROUP BY C.CustomerName
ORDER BY SUM(B.NetCosts) DESC;

/*VehicleTypes*/
/*  View VehicleTypes information   */
SELECT * FROM VehicleTypes;

/*  Most booked vehicle types according to booked services  */
SELECT VT.VehicleTypeName, COUNT(S.VehicleTypeID) as 'Most booked vehicle types according to booked services'
FROM VehicleTypes as VT
JOIN Services as S ON VT.VehicleTypeID = S.VehicleTypeID
JOIN BookedServices as BS ON S.ServiceID = BS.ServiceID
GROUP BY VT.VehicleTypeName 
ORDER BY 'Most booked vehicle types according to booked services' DESC;

/*Vehicles*/
/*  View Vehicle Information Together with Vehicle Type Name    */
SELECT V.*, Vt.VehicleTypeName 
FROM Vehicles as V
JOIN VehicleTypes as Vt ON V.VehicleTypeID = Vt.VehicleTypeID;

/*  Update vehicle information*/
UPDATE Vehicles
SET VehicleName = 'Honda Fit'
WHERE VehicleID = 'V-002';


/*ServiceTypes*/
/*  View ServiceTypes Information   */
SELECT * FROM ServiceTypes;

/*Services*/
/*  View Service Information according to Vehicle Type and Service Type */
SELECT S.*
FROM Services as S
JOIN ServiceTypes as ST ON S.ServiceTypeID = ST.ServiceTypeID
JOIN VehicleTypes as VT ON S.VehicleTypeID = VT.VehicleTypeID
WHERE ST.ServiceTypeName = 'In-Garage' AND VT.VehicleTypeName = 'Compact';

/*  Update Service Information*/
UPDATE Services
SET VehicleTypeID = 'Vt-002'
WHERE ServiceID = 'S-018';

/*  Top 3 most booked services of the month */
SELECT TOP 3 S.ServiceID, S.ServiceName as 'Top 3 most booked services of the month', COUNT (BS.ServiceID) as 'Frequency'
FROM Services as S
JOIN BookedServices as BS ON S.ServiceID = BS.ServiceID
JOIN Bookings as B ON BS.BookingID = B.BookingID
WHERE B.BookingDate BETWEEN '2023-1-1' AND '2023-1-31'
GROUP BY S.ServiceID, S.ServiceName
ORDER BY 'Frequency' DESC;

/*Bookings*/
/*  View specific customer's booking history    */
SELECT C.CustomerName, B.BookingID, B.BookingDate,
CONVERT(VARCHAR(5), B.BookingStartTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingStartTime, 100), 2) as 'Start Time (AM/PM)',
CONVERT(VARCHAR(5), B.BookingEndTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingEndTime, 100), 2) as 'End Time (AM/PM)', 
STUFF   ((SELECT ', ' + S.ServiceName
        FROM Services S
        JOIN BookedServices BS ON S.ServiceID = BS.ServiceID
        WHERE BS.BookingID = B.BookingID
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') as BookedServices, 
B.ServedLocation, B.GarageSpaceID, B. BookingStatus, B.NetCosts, B.PaymentStatus
FROM Bookings B
JOIN Customers as C ON B.CustomerID = C.CustomerID
WHERE C.CustomerName = 'cici289';

/*  Update Booking Information for Cancel   */
UPDATE Bookings
SET BookingStatus = 'Cancelled', 
    CancellationReason = 'We are sorry to cancel your booking as we failed to announce as closed day for our garage maintenances.',
    RemainingAmount = NULL
WHERE BookingID = 'Bk-004';

/*  Update Booking Status*/

UPDATE Bookings
SET BookingStatus = 'On The Way'
WHERE BookingID = 'Bk-005';

/*  Generate report on Booking Lists for specific date, at specific branch  */
SELECT B.BookingID , B.CustomerID, B.BookingDate,
CONVERT(VARCHAR(5), B.BookingStartTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingStartTime, 100), 2) AS 'Start Time (AM/PM)',
CONVERT(VARCHAR(5), B.BookingEndTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingEndTime, 100), 2) AS 'End Time (AM/PM)', 
B.ServedLocation, B.GarageSpaceID, B.BookingStatus, B.NetCosts, B.PaymentStatus
FROM Bookings as B
JOIN GarageSpaces as GS ON B.GarageSpaceID = GS.GarageSpaceID
JOIN Branches as BR ON BR.BranchID = GS.BranchID
WHERE BR.BranchName = 'Pansoedan Branch' AND
B.BookingDate = '2023-1-27';

/*  Generate report on most booked month    */
SELECT TOP 1  DATENAME(MONTH, BookingDate) as 'Month Name', COUNT(*) as 'Bookings'
FROM Bookings
GROUP BY DATENAME(MONTH, BookingDate)
ORDER BY COUNT(*) DESC;

/*Promotions*/
/*  View Promotion Information  */
SELECT * FROM Promotions;

/*  Generate Report on customers who have remaining 2nd payment */
SELECT C.CustomerName ,B.BookingID , B.CustomerID, B.BookingDate,
CONVERT(VARCHAR(5), B.BookingStartTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingStartTime, 100), 2) AS 'Start Time (AM/PM)',
CONVERT(VARCHAR(5), B.BookingEndTime, 108) + ' ' + RIGHT(CONVERT(VARCHAR(20), B.BookingEndTime, 100), 2) AS 'End Time (AM/PM)', 
B.ServedLocation, B.GarageSpaceID, B.BookingStatus, B.NetCosts, B.PaymentDueDate, B.RemainingAmount, B.PaymentStatus
FROM Bookings as B
JOIN Customers as C ON B.CustomerID = C.CustomerID
WHERE B.PaymentStatus = 'Partially Paid' AND B.RemainingAmount IS NOT NULL;

/*3 Make Second Payment*/
INSERT INTO Payments
        (PaymentID,
        BookingID,
        PaymentDate,
        PaymentType,
        PaymentMethod,
        PaymentAmount)

VALUES ('Pay-007',
        'Bk-003',
        '2023-1-28',
        'Partial',
        'CB Pay',
        19200);

/*  Update Booking for Fully paid customer  */
UPDATE Bookings
SET PaymentStatus = 'Fully Paid',
    RemainingAmount = NULL
WHERE BookingID = 'Bk-003';

/*  Generate report on Total Revenue of month from Bookings */
SELECT DATENAME(MONTH, BookingDate) as 'Month Name', SUM(Netcosts) as 'Total Revenues'
FROM Bookings
WHERE BookingStatus != 'Cancelled'
GROUP BY DATENAME(MONTH, BookingDate); 


/*Employees*/
/*  View Employees information in specific Branch   */
SELECT BR.BranchName ,E.* 
FROM Employees as E
JOIN Branches as BR ON E.BranchID = BR.BranchID
WHERE BR.BranchName = 'Pansoedan Branch';

/*  Updating Employee Information   */
UPDATE Employees
SET EmployeePhone = '09798523634'
WHERE EmployeeID = 'Emp-003';


/*Branches*/
/*Update branch's total available space*/
UPDATE Branches
SET AvailableSpaces = 13
WHERE BranchID = 'Br-001';


/*Garage Spaces*/
/*  View Garage Spaces according to Branch  */
SELECT GS.* , BR.BranchName
FROM GarageSpaces As GS
JOIN Branches as BR ON GS.BranchID = BR.BranchID
WHERE BR.BranchName = 'North Dagon Branch';

/*  Update Garage space */
UPDATE GarageSpaces
SET GarageSpaceStatus = 'Taken'
WHERE GarageSpaceID = 'Gs-002';


/*Ratings*/
/*  Generate report on Overall Ratings of Services  */
SELECT S.ServiceName, AVG(R.RatingAmount) as 'Average Rating'
FROM Services as S
JOIN Ratings as R ON S.ServiceID = R.ServiceID
GROUP BY S.ServiceName
ORDER BY AVG(R.RatingAmount) DESC;


/*Comments and AdminReplies*/
/*  View all related customer comments & admin replies for a specific booking   */
SELECT BK.BookingID, CMT.CommentID, CMT.CommentText,
CONVERT(VARCHAR, CMT.CommentTimestamp, 100) + ' ' + CONVERT(VARCHAR, CMT.CommentTimestamp, 108) AS ' Comment Date and Time (AM/PM)',
AR.ReplyID,AR.EmployeeID, AR.ReplyText,
CONVERT(VARCHAR, AR.ReplyTimestamp, 100) + ' ' + CONVERT(VARCHAR, AR.ReplyTimestamp, 108) AS ' Admin Reply Date and Time (AM/PM)'
FROM Comments as CMT
JOIN Bookings as BK ON CMT.BookingID = BK.BookingID
JOIN AdminReplies as AR ON CMT.CommentID = AR.CommentID
WHERE BK.BookingID = 'Bk-003';



