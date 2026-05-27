# 安装

ExpManner 以源码目录形式在 MATLAB 中使用，不需要安装成 toolbox，也不使用 package namespace。

## 前置条件

- MATLAB。当前已验证开发环境为 R2025b，R2024b 是最低支持目标。
- PALM Jia 授权的 GitHub 账号。
- private code repo `PALM-Jia/ExpManner` 的本地 checkout。

R2024b 如果出现 `addpath` 等基础函数无法解析，应先按 MATLAB 环境问题处理，不直接记为框架兼容性失败。

## 获取代码

代码仓库地址：

```text
https://github.com/PALM-Jia/ExpManner
```

克隆后，把本地目录记为 `<path-to-ExpManner>`。公开文档中统一使用这个占位符，不写本机绝对路径。

## MATLAB path 设置

普通使用场景：

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));
```

说明：

- 框架核心代码不会自动调用 `addpath`。
- demo model 位于 `examples` 下，因此运行教程时需要额外加入 `examples`。
- 加入 path 后直接使用短类名，例如 `Dataset`、`TaskManner`、`ModelStats`。

## 数据目录

默认数据根目录由框架按约定推断。公开教程只使用 `Iris` 这类小型公开安全示例。

如果项目需要私有数据：

- 在内部文档或 private repo 中记录具体位置。
- public docs 只描述数据形状、变量名和加载方式。
- 不把私有路径、私有 `.mat` 文件或生成结果放进 public docs repo。

## 健康检查

```matlab
expRoot = "<path-to-ExpManner>";
addpath(expRoot);
addpath(fullfile(expRoot, "examples"));

ds = Dataset("Iris", Normalize="range");
mdl = DemoModels.KMeans();
[~, summary] = TaskManner.train(ds, mdl, NumTrials=1);
disp(summary)
```

如果这段代码能显示 summary table，说明基础路径和 demo model 都已可用。

下一步阅读 [快速开始](getting-started.md)。
