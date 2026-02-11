# GitHub Actions 工作流管理

本章节介绍如何管理 GitHub Actions 工作流，包括禁用、启用和批量操作。

## 📋 概述

LobeHub 项目包含 31 个 GitHub Actions 工作流，涵盖测试、构建、发布、AI 自动化等功能。本文档帮助您高效管理这些工作流，节省 Actions 配额。

## 🎯 功能特性

- ✅ **批量操作**: 一键禁用/启用多个工作流
- ✅ **分类管理**: 按类别管理（claude/issue/desktop/test）
- ✅ **自动化脚本**: 提供管理脚本，无需手动操作
- ✅ **节省资源**: 禁用不需要的工作流，节省 GitHub Actions 配额
- ✅ **易于恢复**: 可随时恢复已禁用的工作流

## 📚 文档列表

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .lg .middle } __快速参考__

    ---

    最快的禁用方法和常用命令

    [:octicons-arrow-right-24: 快速开始](quickstart.md)

-   :material-book-open-variant:{ .lg .middle } __完整指南__

    ---

    5 种禁用方法详解，推荐策略和工作流分类

    [:octicons-arrow-right-24: 查看详情](complete-guide.md)

</div>

## 🚀 快速预览

### 管理脚本使用

```bash
# 查看所有工作流
./scripts/manage-workflows.sh list

# 只保留 Docker 构建工作流
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml

# 按类别禁用
./scripts/manage-workflows.sh disable-category claude  # 禁用 6 个 Claude AI 工作流
./scripts/manage-workflows.sh disable-category issue   # 禁用 4 个 Issue 管理工作流

# 恢复所有
./scripts/manage-workflows.sh enable-all
```

### 工作流分类

| 类别 | 数量 | 说明 |
|-----|------|------|
| 🔴 高资源消耗 | 4 个 | test.yml, e2e.yml, lighthouse.yml, desktop-build |
| 🟡 中等资源消耗 | 4 个 | Claude AI 测试生成、发布流程 |
| 🟢 低资源消耗 | 3 个 | Docker 构建、Fork 同步、Issue 评论 |
| 🔵 定时任务 | 4 个 | i18n 翻译、代码注释翻译、测试生成 |

## 💡 推荐配置

### 配置 1: 最小化（仅 Docker）
```bash
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml
```

### 配置 2: Docker + 测试
```bash
./scripts/manage-workflows.sh disable-all-except \
    auto-docker-build.yml \
    test.yml
```

### 配置 3: 禁用资源密集型
```bash
./scripts/manage-workflows.sh disable-category test
./scripts/manage-workflows.sh disable-category claude
```

## 🛠️ 5 种禁用方法

1. **使用管理脚本** ⭐ (推荐) - 自动化批量操作
2. **使用 GitHub Web UI** ⭐ (最简单) - 无需修改代码
3. **手动重命名文件** - 临时禁用，易于恢复
4. **修改工作流条件** - 代码级禁用
5. **仅保留手动触发** - 部分禁用

详细说明请查看 **[完整指南](complete-guide.md)**。

## 📊 工作流说明

所有 31 个工作流的详细说明（作用、触发条件、定时规则）请查看：
- [完整指南 - 工作流分类](complete-guide.md#工作流分类参考)
- [Docker 构建文档 - 所有工作流说明](../docker/complete-guide.md#所有-github-actions-工作流说明)

## 🔗 相关链接

- [Docker 自动构建](../docker/index.md)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [管理工作流运行](https://docs.github.com/en/actions/managing-workflow-runs)

## ❓ 常见问题

常见问题请查看 [完整指南](complete-guide.md) 中的"常见问题"部分。

---

**下一步**: 开始管理工作流 → [快速参考](quickstart.md)
