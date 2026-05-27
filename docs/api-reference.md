# API 参考

本页是轻量 API 索引。private source link 需要 PALM Jia 授权访问；public docs 不复制大量私有源码。

## 核心类总览

| 类 | 职责 | 常用入口 |
| --- | --- | --- |
| `Dataset` | 加载数据、标签、预处理、约束、图和 ensemble metadata | `Dataset(...)`、`names`、`registry`、`ensembleRegistry`、`suggestName`、`getInfo` |
| `Initializer` | 根据模型需求构造 trial 初始化状态 | `forModel`、`forFields` |
| `InitState` | 保存 labels、membership、factor 初始化和 metadata | `InitState(...)`、`hasField` |
| `TaskManner` | 调度 dataset-model-trial benchmark | `TaskManner.train` |
| `ModelStats` | 保存训练结果、history、prediction 和 options | `ModelStats(...)`、`getClusterLabels`、`emptyHistory` |
| `ModelBase` | 可选模型基类，减少 `ModelStats` 组装样板 | `requiredInitFields`、继承的 `train`、子类 protected `fit` |
| `Metricer` | 计算聚类指标并选择 best trial | `Metricer(...)`、`evaluateTrials` |
| `Recoder` | 写入 manifest、summary、index 和 best stats | `Recoder(...)`、`saveTrainResult`、`defaultResultRoot` |
| `Loader` | 读取 manifest、summary、index 和 artifact | `loadExperimentSummary`、`filterIndex`、`filterSummary`、`loadStats` |
| `utils` | 通用数值、标签、assignment 和 simplex 工具 | `labelsToMembership`、`membershipToLabel`、`proj2simplex`、`hungarian` |

## Dataset

最小调用：

```matlab
ds = Dataset("Iris", Normalize="range");
datasets = Dataset(["Iris", "Wine"], Normalize="range");
names = Dataset.names();
```

常用参数：

| 参数 | 含义 |
| --- | --- |
| `Kind` | `"feature"` 或 `"ensemble"` |
| `DataRoot` | 数据根目录 |
| `Normalize` | `"null"`、`"range"`、`"L1"`、`"L2"` |
| `BuildGraph` | 是否构建 affinity graph |
| `PosLabelRatio` / `NegLabelRatio` | 半监督约束采样比例 |

返回：scalar `Dataset` 或 `Dataset` object array。

source link：[Dataset.m](https://github.com/PALM-Jia/ExpManner/blob/main/Dataset.m)

## TaskManner.train

```matlab
[bestStats, summary, metricer] = TaskManner.train(ds, mdl, ...
    NumTrials=3, Record=false, BestBy="ACC");
```

常用参数：

| 参数 | 含义 |
| --- | --- |
| `NumTrials` | 初始化 trial 数 |
| `Record` | 是否写入结果 |
| `ResultRoot` | 结果仓库根目录 |
| `UseParallel` | 是否并行 trial |
| `Seed` | 初始化 seed 起点 |
| `BestBy` | best trial 选择指标 |
| `MetricList` | 要计算的指标列表 |
| `ExperimentName` | experiment summary 名称 |

返回：

- `bestStats`：单 run 时为 `ModelStats`，多 run 时为 cell。
- `summary`：指标汇总 table。
- `metricer`：评估器。

source link：[TaskManner.m](https://github.com/PALM-Jia/ExpManner/blob/main/TaskManner.m)

## ModelStats

```matlab
labels = bestStats.getClusterLabels();
history = bestStats.history;
```

`ModelStats` 的 `prediction` 支持：

- `labels`
- `membership`
- `embedding`
- `affinity`

常用静态方法：

```matlab
history = ModelStats.emptyHistory();
groups = ModelStats.mySpectralCluster(S, numClasses, NumTests=5);
```

source link：[ModelStats.m](https://github.com/PALM-Jia/ExpManner/blob/main/ModelStats.m)

## ModelBase

适合新模型 wrapper：

```matlab
classdef MyModel < ModelBase
    methods (Access = protected)
        function out = fit(obj, ds, initState)
            out.labels = myAlgorithm(ds.X, initState.labels);
        end
    end
end
```

`fit` 返回 struct 时，至少要包含一种 prediction 字段。`ModelBase` 会构造 `ModelStats`。

source link：[ModelBase.m](https://github.com/PALM-Jia/ExpManner/blob/main/ModelBase.m)

## Recoder 与 Loader

写入：

```matlab
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    Record=true, ResultRoot=resultRoot, ExperimentName="demo");
```

读取：

```matlab
T = Loader.loadExperimentSummary(resultRoot, ExperimentName="demo");
idx = Loader.filterIndex(resultRoot, Dataset="Iris", Model="DemoKMeans");
```

source links：

- [Recoder.m](https://github.com/PALM-Jia/ExpManner/blob/main/Recoder.m)
- [Loader.m](https://github.com/PALM-Jia/ExpManner/blob/main/Loader.m)

## Metricer 与 utils

`@Metricer` 和 `@utils` 使用 MATLAB class-folder layout。类文件声明方法，具体实现放在同目录独立 `.m` 文件中。

常用入口：

```matlab
acc = Metricer.accuracy(labels, gnd);
[nmi, mi] = Metricer.myNMI(labelsA, labelsB);
M = utils.labelsToMembership(labels, numClasses);
labels = utils.membershipToLabel(M);
[assignment, cost] = utils.hungarian(costMatrix);
```

source links：

- [@Metricer](https://github.com/PALM-Jia/ExpManner/tree/main/%40Metricer)
- [@utils](https://github.com/PALM-Jia/ExpManner/tree/main/%40utils)
