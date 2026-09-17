# SQL Data Warehouse & Business Intelligence Project

A comprehensive end-to-end Data Warehousing and Analytics solution built using **Microsoft SQL Server**. This project demonstrates the implementation of a modern **Medallion Architecture** (Bronze, Silver, Gold), robust ETL/ELT pipelines, data cleansing frameworks, star schema dimensional modeling, and business analytics.

---

## Data Architecture

The architecture follows the industry-standard **Medallion Architecture** pattern to structure and process data progressively:

![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw ingested data as-is from disparate source systems (ERP and CRM CSV files) with no modifications.
2. **Silver Layer**: Performs data cleansing, standardization, null handling, structural normalization, and adds audit metadata (`dwh_create_date`) to ensure data integrity and traceability.
3. **Gold Layer**: Hosts business-ready data modeled into an optimized **Star Schema** (Fact and Dimension views/tables) designed specifically for high-performance analytical reporting and BI dashboards.

---

## Technical Highlights & Capabilities

- **Architecture Design**: Implementing multi-tier Medallion Architecture using SQL Server Schemas (`bronze`, `silver`, `gold`).
- **ETL/ELT Pipelines**: Extracting, transforming, and loading batch data with stored procedures and SQL DDL/DML scripts.
- **Data Quality & Cleansing**: Resolving dirty data, inconsistent text, trailing spaces, duplicate primary keys, and unifying formats (e.g., country ISO codes, customer demographics).
- **Dimensional Modeling**: Applying Kimball methodologies to construct a Star Schema with Conformed Dimensions and Fact tables.
- **Analytics & Reporting**: Writing advanced T-SQL queries (aggregations, window functions, CTEs) to extract business metrics for sales, product performance, and customer retention.

---

## Technologies & Tools

- **Database Engine**: Microsoft SQL Server
- **Query & Server Management**: SQL Server Management Studio (SSMS)
- **Version Control**: Git & GitHub
- **Diagramming & Architecture**: Draw.io

---

## Project Requirements & Implementation Scope

### 1. Data Engineering (Data Warehouse Build)
- **Data Ingestion**: Ingest raw datasets from two distinct business operational systems (CRM & ERP).
- **Data Cleansing**: Handle structural inconsistencies, deduplication via ranking window functions, and type casting.
- **Integration**: Merge customer and product entities across both sources into unified surrogate-keyed dimensions.
- **Auditability**: Add load timestamp tracking (`dwh_create_date`) across Silver and Gold entities.

### 2. Business Intelligence & Analytics
- **Customer Analysis**: Profiling customer segments, lifetime purchasing patterns, and geographical distributions.
- **Product Performance**: Tracking sales revenue, costs, margin contributions, and product categorization metrics.
- **Sales Trends**: Evaluating period-over-period performance and key sales performance indicators (KPIs).

---

## Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/                           # Raw datasets from source systems (ERP and CRM CSVs)
│
├── docs/                               # Technical specifications, architecture, and schema diagrams
│   ├── etl.drawio                      # Visual representation of the ETL pipeline
│   ├── data_architecture.drawio        # Medallion architecture diagram
│   ├── data_catalog.md                 # Data dictionary and metadata catalog
│   ├── data_flow.drawio                # End-to-end data lineage diagram
│   ├── data_models.drawio              # Dimensional model (Star Schema design)
│   └── naming-conventions.md           # Engineering guidelines for naming objects
│
├── scripts/                            # Production SQL scripts
│   ├── bronze/                         # Ingestion scripts (Bulk load / DDL)
│   ├── silver/                         # Cleansing, transformation, and audit enrichment scripts
│   └── gold/                           # Star schema creation (Dimension & Fact views)
│
├── tests/                              # Data validation queries and unit integrity tests
│
├── README.md                           # Project documentation
├── LICENSE                             # MIT License
└── .gitignore                          # Standard git ignore file
```
## Author

**Mohamed Osama**  
*Data Analyst & BI Developer*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mohamed_Osama-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mohamed-osama10/)
[![Portfolio](https://img.shields.io/badge/Portfolio-Data_Analyst_&_BI_Developer-000000?style=for-the-badge&logo=google-chrome&logoColor=white)](https://mo-osama.vercel.app/)
