# healthcare-sql-analytics
A collection of SQL queries analyzing healthcare data

### Standard SQL Queries (standard_queries.sql)
Includes:
- Patient filtering
- Appointment reporting
- Billing analysis
- Ranking
- Insert, update, and delete DML operations

Queries: 1–3, 5-13, 15–19 

---

### CTE-Based Queries (ctes.sql)
Uses PostgreSQL CTE for:
- Summary statistics (AVG, MIN, MAX)
- Patient treatment reporting

Query: 14 , 4

---

### Stored Procedures (stored_procedures.sql)
Includes two PostgreSQL stored procedures:

- Add new doctor  
- Insert appointment with validation:
  - Ensures patient exists  
  - Ensures doctor exists  
  - Prevents invalid insertion

Queries: 20 and 21.

---


