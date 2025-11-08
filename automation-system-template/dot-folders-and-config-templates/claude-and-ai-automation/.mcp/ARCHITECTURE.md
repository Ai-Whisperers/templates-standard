# MCP Architecture Overview

**Doc-Type:** Architecture · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Visual guide to MCP servers integration with Customer Feedback Analyzer.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AI Clients                                │
│  • Docker AI (Gordon)  • Claude Desktop                          │
│  • Cursor IDE          • VSCode + Continue.dev                   │
└────────────────────────┬────────────────────────────────────────┘
                         │ MCP Protocol (stdio/SSE)
        ┌────────────────┴───────────────┐
        │                                │
        ▼                                ▼
┌───────────────┐              ┌──────────────────┐
│  gordon-mcp   │              │  MCP Gateway     │
│  (Docker AI)  │              │  (Port 8080)     │
└───────┬───────┘              └────────┬─────────┘
        │ Docker Compose                │ Docker Network (mcp-network)
        └───────────┬───────────────────┘
                    │
        ┌───────────┴──────────────────────────────────┐
        │                                              │
        ▼                                              ▼
┌─────────────────┐                         ┌──────────────────────┐
│  Built-in MCP   │                         │  Custom MCP Server   │
│    Servers      │                         │  feedback-analyzer   │
│ • filesystem    │                         │  Tools:              │
│ • fetch         │                         │  • analyze_sentiment │
│ • time          │                         │  • calculate_nps     │
└────────┬────────┘                         │  • identify_themes   │
         │ Read-only access                 │  • detect_pain_points│
         │                                  │  • analyze_csv_file  │
         │                                  │  • generate_summary  │
         │                                  └──────────┬───────────┘
         │                                             │ Calls
         ▼                                             ▼
┌─────────────────────────────────────────────────────────────────┐
│               Customer Feedback Analyzer Project                │
│  ├── data/ (CSV, Excel)  ├── api/ (Python analysis)             │
│  ├── docs/  └── .env (OpenAI API key)                           │
│  External: OpenAI API (gpt-4o-mini)                             │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow: Sentiment Analysis

```
User: "Analyze sentiment of feedback in data/samples/feedback.csv"
  │
  ├─► 1. AI Client → MCP Gateway (or Docker AI)
  ├─► 2. Gateway routes:
  │      ├─► filesystem server → reads CSV file
  │      └─► feedback-analyzer → analyzes text
  ├─► 3. feedback-analyzer:
  │      ├─► Reads feedback text from CSV
  │      ├─► Calls OpenAI API (gpt-4o-mini)
  │      ├─► Processes AI response
  │      └─► Returns sentiment + confidence scores
  └─► 4. Results → user via AI client
```

---

## MCP Communication

### Stdio Transport (Docker AI)
```
Docker AI → stdin/stdout → MCP Server (Container) → Function calls → Tool Implementations
```

### SSE Transport (MCP Gateway)
```
AI Client → HTTP/SSE (8080) → MCP Gateway → Docker network → MCP Servers → Function calls → Tool Implementations
```

---

## Security Boundaries

```
┌─────────────────────────────────────────────────────────┐
│  Filesystem Server (Read-Only)                          │
│  • Can: Read project files                              │
│  • Cannot: Write, execute, delete                       │
│  • Restricted: CSV, JSON, Excel, Parquet only           │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  Fetch Server (Network Limited)                         │
│  • Can: HTTP to localhost, api.openai.com               │
│  • Cannot: Arbitrary internet access                    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  Custom Analyzer (API Key Required)                     │
│  • Uses: OpenAI API with user's key                     │
│  • Source: Environment variable from .env               │
│  • Never: Stored in Docker images or logs               │
└─────────────────────────────────────────────────────────┘
```

---

## Configuration Flow

```
Source: .mcp/configs/
  ├─► gordon-mcp.yml
  ├─► docker-compose.mcp-gateway.yml
  └─► mcp-catalog.yaml
  │
  ├─► Copied to project root (Docker compatibility)
  └─► Loaded by Docker AI or MCP Gateway
```

---

## Custom Server Architecture

```
┌────────────────────────────────────────────────────────┐
│         feedback-analyzer MCP Server                   │
│  ┌──────────────────────────────────────────────┐     │
│  │  MCP Framework                               │     │
│  │  • list_tools() - Advertise capabilities     │     │
│  │  • call_tool() - Route requests              │     │
│  └─────────────────┬────────────────────────────┘     │
│  ┌─────────────────▼────────────────────────────┐     │
│  │  Tool Implementations                        │     │
│  │  ├─ analyze_sentiment_impl()                 │     │
│  │  ├─ calculate_nps_impl()                     │     │
│  │  ├─ identify_themes_impl()                   │     │
│  │  ├─ detect_pain_points_impl()                │     │
│  │  ├─ analyze_csv_file_impl()                  │     │
│  │  └─ generate_summary_impl()                  │     │
│  └─────────────────┬────────────────────────────┘     │
│  ┌─────────────────▼────────────────────────────┐     │
│  │  External Dependencies                       │     │
│  │  • OpenAI AsyncClient (gpt-4o-mini)          │     │
│  │  • pandas (CSV processing)                   │     │
│  │  • Python standard library                   │     │
│  └──────────────────────────────────────────────┘     │
└────────────────────────────────────────────────────────┘
```

---

## Deployment Models

### Model 1: Docker AI (Development)

**Workflow:**
1. Edit code in IDE
2. Ask Docker AI: "Analyze sentiment in feedback.csv"
3. Docker AI auto-starts MCP servers (from gordon-mcp.yml)
4. Get instant results in terminal

**Pros:** Zero config, auto-detects gordon-mcp.yml, perfect for quick queries, no persistent services
**Cons:** Docker AI only, servers restart each time, no multi-client support

### Model 2: MCP Gateway (Production)

**Workflow:**
1. Start gateway once: `docker-compose -f docker-compose.mcp-gateway.yml up -d`
2. Multiple team members connect (Claude Desktop, Cursor, VSCode)
3. Persistent service runs 24/7
4. All clients share same tools

**Pros:** Multiple AI clients, persistent connections, production-ready, centralized logging
**Cons:** Manual startup, more resource intensive, per-client configuration

---

## File Organization

```
Project Root
├── gordon-mcp.yml                  (Active - Docker AI)
├── docker-compose.mcp-gateway.yml  (Active - Gateway)
├── mcp-catalog.yaml                (Active - tool definitions)
│
└── .mcp/                           (Source directory)
    ├── README.md  ├── SETUP.md  ├── QUICKSTART.md  ├── ARCHITECTURE.md
    ├── configs/
    │   ├── gordon-mcp.yml
    │   ├── docker-compose.mcp-gateway.yml
    │   └── mcp-catalog.yaml
    └── servers/
        └── feedback-analyzer/
            ├── Dockerfile  ├── requirements.txt  ├── server.py  └── README.md
```

---

## Tool Capability Matrix

| Tool | Read Files | Write Files | HTTP Requests | AI Analysis | Database |
|------|------------|-------------|---------------|-------------|----------|
| filesystem | ✅ | ❌ | ❌ | ❌ | ❌ |
| fetch | ❌ | ❌ | ✅ | ❌ | ❌ |
| time | ❌ | ❌ | ❌ | ❌ | ❌ |
| feedback-analyzer | ✅ | ❌ | ✅ (OpenAI) | ✅ | ❌ |

---

## Performance Characteristics

### Built-in Servers
- Startup: < 1s
- Memory: ~20 MB each
- Latency: < 10ms (local ops)

### Custom Analyzer
- Startup: ~3-5s (Python + deps)
- Memory: ~100-200 MB
- Latency:
  - Local ops (NPS, CSV): < 100ms
  - AI ops (sentiment, themes): 1-3s (OpenAI API)

---

## Cost Considerations

**Free Resources:**
- Built-in MCP servers (filesystem, fetch, time)
- Docker compute for containers
- Local data processing

**Paid Resources:**
- OpenAI API calls from feedback-analyzer
- ~$0.0000375 per feedback analyzed
- Example: 1,000 feedbacks ≈ $0.04

---

## Extensibility

### Adding Built-in Servers

```yaml
# In gordon-mcp.yml
services:
  postgres:
    image: mcp/postgres
    environment:
      - DATABASE_URL=${DATABASE_URL}
```

### Adding Custom Tools

```python
# In .mcp/servers/feedback-analyzer/server.py
@app.call_tool()
async def your_new_tool_impl(args: Dict[str, Any]) -> Dict[str, Any]:
    # Your implementation
    return {"result": "..."}
```

---

## Monitoring

### View Logs

```bash
docker-compose -f docker-compose.mcp-gateway.yml logs -f  # All services
docker logs feedback-mcp-analyzer -f  # Specific server
docker logs --tail=100 feedback-mcp-analyzer  # Last 100 lines
```

### Health Checks

```bash
docker-compose -f docker-compose.mcp-gateway.yml ps  # Running containers
curl http://localhost:8080/health  # Gateway health
docker stats feedback-mcp-analyzer  # Resource usage
```

---

## Troubleshooting Decision Tree

```
Issue: MCP not working
  │
  ├─► Is Docker Desktop running?
  │   └─ No → Start Docker Desktop
  │
  ├─► Using Docker AI or Gateway?
  │   ├─ Docker AI → Is gordon-mcp.yml in root?
  │   │             └─ No → Copy from .mcp/configs/
  │   └─ Gateway → Is gateway container running?
  │                └─ No → docker-compose up -d
  │
  ├─► Are containers built?
  │   └─ No → docker-compose build feedback-analyzer
  │
  ├─► Is OPENAI_API_KEY set in .env?
  │   └─ No → Add OPENAI_API_KEY=sk-... to .env
  │
  └─► Check logs
      └─ docker logs feedback-mcp-analyzer
```

---

## Resources

- [MCP Protocol Spec](https://github.com/anthropics/mcp)
- [Docker MCP Docs](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [Setup Guide](SETUP.md)
- [Quick Start](QUICKSTART.md)

---

**Need Help?** Check [SETUP.md](SETUP.md) for detailed troubleshooting or open an issue.
