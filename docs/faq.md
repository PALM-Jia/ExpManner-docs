# FAQ

Status: Public guide

## Why is there no package namespace?

ExpManner currently uses ordinary MATLAB folder style. Add the repository root
to the MATLAB path and call classes directly:

```matlab
addpath("<path-to-ExpManner>");
ds = Dataset("Iris");
```

This keeps scripts short and avoids carrying an older package layout forward.

## Is ModelBase required?

No. Model duck typing remains supported. A model only needs:

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

`ModelBase` is an optional convenience layer for new wrappers that can return a
small struct from `fit(ds, initState)`.

## Where should project-side models live?

Keep project-specific models outside the framework core directory. The private
code repository includes examples under `examples/+DemoModels` and
`examples/+LRDSCAdapters`, but real research models should live in their own
project package or project repository.

## Why are Metricer and utils class folders?

`@Metricer` and `@utils` use MATLAB class-folder layout so the public method
surface stays clear while each method implementation remains in a separate file.
The class files act as declarations and aggregation points.

## Why does the docs site stay public while code is private?

The first release uses a private code repository and a public documentation
repository. This lets collaborators read onboarding and interface docs without
publishing internal code, data paths, or unpublished results.

## Why should results not be committed?

Generated results may contain dataset names, model options, metrics, and
paper-sensitive outputs. They are local experiment artifacts and should stay out
of Git unless a maintainer explicitly approves a release location.

## Which MATLAB version should I use?

The current validated development environment is MATLAB R2025b. R2024b remains
a support target, but local MATLAB installation issues should be separated from
framework compatibility issues.

## What if a private source link returns 404?

Sign in with a GitHub account that has access to `PALM-Jia/ExpManner`. Public
docs links to source files require PALM Jia authorization.

## Can I publish an internal tutorial or benchmark?

Only after reviewing the public boundary. Do not publish private data
locations, generated artifacts, internal benchmark tables, or unpublished
result comparisons in this public docs repo.
