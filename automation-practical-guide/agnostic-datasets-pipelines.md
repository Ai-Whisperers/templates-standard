# Dataset Converter Blueprint

## **General Context of the Blueprint**

Designing The Bridge Between Data Formats and Machine Learning Pipelines

### 1. Root Purpose

We’re designing a **universal system for dataset conversion and decomposition**, capable of **ingesting multiple heterogeneous formats** (`.csv`, `.xls[x]`, `.json`, `.parquet`, `.arrow`, even `.docx`), **converting them into a standard, interoperable format** (Arrow / Parquet), **decomposing each field (column)** into an *independent dataset* exportable and analyzable iteratively or in parallel, and **exposing the result through a REST API** for integration with analytical systems or ML pipelines. In essence, it’s a **field-by-field data analysis middleware**, portable and backend-agnostic, with universal format support.

### 2. Identified Technical Phases

The architecture defines clear **modular phases**, each representing an independent service or container:

| Phase                              | Role                                                   | Output                       |
| ---------------------------------- | ------------------------------------------------------ | ---------------------------- |
| **Ingestion**                      | Detects format and normalizes to `DataFrame`.          | `df_raw`                     |
| **Normalization**                  | Cleans, types, and unifies columns.                    | `df_norm`                    |
| **Decomposition (Field Splitter)** | Splits each field into an `Arrow.Table`.               | `{field: Arrow}`             |
| **Serialization**                  | Converts to `Arrow IPC Stream` (bytes/base64).         | `arrow_bytes`                |
| **Persistence/Cache**              | Stores results (Parquet, MinIO, Redis).                | paths/IDs                    |
| **API Gateway**                    | Orchestrates, coordinates, and exposes REST endpoints. | `/convert`, `/fields/{name}` |

### 3. Proposed Infrastructure

Each phase is **dockerized**, enabling flexible deployment architectures:
**a) Internal HTTP Chaining:** Each container calls the next (`requests.post("http://normalizer:8000/...")`) using Docker’s internal DNS.
**b) Asynchronous Orchestration (Messaging):** Each phase acts as a **Celery worker**, communicating through Redis/RabbitMQ, publishing tasks (`normalize_task`, `split_task`, etc.), and working over shared files (mounted in `/data/` or stored in S3/MinIO). This enables **horizontal scaling** and **fault tolerance**.
**c) Hybrid (Recommended):** HTTP API for input → internal messaging for processing → REST Gateway for output.

### 4. Underlying Concept

This is essentially a **universal dataset-transformation engine** oriented toward *field-centric analytics*, Arrow interoperability, and parallel decomposition. Each column becomes an **independent analytical unit**, allowing *per-field ML pipelines or adaptive compression*. Arrow serves as **shared memory across processes or GPUs**, minimizing overhead, and the system can evolve into a **distributed architecture** (akin to a mini-Snowflake or Polars hub).

### 5. Resulting Tech Stack

**FastAPI** for REST endpoints; **Pandas / PyArrow / Polars** for conversion; **Celery + Redis** for asynchronous orchestration; **Docker Compose** for deployment; **S3 / MinIO / Parquet Store** for persistence; **Grafana + Prometheus** for per-field and per-batch metrics.

### 6. Current Status

Defined milestones include:

1. A **functional monolithic version** (`/convert` endpoint generating Arrow arrays per field).
2. A **plan for modularization by phase** with independent containers.
3. **Communication options** (REST, queues, hybrid).
4. An **external consumption strategy** (API Gateway).

Next steps: define the **message flow and data schema** between phases (`dataset_id`, paths, states), design the **Docker Compose + network + volumes**, and create the **architecture diagram** (Mermaid/PlantUML).
