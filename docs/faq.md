# 常见问题

## 为什么不维护英文版本？

第一版目标用户主要是 PALM Jia 课题组内部成员和授权协作者。为了降低维护成本、减少双语漂移，后续只维护中文版本。API 名称、MATLAB 代码、命令和仓库名继续保留英文。

## 为什么没有 package namespace？

ExpManner 使用普通 MATLAB 文件夹风格。加入根目录后直接调用短类名：

```matlab
addpath("<path-to-ExpManner>");
ds = Dataset("Iris");
```

这样日常实验脚本更短，也避免延续旧 package layout。

## ModelBase 是必须的吗？

不是。duck typing 仍然有效。模型只需要：

```matlab
mdl.name
mdl.requiredInitFields()
mdl.train(ds, initState)
```

`ModelBase` 只是新 wrapper 的便利层。

## 项目侧模型应该放在哪里？

项目侧模型不要放进框架核心目录。private code repo 中的 `examples/+DemoModels` 和 `examples/+LRDSCAdapters` 只是示例；真实研究模型应放在自己的 project package 或 project repo 中。

## 为什么 Metricer 和 utils 使用 class-folder？

`@Metricer` 和 `@utils` 使用 MATLAB class-folder layout。类文件声明方法表面，具体实现放在同目录独立文件里，便于拆分和维护。

## 为什么文档公开而代码 private？

public docs 便于组内 onboarding 和接口说明；private code repo 保护内部代码、私有数据路径、未发表实验结果和项目侧敏感实现。

## 为什么不要提交 results？

`results/` 可能包含数据集名称、模型参数、指标、best stats 和论文敏感输出。它是本地实验 artifact，默认不提交 Git。

## 使用哪个 MATLAB 版本？

当前已验证开发环境是 MATLAB R2025b。R2024b 是最低支持目标，但本机 MATLAB 安装问题应先和框架兼容性问题分开判断。

## private source link 返回 404 怎么办？

确认当前 GitHub 账号已获得 `PALM-Jia/ExpManner` 访问权限。public docs 可以公开阅读，但源代码链接仍需要授权。

## 可以发布内部教程或 benchmark 吗？

可以，但需要先审查公开边界。不要在 public docs 中发布私有数据位置、生成 artifact、内部 benchmark 表格或未发表结果比较。
