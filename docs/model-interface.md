# 模型接口

ExpManner 的模型边界很小。项目侧聚类模型可以是普通 MATLAB 对象，也可以继承可选的 `ModelBase`。

## 最小接口

duck-typed model 需要提供三个成员：

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

`TaskManner.train` 在运行前检查这些成员。模型不需要继承 ExpManner 的基类。

## requiredInitFields

`requiredInitFields()` 告诉 `Initializer` 每个 trial 需要准备哪些初始化变量。

| 返回值 | InitState 字段 | 常见用途 |
| --- | --- | --- |
| `"labels"` | `initState.labels` | k-means 风格随机标签初始化 |
| `"membership"` | `initState.membership` | 软隶属矩阵初始化 |
| `"factors.U"` | `initState.factors.U` | 矩阵分解基矩阵 |
| `"factors.V"` | `initState.factors.V` | 矩阵分解系数矩阵 |

不需要初始化时返回空 string array：

```matlab
function fields = requiredInitFields(~)
    fields = string.empty();
end
```

## train 输出

duck-typed model 的 `train(ds, initState)` 必须返回 `ModelStats`。

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

`history` 推荐使用 `ModelStats.emptyHistory()` 的列约定：

| 列 | 含义 |
| --- | --- |
| `iter` | 迭代编号 |
| `objective` | 目标函数值或评分 |
| `delta` | 相邻迭代变化量 |
| `runtime` | 当前累计运行时间 |
| `extra` | 每轮额外元数据 |

## prediction 字段

`ModelStats.getClusterLabels()` 可以从以下字段得到聚类标签：

| 字段 | 形状口径 |
| --- | --- |
| `labels` | 可转成 `1 x numSamples` 的标签向量 |
| `membership` | `numClasses x numSamples` |
| `embedding` | `numSamples x dim`，再用 k-means 离散化 |
| `affinity` | `numSamples x numSamples`，再用内置谱聚类辅助方法离散化 |

第一次接入模型时，优先返回 `prediction.labels`。NMF 风格模型可返回 `prediction.membership`。

## 可选 ModelBase

`ModelBase` 适合减少样板代码。子类只需要实现 protected `fit(ds, initState)`：

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

`fit` 可以返回 scalar struct，也可以返回完整 `ModelStats`。struct 至少应包含 `labels`、`membership`、`embedding`、`affinity` 或 nested `prediction` 中的一种。

`ModelBase` 会自动完成：

- 计时并写入 `trainTime`。
- 填充 `modelName`、`datasetName`、`numClasses`。
- 根据 `objective`、`delta`、`runtime` 等字段构建 `history`。
- 将 `membership` 规范成 `numClasses x numSamples`。
- 将可读 public property 导出到 `options`。

## 接入检查清单

- `mdl` 是 scalar object。
- `mdl.name` 非空且稳定。
- duck-typed model 返回 `ModelStats`，不是普通 struct。
- `labels` 是 sample-level assignment。
- `membership` 维度能对应 `numClasses` 和 `numSamples`。
- 模型内部不写结果文件，结果记录交给 `TaskManner.train(..., Record=true)`。

完整接入示例见 [自定义模型](tutorials/custom-model.md)。
