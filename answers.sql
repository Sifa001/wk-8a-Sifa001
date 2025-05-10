-- Creating the database
CREATE DATABASE blood_bank_management;

-- Creating the tables
-- Donor Table
CREATE TABLE Donor (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    registration_date DATE NOT NULL,
    last_donation_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

 SELECT * FROM Donor;

-- Staff Table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Blood Collection Table
CREATE TABLE BloodCollection (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    staff_id INT NOT NULL,
    collection_date DATETIME NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    volume_ml INT NOT NULL CHECK (volume_ml BETWEEN 450 AND 500),
    collection_method ENUM('Whole Blood', 'Apheresis') NOT NULL,
    test_status ENUM('Pending', 'Passed', 'Failed') DEFAULT 'Pending',
    expiration_date DATE,
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Blood Inventory Table
CREATE TABLE BloodInventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    collection_id INT UNIQUE NOT NULL,
    storage_location VARCHAR(50) NOT NULL,
    temperature FLOAT NOT NULL,
    status ENUM('Available', 'Reserved', 'Expired', 'Discarded') DEFAULT 'Available',
    FOREIGN KEY (collection_id) REFERENCES BloodCollection(collection_id)
);

-- Recipient Table
CREATE TABLE Recipient (
    recipient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    hospital_name VARCHAR(100),
    medical_record_number VARCHAR(50)
);

--  Blood Request Table
CREATE TABLE BloodRequest (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_id INT,
    requesting_hospital VARCHAR(100) NOT NULL,
    request_date DATETIME NOT NULL,
    required_blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    quantity_units INT NOT NULL,
    urgency_level ENUM('Routine', 'Urgent', 'Emergency') DEFAULT 'Routine',
    status ENUM('Pending', 'Approved', 'Fulfilled', 'Rejected') DEFAULT 'Pending',
    purpose VARCHAR(200),
    FOREIGN KEY (recipient_id) REFERENCES Recipient(recipient_id)
);

-- Blood Distribution Table
CREATE TABLE BloodDistribution (
    distribution_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    staff_id INT NOT NULL,
    distribution_date DATETIME NOT NULL,
    tracking_number VARCHAR(50) UNIQUE,
    FOREIGN KEY (request_id) REFERENCES BloodRequest(request_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Distribution Details (M-M relationship between BloodInventory and BloodDistribution)
CREATE TABLE DistributionDetails (
    distribution_id INT NOT NULL,
    inventory_id INT NOT NULL,
    PRIMARY KEY (distribution_id, inventory_id),
    FOREIGN KEY (distribution_id) REFERENCES BloodDistribution(distribution_id),
    FOREIGN KEY (inventory_id) REFERENCES BloodInventory(inventory_id)
);

-- Donation History Table
CREATE TABLE DonationHistory (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    collection_id INT NOT NULL,
    donation_date DATE NOT NULL,
    notes TEXT,
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    FOREIGN KEY (collection_id) REFERENCES BloodCollection(collection_id)
);

-- Test Results Table
CREATE TABLE TestResults (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    collection_id INT NOT NULL,
    staff_id INT NOT NULL,
    test_date DATETIME NOT NULL,
    hiv_status ENUM('Negative', 'Positive') NOT NULL,
    hepatitis_b_status ENUM('Negative', 'Positive') NOT NULL,
    hepatitis_c_status ENUM('Negative', 'Positive') NOT NULL,
    syphilis_status ENUM('Negative', 'Positive') NOT NULL,
    other_notes TEXT,
    FOREIGN KEY (collection_id) REFERENCES BloodCollection(collection_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Insert into Donor table
INSERT INTO Donor (first_name, last_name, date_of_birth, gender, blood_type, contact_number, email, address, city, registration_date, last_donation_date, is_active)
VALUES
('Vivian', 'Smith', '1985-03-15', 'Female', 'A+', '0705124567', 'vivian.smith@email.com', '123 Main St', 'Nairobi','2022-01-10', '2023-06-15', TRUE),
('Dennis', 'Johnson', '1990-07-22', 'Male', 'B-', '0722535678', 'dennis.j@email.com', '456 Oak Ave', 'Nakuru','2022-02-05', '2023-07-20', TRUE),
('Michael', 'Williams', '1978-11-30', 'Male', 'O+', '0114566789', 'michael.w@email.com', '789 Pine Rd', 'Mombasa',  '2021-11-15', '2023-05-10', TRUE),
('Lauren', 'Brown', '1995-05-18', 'Female', 'AB+', '0705457890', 'lauren.b@email.com', '321 Elm St', 'Nakuru',  '2023-01-20', NULL, TRUE),
('Alex', 'Jones', '1982-09-25', 'Male', 'A-', '0733348901', 'alex.j@email.com', '654 Maple Dr', 'Nairobi', '2022-03-12', '2023-08-05', TRUE),
('Ivy', 'Garcia', '1993-12-08', 'Female', 'O-', '0767829012', 'ivy.g@email.com', '987 Cedar Ln', 'Bungoma','2023-02-18', NULL, TRUE);

-- Insert into Staff table
INSERT INTO Staff (first_name, last_name, position, department, contact_number, email, hire_date, is_active)
VALUES
('Robert', 'Taylor', 'Phlebotomist', 'Collection', '555-111-2222', 'robert.t@bloodbank.org', '2020-05-15', TRUE),
('Jennifer', 'Martinez', 'Nurse', 'Collection', '555-222-3333', 'jennifer.m@bloodbank.org', '2019-08-20', TRUE),
('William', 'Anderson', 'Lab Technician', 'Testing', '555-333-4444', 'william.a@bloodbank.org', '2021-02-10', TRUE),
('Linda', 'Thomas', 'Inventory Manager', 'Storage', '555-444-5555', 'linda.t@bloodbank.org', '2018-11-05', TRUE),
('James', 'Jackson', 'Distribution Coordinator', 'Distribution', '555-555-6666', 'james.j@bloodbank.org', '2022-01-30', TRUE),
('Patricia', 'White', 'Administrator', 'Administration', '555-666-7777', 'patricia.w@bloodbank.org', '2017-06-18', TRUE);


-- Insert into BloodCollection table
INSERT INTO BloodCollection (donor_id, staff_id, collection_date, blood_type, volume_ml, collection_method, test_status, expiration_date)
VALUES
(1, 1, '2023-06-15 09:30:00', 'A+', 480, 'Whole Blood', 'Passed', '2023-07-27'),
(2, 2, '2023-07-20 10:15:00', 'B-', 470, 'Whole Blood', 'Passed', '2023-08-31'),
(3, 1, '2023-05-10 11:00:00', 'O+', 490, 'Whole Blood', 'Passed', '2023-06-22'),
(1, 2, '2023-08-05 08:45:00', 'A+', 460, 'Apheresis', 'Pending', '2023-09-16'),
(4, 3, '2023-09-12 13:30:00', 'AB+', 500, 'Whole Blood', 'Pending', '2023-10-24'),
(5, 1, '2023-08-15 14:00:00', 'A-', 450, 'Whole Blood', 'Passed', '2023-09-26');

-- Insert into BloodInventory table
INSERT INTO BloodInventory (collection_id, storage_location, temperature, status)
VALUES
(1, 'Fridge A1', 4.0, 'Available'),
(2, 'Fridge B2', 4.0, 'Available'),
(3, 'Fridge C3', 4.0, 'Reserved'),
(5, 'Fridge A2', 4.0, 'Available'),
(6, 'Fridge B1', 4.0, 'Available');

-- Insert into Recipient table
INSERT INTO Recipient (first_name, last_name, date_of_birth, gender, contact_number, email, hospital_name, medical_record_number)
VALUES
('Daniel', 'Harris', '1975-04-12', 'Male', '555-777-8888', 'daniel.h@email.com', 'Massachusetts General Hospital', 'MGH-12345'),
('Elizabeth', 'Clark', '1988-09-03', 'Female', '555-888-9999', 'elizabeth.c@email.com', 'Brigham and Women''s Hospital', 'BWH-67890'),
('Christopher', 'Lewis', '1965-12-24', 'Male', '555-999-0000', 'chris.l@email.com', 'Beth Israel Deaconess', 'BID-54321'),
('Amanda', 'Robinson', '1992-07-17', 'Female', '555-000-1111', 'amanda.r@email.com', 'Boston Children''s Hospital', 'BCH-98765'),
('Matthew', 'Walker', '1980-02-28', 'Male', '555-111-2222', 'matthew.w@email.com', 'Tufts Medical Center', 'TMC-13579');

-- Insert into BloodRequest table
INSERT INTO BloodRequest (recipient_id, requesting_hospital, request_date, required_blood_type, quantity_units, urgency_level, status, purpose)
VALUES
(1, 'Massachusetts General Hospital', '2023-08-10 14:30:00', 'A+', 2, 'Urgent', 'Fulfilled', 'Surgery'),
(2, 'Brigham and Women''s Hospital', '2023-08-12 10:15:00', 'B-', 1, 'Emergency', 'Fulfilled', 'Trauma case'),
(3, 'Beth Israel Deaconess', '2023-08-15 09:00:00', 'O+', 3, 'Routine', 'Approved', 'Regular transfusion'),
(4, 'Boston Children''s Hospital', '2023-08-18 16:45:00', 'AB+', 2, 'Emergency', 'Pending', 'Pediatric surgery'),
(5, 'Tufts Medical Center', '2023-08-20 11:30:00', 'A-', 1, 'Urgent', 'Approved', 'Oncology patient');

-- Insert into BloodDistribution table
INSERT INTO BloodDistribution (request_id, staff_id, distribution_date, tracking_number)
VALUES
(1, 5, '2023-08-10 15:45:00', 'TRK-20230810-001'),
(2, 5, '2023-08-12 11:30:00', 'TRK-20230812-002'),
(3, 6, '2023-08-15 10:15:00', 'TRK-20230815-003');

-- Insert into DistributionDetails table
INSERT INTO DistributionDetails (distribution_id, inventory_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert into DonationHistory table
INSERT INTO DonationHistory (donor_id, collection_id, donation_date, notes)
VALUES
(1, 1, '2023-06-15', 'Regular donor, no complications'),
(2, 2, '2023-07-20', 'First-time donor, slightly nervous'),
(3, 3, '2023-05-10', 'Experienced donor, quick process'),
(1, 4, '2023-08-05', 'Platelet donation via apheresis'),
(5, 6, '2023-08-15', 'Donor with rare blood type');

-- Insert into TestResults table
INSERT INTO TestResults (collection_id, staff_id, test_date, hiv_status, hepatitis_b_status, hepatitis_c_status, syphilis_status, other_notes)
VALUES
(1, 3, '2023-06-16 08:00:00', 'Negative', 'Negative', 'Negative', 'Negative', 'All tests passed'),
(2, 3, '2023-07-21 08:00:00', 'Negative', 'Negative', 'Negative', 'Negative', 'All tests passed'),
(3, 4, '2023-05-11 08:00:00', 'Negative', 'Negative', 'Negative', 'Negative', 'All tests passed'),
(6, 4, '2023-08-16 08:00:00', 'Negative', 'Negative', 'Negative', 'Negative', 'All tests passed');

-- SAMPLE QUERIES
-- 1. List all active donors with their last donation date
SELECT first_name, last_name, last_donation_date
FROM Donor
WHERE is_active = TRUE;

-- 2. Count the number of donors by blood type
SELECT blood_type, COUNT(*) AS donor_count
FROM Donor
GROUP BY blood_type;

-- 3. List all blood collections done by a specific staff member
SELECT bc.collection_id, d.first_name AS donor_first_name, d.last_name AS donor_last_name, bc.collection_date, bc.blood_type
FROM BloodCollection bc
JOIN Donor d ON bc.donor_id = d.donor_id
WHERE bc.staff_id = 1; -- Replace with the desired staff_id

-- 4. Find all blood requests that are pending
SELECT r.first_name AS recipient_first_name, r.last_name AS recipient_last_name, br.request_date, br.required_blood_type, br.status
FROM BloodRequest br
JOIN Recipient r ON br.recipient_id = r.recipient_id
WHERE br.status = 'Pending';

-- 5. List all blood distributions along with the tracking number
SELECT bd.distribution_id, br.requesting_hospital, bd.tracking_number, bd.distribution_date
FROM BloodDistribution bd
JOIN BloodRequest br ON bd.request_id = br.request_id;