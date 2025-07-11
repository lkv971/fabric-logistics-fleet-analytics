# Fleet Analytics

> End-to-end fleet maintenance & revenue analytics on Microsoft Fabric, implemented as a Medallion architecture—from raw SSMS staging (Bronze), through cleansed Delta Lakehouse (Silver), to curated Warehouse & semantic model (Gold) powering Power BI.

## Description

This repo implements a **Medallion-style** fleet analytics solution on Fabric:

1. **Bronze (Raw Ingestion)**  
   CSVs for Costs, Freight_Revenue, Drivers, Vehicles, Customers land in SQL Server staging tables via SSMS.

2. **Silver (Cleansed & Enriched)**  
   **Gen2 Dataflow** (`DF_Fleet`) reads staging, applies type fixes, renames, null-imputation, maintenance flags, and builds a `dates` dimension—writing six Delta tables into the Lakehouse (`LH_Fleet`).

3. **Gold (Curated & Aggregated)**  
   - **Warehouse** (`WH_Fleet`): staging views over Silver Delta tables, an **IngestionLogs** audit table, and an upsert stored procedure to merge into final Gold tables.  
   - **Semantic Model** (`SM_Fleet`): business-ready DAX measures, hierarchies, and role-based security.

4. **Delivery**  
   Power BI report (`Fleet report.pbix`) visualizes freight revenue vs. maintenance performance by truck/trailer type.

5. **Orchestration**  
   **Fabric Pipeline** (`PL_Fleet`) automates Bronze→Silver→Gold flow with a **watermark**–based conditional branch, ingestion logging, and semantic-model refresh.

## Key Enhancements

- **Ingestion-log–driven watermark**  
  - `IngestionLogs` table (DATETIME2(3)) captures every run’s timestamp & status.  
  - **Lookup_LastRun** reads the last successful run.  
  - **Lookup_SourceMax** reads the latest `Date` from `Fleet.Freights`.  
  - **IfNewData** compares them—only if new data exists does downstream ETL fire.  
  - **UpdateLogsTable** appends a new row at pipeline end, bumping the watermark.

- **Conditional ETL**  
  The pipeline’s heavy-lifting (Dataflow refresh, staging views, upsert proc, semantic refresh) only runs when `MaxDate > LastRunTime`.

- **Scheduled runs**  
  A **Daily_PL_Fleet** trigger fires the pipeline at 08:00 Eastern Time (US and Canada) each day.

## Folder Structure

```
fleet-analytics/
├── core/
│   ├── LH_Fleet/        ← Silver: Delta table definitions & partition scripts  
│   ├── WH_Fleet/        ← Gold: staging-view SQL, IngestionLogs DDL, upsert SP  
│   └── SM_Fleet/        ← Gold: semantic-model metadata (JSON/.bim)  
│
├── orchestration/
│   ├── DF_Fleet/        ← Silver: Gen2 Dataflow (Power Query M)  
│   └── PL_Fleet/        ← Pipeline JSON (Lookup → IfNewData → conditional ETL)  
│
└── delivery/
    └── Fleet report/    ← Power BI .pbix report  
```

## Medallion Layers

| Layer   | Description                                                                                          |
|---------|------------------------------------------------------------------------------------------------------|
| **Bronze** | SSMS staging tables loaded with raw CSVs.                                                         |
| **Silver** | `DF_Fleet` cleans, enriches, and writes Delta tables (`dim_*`, `fact_*`) into `LH_Fleet`.       |
| **Gold**   | `WH_Fleet` staging views + `IngestionLogs` + upsert SP → final Gold tables; `SM_Fleet` semantic model. |

## Pipeline: **PL_Fleet**

1. **Lookup_LastRun**  
   - Queries `MAX(ProcessedTime)` from `Fleet.IngestionLogs` (coalesced to a seed `1970-01-01 00:00:00.000`).  

2. **Lookup_SourceMax**  
   - Queries `MAX([Date])` from `Fleet.Freights`.  

3. **IfNewData**  
   - Expression:  
     ```text
     @greater(
       activity('Lookup_SourceMax').output.firstRow.MaxDate,
       activity('Lookup_LastRun').output.firstRow.LastRunTime
     )
     ```  
   - **True** → run:  
     1. `Ingest_transform_data` (Dataflow Gen2)  
     2. `Staging_views` (Script to recreate staging views)  
     3. `Upsert_procedure` (stored proc merge)  
     4. `UpdateLogsTable` (Script: INSERT into `IngestionLogs`)  
     5. `SM_Fleet_Refresh` (semantic model refresh)  
   - **False** → end pipeline.

## Scheduling

- **Trigger**: `Daily_PL_Fleet`  
- **Frequency**: Daily at **08:00** (Europe/Paris)  

## Getting Started

1. **Clone**  
   ```bash
   git clone https://github.com/yourorg/fabric-fleet-maintenance-revenue-analytics.git
   cd fabric-fleet-maintenance-revenue-analytics
   ```

2. **Bronze**  
   - In SSMS, create `Fleet.Freights`, `Fleet.Costs`, etc., and load daily CSVs.

3. **Silver**  
   - In Fabric, publish and run `DF_Fleet` under **orchestration/DF_Fleet** to populate `LH_Fleet`.

4. **Gold**  
   - In Fabric, publish `WH_Fleet` (including `IngestionLogs` DDL and upsert SP) and `SM_Fleet`.  
   - Publish and run `PL_Fleet` to perform conditional ETL and refresh the semantic model.

5. **Deliver**  
   - Open `delivery/Fleet report/Fleet report.pbix` in Power BI to explore dashboards.

## Tech Stack

| Layer          | Technology                           |
| -------------- | ------------------------------------ |
| Bronze         | SQL Server (SSMS)                    |
| Silver         | Fabric Dataflow Gen2, Delta Lakehouse|
| Gold           | Fabric Warehouse (SQL), Semantic Model (DAX) |
| BI & Reporting | Power BI                             |
| Orchestration  | Fabric Pipelines                     |

## Contributing

1. Fork and branch from `main`.  
2. Implement changes in the appropriate layer (`core/`, `orchestration/`, or `delivery/`).  
3. Commit, push, and open a Pull Request for review.

## License

This project is licensed under the MIT License.
