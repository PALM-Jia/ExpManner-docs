# 故障排查

本页按“现象、原因、解决方法、相关页面”整理常见问题。

## MATLAB 找不到 Dataset

现象：运行 `Dataset("Iris")` 报未定义函数或变量。

原因：没有把 ExpManner 根目录加入 MATLAB path。

解决：

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
```

相关页面：[安装](installation.md)、[快速开始](getting-started.md)。

## MATLAB 找不到 Models.KMeans

现象：`Models.KMeans()` 无法解析。

实测错误摘录：

```text
无法解析名称 'Models.KMeans'。
```

原因：公开示例模型在 `examples` 目录下，只有根目录不够。

解决：

```matlab
addpath(fullfile(expRoot, "examples"));
```

相关页面：[示例库](examples.md)。

## Dataset file not found

现象：构造某个数据集时提示文件不存在。

原因：

- 本机数据根目录没有安装该数据。
- `DataRoot` 指向错误位置。
- public docs 示例以 `Iris` 为主，私有数据需要内部准备。

解决：

```matlab
Dataset.names()
Dataset.suggestName("datasetName")
```

先用 `Dataset("Iris")` 验证框架，再检查私有数据部署。

## unknown dataset

现象：数据集名称无法匹配。

实测错误摘录：

```text
ExpManner:Dataset:unknownDataset
Unknown feature dataset "Iriss". Did you mean: Iris, Digits, Wine, SEEDS, Yeast?
Use Dataset.names(Kind="feature") to inspect available names.
```

原因：名称拼写错误或 `Kind` 不对。

解决：

```matlab
Dataset.names()
Dataset.names(Kind="ensemble")
Dataset.suggestName("mnist2000")
```

feature dataset 和 ensemble dataset 用 `Kind` 区分。

## missingModelName

现象：`TaskManner.train` 报模型名缺失。

原因：模型没有公开非空 `name` property。

解决：

```matlab
properties
    name (1, 1) string = "MyModel"
end
```

相关页面：[模型接口](model-interface.md)。

## invalidModelInterface

现象：模型接口不合法。

原因：缺少 `requiredInitFields()` 或 `train(ds, initState)`。

解决：按最小接口补齐：

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

相关页面：[自定义模型](tutorials/custom-model.md)。

## invalidStats

现象：duck-typed model 返回值不被接受。

原因：普通 duck-typed model 必须返回 `ModelStats`。只有 `ModelBase.fit` 可以返回 struct。

解决：要么显式构造 `ModelStats`，要么改为继承 `ModelBase`。

## membership 维度错误

现象：`membership` 无法转换成标签。

原因：维度没有对应 `numClasses` 和 `numSamples`。

解决：

```matlab
size(V)  % 应能解释为 numClasses x numSamples
```

`ModelBase` 接受 `numClasses x numSamples` 或 `numSamples x numClasses`，并会规范成前者。

## affinity 为空

现象：基于图的模型或调试代码中发现 `ds.graph.S` 为空。

原因：构造数据集时没有启用 `BuildGraph=true`，或者模型选择了内部临时构图。

解决：

```matlab
ds = Dataset("Iris", Normalize="range", BuildGraph=true, ...
    GraphOptions=struct("WeightMode", "HeatKernel", "k", 5));
```

相关页面：[基于图的聚类](tutorials/graph-clustering.md)。

## 找不到 experiment summary

现象：`Loader.loadExperimentSummary` 找不到 summary。

原因：

- 记录时没有启用 `Record=true`。
- 读取时 `ResultRoot` 或 `ExperimentName` 不一致。

解决：记录和读取使用同一组参数。

```matlab
resultRoot = fullfile(expRoot, "results", "demo");
experimentName = "demo";
```

相关页面：[结果管理](result-management.md)。

## Git 中出现 results

现象：`git status` 显示 `results/` 下有新文件。

原因：运行 smoke 或 recorded benchmark 后生成了本地 artifact。

解决：不要提交这些文件；必要时检查 `.gitignore`。

相关页面：[结果管理](result-management.md)、[安全边界](security.md)。
