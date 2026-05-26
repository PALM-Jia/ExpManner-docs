# Concepts

Status: Minimum usable

ExpManner organizes clustering experiments around a small set of stable
objects. The typical workflow is:

```text
Dataset -> Initializer -> Model.train -> ModelStats -> Metricer -> Recoder
                                  \-------------------------------> Loader
```

## Dataset

`Dataset` owns data loading, preprocessing, labels, optional constraints, and
optional graph construction. Data matrices use the shape `[features, samples]`.
Ground-truth labels are stored in `gnd` as a `1 x n` row vector.

ExpManner supports two dataset forms:

- `Kind="feature"` for ordinary feature matrices.
- `Kind="ensemble"` for ensemble clustering data with base clustering labels.

## Initializer and InitState

`Initializer` creates one `InitState` per trial. A model declares what it needs
through `requiredInitFields()`, for example `"labels"`, `"membership"`, or
`"factors.V"`.

Initialization uses local random streams so repeated trials can be reproduced
from seed information recorded in manifests.

## Model Interface

A model can use duck typing. It only needs:

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

The `train` method returns a `ModelStats` object. New models may optionally
inherit from `ModelBase` to reduce boilerplate, but inheritance is not required.

## ModelStats and Metricer

`ModelStats` records training history, model options, predictions, and extra
model outputs. Clustering labels can come from:

- `prediction.labels`
- `prediction.membership`
- `prediction.embedding`
- `prediction.affinity`

`Metricer` evaluates default clustering metrics such as `ACC`, `NMI`, `PUR`,
`ARI`, `F1`, `Pre`, and `Rec`.

## Recoder and Loader

When `Record=true`, `Recoder` writes structured artifacts under the selected
`ResultRoot`:

```text
results/
  index.csv
  train/<model>/<dataset>/<runId>/
    manifest.json
    bestStats.mat
    runSummary.csv
    trialMetrics.csv
  experiments/<experimentName>/
    index.csv
    summary.csv
```

`Loader` reads manifests, indexes, experiment summaries, run summaries, and best
trial artifacts. ExpManner does not create a root-level `results/summary.csv`.
