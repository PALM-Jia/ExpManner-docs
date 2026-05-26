# ExpManner Documentation

This repository hosts the public documentation site for ExpManner, a MATLAB
framework for future clustering research experiments.

- Documentation site: https://palm-jia.github.io/ExpManner-docs/
- Private code repository: https://github.com/PALM-Jia/ExpManner

The code repository is private and requires PALM Jia authorization. This public
documentation repository must not contain private datasets, credentials, server
information, unpublished experiment results, or sensitive implementation
details.

## Local Preview

```powershell
python -m venv .venv
.\.venv\Scripts\python -m pip install -r requirements.txt
.\.venv\Scripts\python -m mkdocs serve
```

## Deployment

The site is deployed to GitHub Pages with GitHub Actions.
