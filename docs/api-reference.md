# API Reference

Status: Public guide

This is a lightweight public API index. The code repository is private, so
source links require PALM Jia authorization. This page describes stable entry
points and common methods without copying large source sections.

## Core Classes

| Class | Responsibility | Common entry points |
| --- | --- | --- |
| `Dataset` | Load clustering datasets, preprocess features, hold labels and optional metadata | `Dataset(...)`, `Dataset.names`, `Dataset.registry`, `Dataset.ensembleRegistry`, `Dataset.suggestName`, `getInfo`, `makeAffinity` |
| `Initializer` | Build one `InitState` per trial based on model requirements | `Initializer.forModel`, `Initializer.forFields` |
| `InitState` | Store random labels, memberships, factor starts, and init metadata | `InitState(...)`, `hasField` |
| `ModelBase` | Optional base class for compact model wrappers | `requiredInitFields`, inherited `train`, protected `fit` in subclasses |
| `ModelStats` | Store model output, history, options, and predictions | `ModelStats(...)`, `getClusterLabels`, `emptyHistory` |
| `TaskManner` | Orchestrate dataset-model-trial training | `TaskManner.train` |
| `Metricer` | Evaluate clustering metrics and choose best trial | `Metricer(...)`, `evaluateTrials` |
| `Recoder` | Write manifests, summaries, indexes, and best-trial artifacts | `Recoder(...)`, `saveTrainResult`, `defaultResultRoot` |
| `Loader` | Read recorded manifests, summaries, indexes, and artifacts | `loadExperimentSummary`, `filterIndex`, `filterSummary`, `loadStats` |
| `Visualizer` | Provide lightweight visualization helpers | `plotHPgrid` |

## Dataset

```matlab
ds = Dataset("Iris", Normalize="range");
datasets = Dataset(["Iris", "Wine"], Normalize="range");
names = Dataset.names();
```

Use `Kind="feature"` for feature matrices and `Kind="ensemble"` for ensemble
clustering data. `Dataset` data matrices use `[features, samples]`; labels are
stored as a `1 x n` row vector.

Private source link: [Dataset.m](https://github.com/PALM-Jia/ExpManner/blob/main/Dataset.m)

## Training

```matlab
mdl = DemoModels.KMeans();
[bestStats, summary, metricer] = TaskManner.train(ds, mdl, NumTrials=3);
```

`TaskManner.train` accepts a scalar dataset, a dataset object array, a scalar
model, a model object array, or a model cell array. It returns the best
`ModelStats`, a summary table, and the `Metricer` used for evaluation.

Private source links:

- [TaskManner.m](https://github.com/PALM-Jia/ExpManner/blob/main/TaskManner.m)
- [Initializer.m](https://github.com/PALM-Jia/ExpManner/blob/main/Initializer.m)
- [InitState.m](https://github.com/PALM-Jia/ExpManner/blob/main/InitState.m)

## Model Output

`ModelStats` stores:

- `modelName`, `datasetName`, and `numClasses`.
- `history`, a table with iteration-level information.
- `prediction`, containing labels, membership, embedding, or affinity.
- `hp`, `options`, and `extra` metadata.
- `trainTime`.

```matlab
labels = bestStats.getClusterLabels();
history = bestStats.history;
```

Private source links:

- [ModelStats.m](https://github.com/PALM-Jia/ExpManner/blob/main/ModelStats.m)
- [ModelBase.m](https://github.com/PALM-Jia/ExpManner/blob/main/ModelBase.m)

## Results

```matlab
T = Loader.loadExperimentSummary(resultRoot, ExperimentName="firstBenchmark");
idx = Loader.filterIndex(resultRoot, Dataset="Iris", Model="DemoKMeans");
```

Recorded output is organized under the selected `ResultRoot`:

```text
results/
  index.csv
  train/<model>/<dataset>/<runId>/
  experiments/<experimentName>/
```

Private source links:

- [Recoder.m](https://github.com/PALM-Jia/ExpManner/blob/main/Recoder.m)
- [Loader.m](https://github.com/PALM-Jia/ExpManner/blob/main/Loader.m)

## Utilities

`Metricer` and `utils` use MATLAB class-folder layout:

```text
@Metricer/Metricer.m
@utils/utils.m
```

The class files declare the method surface. Individual method implementations
live in separate files in the same class folders.

Typical utility entry points:

- `Metricer.accuracy`
- `Metricer.myNMI`
- `Metricer.pairwiseNMI`
- `utils.labelsToMembership`
- `utils.membershipToLabel`
- `utils.proj2simplex`
- `utils.hungarian`

Private source links:

- [@Metricer](https://github.com/PALM-Jia/ExpManner/tree/main/%40Metricer)
- [@utils](https://github.com/PALM-Jia/ExpManner/tree/main/%40utils)

## Access Note

If a GitHub source link returns 404, sign in with an account that has been
granted access to `PALM-Jia/ExpManner`.
