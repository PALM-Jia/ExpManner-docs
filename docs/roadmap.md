# 版本与路线图

本页记录 public docs 的维护状态。代码事实仍以 private code repo 的 canonical docs 为准。

## 当前状态

| 项目 | 状态 |
| --- | --- |
| 代码仓库 | `PALM-Jia/ExpManner`，private |
| 文档仓库 | `PALM-Jia/ExpManner-docs`，public |
| 文档语言 | 只维护中文 |
| 当前代码状态 | v0.2 runnable skeleton |
| 当前文档目标 | v0.3 中文化与质量升级 |

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

## 后续计划

建议后续优先级：

1. 为核心教程增加 private repo companion scripts，验证文档代码块。
2. 继续细化 API 参考，但不自动复制大段源码。
3. 补充更多公开安全 toy examples。
4. 在 private repo 中维护内部教程或 benchmark，不放入 public docs。
5. 等 GitHub Actions 相关 action 发布新 major 后，移除 Node.js 20 annotation 的临时规避。

## 非目标

- 不维护英文版本。
- 不把 private code repo 公开。
- 不发布私有数据集或未发表实验结果。
- 不把 public docs 变成完整源码镜像。
- 不在 public docs 中记录内部 benchmark 表格。
