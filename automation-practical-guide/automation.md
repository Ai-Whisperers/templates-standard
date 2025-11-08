# **AI Role and Repository Structure**

---

## 🧠 AI Role

**Overview**
The **`.mcp`** orchestrates every **`.claude`** instance.
Each **`.claude`** file within a repo is a *context placeholder* built on the **`ai-whisperers-mcp-template`**.
Variations must remain **minimal** — just enough to give Claude contextual awareness of the repo’s stack and tools, while **avoiding context drift**.

**Entry Points**

| Component             | Description                                                                                   |
| :-------------------- | :-------------------------------------------------------------------------------------------- |
| `company-information` | GitHub repository entry point — stores all cross-repo information, state, and dependencies.   |
| `.mcp server`         | Main entry point for Claude — manages contextual isolation and orchestration across projects. |

---

### 🧩 Claude Behavior Guidelines

* Claude acts as both **coder** and **reviewer**, but must **not attempt to solve everything at once**.
  Context limits exist not only in *coverage* but also in *depth and reasoning bandwidth* across multi-paradigm systems.
* Claude must **never modify an entire project automatically**.
  Default behavior = **fine-grained permissions** and isolated edit scopes.
* Always follow a **Test-Driven Development (TDD) sequence**, respecting planning order.
  Implementation occurs **only after** test architecture and environment specifics are defined.
  Improper sequencing leads to *junk code* generation due to Claude’s tendency to patch or extend before deleting.

**Canonical Workflow Order**

```
IDEA
 → FEATURES LIST
   → TESTING BLUEPRINT
     → CODEBASE BLUEPRINT
       → TESTING IMPLEMENTATION
         → CODEBASE IMPLEMENTATION
```

> 💡 *Key principle:* “Scaffold first, code last.”
> Each stage compresses uncertainty before expansion.

---

## 🧱 Individual Repository Structure

**Root-Level Folders**
Each repo must contain these elements at its root:

```
.claude
.mcp
.git
.specstory
.husky
.devcontainer
.github
```

* **`.mcp`** → must exist individually. If not yet fully implemented, create a placeholder for future integration into the main orchestration ring.
* **`.claude`** → tailored to that repo’s codebase context and specific project goal.
  When multiple repos contribute to one global goal, keep this flexible — ensure each `.claude` clearly distinguishes **codebase goal (scope)** from **codebase context (current reality)**.

**Required Files**

```
README.md
CLAUDE.md
```

> 📘 *Summary:* every repo carries its own cognitive node (`.claude`) and control node (`.mcp`).
> Together they synchronize intent (goal) and state (context) across the full AI-Whisperers ecosystem.

---

