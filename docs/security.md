# Security

Status: Public guide

ExpManner is a private PALM Jia research code repository with a public
documentation site. Security and privacy issues are handled through private
maintainer channels, not public disclosure.

## What to Report

Report any concern involving:

- Credentials, tokens, secrets, or access keys.
- Private data paths, private datasets, or generated result artifacts.
- Unpublished experiment tables, model comparisons, or paper-sensitive results.
- Sensitive implementation details exposed in public documentation.
- Unsafe file-writing behavior.
- Dependency or toolbox risks that affect reproducibility or confidentiality.

## How to Report

Use a private GitHub issue in the code repository, a direct message to the
maintainer, or the PALM Jia internal communication channel.

Include, when possible:

- The affected file, page, commit, or workflow.
- Whether the issue is public or only internal.
- Whether credentials or private data were exposed.
- Suggested immediate containment steps.

## Handling Expectations

- Do not disclose the issue publicly before maintainer review.
- If a credential is exposed, revoke or rotate it immediately.
- If private data or unpublished results are exposed, remove access first, then
  repair documentation or Git history as needed.
- Only the current `main` branch is maintained unless a maintainer creates a
  release branch.

## Public Docs Safety Check

Before publishing docs, check for obvious sensitive strings:

```powershell
rg -n --hidden --glob '!site/**' --glob '!.git/**' --glob '!.venv/**' `
  'token|secret|password|private path|unpublished|credential'
```

This is a guardrail, not a substitute for human review.
