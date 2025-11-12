# SERVICES PROTOCOLS
We use these according to the type of service we are offering. For example API calls determine a flight ticket in an Arrow Flight gRPC protocol enviroment, but the ticket itself doesnt ensure the data stream is properly sent, thus its important to know how to implement gRPC (and in this particular example, Arrow Flight gRPC).

## Apache Kafka
We use Apache Kafka, it is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines. It ensures a professional and mature enviroment for quicker debugging of events and overall higher codebase quality.

## STREAMING AND BATCHING

### Arrow Flight gRPC 
Arrow Flight (already known, still edge-case)
### Custom gRPC
Custom gRPC: Blob as the stream(or Arrow as schema/stream) and JSON as payload-meta (Send Arrow binary over HTTP, but describe schema in a small JSON header).

### ORCHESTRATION AND API CALLS
## REST API
