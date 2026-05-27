## 变更摘要

- 

## 验证

- [ ] `.\scripts\check-docs.ps1`
- [ ] 修改导航或 workflow 后已检查 GitHub Pages workflow
- [ ] 如改动 MATLAB 示例代码，已在 private code repo 中验证
- [ ] 如改动示例输出，已运行 `run("examples/docs/validateDocumentation.m")`
- [ ] 如改动 API 参考，已生成 API 草稿并人工同步公开安全子集
- [ ] 如改动 Live Script，已检查 `.mlx` 输出缓存

## 公开安全检查

- [ ] 没有凭据、令牌、密钥或访问 key
- [ ] 没有本机私有绝对路径
- [ ] 没有私有数据集位置或生成的结果 artifact
- [ ] 没有未发表 benchmark 表格或论文敏感结果比较
- [ ] 指向 private code repo 的链接已说明需要 PALM Jia 授权

## 中文与同步检查

- [ ] 面向读者的标题、导航、正文和维护说明均为中文
- [ ] API 名称、MATLAB 代码、命令和仓库名保留英文原文
- [ ] 内容与 private code repo canonical docs 不冲突
- [ ] 里程碑状态变化时已同步 private code repo 的 `doc_plan.md`
- [ ] 架构选择、接口入口或结果目录变化时已检查设计决策记录
