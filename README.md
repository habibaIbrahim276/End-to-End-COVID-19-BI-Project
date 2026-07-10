# COVID-19 End-to-End Data Engineering & Business Intelligence Project

![Executive Overview](visuals/overview.png)

## Project Overview
This project presents a comprehensive, production-grade Data Engineering and Business Intelligence (BI) solution based on the **Our World in Data (OWID) COVID-19 global dataset**. It encompasses the entire data lifecycle—from architectural data modeling and robust ETL pipeline development to analytical cube design and multi-page interactive dashboard visualization.

The primary objective is to dissect the multi-dimensional impact of the pandemic across temporal, geographical, demographic, socio-economic, and healthcare structural frameworks.

---

## Architecture & Data Modeling
The core data warehouse follows a **Star Schema** optimization pattern built to maximize analytical query performance, minimize join complexities, and establish an intuitive semantic layer.

### 1. Conceptual Schema
A central `fact_table` (or `fact_corona`) surrounded by **5 highly descriptive Dimension Tables**, establishing a clean 1-to-many (`1:*`) analytical layout.

### 2. Logical & Physical Implementation
*   **`dim_country`**: Captures geographic entities (`iso_code`, `country_name`, `continent`).
*   **`dim_date`**: Temporal axis including grain attributes (`date`, `day_number`, `month_name`, `month_number`, `year`, `quarter`).
*   **`dim_demographics`**: Tracks population attributes (`population`, `population_density`, `median_age`, age brackets).
*   **`dim_economy`**: Holds financial health statistics (`gdp_per_capita`, `extreme_poverty`, `human_development_index`).
*   **`dim_health`**: Contains baseline healthcare infrastructure and medical risk profiles (`cardiovasc_death_rate`, `diabetes_prevalence`, smoking statistics, `hospital_beds_per_thousand`, `life_expectancy`).
*   **`fact_table`**: Stores continuous daily transactional metrics including cumulative/new cases, deaths, dynamic testing metrics, and index values like the government `stringency_index`.

---

## ETL Pipeline Architecture (SSIS)
The Extraction, Transformation, and Loading lifecycle is engineered using **SQL Server Integration Services (SSIS)** to automate data synchronization with strict structural validation:

1.  **Stage 1: Operational Data Store (ODS) Ingestion**: Daily chronological source data (44,785+ initial rows) is ingested directly into an ODS landing zone environment.
2.  **Stage 2: Data Cleansing & Transformation**:
    *   **Handling Nulls**: Eliminates missing keys/records and standardizes incomplete attributes using custom expression transformations.
    *   **Data Type Conversions & Feature Derivations**: Appends logical columns such as `Location Type` and aligns precise datatypes for seamless fact matching.
    *   **Staging Load**: Persists uniform records into a high-performance staging area (`STG cleaned_data` reaching ~89,570 processed records).
3.  **Stage 3: Warehouse Warehouse Injection**:
    *   Utilizes a coordinated execution workflow leveraging **Sequence Containers**.
    *   Executes dimension table truncation to avoid lookup anomalies, processes dimensional rows with built-in duplicate exclusions, and completes final dynamic lookups (`Lookup Country`, `Lookup Date`, etc.) to securely map primary/foreign keys into the definitive `fact_corona` star cluster.

---

## Analytical Semantic Layer & Metrics (SSAS)
A semantic model was constructed using **SQL Server Analysis Services (SSAS) Tabular Model** utilizing **DAX (Data Analysis Expressions)** to empower deep business logic generation.

### Formulated Business Measures
| Measure Name | DAX Formula | Functional Description |
| :--- | :--- | :--- |
| **Total Cases** | `Total Cases:= SUM('fact_corona'[new_cases])` | Calculates the cumulative absolute sum of daily new infected cases. |
| **Total Deaths** | `Total Deaths:= SUM('fact_corona'[new_deaths])` | Calculates the global cumulative absolute mortality count. |
| **Total Tests** | `Total Tests:= SUM('fact_corona'[new_tests])` | Aggregates absolute volume of diagnostic testing procedures. |
| **Avg New Cases Smoothed**| `Avg New Cases Smoothed:= AVERAGE('fact_corona'[new_cases_smoothed])` | Eliminates volatile weekday/weekend reporting anomalies via 7-day trailing moving averages. |
| **Mortality Rate %** | `Mortality Rate %:= DIVIDE([Total Deaths], [Total Cases], 0)` | Computes Case Fatality Rate (CFR) dynamically with safe division fault-handling. |
| **Avg Positive Rate %** | `Avg Positive Rate %:= AVERAGE('fact_corona'[positive_rate])` | Tracks average viral spread strength over standard filter horizons. |
| **Avg Cases per Million** | `Avg Cases per Million:= AVERAGE('fact_corona'[new_cases_per_million])` | Normalizes geographic scale variations to accurately compare nations. |
| **New Cases Peak Month** | `new cases peak month:= CALCULATE(FIRSTNONBLANK('dim_date'[month_name], 1) & " " & FIRSTNONBLANK('dim_date'[year], 1), TOPN(1, SUMMARIZE('dim_date', 'dim_date'[month_name], 'dim_date'[year]), [Total Cases], DESC))` | Explicitly pinpoints the chronological peak month and year of viral spread waves. |

### Calculated Columns for Risk Segmentation
*   **Age Segment / Vulnerability Tier**:
    ```dax
    Age Segment = SWITCH(TRUE(), 
        'dim_demographics'[aged_65_older] >= 15, "High Risk", 
        'dim_demographics'[aged_65_older] >= 7 && 'dim_demographics'[aged_65_older] < 15, "Medium Risk", 
        "Low Risk"
    )
    ```
*   **Diabetes Exposure Segment**:
    ```dax
    Diabetes Risk Segment = SWITCH(TRUE(), 
        'dim_demographics'[diabetes_prevalence] >= 12, "Critical Health Risk", 
        'dim_demographics'[diabetes_prevalence] >= 6 && 'dim_demographics'[diabetes_prevalence] < 12, "Moderate Health Risk", 
        "Low Health Risk"
    )
    ```

---

## Power BI Executive Dashboard Suite
The visual insight engine consists of an executive-grade multi-page application with modern UI navigation anchors:

1.  **Landing Portal**: Clean navigation dashboard serving as a central launchpad across analytical modules.
2.  **Executive Overview**: High-level telemetry displaying total figures (e.g., *61M Total Cases*, *172M Deaths*, *346M Tests*) side-by-side with geographical geospatial projections and continental breakdowns.
3.  **Country Deep-Dive**: Granular horizontal rankings mapping per capita case distribution against Age Risk Segments, demonstrating that demographic profiling dictates local clinical severity.
4.  **Time Series Trend Analysis**: Tracking line visuals detailing the historical relationship between case additions and mortality curves, showing distinct peak waves (e.g., *August 2020*).
5.  **Testing & Detection Analysis**: Compares regional execution rates (`Population Tested %`) with test positive percentage ratios to establish national diagnostic infrastructure efficiency.
6.  **Socio-Economic Impact Studio**: Plots national Human Development Index (HDI) baselines and GDP per capita parameters against direct case metrics to isolate socio-economic patterns.
7.  **Healthcare System Resilience**: Contrasts underlying risk metrics (such as smoking rates and diabetes pre-conditions) against overall mortality rates to assess hospital infrastructure performance.

---

## Technology Stack
*   **Data Modeling Tools**: Draw.io / Oracle Data Modeler
*   **RDBMS Engine**: Microsoft SQL Server
*   **Data Integration (ETL)**: SQL Server Integration Services (SSIS)
*   **Semantic Analytical Layer**: SQL Server Analysis Services (SSAS Tabular Model)
*   **Business Intelligence / Data Visualization**: Microsoft Power BI Desktop & Service

---
**Prepared By:** Habiba Ibrahim  
**Project Completion Date:** July 1, 2026
