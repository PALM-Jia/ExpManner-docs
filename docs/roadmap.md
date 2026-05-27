# 版本与路线图

本页记录 public docs 的维护状态。代码事实仍以 private code repo 的 canonical docs 为准。

## 当前状态

| 项目 | 状态 |
| --- | --- |
| 代码仓库 | `PALM-Jia/ExpManner`，private |
| 文档仓库 | `PALM-Jia/ExpManner-docs`，public |
| 文档语言 | 只维护中文 |
| 当前代码状态 | v0.2 runnable skeleton |
| 当前文档状态 | v0.3 已完成，v0.4 已规划 |

## 稳定接口

当前文档视为稳定的公开入口：

- `Dataset(...)`
- `Dataset.names()`、`Dataset.registry()`、`Dataset.ensembleRegistry()`
- `TaskManner.train(...)`
- duck-typed model interface
- 可选 `ModelBase`
- `ModelStats.getClusterLabels()`
- `Loader.loadExperimentSummary(...)`
- `Metricer` 默认聚类指标

## v0.3 文档改进

v0.3 的目标：

- 全站中文化。
- 教程路径统一。
- 示例库按任务组织。
- API 参考更适合查询。
- 增加故障排查。
- 增加中文写作规范和文档质量门禁。

## v0.4 计划：可运行案例与 Live Script 辅助材料

v0.4 的目标是让核心教程不只是“可读”，而是可运行、可复核、可展示结果。

计划内容：

- 在 private code repo 增加 `examples/docs/*.m` companion scripts，作为文档代码块的可验证事实源。
- 在 private code repo 增加 `examples/live/*.mlx` MATLAB Live Script，作为组内教学和交互演示材料。
- 使用 MATLAB MCP 或本机 MATLAB 实际运行核心示例，把公开安全的 summary、目录结构和关键输出贴回 public docs。
- 在 public docs 中标注每个示例对应的 companion script 和验证 marker。
- 不做组内 onboarding 练习题；v0.4 聚焦可运行案例材料，不设计练习作业。

建议优先材料：

| 材料 | 形式 | 用途 |
| --- | --- | --- |
| first benchmark | `.m` + `.mlx` | 展示 `Iris + DemoModels.KMeans` |
| result management | `.m` + `.mlx` | 展示 `Record=true` 和 `Loader.loadExperimentSummary` |
| multi benchmark | `.m` | 展示多数据集、多模型公开安全组合 |
| ensemble workflow | `.m` + 可选 `.mlx` | 展示 `Kind="ensemble"` 的条件 workflow |

维护原则：

- `.m` companion script 是可 diff、可 review、可自动验证的事实源。
- `.mlx` 是教学展示材料，不作为唯一事实源。
- public docs 只展示公开安全结果，不保存依赖 private repo 的完整 live script。
- 运行结果必须先检查是否包含本机路径、私有数据名、内部 benchmark 或未发表结果。

## 后续计划

v0.4 之后可继续考虑：

1. 半自动扫描 MATLAB public methods，降低 API 参考漂移风险。
2. 增加设计决策记录页面，解释 package namespace、`ModelBase`、class-folder 和结果目录等选择。
3. 补充 Mermaid 图，解释训练流程、结果目录和模型接口调用流程。
4. 等 GitHub Actions 相关 action 发布新 major 后，移除 Node.js 20 annotation 的临时规避。

## 非目标

- 不维护英文版本。
- 不把 private code repo 公开。
- 不发布私有数据集或未发表实验结果。
- 不把 public docs 变成完整源码镜像。
- 不在 public docs 中记录内部 benchmark 表格。
- 不设计组内 onboarding 练习题。
