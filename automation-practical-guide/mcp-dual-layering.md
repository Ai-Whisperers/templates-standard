# CLAUDE MCP: Rule-driven vs Context-driven

● **RULESET LAYER**
These are the Mechanical / Straightforward backbone of the MCP server, and should remain mechanical as the fallback, but as a mechanical variable that is somewhat manageable by the "context component" of the MCP server. Some components that take place on the "ruleset layer" are: MCP tool schemas (parameter types, return formats, endpoint contracts) and `.claude` permissions/hooks (regex matchers, allow/deny patterns, env vars) define explicit operational boundaries. 

● **CONTEXT LAYER**
Heuristic / Holistic components take place on this layer, it includes: MCP architecture docs and server descriptions, along with `.claude` README or `CLAUDE.md` files (project context, principles, best practices, and “why” narratives), provide interpretive guidance and reasoning frameworks.