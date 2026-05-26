# Dataset Guide

Status: Public guide

`Dataset` is the public entry point for data loading and per-dataset metadata.
ExpManner currently uses ordinary MATLAB folder style. After adding the project
root to the MATLAB path, construct datasets directly with `Dataset(...)`.

```matlab
addpath("<path-to-ExpManner>");
ds = Dataset("Iris", Normalize="range");
```

Do not use package-qualified dataset calls. ExpManner is loaded as an ordinary
MATLAB folder on the path.

## Feature Datasets

Feature datasets use `Kind="feature"` by default.

```matlab
ds = Dataset("Iris", Kind="feature", Normalize="range");
```

The loaded data follows these conventions:

| Member | Meaning |
| --- | --- |
| `ds.X` | Feature matrix, usually `[features, samples]` |
| `ds.gnd` | Ground-truth labels as a `1 x n` row vector |
| `ds.numSamples` | Number of samples |
| `ds.dataLength` | Number of features after vectorization |
| `ds.numClasses` | Number of unique labels |

Image-like datasets may be loaded as tensors and then vectorized. The default
is `Vectorize=true`.

## Dataset Registry

Inspect available built-in feature names with:

```matlab
Dataset.names()
Dataset.registry()
```

`Dataset.registry()` returns a table with public metadata such as dataset name,
file name, variable names, label interpretation, orientation, and description.

To diagnose a typo:

```matlab
Dataset.suggestName("iriss")
```

## Multiple Datasets

`Dataset` accepts a string array and returns an object array.

```matlab
datasets = Dataset(["Iris", "Wine"], Normalize="range");
mdl = DemoModels.KMeans();

[bestStats, summary] = TaskManner.train(datasets, mdl, NumTrials=3);
```

This is useful for small benchmark sweeps. Keep public examples limited to
datasets that readers can access.

## Preprocessing Options

Common public options:

| Option | Values |
| --- | --- |
| `Normalize` | `"null"`, `"range"`, `"L1"`, `"L2"` |
| `Vectorize` | `true`, `false` |
| `BuildGraph` | `true`, `false` |
| `GraphOptions` | Struct passed to graph construction |
| `PosLabelRatio` | Ratio for class-indicator constraints |
| `NegLabelRatio` | Ratio for pairwise cannot-link constraints |
| `ConstraintSeed` | Seed for constraint sampling |

`Noise` and `Mask` are reserved for a later version.

## Ensemble Datasets

Ensemble datasets use `Kind="ensemble"`.

```matlab
ensembleNames = Dataset.names(Kind="ensemble");
ds = Dataset(ensembleNames(1), Kind="ensemble");
```

An ensemble dataset stores base clustering outputs in `ds.ensemble` and exposes
a feature representation in `ds.X`. The current feature mode is concatenated
membership.

Important ensemble fields:

| Field | Meaning |
| --- | --- |
| `ds.ensemble.enabled` | Whether this is an ensemble dataset |
| `ds.ensemble.members` | Base clustering labels |
| `ds.ensemble.baseMemberships` | One membership matrix per base clustering |
| `ds.ensemble.baseClusterCounts` | Cluster count of each base clustering |
| `ds.ensemble.numBaseClusterings` | Number of base clusterings |
| `ds.ensemble.featureMode` | Feature construction mode |

The ensemble registry scans `.mat` files under the configured data root and only
registers files with the expected public variables.

## Data Root

By default, ExpManner looks for a sibling `datasets` folder next to the project
root. You can override it without changing global MATLAB state:

```matlab
ds = Dataset("Iris", DataRoot="<path-to-datasets>", Normalize="range");
```

For public tutorials, avoid hard-coding local absolute paths. Use placeholders
or environment-specific setup instructions.

## Metadata Snapshot

Use `getInfo()` when you need a lightweight summary:

```matlab
info = ds.getInfo();
disp(info)
```

This returns core size information, preprocessing choices, constraint counts,
graph status, and ensemble metadata when relevant.
