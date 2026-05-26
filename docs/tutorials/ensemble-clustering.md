# Ensemble Clustering

Status: Public guide

ExpManner supports ensemble clustering datasets through `Dataset(...,
Kind="ensemble")`. This tutorial explains the data shape and a public-safe
workflow. It does not list private data locations or unpublished benchmark
results.

## 1. Inspect Available Ensemble Datasets

```matlab
addpath("<path-to-ExpManner>");

names = Dataset.names(Kind="ensemble");
disp(names)
```

The list depends on the `.mat` files available under your configured data root.
If the list is empty, no ensemble datasets are installed for that environment.

## 2. Load One Ensemble Dataset

```matlab
ds = Dataset(names(1), Kind="ensemble");
info = ds.getInfo();
disp(info)
```

Expected high-level properties:

- `ds.kind` is `"ensemble"`.
- `ds.X` is a derived feature representation.
- `ds.gnd` is the ground-truth label vector.
- `ds.ensemble.members` stores base clustering labels.
- `ds.ensemble.numBaseClusterings` reports the number of base clusterings.

## 3. Understand the Members Matrix

The source `.mat` file is expected to contain public variables named `gt` and
`members`.

Conceptually:

```text
gt       -> ground-truth labels
members  -> base clustering labels for the same samples
```

ExpManner converts base cluster labels into membership features and stores
supporting metadata in `ds.ensemble`.

```matlab
size(ds.ensemble.members)
ds.ensemble.baseClusterCounts
ds.ensemble.featureMode
```

The current feature mode is `"concatenatedMembership"`.

## 4. Run a Model on Ensemble Features

Any model that accepts a `Dataset` can run on ensemble features. Start with a
small trial count:

```matlab
mdl = DemoModels.KMeans();
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
disp(summary)
```

This evaluates the derived ensemble feature matrix with the usual clustering
metrics.

## 5. Run Multiple Ensemble Datasets

```matlab
datasets = Dataset(names(1:min(3, numel(names))), Kind="ensemble");
mdl = DemoModels.KMeans();

[bestStats, summary] = TaskManner.train(datasets, mdl, NumTrials=3);
disp(summary)
```

Use this pattern for internal sweeps. For public reports, summarize only data
and results that are cleared for release.

## Public Documentation Boundary

Safe to publish:

- The `Kind="ensemble"` loading pattern.
- The expected `gt` and `members` variables.
- Shape conventions and metadata fields.
- Reproducible code that uses placeholder paths or public data.

Keep private:

- Local absolute data paths.
- Internal benchmark result tables.
- Dataset files that are not redistributable.
- Unpublished model comparisons or ablation results.
