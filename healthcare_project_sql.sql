-- ============================================================
--   HEALTHCARE ANALYTICS
--   Author: Sebastian Quesada Gudiño
--   Database: SQLite
--   Description: Integrated analysis of hospitals, patients,
--                and medications across a health system.
-- ============================================================


-- ============================================================
-- PART 1: TABLE CREATION (Schema Design)
-- ============================================================

DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS hospitals;

-- Hospitals: top-level entity in the health system
CREATE TABLE hospitals (
    hospital_id       INTEGER PRIMARY KEY,
    hospital_name     TEXT    NOT NULL,
    city              TEXT    NOT NULL,
    state             TEXT    NOT NULL,
    hospital_type     TEXT    NOT NULL,  -- 'Public', 'Private', 'Non-profit'
    bed_count         INTEGER,
    established_year  INTEGER
);

-- Departments: clinical units within each hospital
CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY,
    hospital_id     INTEGER NOT NULL,
    department_name TEXT    NOT NULL,
    floor           INTEGER,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

-- Doctors: medical staff assigned to a department and hospital
CREATE TABLE doctors (
    doctor_id        INTEGER PRIMARY KEY,
    first_name       TEXT    NOT NULL,
    last_name        TEXT    NOT NULL,
    specialty        TEXT    NOT NULL,
    department_id    INTEGER,
    hospital_id      INTEGER,
    years_experience INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (hospital_id)   REFERENCES hospitals(hospital_id)
);

-- Patients: individuals receiving medical care
CREATE TABLE patients (
    patient_id     INTEGER PRIMARY KEY,
    first_name     TEXT NOT NULL,
    last_name      TEXT NOT NULL,
    date_of_birth  DATE NOT NULL,
    gender         TEXT NOT NULL,
    blood_type     TEXT,
    city           TEXT,
    state          TEXT,
    insurance_type TEXT   -- 'Medicare', 'Medicaid', 'Private', 'Uninsured'
);

-- Admissions: each hospital visit or stay per patient
CREATE TABLE admissions (
    admission_id      INTEGER PRIMARY KEY,
    patient_id        INTEGER NOT NULL,
    hospital_id       INTEGER NOT NULL,
    doctor_id         INTEGER NOT NULL,
    department_id     INTEGER NOT NULL,
    admission_date    DATE    NOT NULL,
    discharge_date    DATE,
    admission_type    TEXT    NOT NULL,  -- 'Emergency', 'Elective', 'Urgent'
    total_cost        REAL,
    insurance_covered REAL,
    patient_paid      REAL,
    outcome           TEXT,              -- 'Recovered', 'Transferred', 'Deceased', 'Ongoing'
    FOREIGN KEY (patient_id)    REFERENCES patients(patient_id),
    FOREIGN KEY (hospital_id)   REFERENCES hospitals(hospital_id),
    FOREIGN KEY (doctor_id)     REFERENCES doctors(doctor_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Diagnoses: one or more diagnoses linked to an admission
CREATE TABLE diagnoses (
    diagnosis_id   INTEGER PRIMARY KEY,
    admission_id   INTEGER NOT NULL,
    icd_code       TEXT    NOT NULL,
    diagnosis_name TEXT    NOT NULL,
    severity       TEXT    NOT NULL,  -- 'Mild', 'Moderate', 'Severe', 'Critical'
    is_primary     INTEGER NOT NULL,  -- 1 = primary diagnosis, 0 = secondary
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- Medications: catalog of available drugs and their unit costs
CREATE TABLE medications (
    medication_id         INTEGER PRIMARY KEY,
    medication_name       TEXT    NOT NULL,
    generic_name          TEXT,
    category              TEXT    NOT NULL,
    unit_cost             REAL    NOT NULL,
    requires_prescription INTEGER NOT NULL  -- 1 = yes, 0 = no
);

-- Prescriptions: medications prescribed during a specific admission
CREATE TABLE prescriptions (
    prescription_id INTEGER PRIMARY KEY,
    admission_id    INTEGER NOT NULL,
    medication_id   INTEGER NOT NULL,
    doctor_id       INTEGER NOT NULL,
    prescribed_date DATE    NOT NULL,
    dosage          TEXT    NOT NULL,
    duration_days   INTEGER NOT NULL,
    quantity        INTEGER NOT NULL,
    total_cost      REAL    NOT NULL,
    FOREIGN KEY (admission_id)  REFERENCES admissions(admission_id),
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id),
    FOREIGN KEY (doctor_id)     REFERENCES doctors(doctor_id)
);


-- ============================================================
-- PART 2: SYNTHETIC DATA INSERTION
-- ============================================================

-- ---- HOSPITALS ----
INSERT INTO hospitals VALUES
(1, 'General City Hospital',      'New York',     'NY', 'Public',    850, 1948),
(2, 'Sunrise Medical Center',     'Los Angeles',  'CA', 'Private',   620, 1972),
(3, 'Lakeside Community Hospital','Chicago',      'IL', 'Non-profit', 410, 1965),
(4, 'Metro Health System',        'Houston',      'TX', 'Public',    930, 1955),
(5, 'Valley Care Institute',      'Phoenix',      'AZ', 'Private',   380, 1990);

-- ---- DEPARTMENTS ----
INSERT INTO departments VALUES
( 1, 1, 'Emergency',        1),
( 2, 1, 'Cardiology',       3),
( 3, 1, 'Oncology',         4),
( 4, 2, 'Emergency',        1),
( 5, 2, 'Neurology',        2),
( 6, 2, 'Orthopedics',      3),
( 7, 3, 'Pediatrics',       2),
( 8, 3, 'Internal Medicine',3),
( 9, 3, 'Emergency',        1),
(10, 4, 'Cardiology',       2),
(11, 4, 'Emergency',        1),
(12, 4, 'Pulmonology',      3),
(13, 5, 'Orthopedics',      2),
(14, 5, 'Neurology',        3),
(15, 5, 'Internal Medicine',1);

-- ---- DOCTORS ----
INSERT INTO doctors VALUES
( 1, 'James',   'Carter',   'Cardiologist',     2,  1, 18),
( 2, 'Maria',   'Gonzalez', 'Emergency',        1,  1, 12),
( 3, 'David',   'Kim',      'Oncologist',       3,  1, 15),
( 4, 'Sarah',   'Thompson', 'Neurologist',      5,  2, 10),
( 5, 'Robert',  'Brown',    'Emergency',        4,  2,  8),
( 6, 'Linda',   'Patel',    'Orthopedic',       6,  2, 20),
( 7, 'Michael', 'Johnson',  'Pediatrician',     7,  3, 14),
( 8, 'Emily',   'Davis',    'Internist',        8,  3,  9),
( 9, 'Carlos',  'Ramirez',  'Emergency',        9,  3,  6),
(10, 'Angela',  'Moore',    'Cardiologist',    10,  4, 22),
(11, 'Kevin',   'Wilson',   'Emergency',       11,  4,  7),
(12, 'Natalie', 'Harris',   'Pulmonologist',   12,  4, 11),
(13, 'Steven',  'Clark',    'Orthopedic',      13,  5, 16),
(14, 'Rachel',  'Lewis',    'Neurologist',     14,  5, 13),
(15, 'Thomas',  'Walker',   'Internist',       15,  5,  5);

-- ---- PATIENTS ----
INSERT INTO patients VALUES
( 1, 'Alice',    'Johnson',   '1955-03-12', 'F', 'A+',  'Brooklyn',     'NY', 'Medicare'),
( 2, 'Bob',      'Martinez',  '1942-07-22', 'M', 'O-',  'Bronx',        'NY', 'Medicare'),
( 3, 'Carmen',   'Rivera',    '1978-11-05', 'F', 'B+',  'Queens',       'NY', 'Private'),
( 4, 'Daniel',   'Lee',       '1990-02-18', 'M', 'AB+', 'Los Angeles',  'CA', 'Private'),
( 5, 'Eleanor',  'White',     '1965-09-30', 'F', 'A-',  'Pasadena',     'CA', 'Medicaid'),
( 6, 'Frank',    'Thomas',    '1988-06-14', 'M', 'O+',  'Santa Monica', 'CA', 'Uninsured'),
( 7, 'Grace',    'Anderson',  '2010-01-25', 'F', 'B-',  'Evanston',     'IL', 'Private'),
( 8, 'Henry',    'Jackson',   '1972-04-08', 'M', 'A+',  'Chicago',      'IL', 'Medicaid'),
( 9, 'Isabel',   'Garcia',    '1948-12-17', 'F', 'O+',  'Naperville',   'IL', 'Medicare'),
(10, 'James',    'Hernandez', '1983-08-21', 'M', 'AB-', 'Houston',      'TX', 'Private'),
(11, 'Karen',    'Young',     '1959-05-03', 'F', 'B+',  'Sugarland',    'TX', 'Medicare'),
(12, 'Leo',      'King',      '1995-10-11', 'M', 'A+',  'Houston',      'TX', 'Private'),
(13, 'Monica',   'Wright',    '1970-03-28', 'F', 'O-',  'Scottsdale',   'AZ', 'Private'),
(14, 'Nathan',   'Lopez',     '1987-07-15', 'M', 'A-',  'Tempe',        'AZ', 'Uninsured'),
(15, 'Olivia',   'Hill',      '2008-02-09', 'F', 'B+',  'Mesa',         'AZ', 'Medicaid'),
(16, 'Paul',     'Scott',     '1950-11-30', 'M', 'O+',  'Manhattan',    'NY', 'Medicare'),
(17, 'Quinn',    'Green',     '1993-06-22', 'F', 'AB+', 'Los Angeles',  'CA', 'Private'),
(18, 'Richard',  'Adams',     '1944-09-14', 'M', 'A+',  'Chicago',      'IL', 'Medicare'),
(19, 'Sandra',   'Nelson',    '1968-04-05', 'F', 'O-',  'Houston',      'TX', 'Medicaid'),
(20, 'Tyler',    'Baker',     '2005-12-01', 'M', 'B-',  'Phoenix',      'AZ', 'Private'),
(21, 'Uma',      'Carter',    '1975-08-19', 'F', 'A+',  'Brooklyn',     'NY', 'Private'),
(22, 'Victor',   'Mitchell',  '1962-01-27', 'M', 'O+',  'Los Angeles',  'CA', 'Medicare'),
(23, 'Wendy',    'Perez',     '1980-05-16', 'F', 'B+',  'Chicago',      'IL', 'Private'),
(24, 'Xavier',   'Roberts',   '1999-03-07', 'M', 'A-',  'Houston',      'TX', 'Uninsured'),
(25, 'Yolanda',  'Turner',    '1957-10-23', 'F', 'AB+', 'Phoenix',      'AZ', 'Medicare');

-- ---- ADMISSIONS ----
INSERT INTO admissions VALUES
( 1,  1, 1,  2,  1, '2023-01-05', '2023-01-08', 'Emergency',  4200.00, 3780.00,  420.00, 'Recovered'),
( 2,  2, 1,  1,  2, '2023-01-10', '2023-01-20', 'Elective',  18500.00,16650.00, 1850.00, 'Recovered'),
( 3,  3, 1,  3,  3, '2023-02-01', '2023-02-15', 'Urgent',    32000.00,28800.00, 3200.00, 'Recovered'),
( 4,  4, 2,  5,  4, '2023-02-14', '2023-02-15', 'Emergency',  2800.00,    0.00, 2800.00, 'Recovered'),
( 5,  5, 2,  4,  5, '2023-02-20', '2023-03-02', 'Elective',  15600.00,10920.00, 4680.00, 'Recovered'),
( 6,  6, 2,  6,  6, '2023-03-05', '2023-03-10', 'Urgent',     9400.00,    0.00, 9400.00, 'Recovered'),
( 7,  7, 3,  7,  7, '2023-03-12', '2023-03-14', 'Emergency',  3100.00, 2790.00,  310.00, 'Recovered'),
( 8,  8, 3,  8,  8, '2023-03-22', '2023-04-01', 'Elective',  11200.00, 7840.00, 3360.00, 'Recovered'),
( 9,  9, 3,  9,  9, '2023-04-08', '2023-04-10', 'Emergency',  5300.00, 4770.00,  530.00, 'Recovered'),
(10, 10, 4, 10, 10, '2023-04-15', '2023-04-25', 'Urgent',    22000.00,19800.00, 2200.00, 'Recovered'),
(11, 11, 4, 12, 12, '2023-04-20', '2023-05-03', 'Elective',  17500.00,14000.00, 3500.00, 'Recovered'),
(12, 12, 4, 11, 11, '2023-05-01', '2023-05-02', 'Emergency',  1800.00, 1620.00,  180.00, 'Recovered'),
(13, 13, 5, 13, 13, '2023-05-10', '2023-05-18', 'Elective',  13400.00,12060.00, 1340.00, 'Recovered'),
(14, 14, 5, 14, 14, '2023-05-15', '2023-05-20', 'Urgent',     8700.00,    0.00, 8700.00, 'Recovered'),
(15, 15, 5, 15, 15, '2023-06-01', '2023-06-03', 'Emergency',  4600.00, 3680.00,  920.00, 'Recovered'),
(16, 16, 1,  1,  2, '2023-06-10', '2023-06-22', 'Elective',  25000.00,22500.00, 2500.00, 'Recovered'),
(17, 17, 2,  4,  5, '2023-06-18', '2023-06-24', 'Urgent',    11000.00, 9900.00, 1100.00, 'Recovered'),
(18, 18, 3,  8,  8, '2023-07-03', '2023-07-15', 'Elective',  14800.00,13320.00, 1480.00, 'Recovered'),
(19, 19, 4, 10, 10, '2023-07-10', '2023-07-20', 'Urgent',    19500.00,13650.00, 5850.00, 'Recovered'),
(20, 20, 5, 13, 13, '2023-07-22', '2023-07-28', 'Elective',   9200.00, 8280.00,  920.00, 'Recovered'),
(21,  1, 1,  2,  1, '2023-08-05', '2023-08-07', 'Emergency',  3800.00, 3420.00,  380.00, 'Recovered'),
(22,  3, 1,  3,  3, '2023-08-14', '2023-09-01', 'Urgent',    45000.00,40500.00, 4500.00, 'Recovered'),
(23,  5, 2,  5,  4, '2023-08-20', '2023-08-21', 'Emergency',  2200.00, 1540.00,  660.00, 'Recovered'),
(24,  9, 3,  9,  9, '2023-09-01', '2023-09-04', 'Emergency',  6100.00, 5490.00,  610.00, 'Recovered'),
(25, 11, 4, 12, 12, '2023-09-12', '2023-09-26', 'Elective',  21000.00,16800.00, 4200.00, 'Recovered'),
(26, 13, 5, 14, 14, '2023-09-20', '2023-09-27', 'Urgent',    10500.00, 9450.00, 1050.00, 'Recovered'),
(27,  2, 1,  1,  2, '2023-10-01', '2023-10-08', 'Urgent',    16000.00,14400.00, 1600.00, 'Recovered'),
(28,  6, 2,  6,  6, '2023-10-10', '2023-10-16', 'Elective',  12300.00,    0.00,12300.00, 'Recovered'),
(29,  8, 3,  7,  7, '2023-10-15', '2023-10-16', 'Emergency',  2900.00, 2030.00,  870.00, 'Recovered'),
(30, 10, 4, 11, 11, '2023-10-22', '2023-10-23', 'Emergency',  3500.00, 3150.00,  350.00, 'Recovered'),
(31, 12, 4, 10, 10, '2023-11-01', '2023-11-12', 'Elective',  20500.00,18450.00, 2050.00, 'Recovered'),
(32, 14, 5, 13, 13, '2023-11-08', '2023-11-15', 'Urgent',     8900.00,    0.00, 8900.00, 'Transferred'),
(33, 16, 1,  2,  1, '2023-11-15', '2023-11-17', 'Emergency',  4100.00, 3690.00,  410.00, 'Recovered'),
(34, 18, 3,  8,  8, '2023-11-22', '2023-12-05', 'Elective',  13700.00,12330.00, 1370.00, 'Recovered'),
(35, 20, 5, 15, 15, '2023-12-01', '2023-12-03', 'Emergency',  3200.00, 2880.00,  320.00, 'Recovered'),
(36,  4, 2,  4,  4, '2023-12-05', '2023-12-06', 'Emergency',  2500.00,    0.00, 2500.00, 'Recovered'),
(37,  7, 3,  7,  7, '2023-12-10', '2023-12-12', 'Emergency',  3600.00, 3240.00,  360.00, 'Recovered'),
(38, 21, 1,  3,  3, '2024-01-08', '2024-01-22', 'Urgent',    38000.00,34200.00, 3800.00, 'Recovered'),
(39, 22, 2,  5,  5, '2024-01-15', '2024-01-22', 'Elective',  14200.00,12780.00, 1420.00, 'Recovered'),
(40, 23, 3,  8,  8, '2024-01-20', '2024-02-01', 'Urgent',    16500.00,14850.00, 1650.00, 'Recovered'),
(41, 24, 4, 10, 10, '2024-02-01', '2024-02-11', 'Urgent',    23000.00,    0.00,23000.00, 'Recovered'),
(42, 25, 5, 14, 14, '2024-02-10', '2024-02-18', 'Elective',  11800.00,10620.00, 1180.00, 'Recovered'),
(43,  1, 1,  1,  2, '2024-02-20', '2024-03-02', 'Urgent',    19000.00,17100.00, 1900.00, 'Recovered'),
(44,  2, 1,  2,  1, '2024-03-05', '2024-03-07', 'Emergency',  4500.00, 4050.00,  450.00, 'Recovered'),
(45, 11, 4, 12, 12, '2024-03-15', '2024-03-28', 'Elective',  24000.00,19200.00, 4800.00, 'Recovered'),
(46, 19, 4, 11, 11, '2024-03-22', '2024-03-23', 'Emergency',  2700.00, 1890.00,  810.00, 'Recovered'),
(47,  5, 2,  4,  4, '2024-04-01', '2024-04-02', 'Emergency',  3100.00, 2170.00,  930.00, 'Recovered'),
(48, 13, 5, 13, 13, '2024-04-10', '2024-04-18', 'Elective',  14700.00,13230.00, 1470.00, 'Recovered'),
(49,  9, 3,  9,  9, '2024-04-20', '2024-04-23', 'Urgent',     7200.00, 6480.00,  720.00, 'Recovered'),
(50, 17, 2,  6,  6, '2024-05-01', '2024-05-08', 'Elective',  11500.00,10350.00, 1150.00, 'Recovered'),
(51,  3, 1,  3,  3, '2024-05-10', '2024-06-01', 'Urgent',    52000.00,46800.00, 5200.00, 'Deceased'),
(52, 15, 5, 15, 15, '2024-05-18', '2024-05-20', 'Emergency',  3400.00, 2720.00,  680.00, 'Recovered'),
(53, 20, 5, 14, 14, '2024-06-01', '2024-06-09', 'Urgent',     9800.00, 8820.00,  980.00, 'Recovered'),
(54, 23, 3,  8,  8, '2024-06-10', '2024-06-22', 'Elective',  15300.00,13770.00, 1530.00, 'Recovered'),
(55, 25, 5, 15, 15, '2024-06-20', '2024-06-22', 'Emergency',  4800.00, 4320.00,  480.00, 'Recovered'),
(56,  6, 2,  5,  5, '2024-07-01', '2024-07-10', 'Urgent',    13600.00,    0.00,13600.00, 'Recovered'),
(57, 10, 4, 10, 10, '2024-07-08', '2024-07-18', 'Elective',  21500.00,19350.00, 2150.00, 'Recovered'),
(58, 14, 5, 13, 13, '2024-07-15', '2024-07-22', 'Urgent',     9300.00,    0.00, 9300.00, 'Recovered'),
(59, 16, 1,  1,  2, '2024-07-22', '2024-08-03', 'Elective',  26500.00,23850.00, 2650.00, 'Recovered'),
(60, 24, 4, 12, 12, '2024-08-01', '2024-08-14', 'Urgent',    18200.00,    0.00,18200.00, 'Transferred');

-- ---- MEDICATIONS ----
INSERT INTO medications VALUES
( 1, 'Lisinopril',      'Lisinopril',       'ACE Inhibitor',    0.85,  1),
( 2, 'Metformin',       'Metformin HCl',    'Antidiabetic',     0.45,  1),
( 3, 'Atorvastatin',    'Atorvastatin',     'Statin',           1.20,  1),
( 4, 'Amoxicillin',     'Amoxicillin',      'Antibiotic',       0.60,  1),
( 5, 'Omeprazole',      'Omeprazole',       'Antacid/PPI',      0.90,  1),
( 6, 'Amlodipine',      'Amlodipine',       'Calcium Blocker',  1.10,  1),
( 7, 'Losartan',        'Losartan',         'ARB',              1.30,  1),
( 8, 'Albuterol',       'Salbutamol',       'Bronchodilator',   2.50,  1),
( 9, 'Ibuprofen',       'Ibuprofen',        'NSAID',            0.20,  0),
(10, 'Acetaminophen',   'Paracetamol',      'Analgesic',        0.15,  0),
(11, 'Warfarin',        'Warfarin',         'Anticoagulant',    1.80,  1),
(12, 'Furosemide',      'Furosemide',       'Diuretic',         0.40,  1),
(13, 'Prednisone',      'Prednisone',       'Corticosteroid',   0.55,  1),
(14, 'Metoprolol',      'Metoprolol',       'Beta Blocker',     0.75,  1),
(15, 'Gabapentin',      'Gabapentin',       'Anticonvulsant',   1.95,  1),
(16, 'Hydrocodone',     'Hydrocodone',      'Opioid Analgesic', 3.20,  1),
(17, 'Ciprofloxacin',   'Ciprofloxacin',    'Antibiotic',       1.50,  1),
(18, 'Insulin Glargine','Insulin Glargine', 'Insulin',         12.00,  1),
(19, 'Clopidogrel',     'Clopidogrel',      'Antiplatelet',     2.80,  1),
(20, 'Doxorubicin',     'Doxorubicin',      'Chemotherapy',    85.00,  1);

-- ---- DIAGNOSES ----
INSERT INTO diagnoses VALUES
( 1,  1, 'J18.9', 'Community-Acquired Pneumonia',       'Moderate', 1),
( 2,  2, 'I21.9', 'Acute Myocardial Infarction',        'Severe',   1),
( 3,  2, 'I10',   'Essential Hypertension',             'Moderate', 0),
( 4,  3, 'C50.9', 'Malignant Neoplasm of Breast',       'Severe',   1),
( 5,  4, 'S72.0', 'Femoral Neck Fracture',              'Moderate', 1),
( 6,  5, 'G35',   'Multiple Sclerosis',                 'Moderate', 1),
( 7,  6, 'M17.1', 'Knee Osteoarthritis',                'Moderate', 1),
( 8,  7, 'J06.9', 'Acute Upper Respiratory Infection',  'Mild',     1),
( 9,  8, 'E11.9', 'Type 2 Diabetes Mellitus',           'Moderate', 1),
(10,  8, 'I10',   'Essential Hypertension',             'Mild',     0),
(11,  9, 'N39.0', 'Urinary Tract Infection',            'Mild',     1),
(12, 10, 'I50.9', 'Heart Failure, Unspecified',         'Severe',   1),
(13, 10, 'I10',   'Essential Hypertension',             'Moderate', 0),
(14, 11, 'J44.1', 'COPD with Acute Exacerbation',       'Severe',   1),
(15, 12, 'R07.9', 'Chest Pain, Unspecified',            'Moderate', 1),
(16, 13, 'M17.1', 'Knee Osteoarthritis',                'Moderate', 1),
(17, 14, 'G43.9', 'Migraine, Unspecified',              'Moderate', 1),
(18, 15, 'A09',   'Infectious Gastroenteritis',         'Mild',     1),
(19, 16, 'I21.9', 'Acute Myocardial Infarction',        'Critical', 1),
(20, 17, 'G35',   'Multiple Sclerosis',                 'Moderate', 1),
(21, 18, 'E11.9', 'Type 2 Diabetes Mellitus',           'Moderate', 1),
(22, 18, 'N18.3', 'Chronic Kidney Disease Stage 3',     'Moderate', 0),
(23, 19, 'I50.9', 'Heart Failure, Unspecified',         'Severe',   1),
(24, 20, 'M17.1', 'Knee Osteoarthritis',                'Mild',     1),
(25, 21, 'J18.9', 'Community-Acquired Pneumonia',       'Moderate', 1),
(26, 22, 'C50.9', 'Malignant Neoplasm of Breast',       'Critical', 1),
(27, 23, 'N39.0', 'Urinary Tract Infection',            'Mild',     1),
(28, 24, 'N39.0', 'Urinary Tract Infection',            'Moderate', 1),
(29, 25, 'J44.1', 'COPD with Acute Exacerbation',       'Severe',   1),
(30, 26, 'G43.9', 'Migraine, Unspecified',              'Moderate', 1),
(31, 27, 'I21.9', 'Acute Myocardial Infarction',        'Severe',   1),
(32, 28, 'M17.1', 'Knee Osteoarthritis',                'Severe',   1),
(33, 29, 'J06.9', 'Acute Upper Respiratory Infection',  'Mild',     1),
(34, 30, 'R07.9', 'Chest Pain, Unspecified',            'Moderate', 1),
(35, 31, 'I50.9', 'Heart Failure, Unspecified',         'Severe',   1),
(36, 32, 'S72.0', 'Femoral Neck Fracture',              'Severe',   1),
(37, 33, 'J18.9', 'Community-Acquired Pneumonia',       'Moderate', 1),
(38, 34, 'E11.9', 'Type 2 Diabetes Mellitus',           'Moderate', 1),
(39, 35, 'A09',   'Infectious Gastroenteritis',         'Mild',     1),
(40, 36, 'R07.9', 'Chest Pain, Unspecified',            'Mild',     1),
(41, 37, 'J06.9', 'Acute Upper Respiratory Infection',  'Mild',     1),
(42, 38, 'C50.9', 'Malignant Neoplasm of Breast',       'Severe',   1),
(43, 39, 'G35',   'Multiple Sclerosis',                 'Moderate', 1),
(44, 40, 'E11.9', 'Type 2 Diabetes Mellitus',           'Severe',   1),
(45, 41, 'I50.9', 'Heart Failure, Unspecified',         'Critical', 1),
(46, 42, 'G43.9', 'Migraine, Unspecified',              'Moderate', 1),
(47, 43, 'I21.9', 'Acute Myocardial Infarction',        'Severe',   1),
(48, 44, 'J18.9', 'Community-Acquired Pneumonia',       'Moderate', 1),
(49, 45, 'J44.1', 'COPD with Acute Exacerbation',       'Critical', 1),
(50, 46, 'R07.9', 'Chest Pain, Unspecified',            'Moderate', 1),
(51, 47, 'N39.0', 'Urinary Tract Infection',            'Mild',     1),
(52, 48, 'M17.1', 'Knee Osteoarthritis',                'Moderate', 1),
(53, 49, 'N39.0', 'Urinary Tract Infection',            'Moderate', 1),
(54, 50, 'M17.1', 'Knee Osteoarthritis',                'Moderate', 1),
(55, 51, 'C50.9', 'Malignant Neoplasm of Breast',       'Critical', 1),
(56, 52, 'A09',   'Infectious Gastroenteritis',         'Mild',     1),
(57, 53, 'G43.9', 'Migraine, Unspecified',              'Moderate', 1),
(58, 54, 'E11.9', 'Type 2 Diabetes Mellitus',           'Moderate', 1),
(59, 55, 'N39.0', 'Urinary Tract Infection',            'Mild',     1),
(60, 56, 'G35',   'Multiple Sclerosis',                 'Severe',   1),
(61, 57, 'I50.9', 'Heart Failure, Unspecified',         'Severe',   1),
(62, 58, 'S72.0', 'Femoral Neck Fracture',              'Moderate', 1),
(63, 59, 'I21.9', 'Acute Myocardial Infarction',        'Critical', 1),
(64, 60, 'J44.1', 'COPD with Acute Exacerbation',       'Severe',   1),
(65, 60, 'E11.9', 'Type 2 Diabetes Mellitus',           'Moderate', 0);

-- ---- PRESCRIPTIONS ----
INSERT INTO prescriptions VALUES
( 1,  1,  4,  2, '2023-01-05', '500mg',    7, 14,    8.40),
( 2,  1, 10,  2, '2023-01-05', '500mg',    5, 10,    1.50),
( 3,  2, 14,  1, '2023-01-10', '50mg',    30, 30,   22.50),
( 4,  2, 19,  1, '2023-01-10', '75mg',    90, 90,  252.00),
( 5,  2, 11,  1, '2023-01-10', '5mg',     90, 90,  162.00),
( 6,  3, 20,  3, '2023-02-01', '60mg/m2', 21,  3, 15300.00),
( 7,  4,  9,  5, '2023-02-14', '400mg',    5, 10,    2.00),
( 8,  5, 15,  4, '2023-02-20', '300mg',   30, 30,   58.50),
( 9,  6,  9,  6, '2023-03-05', '400mg',    7, 14,    2.80),
(10,  6, 16,  6, '2023-03-05', '5/325mg',  7, 14,   44.80),
(11,  7, 10,  7, '2023-03-12', '250mg',    5, 10,    1.50),
(12,  7,  4,  7, '2023-03-12', '250mg',    5, 10,    6.00),
(13,  8,  2,  8, '2023-03-22', '500mg',   30, 30,   13.50),
(14,  8,  1,  8, '2023-03-22', '10mg',    30, 30,   25.50),
(15,  9, 17,  9, '2023-04-08', '500mg',    7, 14,   21.00),
(16, 10, 14, 10, '2023-04-15', '25mg',    30, 30,   22.50),
(17, 10, 12, 10, '2023-04-15', '40mg',    30, 30,   12.00),
(18, 10, 11, 10, '2023-04-15', '2mg',     30, 30,   54.00),
(19, 11,  8, 12, '2023-04-20', '90mcg',   30, 60,  150.00),
(20, 11, 13, 12, '2023-04-20', '10mg',    10, 10,    5.50),
(21, 12,  9, 11, '2023-05-01', '400mg',    3,  6,    1.20),
(22, 13,  9,  6, '2023-05-10', '400mg',    7, 14,    2.80),
(23, 13, 16, 13, '2023-05-10', '5/325mg', 10, 20,   64.00),
(24, 14, 15, 14, '2023-05-15', '300mg',   30, 30,   58.50),
(25, 15,  4,  9, '2023-06-01', '500mg',    7, 14,    8.40),
(26, 16, 14,  1, '2023-06-10', '50mg',    30, 30,   22.50),
(27, 16, 19,  1, '2023-06-10', '75mg',    90, 90,  252.00),
(28, 17, 15,  4, '2023-06-18', '300mg',   30, 30,   58.50),
(29, 18,  2,  8, '2023-07-03', '1000mg',  30, 30,   13.50),
(30, 18, 18,  8, '2023-07-03', '20u',     30, 30,  360.00),
(31, 19, 12, 10, '2023-07-10', '40mg',    30, 30,   12.00),
(32, 19, 14, 10, '2023-07-10', '25mg',    30, 30,   22.50),
(33, 20,  9, 13, '2023-07-22', '400mg',    5, 10,    2.00),
(34, 21,  4,  2, '2023-08-05', '500mg',    7, 14,    8.40),
(35, 22, 20,  3, '2023-08-14', '60mg/m2', 21,  3, 15300.00),
(36, 23, 10,  5, '2023-08-20', '500mg',    3,  6,    0.90),
(37, 24, 17,  9, '2023-09-01', '500mg',    7, 14,   21.00),
(38, 25,  8, 12, '2023-09-12', '90mcg',   30, 60,  150.00),
(39, 26, 15, 14, '2023-09-20', '300mg',   30, 30,   58.50),
(40, 27, 19,  1, '2023-10-01', '75mg',    90, 90,  252.00),
(41, 27, 14,  1, '2023-10-01', '25mg',    30, 30,   22.50),
(42, 28,  9,  6, '2023-10-10', '400mg',    7, 14,    2.80),
(43, 29, 10,  7, '2023-10-15', '250mg',    5, 10,    1.50),
(44, 30,  9, 11, '2023-10-22', '400mg',    3,  6,    1.20),
(45, 31, 12, 10, '2023-11-01', '40mg',    30, 30,   12.00),
(46, 31, 11, 10, '2023-11-01', '5mg',     30, 30,   54.00),
(47, 32,  9, 13, '2023-11-08', '400mg',    7, 14,    2.80),
(48, 32, 16, 13, '2023-11-08', '5/325mg', 14, 28,   89.60),
(49, 33,  4,  2, '2023-11-15', '500mg',    7, 14,    8.40),
(50, 34,  2,  8, '2023-11-22', '500mg',   30, 30,   13.50),
(51, 34, 18,  8, '2023-11-22', '20u',     30, 30,  360.00),
(52, 35, 10,  9, '2023-12-01', '500mg',    3,  6,    0.90),
(53, 36,  9,  4, '2023-12-05', '400mg',    3,  6,    1.20),
(54, 37, 10,  7, '2023-12-10', '250mg',    5, 10,    1.50),
(55, 38, 20,  3, '2024-01-08', '60mg/m2', 21,  3, 15300.00),
(56, 39, 15,  4, '2024-01-15', '300mg',   30, 30,   58.50),
(57, 40,  2,  8, '2024-01-20', '1000mg',  30, 30,   13.50),
(58, 40, 18,  8, '2024-01-20', '20u',     30, 30,  360.00),
(59, 41, 12, 10, '2024-02-01', '40mg',    30, 30,   12.00),
(60, 41, 14, 10, '2024-02-01', '25mg',    30, 30,   22.50),
(61, 42, 15, 14, '2024-02-10', '300mg',   30, 30,   58.50),
(62, 43, 19,  1, '2024-02-20', '75mg',    90, 90,  252.00),
(63, 43, 14,  1, '2024-02-20', '50mg',    30, 30,   22.50),
(64, 44,  4,  2, '2024-03-05', '500mg',    7, 14,    8.40),
(65, 44, 10,  2, '2024-03-05', '500mg',    5, 10,    1.50),
(66, 45,  8, 12, '2024-03-15', '90mcg',   30, 60,  150.00),
(67, 45, 13, 12, '2024-03-15', '10mg',    10, 10,    5.50),
(68, 46,  9, 11, '2024-03-22', '400mg',    3,  6,    1.20),
(69, 47, 17,  4, '2024-04-01', '500mg',    7, 14,   21.00),
(70, 48,  9, 13, '2024-04-10', '400mg',    7, 14,    2.80),
(71, 49, 17,  9, '2024-04-20', '500mg',    7, 14,   21.00),
(72, 50,  9,  6, '2024-05-01', '400mg',    7, 14,    2.80),
(73, 50, 16,  6, '2024-05-01', '5/325mg', 10, 20,   64.00),
(74, 51, 20,  3, '2024-05-10', '60mg/m2', 21,  3, 15300.00),
(75, 52, 10,  9, '2024-05-18', '500mg',    3,  6,    0.90),
(76, 53, 15, 14, '2024-06-01', '300mg',   30, 30,   58.50),
(77, 54,  2,  8, '2024-06-10', '1000mg',  30, 30,   13.50),
(78, 54, 18,  8, '2024-06-10', '20u',     30, 30,  360.00),
(79, 55, 17,  9, '2024-06-20', '500mg',    7, 14,   21.00),
(80, 56, 15,  4, '2024-07-01', '300mg',   30, 30,   58.50),
(81, 57, 14, 10, '2024-07-08', '25mg',    30, 30,   22.50),
(82, 57, 12, 10, '2024-07-08', '40mg',    30, 30,   12.00),
(83, 58,  9, 13, '2024-07-15', '400mg',    7, 14,    2.80),
(84, 58, 16, 13, '2024-07-15', '5/325mg', 14, 28,   89.60),
(85, 59, 19,  1, '2024-07-22', '75mg',    90, 90,  252.00),
(86, 59, 14,  1, '2024-07-22', '50mg',    30, 30,   22.50),
(87, 59, 11,  1, '2024-07-22', '5mg',     30, 30,   54.00),
(88, 60,  8, 12, '2024-08-01', '90mcg',   30, 60,  150.00),
(89, 60,  2, 12, '2024-08-01', '1000mg',  30, 30,   13.50),
(90, 60, 18, 12, '2024-08-01', '20u',     30, 30,  360.00);


-- ============================================================
-- PART 3: ANALYTICAL QUERIES
-- ============================================================

-- ============================================================
-- LEVEL 1 — BASIC: SELECT, WHERE, JOIN, GROUP BY, ORDER BY
-- ============================================================

-- Q1: Full patient list with insurance type
SELECT
    patient_id,
    first_name || ' ' || last_name AS full_name,
    gender,
    date_of_birth,
    insurance_type
FROM patients
ORDER BY last_name;

-- Q2: Total admissions and average cost by admission type
SELECT
    admission_type,
    COUNT(*) AS total_admissions,
    ROUND(AVG(total_cost), 2) AS avg_cost
FROM admissions
GROUP BY admission_type
ORDER BY total_admissions DESC;

-- Q3: Hospitals ranked by number of beds (largest first)
SELECT
    hospital_name,
    city,
    state,
    hospital_type,
    bed_count
FROM hospitals
ORDER BY bed_count DESC;

-- Q4: Most frequent diagnoses with count of critical cases
SELECT
    diagnosis_name,
    icd_code,
    COUNT(*) AS total_cases,
    COUNT(CASE WHEN severity = 'Critical' THEN 1 END) AS critical_cases
FROM diagnoses
GROUP BY diagnosis_name, icd_code
ORDER BY total_cases DESC;

-- Q5: Most prescribed medications with total revenue generated
SELECT
    m.medication_name,
    m.category,
    m.unit_cost,
    COUNT(p.prescription_id) AS times_prescribed,
    ROUND(SUM(p.total_cost), 2) AS total_revenue
FROM medications m
JOIN prescriptions p ON m.medication_id = p.medication_id
GROUP BY m.medication_name, m.category, m.unit_cost
ORDER BY times_prescribed DESC;

-- Q6: Patients admitted through the Emergency department
SELECT DISTINCT
    pa.first_name || ' ' || pa.last_name AS patient_name,
    pa.insurance_type,
    h.hospital_name,
    a.admission_date,
    a.total_cost
FROM patients pa
JOIN admissions a ON pa.patient_id = a.patient_id
JOIN hospitals h  ON a.hospital_id = h.hospital_id
WHERE a.admission_type = 'Emergency'
ORDER BY a.admission_date;


-- ============================================================
-- LEVEL 2 — INTERMEDIATE: CTEs, SUBQUERIES, CASE WHEN, HAVING
-- ============================================================

-- Q7: Average cost per hospital with cost category classification
SELECT
    h.hospital_name,
    h.hospital_type,
    COUNT(a.admission_id) AS total_admissions,
    ROUND(AVG(a.total_cost), 2) AS avg_cost_per_admission,
    ROUND(SUM(a.total_cost), 2) AS total_revenue,
    CASE
        WHEN AVG(a.total_cost) > 20000 THEN 'High Cost'
        WHEN AVG(a.total_cost) BETWEEN 10000 AND 20000 THEN 'Medium Cost'
        ELSE 'Low Cost'
    END AS cost_category
FROM hospitals h
JOIN admissions a ON h.hospital_id = a.hospital_id
GROUP BY h.hospital_name, h.hospital_type
ORDER BY total_revenue DESC;

-- Q8: Returning patients (more than one admission) with lifetime cost
SELECT
    pa.first_name || ' ' || pa.last_name AS patient_name,
    pa.insurance_type,
    COUNT(a.admission_id) AS num_admissions,
    ROUND(SUM(a.total_cost), 2) AS lifetime_cost,
    ROUND(AVG(a.total_cost), 2) AS avg_cost_per_visit
FROM patients pa
JOIN admissions a ON pa.patient_id = a.patient_id
GROUP BY pa.patient_id, pa.first_name, pa.last_name, pa.insurance_type
HAVING COUNT(a.admission_id) > 1
ORDER BY num_admissions DESC, lifetime_cost DESC;

-- Q9: CTE — Insurance coverage analysis by admission
WITH insurance_coverage AS (
    SELECT
        a.admission_id,
        pa.insurance_type,
        a.total_cost,
        a.insurance_covered,
        a.patient_paid,
        ROUND((a.insurance_covered / NULLIF(a.total_cost, 0)) * 100, 1) AS coverage_pct
    FROM admissions a
    JOIN patients pa ON a.patient_id = pa.patient_id
)
SELECT
    insurance_type,
    COUNT(*) AS total_cases,
    ROUND(AVG(total_cost), 2) AS avg_total_cost,
    ROUND(AVG(insurance_covered), 2) AS avg_covered,
    ROUND(AVG(patient_paid), 2) AS avg_out_of_pocket,
    ROUND(AVG(coverage_pct), 1) AS avg_coverage_pct
FROM insurance_coverage
GROUP BY insurance_type
ORDER BY avg_coverage_pct DESC;

-- Q10: CTE — Top 10 doctors by total prescription cost
WITH doctor_prescriptions AS (
    SELECT
        d.doctor_id,
        d.first_name || ' ' || d.last_name AS doctor_name,
        d.specialty,
        h.hospital_name,
        COUNT(p.prescription_id) AS total_prescriptions,
        ROUND(SUM(p.total_cost), 2) AS total_prescribed_cost
    FROM doctors d
    JOIN prescriptions p ON d.doctor_id = p.doctor_id
    JOIN hospitals h ON d.hospital_id = h.hospital_id
    GROUP BY d.doctor_id, doctor_name, d.specialty, h.hospital_name
)
SELECT *
FROM doctor_prescriptions
ORDER BY total_prescribed_cost DESC
LIMIT 10;

-- Q11: Subquery — Patients with admission costs above the overall average
SELECT
    pa.first_name || ' ' || pa.last_name AS patient_name,
    pa.insurance_type,
    h.hospital_name,
    a.admission_type,
    a.total_cost,
    ROUND(a.total_cost - (SELECT AVG(total_cost) FROM admissions), 2) AS above_avg_by
FROM admissions a
JOIN patients pa ON a.patient_id  = pa.patient_id
JOIN hospitals h ON a.hospital_id = h.hospital_id
WHERE a.total_cost > (SELECT AVG(total_cost) FROM admissions)
ORDER BY a.total_cost DESC;

-- Q12: Diagnosis severity distribution by hospital (with % share)
SELECT
    h.hospital_name,
    d.severity,
    COUNT(*) AS case_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY h.hospital_name), 1) AS pct_of_hospital
FROM hospitals h
JOIN admissions a ON h.hospital_id  = a.hospital_id
JOIN diagnoses d  ON a.admission_id = d.admission_id
WHERE d.is_primary = 1
GROUP BY h.hospital_name, d.severity
ORDER BY h.hospital_name,
    CASE d.severity
        WHEN 'Critical' THEN 1
        WHEN 'Severe'   THEN 2
        WHEN 'Moderate' THEN 3
        ELSE 4
    END;

-- Q13: Most expensive medication categories by total spend
SELECT
    m.category,
    COUNT(DISTINCT m.medication_id) AS unique_medications,
    COUNT(p.prescription_id) AS times_prescribed,
    ROUND(SUM(p.total_cost), 2) AS total_cost,
    ROUND(AVG(p.total_cost), 2) AS avg_cost_per_prescription
FROM medications m
JOIN prescriptions p ON m.medication_id = p.medication_id
GROUP BY m.category
HAVING COUNT(p.prescription_id) > 1
ORDER BY total_cost DESC;


-- ============================================================
-- LEVEL 3 — ADVANCED: WINDOW FUNCTIONS, LAG, RANKINGS
-- ============================================================

-- Q14: Hospital ranking by total revenue and admission volume
SELECT
    h.hospital_name,
    h.hospital_type,
    COUNT(a.admission_id) AS total_admissions,
    ROUND(SUM(a.total_cost), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(a.total_cost) DESC)          AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY COUNT(a.admission_id) DESC) AS volume_rank
FROM hospitals h
JOIN admissions a ON h.hospital_id = a.hospital_id
GROUP BY h.hospital_name, h.hospital_type;

-- Q15: Length of stay per patient grouped into quartiles by hospital (NTILE)
SELECT
    h.hospital_name,
    pa.first_name || ' ' || pa.last_name AS patient_name,
    a.admission_type,
    (julianday(a.discharge_date) - julianday(a.admission_date)) AS stay_days,
    a.total_cost,
    NTILE(4) OVER (
        PARTITION BY h.hospital_id
        ORDER BY (julianday(a.discharge_date) - julianday(a.admission_date))
    ) AS stay_quartile
FROM admissions a
JOIN hospitals h ON a.hospital_id = h.hospital_id
JOIN patients pa ON a.patient_id  = pa.patient_id
WHERE a.discharge_date IS NOT NULL
ORDER BY h.hospital_name, stay_days DESC;

-- Q16: Monthly admission trend with month-over-month change (LAG)
WITH monthly_admissions AS (
    SELECT
        strftime('%Y-%m', admission_date) AS month,
        COUNT(*) AS total_admissions,
        ROUND(SUM(total_cost), 2) AS total_revenue
    FROM admissions
    GROUP BY strftime('%Y-%m', admission_date)
)
SELECT
    month,
    total_admissions,
    total_revenue,
    LAG(total_admissions) OVER (ORDER BY month) AS prev_month_admissions,
    total_admissions - LAG(total_admissions) OVER (ORDER BY month) AS admissions_change,
    ROUND(
        (total_admissions - LAG(total_admissions) OVER (ORDER BY month)) * 100.0
        / NULLIF(LAG(total_admissions) OVER (ORDER BY month), 0),
    1) AS pct_change
FROM monthly_admissions
ORDER BY month;

-- Q17: Top 3 most expensive diagnoses per hospital (ROW_NUMBER)
WITH diagnosis_costs AS (
    SELECT
        h.hospital_name,
        diag.diagnosis_name,
        COUNT(*) AS cases,
        ROUND(AVG(a.total_cost), 2) AS avg_admission_cost,
        ROW_NUMBER() OVER (
            PARTITION BY h.hospital_id
            ORDER BY AVG(a.total_cost) DESC
        ) AS rank_within_hospital
    FROM hospitals h
    JOIN admissions a   ON h.hospital_id  = a.hospital_id
    JOIN diagnoses diag ON a.admission_id = diag.admission_id
    WHERE diag.is_primary = 1
    GROUP BY h.hospital_name, h.hospital_id, diag.diagnosis_name
)
SELECT hospital_name, diagnosis_name, cases, avg_admission_cost, rank_within_hospital
FROM diagnosis_costs
WHERE rank_within_hospital <= 3
ORDER BY hospital_name, rank_within_hospital;

-- Q18: Cumulative prescription cost per patient over time (SUM OVER)
WITH patient_prescriptions AS (
    SELECT
        pa.first_name || ' ' || pa.last_name AS patient_name,
        pr.prescribed_date,
        m.medication_name,
        m.category,
        pr.total_cost,
        SUM(pr.total_cost) OVER (
            PARTITION BY pa.patient_id
            ORDER BY pr.prescribed_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_rx_cost
    FROM prescriptions pr
    JOIN admissions a  ON pr.admission_id  = a.admission_id
    JOIN patients pa   ON a.patient_id     = pa.patient_id
    JOIN medications m ON pr.medication_id = m.medication_id
)
SELECT *
FROM patient_prescriptions
ORDER BY patient_name, prescribed_date;

-- Q19: Most cost-efficient doctors with high recovery rates
WITH doctor_performance AS (
    SELECT
        d.first_name || ' ' || d.last_name AS doctor_name,
        d.specialty,
        h.hospital_name,
        d.years_experience,
        COUNT(a.admission_id) AS total_patients,
        ROUND(AVG(a.total_cost), 2) AS avg_cost,
        ROUND(AVG(julianday(a.discharge_date) - julianday(a.admission_date)), 1) AS avg_stay_days,
        SUM(CASE WHEN a.outcome = 'Recovered' THEN 1 ELSE 0 END) AS recovered_count,
        ROUND(
            SUM(CASE WHEN a.outcome = 'Recovered' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1
        ) AS recovery_rate_pct
    FROM doctors d
    JOIN admissions a ON d.doctor_id   = a.doctor_id
    JOIN hospitals h  ON d.hospital_id = h.hospital_id
    WHERE a.discharge_date IS NOT NULL
    GROUP BY d.doctor_id, doctor_name, d.specialty, h.hospital_name, d.years_experience
    HAVING COUNT(a.admission_id) >= 2
)
SELECT
    doctor_name,
    specialty,
    hospital_name,
    years_experience,
    total_patients,
    avg_cost,
    avg_stay_days,
    recovery_rate_pct,
    RANK() OVER (ORDER BY avg_cost ASC) AS cost_efficiency_rank
FROM doctor_performance
ORDER BY cost_efficiency_rank;

-- Q20: Executive summary — Key Performance Indicators (KPIs) for the health system
WITH summary AS (
    SELECT
        COUNT(DISTINCT h.hospital_id)  AS total_hospitals,
        COUNT(DISTINCT pa.patient_id)  AS total_patients,
        COUNT(DISTINCT a.admission_id) AS total_admissions,
        ROUND(SUM(a.total_cost), 2)    AS total_system_revenue,
        ROUND(AVG(a.total_cost), 2)    AS avg_admission_cost,
        ROUND(AVG(julianday(a.discharge_date) - julianday(a.admission_date)), 1) AS avg_length_of_stay,
        SUM(CASE WHEN a.outcome = 'Recovered' THEN 1 ELSE 0 END) AS recovered,
        SUM(CASE WHEN a.outcome = 'Deceased'  THEN 1 ELSE 0 END) AS deceased,
        COUNT(DISTINCT pr.prescription_id) AS total_prescriptions,
        ROUND(SUM(pr.total_cost), 2) AS total_rx_cost
    FROM hospitals h
    LEFT JOIN admissions a     ON h.hospital_id  = a.hospital_id
    LEFT JOIN patients pa      ON a.patient_id   = pa.patient_id
    LEFT JOIN prescriptions pr ON a.admission_id = pr.admission_id
    WHERE a.discharge_date IS NOT NULL
)
SELECT
    total_hospitals,
    total_patients,
    total_admissions,
    total_system_revenue,
    avg_admission_cost,
    avg_length_of_stay || ' days' AS avg_los,
    recovered,
    deceased,
    ROUND(recovered * 100.0 / (recovered + deceased), 1) || '%' AS recovery_rate,
    total_prescriptions,
    total_rx_cost
FROM summary;
