# Blood Bank Management System

##  Introduction

The **Blood Bank Management System** is a MySQL-based project designed to streamline blood bank operations in healthcare systems. It provides an end-to-end solution for managing donors, blood inventory, testing, recipient requests, and logistics. The system incorporates context—such as city names and phone number formats—making it highly relevant for healthcare providers across the country.

---


##  Features

* Donor management with demographics and donation history
* Blood collection tracking by volume, method, and phlebotomist
* Inventory control including storage and expiration monitoring
* Recipient information and hospital blood request tracking
* Distribution logging with tracking numbers
* Blood testing and compliance storage
* Localized for Kenyan use (cities, phone formats)

---

##  Database Features

* Secure storage of donor and recipient data
* Real-time blood inventory tracking
* Automated expiration date calculation
* Donation eligibility tracking
* Blood test result storage
* Request fulfillment workflows
* Built-in reporting capabilities

---

##  Setup Instructions

### Prerequisites

* **MySQL Server** (version 8.0+ recommended)
* **MySQL Client** (Workbench, CLI, or other)

---

### Installation Options

####  Option 1: Using MySQL Workbench

1. Download & install MySQL Workbench.
2. Connect to your MySQL server.
3. Create a new schema:

   ```sql
   CREATE DATABASE blood_bank_management;
   ```
4. Open and run the provided SQL script using the lightning bolt icon or `Ctrl+Shift+Enter`.

#### 🔹 Option 2: Using Command Line

```bash
mysql -u [username] -p
CREATE DATABASE blood_bank_management;
USE blood_bank_management;
SOURCE /path/to/your_script.sql;
```

####  Option 3: Importing SQL File via Workbench

1. Save SQL script to a file.
2. Go to **Server → Data Import** in MySQL Workbench.
3. Choose **"Import from Self-Contained File"**.
4. Select your SQL file and target schema.
5. Start import.

---

##  Usage

Once installed, the database can be used to:

* Register new donors and patients
* Log and monitor blood collections
* Track stock availability and expiration
* Record test results
* Fulfill and track blood requests
* Generate regular usage and stock reports

---

##  Sample Queries Included

* List all active donors with last donation date
* Count donors grouped by blood type
* Find blood collections handled by each staff member
* View pending blood requests by hospital
* Track recent blood product distributions

---

## Maintenance

* Regularly back up the database to prevent data loss
* Use **views** for reusable reports
* Set up user roles and privileges for security and access control

---

## License

This project is **open-source** and freely available for adaptation to support blood banking in healthcare systems. No attribution required, but contributions and enhancements are welcome.

---



