# 自定义模型

本教程展示两种接入方式：普通 duck-typed class，以及继承 `ModelBase` 的紧凑 wrapper。private code repo 中的 `examples/+Models` 提供了公开安全参考实现，可先读这些模型再写自己的项目侧模型。

## 目标

完成后你将能够：

- 写出满足 ExpManner 接口的最小模型。
- 理解 `requiredInitFields()` 的作用。
- 决定何时返回 `ModelStats`，何时使用 `ModelBase.fit` 返回 struct。
- 排查常见模型接口错误。

## 前置条件

- 已能运行 [第一个 benchmark](first-benchmark.md)。
- 了解 MATLAB classdef 基本语法。
- 自定义模型文件位于 MATLAB path 上。

## duck-typed 模型模板

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

把 `myClusteringRoutine` 替换成你的算法主体即可。duck-typed model 的 `train` 必须返回 `ModelStats`。

## 单 trial 测试

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);

ds = Dataset("Iris", Normalize="range");
mdl = MyKMeansLike();

[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=1);
disp(summary)
labels = bestStats.getClusterLabels();
```

先用 `NumTrials=1` 调通接口，再增加 trial 数。

## ModelBase 模板

如果模型主体可以返回一个轻量 struct，建议使用 `ModelBase` 减少样板代码：

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

`ModelBase` 会把 `out` 转成标准 `ModelStats`。

## 返回 membership

分解模型通常返回 membership：

```matlab
out = struct();
out.membership = V;
out.objective = objectiveTrace;
out.delta = deltaTrace;
```

推荐维度是 `numClasses x numSamples`。`ModelBase` 也接受转置形式，并会规范成推荐维度。

## 记录结果

```matlab
resultRoot = fullfile(expRoot, "results", "my-model-check");
[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=5, ...
    Seed=1, ...
    Record=true, ...
    ResultRoot=resultRoot, ...
    ExperimentName="myModelCheck");
```

生成的结果只用于本地复现，不提交到 Git。

## 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `missingModelName` | `name` 为空或不可访问 | 增加稳定的 public `name` property |
| `invalidModelInterface` | 缺少 `requiredInitFields` 或 `train` | 补齐最小接口 |
| `invalidStats` | duck-typed model 返回了 struct | 返回 `ModelStats` 或改用 `ModelBase` |
| `missingPrediction` | `fit` 输出没有 labels/membership/embedding/affinity | 补一个 prediction 字段 |
| 指标计算失败 | `getClusterLabels()` 无法得到标签 | 检查 prediction 形状 |

## 下一步

## 可参考的公开示例模型

| 模型 | 接口风格 | 输出类型 | 适合参考的点 |
| --- | --- | --- | --- |
| `Models.KMeans` | duck typing | `labels` | 最小 `train(ds, initState)` 和 `ModelStats` 组装 |
| `Models.NMF` | `ModelBase` | `membership` | `factors.U/V` 初始化与 membership 输出 |
| `Models.KKM` | `ModelBase` | `labels` | kernel k-means 的 label 输出 |
| `Models.SymNMF` | `ModelBase` | `membership` | affinity graph 与 symmetric factor |
| `Models.LoRD` | `ModelBase` | `membership` | 带投影步骤的图分解模型 |

阅读 [模型接口](../model-interface.md) 查看完整契约，或参考 private code repo 中的 `examples/+Models`。
