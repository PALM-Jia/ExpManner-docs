# 示例库

本页按任务组织示例，而不是只按文件名罗列。示例代码只使用公开安全数据和占位路径。

## 可运行 companion scripts

private code repo 中的核心文档示例有对应 companion script，可用于复核 public docs 中展示的代码和输出。

```matlab
run("examples/docs/validateDocumentation.m")
```

运行成功时会输出 `DOC_ALL_EXAMPLES_OK` 和 `DOC_DOCUMENTATION_VALIDATION_OK`。这些脚本可能在本地生成 `results/`，生成物不提交。

| 任务 | companion script | 成功 marker | 实测公开输出 |
| --- | --- | --- | --- |
| 最小 benchmark | `examples/docs/firstBenchmarkDoc.m` | `DOC_FIRST_BENCHMARK_OK` | `Iris` + `DemoKMeans`，`ACC=0.96`，`NMI=0.86227` |
| 结果记录与读取 | `examples/docs/resultManagementDoc.m` | `DOC_RESULT_MANAGEMENT_OK` | 读取 `docsV04ResultManagement` summary，并列出规范化 result tree |
| 多数据集与多模型 | `examples/docs/multiBenchmarkDoc.m` | `DOC_MULTI_BENCHMARK_OK` | `Iris/Wine` 多数据集；`DemoKMeans/DemoSimpleNMF` 多模型 |
| ensemble workflow | `examples/docs/ensembleWorkflowDoc.m` | `DOC_ENSEMBLE_WORKFLOW_OK` 或 `DOC_ENSEMBLE_WORKFLOW_SKIPPED` | 有本机 ensemble 数据时只展示 shape 和精简指标；无数据时跳过 |

## Live Script 辅助材料

private code repo 还包含面向组内教学的 `.mlx` Live Script。它们不是事实源；事实源仍是 `examples/docs/*.m` 和 `examples/live/sources/*.m`。

| 任务 | Live Script | 可审阅源文件 |
| --- | --- | --- |
| 最小 benchmark | `examples/live/firstBenchmark.mlx` | `examples/live/sources/firstBenchmarkLiveSource.m` |
| 结果记录与读取 | `examples/live/resultManagement.mlx` | `examples/live/sources/resultManagementLiveSource.m` |
| 多数据集与多模型 | `examples/live/multiBenchmark.mlx` | `examples/live/sources/multiBenchmarkLiveSource.m` |
| ensemble workflow | `examples/live/ensembleWorkflow.mlx` | `examples/live/sources/ensembleWorkflowLiveSource.m` |

维护者可以在 private code repo 中运行：

```matlab
run("examples/docs/validateDocumentation.m")
```

如果需要重新生成 `.mlx`，在普通 MATLAB session 或 batch 进程中运行：

```matlab
addpath(fullfile(pwd, "examples", "docs"))
validateDocumentation(GenerateLiveScripts=true)
```

生成或更新 `.mlx` 后，需要确认其中没有本机路径、私有数据位置或内部 benchmark。

## Iris + KMeans

用途：验证最小 dataset-model benchmark。

输入：`Iris`，`DemoModels.KMeans`。

是否写入 `results/`：否。

是否需要 private code repo 权限：需要。

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = DemoModels.KMeans();
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
disp(summary)
```

预期输出：一行 summary table，并能通过 `bestStats.getClusterLabels()` 取得聚类标签。

实测精简输出：

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | DemoKMeans | 3 | ACC | 1 | 0.96 | 0.96 | 0.86227 | 0.96 | 0.88567 |

## 多数据集 benchmark

用途：一次运行多个小型 feature dataset。

输入：`Iris`、`Wine`，`DemoModels.KMeans`。

是否写入 `results/`：否。

```matlab
datasets = Dataset(["Iris", "Wine"], Normalize="range");
mdl = DemoModels.KMeans();

[bestStats, summary] = TaskManner.train(datasets, mdl, NumTrials=3);
disp(summary)
```

预期输出：`summary` 中每个 dataset-model pair 一行。

实测精简输出：

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | DemoKMeans | 2 | ACC | 1 | 0.96 | 0.96 | 0.86227 | 0.96 | 0.88567 |
| Wine | DemoKMeans | 2 | ACC | 1 | 0.69663 | 0.69663 | 0.37416 | 0.69663 | 0.34162 |

## 多模型 benchmark

用途：比较多个满足接口的模型。

输入：`Iris`，demo k-means 与 NMF 风格 demo model。

是否写入 `results/`：否。

```matlab
ds = Dataset("Iris", Normalize="range");
models = {DemoModels.KMeans(), DemoModels.SimpleNMF()};

[bestStats, summary] = TaskManner.train(ds, models, NumTrials=3);
disp(summary)
```

预期输出：`summary` 中每个 model 一行。`bestStats` 在多模型时返回 cell。

实测精简输出：

| dataset | model | numTrials | bestBy | bestTrial | bestValue | ACC | NMI | PUR | ARI |
| --- | --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Iris | DemoKMeans | 2 | ACC | 1 | 0.96 | 0.96 | 0.86227 | 0.96 | 0.88567 |
| Iris | DemoSimpleNMF | 2 | ACC | 1 | 0.71333 | 0.69 | 0.52311 | 0.69 | 0.45511 |

## 记录并读取 experiment summary

用途：展示 `Record=true` 后如何读取结果。

是否写入 `results/`：是，本地 artifact，不提交 Git。

```matlab
resultRoot = fullfile(expRoot, "results", "docs-examples");
ds = Dataset("Iris", Normalize="range");
mdl = DemoModels.KMeans();

[bestStats, summary] = TaskManner.train(ds, mdl, ...
    NumTrials=3, ...
    Record=true, ...
    ResultRoot=resultRoot, ...
    ExperimentName="docsDemo");

T = Loader.loadExperimentSummary(resultRoot, ExperimentName="docsDemo");
disp(T)
```

预期输出：`results/docs-examples/experiments/docsDemo/summary.csv` 可被读取。

实测 result tree 摘要：

```text
experiments/docsV04ResultManagement/index.csv
experiments/docsV04ResultManagement/summary.csv
index.csv
train/DemoKMeans/Iris/<runId>/bestStats.mat
train/DemoKMeans/Iris/<runId>/manifest.json
train/DemoKMeans/Iris/<runId>/runSummary.csv
train/DemoKMeans/Iris/<runId>/trialMetrics.csv
```

## ensemble dataset workflow

用途：说明 ensemble dataset 的公开安全调用方式。

输入：本机已安装的 ensemble `.mat` 数据。

是否写入 `results/`：否。

```matlab
names = Dataset.names(Kind="ensemble");
if ~isempty(names)
    ds = Dataset(names(1), Kind="ensemble");
    mdl = DemoModels.KMeans();
    [bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
    disp(summary)
end
```

说明：公开文档只展示 shape 和调用方式，不展示私有数据路径或内部 benchmark。

实测公开安全 shape 摘要：

| kind | numSamples | dataLength | numClasses | numBaseClusterings | ensembleFeatureMode |
| --- | ---: | ---: | ---: | ---: | --- |
| ensemble | 2139 | 2400 | 2 | 100 | concatenatedMembership |

## 仓库内示例文件

private code repo 中包含这些示例：

| 文件 | 用途 |
| --- | --- |
| `examples/smokeExpManner.m` | 最小端到端 smoke workflow |
| `examples/+DemoModels/KMeans.m` | duck-typed label-returning model |
| `examples/+DemoModels/CompactKMeans.m` | `ModelBase` 风格 k-means wrapper |
| `examples/+DemoModels/SimpleNMF.m` | membership-returning NMF 风格 demo |
| `examples/+LRDSCAdapters/BasicNMF.m` | LRDSC 风格适配器示例 |

复制示例时优先复制接口形状，不要把 demo 结果当作正式 benchmark baseline。
