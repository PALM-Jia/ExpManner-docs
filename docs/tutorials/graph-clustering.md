# 基于图的聚类

本教程用 `Models.KKM`、`Models.SymNMF` 和 `Models.LoRD` 展示 affinity graph 相关模型。

## 目标

完成后你将能够：

- 在 `Dataset` 中构建 affinity graph。
- 运行公开安全的 KKM、SymNMF 和 LoRD 示例模型。
- 理解基于图的模型如何复用同一个 benchmark 入口。
- 查看图状态和精简 summary。

## 前置条件

- 已能运行 [第一个 benchmark](first-benchmark.md)。
- MATLAB 当前会话能解析 `Dataset.my_get_affinity` 依赖的邻近搜索函数。

## 完整代码

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range", BuildGraph=true, ...
    GraphOptions=struct("WeightMode", "HeatKernel", "k", 5));
models = {Models.KKM(MaxIterations=10), Models.SymNMF(MaxIterations=10), ...
    Models.LoRD(MaxIterations=8, ProjectionIterations=200)};

[bestStats, summary] = TaskManner.train(ds, models, NumTrials=2, Seed=1);
disp(ds.getInfo())
disp(summary)
```

## 预期输出

- `ds.graph.S` 非空。
- `summary` 有三行，分别对应 `KKM`、`SymNMF` 和 `LoRD`。
- `KKM` 返回 labels；`SymNMF` 和 `LoRD` 返回 membership。

## 实测输出摘录

以下结果来自 `examples/docs/graphClusteringDoc.m`。

| hasAffinity | numSamples | numClasses | affinitySize |
| ---: | ---: | ---: | --- |
| 1 | 150 | 3 | `[150 150]` |

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | KKM | 2 | ACC | 1 | 0.94667 | 0.94333 | 0.82569 | 0.94333 | 0.84246 |
| Iris | SymNMF | 2 | ACC | 2 | 0.46 | 0.44333 | 0.056894 | 0.45667 | 0.048364 |
| Iris | LoRD | 2 | ACC | 1 | 0.46667 | 0.46 | 0.045064 | 0.46 | 0.037606 |

成功 marker：

```text
DOC_GRAPH_CLUSTERING_OK
```

## 图构建口径

示例使用 `Dataset(..., BuildGraph=true)` 构建图。模型内部也能在需要时临时构造 affinity graph，但教程中显式构造 `ds.graph.S`，便于调试和复核。

## 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| affinity 为空 | 构造数据集时没有启用 `BuildGraph=true` | 传入 `BuildGraph=true` 或让模型内部构图 |
| 图模型运行较慢 | 图构建和矩阵分解比 k-means 更重 | 先用 `Iris` 和小 `MaxIterations` 调通 |
| 指标低于预期 | 示例参数为教学口径 | 正式实验应在 private repo 中记录完整参数和数据边界 |

## 下一步

- 想看 ensemble 数据形态，读 [集成聚类](ensemble-clustering.md)。
- 想查结果文件，读 [结果管理](../result-management.md)。
