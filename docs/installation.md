# Installation

Status: Minimum usable

ExpManner is a source checkout used from MATLAB path. It is not installed as a
toolbox and does not require a `+ExpManner` package namespace.

## MATLAB Version

Current development validation uses MATLAB R2025b. The minimum-support goal is
MATLAB R2024b, but local R2024b environment issues have been observed and should
be treated as environment blockers unless reproduced in a clean install.

## Get the Code

The source repository is private:

```text
https://github.com/PALM-Jia/ExpManner
```

Access requires PALM Jia authorization. Clone the repository to a local folder,
then use that folder as `<path-to-ExpManner>` in examples.

## Path Setup

For a normal session:

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));
```

Library code does not call `addpath` for you. Scripts and tests add paths only
at their entry point.

## Data Root

Built-in dataset loaders use the framework's default data-root convention. Keep
private datasets outside this public documentation. When documenting a private
project, describe the expected data shape and variables without exposing local
paths or unpublished data locations.

## Quick Health Check

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = DemoModels.KMeans();
[~, summary] = TaskManner.train(ds, mdl, NumTrials=1);
disp(summary)
```

If this succeeds, the core path setup is working.
