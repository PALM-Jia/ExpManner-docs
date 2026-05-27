# 版本与路线图

本页记录 ExpManner 代码库的公开能力边界、稳定接口和后续维护方向。代码事实仍以 private code repo 的 canonical docs 为准。

## 当前状态

| 项目 | 状态 |
| --- | --- |
| 代码仓库 | `PALM-Jia/ExpManner`，private |
| 公开说明仓库 | `PALM-Jia/ExpManner-docs`，public |
| 公开语言 | 只维护中文 |
| 当前代码状态 | v0.2 runnable skeleton |
| 当前公开说明 | 覆盖入门、教程、操作指南、概念解释、API 参考、贡献与安全边界 |
| 当前示例模型 | `Models.KMeans`、`Models.KKM`、`Models.NMF`、`Models.SymNMF`、`Models.LoRD` |

## 稳定接口

当前视为稳定的公开入口：

- `Dataset(...)`
- `Dataset.names()`、`Dataset.registry()`、`Dataset.ensembleRegistry()`
- `TaskManner.train(...)`
- duck-typed model interface
- 可选 `ModelBase`
- `ModelStats.getClusterLabels()`
- `Loader.loadExperimentSummary(...)`
- `Metricer` 默认聚类指标
- `examples/+Models` 公开安全示例模型库

## 当前公开说明能力

公开说明已经覆盖：

- 中文-only 使用说明和维护规范。
- 第一个 benchmark、矩阵分解聚类、基于图的聚类、集成聚类和自定义模型接入。
- companion scripts 与 Live Script 辅助材料的验证方式。
- 结果记录、读取和本地 artifact 边界。
- API 轻量索引、故障排查、贡献流程、引用方式和安全边界。
- 设计决策记录与 Mermaid 流程图。

## 变更记录

| 版本 | 状态 | ExpManner 侧重点变化 |
| --- | --- | --- |
| v0.6 | 进行中 | 示例模型库改为 `Models`，加入 `KKM`、`NMF`、`SymNMF`、`LoRD`，教程扩展为可运行的矩阵分解聚类和基于图的聚类案例 |
| v0.5 | 已完成 | 增加设计决策记录、Mermaid 图、API 草稿机制、内部材料边界和审查清单 |
| v0.4 | 已完成 | 增加 companion scripts、Live Script、实测输出嵌入和统一验证入口 |
| v0.3 | 已完成 | 完成中文化、信息架构、示例库、故障排查和质量门禁 |

## 后续计划

v0.6 之后可继续考虑：

1. 根据组内项目接入情况，补充更多公开安全的模型接口模式。
2. 当有稳定 MATLAB runner 和 license 策略时，再评估是否把 private 文档示例验证接入 CI。
3. 等 GitHub Actions 相关 action 发布新 major 后，移除 Node.js 20 annotation 的临时规避。
4. 根据论文和组内项目需要，逐步补充 private `docs/internal/`，public docs 只同步公开安全摘要。

## 非目标

- 不维护英文版本。
- 不把 private code repo 公开。
- 不发布私有数据集或未发表实验结果。
- 不把 public docs 变成完整源码镜像。
- 不在 public docs 中记录内部 benchmark 表格。
- 不设计组内 onboarding 练习题。
