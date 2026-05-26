# Model Interface

Status: Public guide

ExpManner keeps the model boundary small. A clustering model can be either a
plain MATLAB object that follows the expected methods, or a subclass of
`ModelBase` that lets ExpManner build the `ModelStats` object for you.

## Duck-Typed Contract

A duck-typed model needs three public members:

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

`TaskManner.train` checks these members before running trials. The model does
not need to inherit from an ExpManner class.

## Initialization Requirements

`requiredInitFields()` tells `Initializer` what to create for each trial.
Supported public fields are:

| Field | InitState member | Typical use |
| --- | --- | --- |
| `"labels"` | `initState.labels` | k-means style label starts |
| `"membership"` | `initState.membership` | soft assignment starts |
| `"factors.U"` | `initState.factors.U` | factor model basis |
| `"factors.V"` | `initState.factors.V` | factor model coefficients |

Return an empty string array when a model does not need random initialization:

```matlab
function fields = requiredInitFields(~)
    fields = string.empty();
end
```

## Training Output

A duck-typed model's `train(ds, initState)` method must return a `ModelStats`
object.

```matlab
prediction = struct("labels", labels(:)');
stats = ModelStats( ...
    ModelName=obj.name, ...
    DatasetName=ds.name, ...
    NumClasses=ds.numClasses, ...
    History=history, ...
    Prediction=prediction, ...
    Options=struct("maxIterations", obj.maxIterations));
```

`history` should be a table with the standard columns returned by
`ModelStats.emptyHistory()`:

| Column | Meaning |
| --- | --- |
| `iter` | Iteration number |
| `objective` | Objective value or score |
| `delta` | Change from the previous iteration |
| `runtime` | Elapsed runtime in seconds |
| `extra` | Per-iteration metadata cell |

## Prediction Fields

`ModelStats.getClusterLabels()` can derive labels from any one of these fields:

| Prediction field | Shape expectation |
| --- | --- |
| `labels` | `1 x numSamples` or convertible vector |
| `membership` | `numClasses x numSamples` |
| `embedding` | `numSamples x dim`, discretized by k-means |
| `affinity` | `numSamples x numSamples`, discretized by spectral clustering |

For the clearest first integration, return `prediction.labels`. Use
`prediction.membership` for NMF-like models where cluster assignment comes from
the largest membership row.

## Optional ModelBase

New wrappers can inherit from `ModelBase` and implement only a protected
`fit(ds, initState)` method. `ModelBase.train` measures runtime, builds
history, normalizes membership orientation, and returns `ModelStats`.

```matlab
classdef MyModel < ModelBase
    methods
        function fields = requiredInitFields(~)
            fields = "labels";
        end
    end

    methods (Access = protected)
        function out = fit(obj, ds, initState)
            labels = myAlgorithm(ds.X, initState.labels, ds.numClasses);
            out = struct("labels", labels(:)');
        end
    end
end
```

`fit` may return either a scalar struct or a complete `ModelStats` object. For a
struct output, include at least one prediction field: `labels`, `membership`,
`embedding`, `affinity`, or a nested `prediction` struct.

Common struct fields recognized by `ModelBase`:

| Field | Effect |
| --- | --- |
| `labels`, `membership`, `embedding`, `affinity` | Added to `prediction` |
| `objective`, `delta`, `runtime`, `iter` | Used to build `history` |
| `history` | Used directly when supplied |
| `hp`, `options`, `extra` | Copied into `ModelStats` |
| `objectiveMode` | Stored as `"minimize"` or another model-specific mode |

## Common Integration Checks

- Keep the model object scalar.
- Make `name` non-empty and stable because it becomes part of result paths.
- Return `ModelStats` from duck-typed models.
- Return labels as sample-level assignments, not class-level summaries.
- Keep `membership` as `numClasses x numSamples`; `ModelBase` also accepts the
  transposed form and normalizes it.
- Avoid writing result files inside the model. Let `TaskManner.train` and
  `Recoder` handle recording when `Record=true`.
