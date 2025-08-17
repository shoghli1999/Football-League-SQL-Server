# Football League Database Management System

## Project Overview

This project is a comprehensive database management system designed for the Iranian Football League, developed as part of a Database Design course in 2021. The system demonstrates relational database design principles, SQL Server implementation, and data management best practices.

## Project Details

- **Course**: Database Design 2021
- **Institution**: Bachelor's Program - Islamic Azad University south tehran branch
- **Technology Stack**: Microsoft SQL Server
- **Focus**: Relational database design and implementation for football league management

## Key Features

- **Relational Database Design**: Complete database schema with proper relationships
- **SQL Server Implementation**: Full database implementation using Microsoft SQL Server
- **ERD Diagram**: Visual representation of database structure and relationships
- **Data Collection & Cleaning**: Comprehensive data gathering and preprocessing
- **Table Insertion**: Complete data population with real football league information

## File Structure & Description

### Database Files

#### `databaseProject.mdf` (5.0MB)
- **Purpose**: Main SQL Server database file
- **Description**: Contains all the database tables, stored procedures, views, and data for the football league system
- **Usage**: Primary database file that can be attached to SQL Server Management Studio

#### `databaseProject_log.ldf` (2.0MB)
- **Purpose**: SQL Server transaction log file
- **Description**: Records all database transactions and changes for recovery and consistency
- **Usage**: Automatically managed by SQL Server for data integrity

#### `databaseProject.zip` (2.6MB)
- **Purpose**: Compressed version of the database
- **Description**: Zipped archive containing the database files for easy distribution and backup
- **Usage**: Can be extracted to restore the database on another system

### Design Documentation

#### `erd.pdf` (316KB)
- **Purpose**: Entity Relationship Diagram in PDF format
- **Description**: Visual representation of the database schema showing tables, attributes, and relationships
- **Contents**: 
  - Table structures
  - Primary and foreign key relationships
  - Data types and constraints
  - Cardinality between entities

#### `erd.vsdx` (140KB)
- **Purpose**: Source file for the Entity Relationship Diagram
- **Description**: Microsoft Visio file containing the editable ERD diagram
- **Usage**: Can be opened in Microsoft Visio for modifications or additional documentation

### Data Export Files

#### `database export.pdf` (238KB)
- **Purpose**: Database content exported to PDF format
- **Description**: Contains exported data from all database tables in a readable format
- **Contents**: 
  - Team information
  - Player data
  - Match results
  - League standings
  - Statistics and performance metrics

#### `database export.xlsx` (60KB)
- **Purpose**: Database content exported to Excel format
- **Description**: Spreadsheet format of the database data for analysis and reporting
- **Usage**: Can be used for data analysis, reporting, or integration with other tools

### Project Documentation

#### `shirin shoghli 9625512123.pdf` (1.6MB)
- **Purpose**: Comprehensive project documentation
- **Description**: Detailed project report including methodology, implementation details, and results
- **Contents**: 
  - Project objectives and scope
  - Database design methodology
  - Implementation process
  - Data collection and cleaning procedures
  - Results and analysis
  - Conclusions and recommendations

## Database Schema Overview

The database likely includes the following main entities:

### Core Tables
- **Teams**: Team information, history, and statistics
- **Players**: Player profiles, performance data, and career information
- **Matches**: Game results, scores, and match details
- **Leagues**: League structure and season information
- **Stadiums**: Venue information and capacity data

### Supporting Tables
- **Coaches**: Manager and coaching staff information
- **Referees**: Match official data
- **Statistics**: Performance metrics and analytics
- **Schedules**: Fixture and calendar information

## Getting Started

### Prerequisites
- Microsoft SQL Server (2016 or later)
- SQL Server Management Studio (SSMS)
- Microsoft Visio (for viewing/editing ERD)

### Installation Steps
1. Extract `databaseProject.zip` if using the compressed version
2. Open SQL Server Management Studio
3. Attach the database using `databaseProject.mdf`
4. Review the ERD diagram in `erd.pdf` for database structure
5. Explore the data using the export files

### Data Analysis
- Use `database export.xlsx` for data analysis in Excel
- Review `database export.pdf` for formatted data presentation
- Reference `shirin shoghli 9625512123.pdf` for detailed project insights

## Technical Implementation

### Database Design Principles
- **Normalization**: Proper table normalization to eliminate redundancy
- **Referential Integrity**: Foreign key constraints for data consistency
- **Indexing**: Optimized query performance through strategic indexing
- **Constraints**: Data validation through check constraints and triggers

### Data Management
- **Data Collection**: Comprehensive gathering of football league information
- **Data Cleaning**: Preprocessing and validation of raw data
- **Data Insertion**: Systematic population of all database tables
- **Data Validation**: Verification of data integrity and consistency

## Project Outcomes

This project successfully demonstrates:
- Complete database lifecycle from design to implementation
- Real-world application of database management concepts
- Professional documentation and presentation skills
- Practical experience with SQL Server and database tools

## Author

**Shirin Shoghli** - Database Design Course Project (2021)

---

*This project serves as a comprehensive example of database design and implementation for sports league management systems.*
