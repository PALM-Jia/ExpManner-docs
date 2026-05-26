# ExpManner

Status: Minimum usable

ExpManner is a MATLAB framework for future clustering research experiments,
benchmarking, result recording, and reusable model evaluation.

This public documentation site is paired with the private
`PALM-Jia/ExpManner` code repository. Access to the code repository requires
PALM Jia authorization.

## What ExpManner Is

ExpManner focuses on clustering experiments. It standardizes a small set of
repeatable research tasks:

- loading feature and ensemble clustering datasets;
- creating trial initialization states;
- running dataset-model benchmarks;
- evaluating common clustering metrics;
- recording run manifests, summaries, and best-trial artifacts.

ExpManner is not intended to be a general machine-learning framework for all
task types. It is also not a package namespace: users add the repository root to
the MATLAB path and then use short class names such as `Dataset`, `TaskManner`,
`Metricer`, and `ModelStats`.

## Start Here

1. Read [Installation](installation.md) to prepare MATLAB and local paths.
2. Follow [Getting Started](getting-started.md) to run the first commands.
3. Read [Concepts](concepts.md) to understand the core workflow.
4. Run [First Benchmark](tutorials/first-benchmark.md) for the first recorded
   experiment.

## Public Boundary

This site intentionally avoids private datasets, unpublished experiment results,
credentials, server information, and sensitive internal implementation details.

The public documentation can explain interfaces and runnable toy examples, but
the source code remains in the private `PALM-Jia/ExpManner` repository.
