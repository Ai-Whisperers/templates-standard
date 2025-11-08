# 🧩 **Documentation Ratio Protocol (DRP)**

> *Every document lives between two minds: Human (clarity) and Machine (structure). The ratio decides which one leads.*

---

## ⚖️ **Core Rule**

[
R_{Toon} + R_{Human} = 100%
]
Where

* (R_{Toon}) = % of document written in **Toon Format**
* (R_{Human}) = % of document written in **Human-Oriented prose**

The ratio is chosen by **document type, volatility, and integration depth**.

---

## 🧭 **Decision Matrix**

| Document Type                      | Toon % | Human % | Rationale                                                                |
| :--------------------------------- | -----: | ------: | :----------------------------------------------------------------------- |
| **README.md / Overview**           |      0 |     100 | First contact point — empathy, mission, and clarity outweigh structure.  |
| **INSTALL / SETUP Guides**         |     20 |      80 | Mostly human; only commands/config blocks in Toon or YAML-like snippets. |
| **API Spec / Schema Docs**         |     90 |      10 | Machines must read it more than humans; precision > narrative.           |
| **Data Pipeline Descriptions**     |     75 |      25 | Hybrid: human flow explanation + structured Toon for schemas and IO.     |
| **Configuration Templates**        |     95 |       5 | Pure schema — humans only need headers and comments.                     |
| **CI/CD or Deployment Docs**       |     70 |      30 | Mixed: command narratives up top, Toon for parameters and sequences.     |
| **Research Reports / Findings**    |     40 |      60 | Concepts need prose, but structured data aids reproducibility.           |
| **Design Decisions Records (ADR)** |     50 |      50 | Equal weight: reasoning (human) + outcome (machine-logged).              |
| **Knowledge Base / Wiki Pages**    |     30 |      70 | Contextual learning dominates, but indexable structure still matters.    |
| **Experiment Logs / Metrics**      |     80 |      20 | Metrics must be machine-readable, but commentary adds value.             |
| **Security / Compliance Docs**     |     85 |      15 | Must integrate with automated checks; minimal human ambiguity.           |

---

## 🧠 **Conditionals by Context**

**1. Volatility (how often it changes)**

* High-change (daily/weekly): ↓ Toon % (focus on fluid narrative).
* Low-change (stable infra, APIs): ↑ Toon % (optimize for automation).

**2. Integration Level (how connected it is)**

* Standalone doc → Human bias.
* Auto-ingested by CI/LLM pipelines → Toon bias.

**3. Criticality (impact if misread)**

* If *misinterpretation = failure* → prioritize Toon precision.
* If *misinterpretation = delay* → prioritize Human clarity.

**4. Temporal Relevance**

* Long-lived (standards, contracts) → higher Toon %.
* Short-lived (notes, changelogs) → higher Human %.

**5. Audience**

* Primarily developers → 60–80 % Toon.
* Stakeholders or non-tech readers → ≤ 20 % Toon.

---

## ⚙️ **Operational Formula**

[
R_{Toon} = (S_t \cdot 0.4) + (I_t \cdot 0.3) + (C_t \cdot 0.2) + (A_t \cdot 0.1)
]

Where:

* (S_t) = Stability (0–1, 1 = very stable)
* (I_t) = Integration with automation (0–1)
* (C_t) = Criticality (0–1, safety/precision sensitivity)
* (A_t) = Audience technicality (0–1, expert-heavy)

**Clamp result between [0.1, 0.95].**
Then (R_{Human} = 1 - R_{Toon}).

---

## 🧩 **Examples**

**A. API Endpoint Catalog**
S_t=1.0, I_t=1.0, C_t=0.9, A_t=0.9 →
(R_{Toon}=0.4+0.3+0.18+0.09=0.97) → **97 % Toon / 3 % Human**

**B. Team Process Handbook**
S_t=0.5, I_t=0.1, C_t=0.3, A_t=0.4 →
(R_{Toon}=0.2+0.03+0.06+0.04=0.33) → **33 % Toon / 67 % Human**

**C. Machine Learning Experiment Log**
S_t=0.8, I_t=0.7, C_t=0.8, A_t=0.8 →
(R_{Toon}=0.32+0.21+0.16+0.08=0.77) → **77 % Toon / 23 % Human**

---

## 🧱 **Implementation Tips**

* Define ratio in the header:
  `Doc-Ratio: Toon 0.9 / Human 0.1`
* CI validation: fail builds if ratio not met for required doc types.
* Maintain one conversion script:
  `convert_docs.py --ratio-check --toon-export`.
* Human sections → empathy, rationale, flow.
* Toon sections → schemas, configuration, parameters.

---

## 💡 **Closing Principle**

> *Precision and empathy are not opposites — they are sequential phases of understanding.*

The **Documentation Ratio Protocol** ensures that:

* **Humans** can learn the system intuitively.
* **Machines** can interpret it deterministically.
* And both can evolve without rewriting each other.

---
