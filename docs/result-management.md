# 结果管理

ExpManner 把单次 run artifact 和 experiment summary 分开保存，避免在根目录堆积混乱的结果文件。

## 目标

阅读本页后你应该知道：

- `ResultRoot` 表示什么。
- 单次 dataset-model run 保存在哪里。
- experiment summary 保存在哪里。
- 如何用 `Loader` 读取结果。
- 哪些结果文件不能提交到 Git。

## 写入结果

```matlab
resultRoot = fullfile(expRoot, "results", "docs-first-benchmark");
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=3, ...
    Record=true, ...
    ResultRoot=resultRoot, ...
    ExperimentName="firstBenchmark");
```

`ResultRoot` 是结果仓库根目录，不是某一次 run 的目录。

## 目录结构

典型结构：

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

说明：

- `train/<model>/<dataset>/<runId>/` 保存一次 dataset-model run 的 artifact。
- `manifest.json` 保存运行元数据。
- `bestStats.mat` 保存 best trial 的完整 `ModelStats`。
- `runSummary.csv` 保存该 run 的汇总行。
- `trialMetrics.csv` 保存每个 trial 的指标。
- `experiments/<experimentName>/summary.csv` 保存实验级汇总。

ExpManner 不生成根目录 `results/summary.csv`。

## 读取 summary

```matlab
T = Loader.loadExperimentSummary(resultRoot, ExperimentName="firstBenchmark");
disp(T)
```

按条件过滤：

```matlab
idx = Loader.filterIndex(resultRoot, Dataset="Iris", Model="DemoKMeans");
summary = Loader.filterSummary(resultRoot, ExperimentName="firstBenchmark");
```

读取 best stats：

```matlab
manifest = Loader.loadManifest("<path-to-manifest.json>");
stats = Loader.loadStats(manifest.artifact.bestStats);
```

## 不要提交的内容

不要把以下内容提交到 Git：

- `results/` 下的生成文件。
- `bestStats.mat` 等 heavy artifact。
- 包含私有数据集名称、内部指标或论文敏感结果的 CSV。
- 临时调试输出。

如果需要公开某个结果，应先确认数据、模型、参数和指标都已经允许公开，再单独整理成 release artifact 或论文附录材料。

## 常见问题

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 找不到 `summary.csv` | 没有传入相同的 `ExperimentName` | 检查记录和读取时的实验名 |
| 根目录没有 `results/summary.csv` | 当前设计不再生成这个旧文件 | 读取 `experiments/<experimentName>/summary.csv` |
| `bestStats.mat` 很大 | 它保存 best trial 的完整对象 | 不提交，只在本地复现实验时使用 |
| 结果路径不符合预期 | `ResultRoot` 指向了别的目录 | 显式传入 `ResultRoot` 并打印确认 |
