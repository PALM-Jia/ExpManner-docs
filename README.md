# ExpManner 中文文档

本仓库托管 ExpManner 的公开中文说明。ExpManner 是一个面向未来聚类研究实验的 MATLAB 框架，用于 benchmark、结果记录和模型复用评估。

- 在线说明：<https://palm-jia.github.io/ExpManner-docs/>
- private code repo：<https://github.com/PALM-Jia/ExpManner>

代码仓库是 private repo，需要 PALM Jia 授权访问。本 public docs repo 只维护公开安全内容，不放私有数据路径、凭据、密钥、未发表实验结果、内部 benchmark 表格或敏感实现细节。

## 本地预览

```powershell
python -m venv .venv
.\.venv\Scripts\python -m pip install -r requirements.txt
.\.venv\Scripts\python -m mkdocs serve
```

提交 PR 前运行：

```powershell
.\scripts\check-docs.ps1
```

## 维护规则

- ExpManner 的公开说明后续只维护中文版本。
- API 名称、MATLAB 代码、命令、路径占位符、仓库名和工具名保留英文原文。
- private code repo 的 canonical docs 是事实来源，public docs 只同步公开安全子集。
- 站点由 GitHub Actions 发布到 GitHub Pages。
