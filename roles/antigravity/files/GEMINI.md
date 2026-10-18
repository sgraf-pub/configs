# Rule: Git Commit Message Attribution

## Intent
Whenever creating or amending a Git commit, append a standard "Assisted-by" footer to the commit message indicating the active AI model used during this session.

## Instructions
1. When generating a git commit message (e.g., executing `git commit -m "..."`), inspect your active system prompt context or runtime model configuration to identify the model version currently running (e.g., `Gemini 3.8 Flash`, `Gemini 3.5 Pro`, etc.).
2. Append a blank line followed by a trailer formatted as follows:
   `Assisted-by: [Active Model Name] via Antigravity`
3. If an `Assisted-by` trailer is already present (e.g. during `git commit --amend`), update or preserve it rather than duplicating the trailer.

## Examples

### Example 1: Standard Commit
**Original Message:**
`feat(auth): add OAuth2 token refresh handler`

**Formatted Output:**
feat(auth): add OAuth2 token refresh handler

Assisted-by: Gemini 3.8 Flash via Antigravity


### Example 2: Conventional Commit with Body
**Original Message:**
fix(database): mitigate memory leak in query connection pool

Closed idle connections after 30s timeout to prevent thread exhaustion.

**Formatted Output:**
fix(database): mitigate memory leak in query connection pool

Closed idle connections after 30s timeout to prevent thread exhaustion.

Assisted-by: Gemini 3.5 Pro via Antigravity


## Constraints
- Always include a blank line separating the commit body/subject from the `Assisted-by` trailer.
- Do not append multiple duplicate trailers.

---

# Rule: Subagent Delegation & Model Tiering

To conserve primary context tokens and optimize speed, follow these delegation guidelines:

1. **Keep Parent Agent Lightweight:**
   - Reserve the main chat session for orchestration, high-level planning, spec reviews, and final task validation.

2. **Delegate Implementation & Edits:**
   - For non-trivial code implementation, refactoring, or multi-file edits, spawn a subagent (`TypeName: self`) using `Model: flash` (corresponds to `gemini-3.8-flash-medium`).

3. **Delegate Documentation & Tests:**
   - For generating unit tests, updating `README.md`, or writing docstrings, spawn a subagent (`TypeName: self`) using `Model: flash_lite` (corresponds to `gemini-3.8-flash-low`).
