# 版本与路线图

本页记录 public docs 的维护状态。代码事实仍以 private code repo 的 canonical docs 为准。

## 当前状态

| 项目 | 状态 |
| --- | --- |
| 代码仓库 | `PALM-Jia/ExpManner`，private |
| 文档仓库 | `PALM-Jia/ExpManner-docs`，public |
| 文档语言 | 只维护中文 |
| 当前代码状态 | v0.2 runnable skeleton |
| 当前文档状态 | v0.3 已完成，v0.4 已完成，v0.5 已完成 |

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

当前进展：

- M10 companion scripts 已完成：private code repo 已新增 `examples/docs/*.m` 和统一入口 `examples/docs/runAllDocExamples.m`。
- 已使用 MATLAB MCP 运行统一入口，成功输出 `DOC_ALL_EXAMPLES_OK`。
- M11 Live Script 辅助材料已完成：private code repo 已新增 `examples/live/*.mlx`、`examples/live/sources/*.m` 和 `generateLiveScripts.m`。
- 已用独立 MATLAB batch 进程生成并执行保存 Live Script，成功输出 `DOC_M11_BATCH_LIVE_EXECUTION_OK`。
- M12 公开安全输出嵌入已完成：public docs 已补充 summary 表格、规范化 result tree、ensemble shape 摘要和两个实测错误摘录。
- M13 维护闭环已完成：private code repo 已新增 `examples/docs/validateDocumentation.m`，成功时输出 `DOC_DOCUMENTATION_VALIDATION_OK`。
- public docs 已记录 companion script、Live Script、统一验证入口和成功 marker。

维护入口：

- 更新 public docs 的示例输出前，在 private code repo 运行 `run("examples/docs/validateDocumentation.m")`。
- 更新 `.mlx` 前，先修改 `examples/live/sources/*.m`，再运行 `validateDocumentation(GenerateLiveScripts=true)`。
- 暂不把 MATLAB 示例验证接入 public docs GitHub Actions；public docs repo 不包含 private code repo，也没有稳定的 MATLAB license runner。

建议优先材料：

| 材料 | 形式 | 用途 |
| --- | --- | --- |
| first benchmark | `.m` + `.mlx` | 展示 `Iris + DemoModels.KMeans` |
| result management | `.m` + `.mlx` | 展示 `Record=true` 和 `Loader.loadExperimentSummary` |
| multi benchmark | `.m` + `.mlx` | 展示多数据集、多模型公开安全组合 |
| ensemble workflow | `.m` + `.mlx` | 展示 `Kind="ensemble"` 的条件 workflow |

维护原则：

- `.m` companion script 是可 diff、可 review、可自动验证的事实源。
- `.mlx` 是教学展示材料，不作为唯一事实源。
- public docs 只展示公开安全结果，不保存依赖 private repo 的完整 live script。
- 运行结果必须先检查是否包含本机路径、私有数据名、内部 benchmark 或未发表结果。

## v0.5 文档可维护性升级

v0.5 的目标是降低长期维护成本，减少架构误解和 API 参考漂移。

完成内容：

- M14 设计决策记录已完成：新增设计决策页面，解释普通文件夹风格、`ModelBase` 可选性、class-folder、结果目录和 public/private 分离。
- M14 流程图已完成：新增训练流程、模型接口调用链和结果目录 Mermaid 图。
- M15 半自动 API 维护已完成：private code repo 新增 API 草稿生成脚本；public API 页记录人工同步规则。
- M16 版本、变更记录和内部边界已完成：private code repo 新增 `docs/internal/README.md`，public docs 记录内部材料只放 private repo。
- M17 文档审查清单已完成：PR 模板、贡献指南和写作规范已补充设计决策、API 草稿、Live Script 和公开边界检查项。

## 变更记录

| 版本 | 状态 | 重点变化 |
| --- | --- | --- |
| v0.5 | 已完成 | 增加设计决策记录、Mermaid 图、API 草稿机制、内部文档边界和审查清单 |
| v0.4 | 已完成 | 增加 companion scripts、Live Script、实测输出嵌入和统一验证入口 |
| v0.3 | 已完成 | 全中文化、信息架构、示例库、故障排查和质量门禁 |

## 后续计划

v0.5 之后可继续考虑：

1. 如果有稳定 MATLAB runner 和 license 策略，再评估是否把 private 文档示例验证接入 CI。
2. 等 GitHub Actions 相关 action 发布新 major 后，移除 Node.js 20 annotation 的临时规避。
3. 根据实际论文和组内项目需要，逐步补充 private `docs/internal/`，public docs 只同步公开安全摘要。

## 非目标

- 不维护英文版本。
- 不把 private code repo 公开。
- 不发布私有数据集或未发表实验结果。
- 不把 public docs 变成完整源码镜像。
- 不在 public docs 中记录内部 benchmark 表格。
- 不设计组内 onboarding 练习题。
