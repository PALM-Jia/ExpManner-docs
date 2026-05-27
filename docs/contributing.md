# 贡献指南

ExpManner 是 PALM Jia 内部研究框架。代码仓库为 private，文档仓库为 public。

## 访问模型

组织 team 表达权限，不建议临时给个人散点权限。

| team | 职责 |
| --- | --- |
| `maintainers` | 仓库管理、release、review 和策略 |
| `contributors` | 功能分支和 PR |
| `members` | 内部只读访问和 issue 讨论 |
| `docs` | 文档维护和文档 PR |

需要代码访问时，联系 maintainer 加入相应 team。

## 工作流

1. 从 `main` 创建聚焦分支。
2. 一个 PR 只解决一个主题。
3. 行为、接口、路径或项目规则变化时，同步 canonical docs。
4. 运行相关验证命令。
5. PR 描述中写清变更摘要和验证结果。

推荐分支名：

```text
feature/custom-model-tutorial
fix/ensemble-loader-error
docs/getting-started
```

## 验证

文档改动在 docs repo 中运行：

```powershell
.\scripts\check-docs.ps1
```

MATLAB 代码改动在 private code repo 中运行：

```matlab
expRoot = "<path-to-ExpManner>";
cd(expRoot)
clear classes
addpath(expRoot)
runtests("tests")
run("examples/smokeExpManner.m")
```

如果 PR 更新教程代码、示例输出或 Live Script 辅助材料，还需要运行文档材料统一验证入口：

```matlab
run("examples/docs/validateDocumentation.m")
```

代码改动还应运行 MATLAB Code Analyzer 覆盖 core、class-folder、examples 和 tests。

## 文档审查清单

文档 PR 至少检查：

- 是否需要更新 [设计决策记录](design-decisions.md)。
- 是否重跑 `validateDocumentation`。
- 是否需要生成 API 草稿，并人工同步 [API 参考](api-reference.md)。
- 是否检查 `.mlx` 输出缓存。
- 是否确认 public docs 没有本机路径、私有数据位置、未发表结果或内部 benchmark。

## 文档同步

private code repo 中这些文件是事实来源：

- `README.md`
- `AGENTS.md`
- `doc_plan.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `CITATION.cff`
- `docs/lrdsc-audit.md`
- `docs/utils-inventory.md`
- `docs/internal/README.md`

public docs 只同步公开安全子集。发现冲突时，先修正 private canonical docs，再同步 public docs。

内部数据准备、真实 benchmark 和私有模型案例只放在 private code repo 的 `docs/internal/`。public docs 只记录公开安全摘要和入口说明。

## 中文文档要求

- 后续只维护中文版本。
- 页面标题、导航、正文和维护说明使用中文。
- API 名称、MATLAB 代码、命令、路径占位符、仓库名和工具名保留英文。
- 新教程按 [中文写作规范](writing-style.md) 的模板组织。

## 公开安全边界

不要发布：

- 凭据、令牌、密钥或访问 key。
- 本机私有绝对路径。
- 私有数据集文件或具体位置。
- 生成的 experiment artifact。
- 内部 benchmark 表格或未发表结果比较。
- 项目侧敏感模型实现。

提交 PR 前使用 `.github/pull_request_template.md` 中的 checklist 自查。
