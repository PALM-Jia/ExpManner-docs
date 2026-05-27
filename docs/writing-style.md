# 中文写作规范

ExpManner 文档站后续只维护中文版本。

## 基本原则

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
