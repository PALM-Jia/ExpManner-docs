# First Benchmark

Status: Minimum usable

This tutorial runs a small public-safe benchmark with `Iris` and
`DemoModels.KMeans`.

## 1. Prepare the MATLAB Session

Replace `<path-to-ExpManner>` with your local checkout path.

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));
```

## 2. Load a Dataset

```matlab
ds = Dataset("Iris", Normalize="range");
```

`Iris` is small enough for a first benchmark and does not require private data.

## 3. Create a Demo Model

```matlab
mdl = DemoModels.KMeans();
```

The demo model exposes the standard model interface and requests random label
initialization.

## 4. Run Three Trials

```matlab
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
disp(summary)
```

The returned `summary` table contains one row for the dataset-model pair and
reports metrics such as `ACC`, `NMI`, `PUR`, `ARI`, `F1`, `Pre`, and `Rec`.

## 5. Record Results

To write a local result folder, pass `Record=true` and a local `ResultRoot`:

```matlab
resultRoot = fullfile(expRoot, "results", "docs-first-benchmark");
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3, ...
    Record=true, ResultRoot=resultRoot, ExperimentName="firstBenchmark");
```

The generated files are local experiment artifacts. Keep them out of Git.

Expected structure:

```text
results/docs-first-benchmark/
  index.csv
  train/DemoKMeans/Iris/<runId>/
    manifest.json
    bestStats.mat
    runSummary.csv
    trialMetrics.csv
  experiments/firstBenchmark/
    index.csv
    summary.csv
```

## 6. Read the Experiment Summary

```matlab
T = Loader.loadExperimentSummary(resultRoot, ExperimentName="firstBenchmark");
disp(T)
```

This confirms that the recorded experiment summary can be loaded without
opening the heavy `bestStats.mat` artifact.
