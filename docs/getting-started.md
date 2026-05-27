# 快速开始

本页目标是在 10 分钟内跑通第一次 ExpManner 实验。

## 目标

完成后你将能够：

- 在当前 MATLAB 会话中加入 ExpManner。
- 加载 `Iris` 数据集。
- 使用 `Models.KMeans` 跑 3 次 trial。
- 识别成功输出和常见路径错误。

## 前置条件

- 已完成 [安装](installation.md)。
- 已获得 private code repo 访问权限。
- 已知道本机 `<path-to-ExpManner>`。

## 完整代码

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = Models.KMeans();
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);

disp(summary)
labels = bestStats.getClusterLabels();
```

## 预期输出

成功时应看到：

- `summary` 是一行 table。
- table 中包含 `Dataset`、`Model`、`BestTrial`、`ACC`、`NMI`、`PUR`、`ARI` 等列。
- `labels` 是长度等于样本数的聚类标签。

## 运行 smoke workflow

smoke 脚本会运行多个 demo model，并写入本地 `results/`：

```matlab
run(fullfile(expRoot, "examples", "smokeExpManner.m"));
```

成功结束时会显示：

```text
Smoke run completed.
```

生成的 `results/` 是本地实验 artifact，不要提交到 Git。

## 常见错误

| 现象 | 常见原因 | 处理 |
| --- | --- | --- |
| MATLAB 找不到 `Dataset` | 没有加入 ExpManner 根目录 | 重新运行 `addpath(expRoot)` |
| MATLAB 找不到 `Models.KMeans` | 没有加入 `examples` | 重新运行 `addpath(fullfile(expRoot, "examples"))` |
| 数据集文件找不到 | 本机数据根目录未准备好 | 先用 `Iris` 做健康检查，再检查私有数据安装 |
| 结果目录出现很多文件 | smoke workflow 启用了记录 | 保留本地使用，不提交 `results/` |

下一步可以阅读 [第一个 benchmark](tutorials/first-benchmark.md)，了解如何记录和读取 experiment summary。
