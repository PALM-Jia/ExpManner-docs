# Custom Model

Status: Public guide

This tutorial shows the two recommended ways to connect a project-side
clustering model to ExpManner:

- A plain duck-typed class that returns `ModelStats`.
- A compact `ModelBase` subclass that returns a small struct from `fit`.

The examples below are intentionally small. They are meant as templates for
private or unpublished algorithms without exposing their implementation.

## 1. Create a Duck-Typed Model

Create a class on your MATLAB path, for example `MyKMeansLike.m`.

```matlab
classdef MyKMeansLike
    properties
        name (1, 1) string = "MyKMeansLike"
        maxIterations (1, 1) double = 100
    end

    methods
        function fields = requiredInitFields(~)
            fields = "labels";
        end

        function stats = train(obj, ds, initState)
            labels = myClusteringRoutine(ds.X, initState.labels, ...
                ds.numClasses, obj.maxIterations);

            history = ModelStats.emptyHistory();
            prediction = struct("labels", labels(:)');
            stats = ModelStats( ...
                ModelName=obj.name, ...
                DatasetName=ds.name, ...
                NumClasses=ds.numClasses, ...
                History=history, ...
                Prediction=prediction, ...
                Options=struct("maxIterations", obj.maxIterations));
        end
    end
end
```

Replace `myClusteringRoutine` with your algorithm. The important part is the
interface: `requiredInitFields()` declares the initialization, and `train`
returns `ModelStats`.

## 2. Test the Model in One Trial

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);

ds = Dataset("Iris", Normalize="range");
mdl = MyKMeansLike();

[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=1);
disp(summary)
labels = bestStats.getClusterLabels();
```

Start with one trial while checking an integration. Increase `NumTrials` only
after the model produces valid labels.

## 3. Use ModelBase for Less Boilerplate

When you inherit from `ModelBase`, implement a protected `fit` method. The
public `train` method is inherited.

```matlab
classdef MyCompactModel < ModelBase
    properties
        maxIterations (1, 1) double = 100
    end

    methods
        function fields = requiredInitFields(~)
            fields = "labels";
        end
    end

    methods (Access = protected)
        function out = fit(obj, ds, initState)
            labels = myClusteringRoutine(ds.X, initState.labels, ...
                ds.numClasses, obj.maxIterations);

            out = struct();
            out.labels = labels(:)';
            out.objective = NaN;
            out.delta = NaN;
        end
    end
end
```

`ModelBase` converts the struct into `ModelStats`, fills the model name and
dataset name, exports readable public properties as options, and records
training time.

## 4. Return Membership Instead of Labels

Factorization models often produce a membership matrix. Use
`numClasses x numSamples` orientation:

```matlab
out = struct();
out.membership = V;
out.objective = objectiveTrace;
out.delta = deltaTrace;
```

`ModelStats.getClusterLabels()` converts membership to hard labels by taking the
largest class membership for each sample.

## 5. Run Multiple Trials and Record Results

```matlab
resultRoot = fullfile(expRoot, "results", "my-model-check");
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=5, ...
    Seed=1, ...
    Record=true, ...
    ResultRoot=resultRoot, ...
    ExperimentName="myModelCheck");
```

Result files are local artifacts. Keep them out of Git, especially when they
contain unpublished model behavior or private data names.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| `missingModelName` | `mdl.name` is empty or unavailable |
| `invalidModelInterface` | `requiredInitFields` or `train` is missing |
| `invalidStats` | A duck-typed model returned a struct instead of `ModelStats` |
| `missingPrediction` | `ModelBase.fit` did not return labels, membership, embedding, affinity, or prediction |
| Unexpected metric errors | `bestStats.getClusterLabels()` cannot derive sample labels |

For a working reference, inspect the demo models in the private code repository
after you have PALM Jia access.
