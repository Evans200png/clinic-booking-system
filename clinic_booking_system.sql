-- creating my database
CREATE DATABASE ClinicDB;

-- getting into ClinicDB
USE ClinicDB;

-- creating Tables

-- Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) NOT NULL
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) NOT NULL,
    hire_date DATE NOT NULL
);

-- Specialties Table
CREATE TABLE Specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Doctor_Specialty Table
CREATE TABLE Doctor_Specialty (
    doctor_id INT,
    specialty_id INT,
    PRIMARY KEY (doctor_id, specialty_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (specialty_id) REFERENCES Specialties(specialty_id) ON DELETE CASCADE
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    reason TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    UNIQUE(patient_id, doctor_id, appointment_datetime)
);

-- Prescriptions Table
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    issued_date DATE NOT NULL,
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- Medications Table
CREATE TABLE Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Prescription_Medication Table
CREATE TABLE Prescription_Medication (
    prescription_id INT,
    medication_id INT,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50),
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id) ON DELETE CASCADE
);


-- filling the tables with data

-- Insert into Patients
INSERT INTO Patients (first_name, last_name, dob, email, phone) VALUES
('Alice', 'Johnson', '1990-03-15', 'alice.johnson@example.com', '555-1234'),
('Bob', 'Smith', '1985-08-22', 'bob.smith@example.com', '555-5678'),
('Carol', 'Lee', '1992-12-05', 'carol.lee@example.com', '555-8765'),
('David', 'Kim', '1987-07-19', 'david.kim@example.com', '555-2345'),
('Eva', 'Brown', '1995-02-10', 'eva.brown@example.com', '555-7890');

-- Insert into Doctors
INSERT INTO Doctors (first_name, last_name, email, phone, hire_date) VALUES
('Dr. Emily', 'Clark', 'emily.clark@clinic.com', '555-1111', '2018-01-15'),
('Dr. John', 'Doe', 'john.doe@clinic.com', '555-2222', '2020-06-01'),
('Dr. Sarah', 'Ngugi', 'sarah.ngugi@clinic.com', '555-3333', '2021-09-10'),
('Dr. Ahmed', 'Khan', 'ahmed.khan@clinic.com', '555-4444', '2019-03-20');

-- Insert into Specialties
INSERT INTO Specialties (name) VALUES
('Cardiology'),
('Dermatology'),
('Pediatrics'),
('Neurology'),
('Orthopedics');

-- Insert into Doctor_Specialty
INSERT INTO Doctor_Specialty (doctor_id, specialty_id) VALUES
(1, 1),  -- Dr. Emily - Cardiology
(1, 2),  -- Dr. Emily - Dermatology
(2, 3),  -- Dr. John - Pediatrics
(3, 4),  -- Dr. Sarah - Neurology
(3, 1),  -- Dr. Sarah - Cardiology
(4, 5);  -- Dr. Ahmed - Orthopedics

-- Insert into Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_datetime, reason) VALUES
(1, 1, '2025-05-15 09:00:00', 'Chest pain and shortness of breath'),
(2, 1, '2025-05-16 10:00:00', 'Skin rash consultation'),
(3, 2, '2025-05-17 14:30:00', 'Pediatric check-up'),
(4, 3, '2025-05-18 11:00:00', 'Frequent migraines'),
(5, 4, '2025-05-19 13:00:00', 'Knee pain'),
(1, 2, '2025-05-20 09:30:00', 'Child vaccination follow-up');

-- Insert into Prescriptions
INSERT INTO Prescriptions (appointment_id, issued_date, notes) VALUES
(1, '2025-05-15', 'Prescribed beta-blockers and follow-up needed'),
(2, '2025-05-16', 'Prescribed topical cream for rash'),
(3, '2025-05-17', 'Multivitamins recommended'),
(4, '2025-05-18', 'Recommended MRI and prescribed medication'),
(5, '2025-05-19', 'Anti-inflammatory drugs and physiotherapy suggested'),
(6, '2025-05-20', 'Routine check-up, no medication required');

-- Insert into Medications
INSERT INTO Medications (name, description) VALUES
('Atenolol', 'Used for treating hypertension and angina'),
('Hydrocortisone Cream', 'Used for skin irritation and rash'),
('Children\'s Multivitamins', 'Nutritional supplement for kids'),
('Ibuprofen', 'Nonsteroidal anti-inflammatory drug'),
('Sumatriptan', 'Used to treat migraines'); 

-- Insert into Prescription_Medication
INSERT INTO Prescription_Medication (prescription_id, medication_id, dosage, frequency) VALUES
(1, 1, '50mg', 'Once daily'),
(2, 2, 'Apply thin layer', 'Twice daily'),
(3, 3, '1 tablet', 'Once daily'),
(4, 5, '50mg', 'As needed for migraines'),
(5, 4, '400mg', 'Three times a day');

-- admin tracking report


-- Admin Report 1: Total Appointments per Doctor
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC;

-- Admin Report 2: Number of Unique Patients Seen by Each Doctor
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS patients_seen
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY patients_seen DESC;

-- Admin Report 3: Daily Appointment Count
SELECT 
    DATE(appointment_datetime) AS appointment_date,
    COUNT(*) AS total_appointments
FROM Appointments
GROUP BY appointment_date
ORDER BY appointment_date;

-- Admin Report 4: Top 5 Most Prescribed Medications
SELECT 
    m.name AS medication,
    COUNT(pm.prescription_id) AS times_prescribed
FROM Medications m
JOIN Prescription_Medication pm ON m.medication_id = pm.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Admin Report 5: Patient Visit Frequency
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.appointment_id) AS total_visits
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
ORDER BY total_visits DESC;

