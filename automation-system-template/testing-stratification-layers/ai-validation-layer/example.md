Here is the **minimal hybrid layout** showing how `.claude` + `.mcp` can *(and should)* coexist in one repo to give you both **local intelligence** and **ecosystem interoperability**.

---

## 📁 Folder layout

```
my-project/
 ├─ src/
 ├─ data/
 ├─ .claude/
 │    ├─ settings.json
 │    ├─ commands/
 │    │    └─ test.md
 │    └─ agents/
 │         └─ repo-guide.md
 ├─ mcp/
 │    ├─ tools.json
 │    ├─ schemas/
 │    │    └─ format-schema.json
 │    └─ server.js
 └─ package.json
```

---

## 🧩 `.claude/settings.json`

```json
{
  "project": "my-project",
  "env": {
    "NODE_ENV": "development"
  },
  "permissions": {
    "allow": ["Read(src/**)", "Run(npm run build)"],
    "deny": ["Read(secrets/**)"]
  },
  "style": {
    "language": "typescript",
    "lintCommand": "npm run lint"
  },
  "context": {
    "summary": "Main repository for data pipeline and analytics API. Follow our lint and schema rules."
  }
}
```

**Purpose:** anchors Claude’s behavior *inside* the repo — style, permissions, and contextual summary.

---

## 💬 `.claude/commands/test.md`

```
# /test
Run `npm test` and report any failing suites.
```

Claude will interpret `/test` in chat as a command and run or emulate your local tests.

---

## 🌐 `mcp/tools.json`

```json
{
  "version": "1.0",
  "tools": [
    {
      "name": "repo_linter",
      "description": "Lints source files using repo rules.",
      "input_schema": "schemas/format-schema.json",
      "endpoint": "/lint"
    },
    {
      "name": "data_summary",
      "description": "Summarizes datasets in /data directory.",
      "input_schema": "schemas/summary-schema.json",
      "endpoint": "/summary"
    }
  ]
}
```

**Purpose:** declares to any MCP-compatible model what callable tools exist and where to reach them.

---

## ⚙️ `mcp/server.js` (Node example)

```js
import express from "express";
import bodyParser from "body-parser";
import { lintRepo } from "./src/linter.js";
import { summarizeData } from "./src/summarizer.js";

const app = express();
app.use(bodyParser.json());

app.post("/lint", async (req, res) => {
  const result = await lintRepo(req.body);
  res.json({ result });
});

app.post("/summary", async (req, res) => {
  const result = await summarizeData(req.body);
  res.json({ result });
});

app.listen(8080, () => console.log("MCP server running on port 8080"));
```

---

## 🧠 How They Interact

1. **Claude (via `.claude`)**

   * Understands your repo style, allowed actions, and local commands.
   * Operates safely with your environment variables and coding patterns.
2. **Any LLM or agent (via MCP)**

   * Discovers your repo’s public tool endpoints (`tools.json`).
   * Uses JSON-RPC or HTTP to call `/lint` or `/summary`.
   * Gains structured results usable as context anywhere else.

---

## 🧭 Summary

| Layer     | Role                                              | Scope                 |
| --------- | ------------------------------------------------- | --------------------- |
| `.claude` | Local personality, permissions, and code behavior | Repo-specific         |
| `.mcp`    | Tool/service interface contract                   | Multi-model ecosystem |

**Result:** your repo becomes *self-describing* (for assistants) and *interoperable* (for other systems) — internal coherence + external reach.
