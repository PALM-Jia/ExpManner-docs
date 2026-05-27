# 中文写作规范

ExpManner 面向使用者的公开说明后续只维护中文版本。页面内容应服务 ExpManner 代码库的使用、扩展、验证和维护，不把 docs repo 本身当作产品主体。

## 基本原则

- 以 ExpManner 的功能、接口、实验流程和维护边界为主语。
- 面向读者任务写作，不写空泛口号。
- 页面标题、导航、正文、状态说明和维护说明使用中文。
- API 名称、MATLAB 代码、命令、路径占位符、仓库名和工具名保留英文。
- public docs 只同步 private code repo 的公开安全子集。
- 不公开私有数据路径、凭据、密钥、未发表结果或内部 benchmark。

## 技术名词

首次出现时推荐写成：

```text
初始化状态 `InitState`
结果对象 `ModelStats`
实验汇总 `experiment summary`
```

如果英文 API 本身就是用户要输入的内容，直接保留英文，例如：

```matlab
TaskManner.train(ds, mdl, NumTrials=3)
```

## 主体措辞

推荐写法：

- ExpManner 支持 `Dataset` object array 与 model cell array 的组合 benchmark。
- ExpManner 的公开示例模型位于 `examples/+Models`。
- ExpManner 当前稳定接口包括 `Dataset`、`TaskManner`、`ModelStats` 和可选 `ModelBase`。
- 公开说明只展示安全示例；真实 benchmark 和内部材料留在 private code repo。

避免写法：

- 以公开说明本身作为功能主体。
- 以页面完成情况替代 ExpManner 能力状态。
- 路线图以 docs repo 的维护事项为主线。

## 教程模板

教程页优先包含：

- 目标。
- 前置条件。
- 完整代码。
- 预期输出。
- 生成文件。
- 常见错误。
- 下一步。

## 公开边界措辞

推荐写法：

- 使用 `<path-to-ExpManner>` 表示本地路径。
- 使用 `Iris`、`Wine` 这类公开安全小数据作为示例。
- 说明 private source link 需要 PALM Jia 授权。

避免写法：

- 本机绝对路径。
- 私有数据集具体位置。
- 内部 benchmark 结果表格。
- 未发表论文的完整复现实验组合。

## 检查命令

提交 PR 前运行：

```powershell
.\scripts\check-docs.ps1
```

该脚本会运行 MkDocs strict build、空白检查、中文化扫描、敏感信息扫描和本地链接检查。

更新教程代码或展示输出前，还需要在 private code repo 中运行文档材料统一验证入口：

```matlab
run("examples/docs/validateDocumentation.m")
```

只有输出 `DOC_DOCUMENTATION_VALIDATION_OK`，并确认展示内容没有本机路径、私有数据位置或内部 benchmark 后，才能把结果同步到 public docs。

更新 `.mlx` Live Script 时，先修改 private code repo 中的 `examples/live/sources/*.m`，再重新生成：

```matlab
addpath(fullfile(pwd, "examples", "docs"))
validateDocumentation(GenerateLiveScripts=true)
```

`.mlx` 只作为组内教学展示材料；提交前必须检查输出缓存中没有本机路径、私有数据位置、未发表结果或内部 benchmark。

当前不把 MATLAB 文档示例验证接入 public docs GitHub Actions；原因是 public docs repo 不包含 private code repo，也没有稳定的 MATLAB license runner。

如果公开说明涉及架构选择、接口入口或结果目录约定，应同时检查 [设计决策记录](design-decisions.md)。如果公开说明涉及 API 列表，应先在 private code repo 中生成 API 草稿，再人工同步公开安全子集。
