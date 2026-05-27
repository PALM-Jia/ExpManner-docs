# ExpManner 中文文档

ExpManner 是一个面向聚类研究实验的 MATLAB 框架，用来统一数据集加载、初始化、多 trial benchmark、指标评估、结果记录和结果读取。

本网站是公开中文文档站。代码仓库 `PALM-Jia/ExpManner` 是 private repo，需要 PALM Jia 授权访问。

## 适合谁阅读

| 读者 | 建议入口 |
| --- | --- |
| 新同学 | 先读 [安装](installation.md)，再按 [快速开始](getting-started.md) 跑通第一轮 |
| 模型开发者 | 先读 [模型接口](model-interface.md)，再做 [自定义模型](tutorials/custom-model.md) |
| 数据集维护者 | 先读 [数据集指南](dataset-guide.md)，再看 [ensemble clustering 教程](tutorials/ensemble-clustering.md) |
| 实验复现者 | 先读 [结果管理](result-management.md)，再看 [示例库](examples.md) |
| 文档维护者 | 先读 [贡献指南](contributing.md)、[中文写作规范](writing-style.md) 和 [安全边界](security.md) |

## 最短路径

1. 获取 private code repo 访问权限。
2. 克隆 `PALM-Jia/ExpManner`。
3. 在 MATLAB 中加入项目根目录和 `examples` 目录。
4. 运行 `Dataset("Iris", Normalize="range")`。
5. 使用 `DemoModels.KMeans()` 跑第一个 benchmark。
6. 需要记录结果时启用 `Record=true`。

最小代码：

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = DemoModels.KMeans();
[bestStats, summary] = TaskManner.train(ds, mdl, NumTrials=3);
disp(summary)
```

## ExpManner 解决什么问题

ExpManner 关注聚类实验的公共流程：

- 统一 feature dataset 和 ensemble dataset 的加载方式。
- 统一 trial 初始化和随机种子记录。
- 统一 dataset-model benchmark 调用入口。
- 统一 `ACC`、`NMI`、`PUR`、`ARI`、`F1` 等聚类指标评估。
- 统一 run manifest、best-trial artifact、run summary 和 experiment summary 的目录结构。
- 允许项目侧模型通过 duck typing 或可选 `ModelBase` 接入。

ExpManner 不是通用机器学习框架，也不是 MATLAB package namespace。日常使用时只需要把仓库根目录加入 MATLAB path，然后直接调用 `Dataset`、`TaskManner`、`Metricer`、`ModelStats` 等类名。

## 公开边界

本文档只写公开安全内容。可以公开接口、toy dataset 示例、结果目录格式和贡献流程；不要公开私有数据路径、凭据、密钥、未发表实验结果、内部 benchmark 表格或项目侧敏感模型实现。

如果某个源代码链接返回 404，请确认当前 GitHub 账号已经获得 `PALM-Jia/ExpManner` 访问权限。
