# 数据集指南

`Dataset` 是 ExpManner 的数据入口，负责数据加载、标签、预处理、可选约束、可选图和 ensemble 元数据。

## feature dataset

默认 `Kind="feature"`：

```matlab
ds = Dataset("Iris", Normalize="range");
```

核心成员：

| 成员 | 含义 |
| --- | --- |
| `ds.X` | 特征矩阵，通常为 `[features, samples]` |
| `ds.gnd` | `1 x n` 标签行向量 |
| `ds.numSamples` | 样本数 |
| `ds.dataLength` | vectorize 后的特征数 |
| `ds.numClasses` | 标签类别数 |

图像类数据可以由 loader 读取成 tensor，再按默认 `Vectorize=true` 展开为特征矩阵。

## 名称查询

```matlab
Dataset.names()
Dataset.registry()
Dataset.suggestName("iriss")
```

用途：

- `Dataset.names()` 查看可用名称。
- `Dataset.registry()` 查看 feature dataset registry。
- `Dataset.suggestName()` 处理拼写不确定的问题。

## 多数据集

`Dataset` 接受 string array，并返回 object array：

```matlab
datasets = Dataset(["Iris", "Wine"], Normalize="range");
mdl = Models.KMeans();
[bestStats, summary] = TaskManner.train(datasets, mdl, NumTrials=3);
```

这是小型 benchmark sweep 的推荐写法。

## 常用选项

| 选项 | 可选值或含义 |
| --- | --- |
| `Normalize` | `"null"`、`"range"`、`"L1"`、`"L2"` |
| `Vectorize` | 是否把样本展开为列向量 |
| `BuildGraph` | 是否构建 affinity graph |
| `GraphOptions` | 图构造参数 struct |
| `PosLabelRatio` | class-indicator 约束比例 |
| `NegLabelRatio` | pairwise cannot-link 约束比例 |
| `ConstraintSeed` | 约束采样 seed |

`Noise` 和 `Mask` 当前保留给后续版本。

## ensemble dataset

ensemble clustering 数据使用 `Kind="ensemble"`：

```matlab
names = Dataset.names(Kind="ensemble");
ds = Dataset(names(1), Kind="ensemble");
```

重要字段：

| 字段 | 含义 |
| --- | --- |
| `ds.ensemble.enabled` | 是否为 ensemble dataset |
| `ds.ensemble.members` | base clustering labels |
| `ds.ensemble.baseMemberships` | 每个 base clustering 的 membership matrix |
| `ds.ensemble.baseClusterCounts` | 每个 base clustering 的 cluster count |
| `ds.ensemble.numBaseClusterings` | base clustering 数量 |
| `ds.ensemble.featureMode` | 当前 feature 表示方式 |

当前 feature mode 是 `concatenatedMembership`，即把 base clustering labels 转成 membership features 后拼接为 `ds.X`。

## 数据根目录

默认数据根目录由 ExpManner 约定推断，也可以显式传入：

```matlab
ds = Dataset("Iris", DataRoot="<path-to-datasets>", Normalize="range");
```

public docs 中不要写真实私有路径。需要说明私有数据时，只写变量约定和 shape。

## 轻量信息快照

```matlab
info = ds.getInfo();
disp(info)
```

`getInfo()` 返回样本数、特征数、类别数、预处理选项、约束数量、图状态和 ensemble metadata。它适合在实验日志或调试输出中使用。
