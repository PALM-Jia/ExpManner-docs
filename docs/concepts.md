# 核心概念

ExpManner 把聚类实验拆成少量稳定对象。理解这些对象后，接入新模型和复现实验会简单很多。

## 主流程

```text
Dataset -> Initializer -> Model.train -> ModelStats -> Metricer -> Recoder
                                  \-------------------------------> Loader
```

含义：

- `Dataset` 负责数据、标签、可选约束和可选图。
- `Initializer` 根据模型声明生成每个 trial 的 `InitState`。
- 模型的 `train(ds, initState)` 产出 `ModelStats`。
- `Metricer` 从 `ModelStats` 中取标签并计算指标。
- `Recoder` 在 `Record=true` 时写入结构化结果。
- `Loader` 读取 manifest、summary、index 和 best stats。

## Dataset

`Dataset` 是数据入口。核心约定：

- `ds.X` 通常是 `[features, samples]`。
- `ds.gnd` 是 `1 x n` 的标签行向量。
- `Kind="feature"` 表示普通特征数据。
- `Kind="ensemble"` 表示集成聚类数据。

常用调用：

```matlab
ds = Dataset("Iris", Normalize="range");
datasets = Dataset(["Iris", "Wine"], Normalize="range");
names = Dataset.names();
```

## InitState

模型通过 `requiredInitFields()` 声明需要哪些初始化变量，例如：

```matlab
fields = "labels";
fields = ["factors.U", "factors.V"];
```

`Initializer` 会为每个 trial 创建一个 `InitState`，并记录 seed、trial 编号和初始化字段。这样 summary 与 manifest 能追踪随机性来源。

## 模型接口

模型可以采用 duck typing，只要提供：

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

新模型也可以继承 `ModelBase`，只实现 protected `fit(ds, initState)`。`ModelBase` 是便利层，不是强制要求。

## ModelStats

`ModelStats` 记录一次训练的结果：

- 模型名和数据集名。
- 迭代历史 `history`。
- 聚类输出 `prediction`。
- 参数、选项和额外信息。
- 训练时间。

`prediction` 至少需要提供一种可转成标签的字段：

- `labels`
- `membership`
- `embedding`
- `affinity`

## trial、best trial 和 summary

`TaskManner.train(..., NumTrials=3)` 会运行 3 次初始化 trial。`Metricer` 计算每次 trial 的指标，并默认按 `ACC` 选出 best trial。

返回值：

```matlab
[bestStats, summary, metricer] = TaskManner.train(ds, mdl, NumTrials=3);
```

- `bestStats`：best trial 的完整 `ModelStats`。
- `summary`：dataset-model 级别的指标汇总。
- `metricer`：本次评估使用的指标器。

## 记录与读取

启用记录：

```matlab
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=3, Record=true, ExperimentName="firstBenchmark");
```

读取实验汇总：

```matlab
T = Loader.loadExperimentSummary(ExperimentName="firstBenchmark");
```

结果目录细节见 [结果管理](result-management.md)。
