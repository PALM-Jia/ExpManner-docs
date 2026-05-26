# Contributing

Status: Public guide

ExpManner is maintained as a PALM Jia internal research framework. Code access
requires authorization, while this documentation site is public.

## Access Model

Organization teams are used instead of ad hoc repository permissions:

| Team | Role |
| --- | --- |
| `maintainers` | Repository administration, releases, reviews, and policy |
| `contributors` | Implementation branches and pull requests |
| `members` | Internal read access and issue discussion |
| `docs` | Documentation triage and documentation pull requests |

Ask a maintainer for the appropriate team assignment before contributing to the
private code repository.

## Workflow

1. Create a focused branch from `main`.
2. Keep each pull request about one topic.
3. Update canonical documentation when behavior, interfaces, paths, or project
   rules change.
4. Run the relevant validation commands.
5. Open a pull request with a concise summary and validation notes.

Suggested branch names:

```text
feature/custom-model-tutorial
fix/ensemble-loader-error
docs/getting-started
```

## Validation

For MATLAB code changes, run the standard validation from the private code repo
root:

```matlab
expRoot = "<path-to-ExpManner>";
cd(expRoot)
clear classes
addpath(expRoot)
runtests("tests")
run("examples/smokeExpManner.m")
```

For code changes, also run MATLAB Code Analyzer over core files, class folders,
examples, and tests.

For documentation-only changes in this public docs repo:

```powershell
.\.venv\Scripts\python -m mkdocs build --strict
git diff --check
```

If you changed Pages workflow files, confirm that the GitHub Actions deploy run
passes after pushing.

## Documentation Synchronization

The private code repository remains the canonical source for:

- `README.md`: entry-point usage and current status.
- `AGENTS.md`: durable collaboration and repository rules.
- `doc_plan.md`: documentation milestones and release notes for this docs site.
- `CONTRIBUTING.md`: full internal contribution policy.
- `SECURITY.md`: full internal security handling policy.
- `CITATION.cff`: citation metadata.

This public documentation site should mirror only the public-safe subset.

## Public Boundary

Do not publish:

- Credentials, tokens, or secrets.
- Private absolute paths.
- Private dataset files or dataset locations.
- Generated experiment artifacts.
- Internal benchmark tables or unpublished result comparisons.
- Sensitive implementation details from project-side models.

Use placeholders such as `<path-to-ExpManner>` in public examples.

## Pull Request Checklist

Before requesting review:

- The page builds locally with `mkdocs build --strict`.
- `git diff --check` has no whitespace errors.
- Links added in navigation are reachable.
- Code blocks use the current `ExpManner` naming.
- Any source links to the private code repo clearly require authorization.
- Public docs do not expose sensitive or unpublished material.
