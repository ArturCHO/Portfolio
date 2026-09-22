## Personal Finances Project

  The goal of the project is to create an automated system for processing, storing, and analyzing household financial data.
The project covers the entire data processing workflow—from retrieving transaction reports from the bank, through the automatic 
preparation and storage of data in an SQL database, to its visualization in an analytical report.

**Main project phases:**

- Manually download the monthly transaction report from the bank in CSV format. :white_check_mark:
- Automatically detect the downloaded report. :white_check_mark:
- Move the file to a dedicated archive folder. :white_check_mark:
- Standardizing the file name according to the following format: "Transaction History MM.YYYY". :white_check_mark:
- ETL and Data Preparation. :white_check_mark:

![Overview](Personal%20Finances/Overview.png)

- Automatic import of cleaned data into SQL Server.
- Designing a relational data model.
- Using a star schema to prepare data for reporting and analysis.
- Preparing a report for financial analysis.
- Automatically incorporating new transactions after each import.
