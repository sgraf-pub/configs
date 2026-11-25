# Rule: Git Commit Message Attribution

## Intent
Whenever creating or amending a Git commit, append a standard "Assisted-by" footer naming the model used in this session. The subject and body follow the repository's recent commit style. The trailer is the only fixed part.

## Instructions
1. Inspect your system prompt or runtime model configuration for the model name currently running. Example names below are illustrations, not the name to copy.
2. Pass the commit message with `-m` and the trailer in a second `-m`. Git inserts the blank line between them:

```bash
git commit -m "$(cat <<'EOF'
feat(auth): add OAuth2 token refresh handler

Refresh tokens before they expire so API calls survive long sessions.
EOF
)" -m "Assisted-by: Gemini 3.8 Flash via Antigravity"
```

3. If an `Assisted-by` trailer is already present (for example during `git commit --amend`), update it or leave it. Do not add a second trailer.

## Constraints
- The second `-m` is the trailer. Do not glue the trailer onto the subject or body inside the first `-m`.
- Do not append duplicate trailers.
- Keep the subject and body in the repository's recent commit style.

---

# Rule: Unix Line Endings

## Intent
Every machine here runs Linux. Write text with Unix line endings only so diffs do not show `^M`.

## Instructions
- New files and edits use LF (`\n`) only. Do not insert `\r`.
- If a tool, patch, or generated file arrives with CRLF (`\r\n`), convert it to LF before writing it into the tree.
- Do not mix endings in one file. A file that is already LF stays LF.
- Shell heredocs, scripts, and config files use LF.
- Leave an existing CRLF file alone unless the task is to fix its line endings. Then convert the whole file to LF in one change, not line by line.

---

# Rule: Throwaway Scripts

## Intent
Large or repetitive text processing belongs in a short Python script. One-off scripts stay out of the repository.

## Instructions
1. Use a script for parsing large CSV, JSON, or log files; regex or structural edits across many lines or files; and stats or other bulk arithmetic.
2. Put the script in `.agent_scratch/`. Create that directory if it is missing.
3. Add `.agent_scratch/` to `.gitignore` when it is not already ignored.
4. Run the script and print a short result. Reply with the summary and the script path. Leave the full input and the rewritten data out of the chat.
5. Project code the user asked to add stays in the repository. This directory is only for throwaway scripts.

---

# Rule: Subagent Delegation and Model Tiering

## Intent
Keep the parent session for orchestration, planning, spec review, and checking the result.

## Instructions
1. Do a small, single-step change in this chat.
2. For non-trivial implementation, refactoring, or multi-file edits, spawn a subagent (`TypeName: self`) using `Model: flash` (`gemini-3.8-flash-medium`).
3. For unit tests, `README.md` updates, or docstrings, spawn a subagent (`TypeName: self`) using `Model: flash_lite` (`gemini-3.8-flash-low`).
4. In the spawn prompt, tell the subagent to match existing style, keep the diff limited to the task, and report what changed and how it was checked.

## Constraints
- An implementation subagent matches existing style, keeps the diff limited to the task, and reports what changed and how it was checked.
- A documentation or test subagent follows the project's existing test and documentation style, and reports what it added and how it ran the tests.
