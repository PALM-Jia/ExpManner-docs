# Ensemble clustering

本教程说明 `Kind="ensemble"` 的数据形态和公开安全 workflow。

## 目标

完成后你将能够：

- 查看本机可用的 ensemble dataset。
- 加载一个 ensemble dataset。
- 理解 `ds.ensemble.members` 与 `ds.X` 的关系。
- 用普通模型运行 ensemble feature。

## 前置条件

- 已完成 [安装](../installation.md)。
- 本机数据根目录已经准备好 ensemble `.mat` 文件。
- 公开文档不展示私有数据路径或内部 benchmark。

## 完整代码

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

names = Dataset.names(Kind="ensemble");
disp(names)

if ~isempty(names)
    ds = Dataset(names(1), Kind="ensemble");
    info = ds.getInfo();
    disp(info)

    mdl = DemoModels.KMeans();
    [bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
    disp(summary)
end
```

## 预期输出

- `names` 显示当前环境可用的 ensemble dataset 名称。
- `info.kind` 为 `"ensemble"`。
- `info.numBaseClusterings` 大于 0。
- `summary` 显示 dataset-model 的聚类指标。

如果 `names` 为空，说明当前环境没有安装 ensemble 数据。这不是框架错误。

## members 与 X

ensemble `.mat` 文件应包含概念变量：

```text
gt       -> ground-truth labels
members  -> base clustering labels for the same samples
```

ExpManner 会把 base clustering labels 转成 membership features，并拼接为 `ds.X`。

可检查字段：

```matlab
size(ds.ensemble.members)
ds.ensemble.baseClusterCounts
ds.ensemble.featureMode
```

当前 `featureMode` 是 `"concatenatedMembership"`。

## 多个 ensemble dataset

```matlab
keep = names(1:min(3, numel(names)));
datasets = Dataset(keep, Kind="ensemble");
mdl = DemoModels.KMeans();

[bestStats, summary] = TaskManner.train(datasets, mdl, NumTrials=3);
disp(summary)
```

这类代码适合内部 sweep。公开报告只能使用已允许公开的数据和结果。

## 常见错误

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `names` 为空 | 当前数据根目录没有 ensemble 文件 | 检查内部数据安装 |
| unknown ensemble dataset | 名称拼写错误或 `Kind` 不对 | 用 `Dataset.names(Kind="ensemble")` 查询 |
| 不能公开结果 | 数据或模型仍是内部材料 | 只在 private repo 或论文允许范围内记录 |

## 下一步

阅读 [数据集指南](../dataset-guide.md) 了解 registry 和 data root 约定。
