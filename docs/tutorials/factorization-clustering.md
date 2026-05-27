# 矩阵分解聚类

本教程用 `Models.NMF` 和 `Models.SymNMF` 展示 membership-returning 模型如何接入 ExpManner。

## 目标

完成后你将能够：

- 运行公开安全的 NMF 和 SymNMF 示例模型。
- 理解 `requiredInitFields()` 如何请求 `factors.U/V` 或 `membership`。
- 理解 `ModelStats.getClusterLabels()` 如何把 membership 转成聚类标签。
- 对比多个矩阵分解模型的 summary。

## 前置条件

- 已能运行 [第一个 benchmark](first-benchmark.md)。
- 已把 ExpManner 根目录和 `examples` 目录加入 MATLAB path。

## 完整代码

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
models = {Models.NMF(MaxIterations=10), Models.SymNMF(MaxIterations=10)};

[bestStats, summary] = TaskManner.train(ds, models, NumTrials=2, Seed=1);
disp(summary)
```

## 预期输出

- `summary` 有两行，分别对应 `NMF` 和 `SymNMF`。
- `bestStats` 是 cell，每个元素都是 `ModelStats`。
- 两个模型都通过 `prediction.membership` 给出聚类结果。

## 实测输出摘录

以下结果来自 `examples/docs/factorizationClusteringDoc.m`。

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | NMF | 2 | ACC | 1 | 0.64 | 0.59 | 0.21906 | 0.59 | 0.19820 |
| Iris | SymNMF | 2 | ACC | 2 | 0.46 | 0.44333 | 0.056894 | 0.45667 | 0.048364 |

成功 marker：

```text
DOC_FACTORIZATION_CLUSTERING_OK
```

## 模型接口要点

`Models.NMF` 使用：

```matlab
requiredInitFields() -> ["factors.U", "factors.V"]
```

`Models.SymNMF` 使用：

```matlab
requiredInitFields() -> "membership"
```

两个模型都继承可选 `ModelBase`，只实现 protected `fit(ds, initState)`。`fit` 返回轻量 struct，`ModelBase` 负责生成标准 `ModelStats`。

## 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| membership 维度错误 | `membership` 不能解释为 `numClasses x numSamples` 或转置 | 检查 `fit` 输出形状 |
| 指标很低 | toy 参数只用于展示接口 | 不把示例指标当正式 benchmark |
| 找不到 `Models.NMF` | 没有加入 `examples` | 运行 `addpath(fullfile(expRoot, "examples"))` |

## 下一步

- 想看 affinity graph，读 [基于图的聚类](graph-clustering.md)。
- 想写自己的模型，读 [自定义模型](custom-model.md)。
