# Personal OpenCode Instructions

## Workflow
- Prefer running tasks through `just` recipes when a `justfile` is present and the recipe fits the task.
- Before using raw commands for common workflows like build, test, lint, format, or deploy, check the `justfile` for an existing recipe.
- If no suitable `just` recipe exists, use the direct command that best matches the project's existing tooling.

## Clarification
- Ask for clarification when requirements are ambiguous, missing, or could reasonably lead to different implementations.
- Do not make important assumptions when a short question would avoid rework.
- If a safe default is obvious and low-risk, you may proceed, but call out the assumption clearly.

## Changes
- Follow existing project conventions and file structure.
- Prefer minimal, targeted changes over broad rewrites.
- Avoid changing unrelated files unless the task requires it.
- Do not worry about backwards compatability unless I specifically ask for it.

## Validation
- When making code or config changes, run the most relevant validation commands available.
- Prefer project-defined validation commands from `justfile` when available.
