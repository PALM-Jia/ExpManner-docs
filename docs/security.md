# 安全边界

ExpManner 采用 private code repo + public docs repo 的形式。安全问题通过 private maintainer channel 处理，不在公开页面披露细节。

## 需要报告的问题

发现以下情况时应立即报告：

- 凭据、令牌、密钥或访问 key 暴露。
- 私有数据路径、私有数据集或生成结果 artifact 暴露。
- 未发表实验表格、模型比较或论文敏感结果暴露。
- public docs 中复制了敏感实现细节。
- 文件写入行为可能覆盖重要实验结果。
- 依赖或 toolbox 风险影响复现性或保密性。

## 报告方式

使用以下任一 private channel：

- private code repo issue。
- maintainer 直接消息。
- PALM Jia 内部沟通渠道。

报告时尽量包含：

- 受影响文件、页面、commit 或 workflow。
- 问题是否已经公开可见。
- 是否涉及凭据或私有数据。
- 建议的第一步 containment。

## 处理预期

- maintainer review 前不要公开传播。
- 凭据暴露时先撤销或轮换。
- 私有数据或未发表结果暴露时先移除访问，再修正文档或 Git 历史。
- 默认只维护当前 `main` 分支，除非 maintainer 创建 release branch。

## 发布前检查

docs repo 中运行：

```powershell
.\scripts\check-docs.ps1
```

该脚本只是 guardrail，不能替代人工 review。公开前仍需确认页面没有私有路径、内部 benchmark 或论文敏感内容。
