# 第一个 benchmark

本教程用 `Iris + Models.KMeans` 完成第一次可记录 benchmark。

## 目标

完成后你将能够：

- 加载公开安全小数据集 `Iris`。
- 运行 3 次 trial。
- 启用 `Record=true` 写入结果。
- 使用 `Loader` 读取 experiment summary。

## 前置条件

- 已完成 [安装](../installation.md)。
- MATLAB 当前会话能解析 `Dataset` 和 `Models.KMeans`。
- 已知道 `<path-to-ExpManner>`。

## 完整代码

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = Models.KMeans();

resultRoot = fullfile(expRoot, "results", "docs-first-benchmark");
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=3, ...
    Seed=1, ...
    Record=true, ...
    ResultRoot=resultRoot, ...
    ExperimentName="firstBenchmark");

disp(summary)

T = Loader.loadExperimentSummary(resultRoot, ExperimentName="firstBenchmark");
disp(T)
```

## 预期输出

- `summary` 是一行 table。
- `T` 能读取刚写入的 experiment summary。
- `bestStats.getClusterLabels()` 能返回 `Iris` 样本的聚类标签。

## 实测输出摘录

以下结果来自维护者在 MATLAB 中运行 `examples/docs/firstBenchmarkDoc.m`，只保留适合公开展示的精简列。

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | KMeans | 3 | ACC | 1 | 0.96 | 0.96 | 0.86227 | 0.96 | 0.88567 |

成功 marker：

```text
DOC_FIRST_BENCHMARK_OK
```

## 生成文件

```text
results/docs-first-benchmark/
  index.csv
  train/KMeans/Iris/<runId>/
    manifest.json
    bestStats.mat
    runSummary.csv
    trialMetrics.csv
  experiments/firstBenchmark/
    index.csv
    summary.csv
```

这些文件是本地实验 artifact，不要提交到 Git。

## 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 找不到 `Models.KMeans` | 没有加入 `examples` | 运行 `addpath(fullfile(expRoot, "examples"))` |
| `summary.csv` 读取不到 | `ResultRoot` 或 `ExperimentName` 不一致 | 记录和读取时使用同一变量 |
| `results/` 出现在 Git 状态中 | benchmark 写入了本地 artifact | 不提交 `results/` |

## 下一步

- 想看矩阵分解模型，读 [矩阵分解聚类](factorization-clustering.md)。
- 想看图聚类模型，读 [基于图的聚类](graph-clustering.md)。
- 想接入自己的算法，读 [自定义模型](custom-model.md)。
- 想理解结果目录，读 [结果管理](../result-management.md)。
