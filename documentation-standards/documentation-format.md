# 📘 DOCUMENTATION STANDARD FOR REPOSITORIES (`/docs`)

> *One document, two versions within — human first, model next.*

Each repo document follows a **dual-layer pattern**:

1. A concise **Human-Oriented Header** — natural-language summary, principles, and rationale.
2. A **Toon-Format Body** — structured data for model ingestion and automation.

---

### 🧠 Human-Oriented Header

> *Readable, concise and non-verbose, immediately graspable and context-oriented.*

**Purpose**

* Introduce the document’s intent, context, and dependencies.
* Explain *why it exists* in ≤ 120 words.
* Highlight operational scope and version metadata.

**Principles**

* **Concise phrasing:** high meaning per line, conversational tone.
* **Two hierarchy levels max:** (`## Principle → – Rule`).
* **Temporal flow:** show sequences (input → process → output).
* **Cognitive rhythm:** short, symmetrical lines; clear breathing.
* **Metadata line:** `Doc-Type · Version · Updated-On · Author`.

**Example**

```markdown
# Data Pipeline Overview
Doc-Type: Architecture Summary · Version 1.3 · Updated 2025-11-07 · Author AI Whisperers  
Purpose: describe end-to-end data flow from ingestion → storage → analytics.  
Scope: applies to Arrow/Parquet layer; excludes visualization stack.  
```

🧩 **Why:** this first section is for humans — sets narrative context and emotional tone, trains working memory to expect order.

---

### 🤖 Toon-Format Body

> *Compact, deterministic, and ready for LLMs.*

After the human header, continue directly in **Toon syntax** (Markdown-compatible structured text).
It keeps meaning but minimizes tokens and ambiguity.
Reference → [Toon Format Repo](https://github.com/toon-format/toon)

**Benefits**

* ~**−22 % token reduction** vs JSON.
* More stable parsing than YAML or XML.
* Perfect for embeddings, fine-tuning, and context compression.

| Dataset Type              | Toon Tokens |   vs JSON |  vs YAML |    vs XML |
| :------------------------ | ----------: | --------: | -------: | --------: |
| E-commerce (nested)       |      72 743 |     −33 % |    −14 % |     −41 % |
| Event Logs (semi-uniform) |     153 223 |     −15 % |     −1 % |     −25 % |
| Deep Config (nested)      |         631 |     −31 % |     −6 % |     −37 % |
| **Total**                 | **226 597** | **−22 %** | **−6 %** | **−31 %** |

**Operational rules**

* After the header, begin with a clear delimiter line: `---`
* Nest fields using Toon’s indentation syntax.
* Keep naming deterministic (snake_case or kebab-case).
* Use comments (`#`) only for context; models treat them as soft metadata.
* Validate using `toon check --strict` in CI.

**Example**

```toon
---
pipeline:
  ingestion:
    format: csv
    convert_to: arrow
    checksum: sha256
  storage:
    format: parquet
    partition_key: date
  analytics:
    engine: polars
    output: json
```

---

### 🧭 Harmonized Workflow

> *Document once, read twice.*

| Step                      | Purpose                                       |
| :------------------------ | :-------------------------------------------- |
| 1. Write the human header | cognitive orientation, context & emotion      |
| 2. Append Toon body       | machine readability & automation              |
| 3. Cross-link             | each header links to its Toon spec via anchor |
| 4. Validate               | run lint + CI check                           |
| 5. Version                | auto-increment both header and body metadata  |

🪄 **Micro-echo:** *Human → Model → Human again.* The cycle ensures both stay aligned; no semantic drift between teams and AIs.

---