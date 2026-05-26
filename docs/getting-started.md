# Getting Started

Status: Minimum usable

This page guides a new user through the first successful ExpManner run.

## Prerequisites

- MATLAB installed locally.
- Access to the private `PALM-Jia/ExpManner` code repository.
- A local checkout of the repository.
- The repository root added to the MATLAB path for the current session.

Replace `<path-to-ExpManner>` with your local checkout path.

## Add ExpManner to the MATLAB Path

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));
```

ExpManner does not use a `+ExpManner` package namespace. After adding the root
folder to the path, use the short class names directly.

## Load the First Dataset

```matlab
ds = Dataset("Iris", Normalize="range");
disp(ds)
```

`Dataset("Iris")` loads a small public feature dataset. ExpManner stores data as
`[features, samples]` and labels as a `1 x n` positive-integer row vector.

## Run a Minimal Benchmark

```matlab
mdl = DemoModels.KMeans();
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
disp(summary)
```

`TaskManner.train` runs multiple initialization trials, evaluates clustering
metrics, and returns the best trial according to the default `ACC` metric.

## Run the Smoke Workflow

The smoke script runs several demo models and writes results under the local
`results/` folder:

```matlab
run(fullfile(expRoot, "examples", "smokeExpManner.m"));
```

Generated results are local artifacts. Do not commit `results/` to Git.

## Expected Outcome

A successful first run should:

- construct a `Dataset` object for `Iris`;
- run `DemoModels.KMeans`;
- display a summary table with metrics such as `ACC`, `NMI`, `PUR`, and `ARI`;
- complete the smoke workflow with `Smoke run completed.`

If MATLAB cannot find `Dataset` or `DemoModels.KMeans`, check that both
`expRoot` and `fullfile(expRoot, "examples")` were added to the path.
