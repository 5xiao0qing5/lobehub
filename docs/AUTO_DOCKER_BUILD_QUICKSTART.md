# 自动构建 Docker 镜像 - 快速开始指南

## 🎯 问题回答

### 1. 各个 Action 的作用和定时规则

项目中共有 **31 个 GitHub Actions 工作流**，分为以下几类：

#### 📊 主要工作流分类

| 类别 | 数量 | 主要作用 |
|-----|------|---------|
| 测试与 CI | 5 个 | 运行单元测试、E2E 测试、性能测试 |
| 桌面应用构建发布 | 6 个 | 构建 Electron 桌面应用（macOS/Windows/Linux） |
| Web/Docker 发布 | 4 个 | 构建和发布 Web 应用、Docker 镜像 |
| 版本控制与自动化 | 4 个 | 自动标签、i18n 翻译、数据库同步 |
| Claude AI 自动化 | 6 个 | AI 驱动的测试生成、翻译、问题分类 |
| Issue 管理 | 4 个 | 自动评论、关闭重复 issue、锁定 issue |
| 工具与监控 | 2 个 | Fork 同步、Bundle 分析 |

#### 🕒 定时任务汇总

| 时间 (UTC) | 工作流 | 说明 |
|-----------|--------|------|
| 00:00 | `auto-i18n.yml` | 生成 i18n 翻译 |
| 00:00 | `issue-close-require.yml` | 关闭不活跃 issue |
| 01:00 | `lock-closed-issues.yml` | 锁定已关闭 issue |
| 02:00 | `claude-translate-comments.yml` | 翻译代码注释 |
| 02:00 | `issue-auto-close-duplicates.yml` | 关闭重复 issue |
| 05:30 | `claude-auto-testing.yml` | 生成单元测试 |
| 21:00 | `claude-auto-e2e-testing.yml` | 生成 E2E 测试 |
| 每 6 小时 | `sync.yml` | 同步 fork |

详细的所有工作流说明请查看：
- 📄 [中文完整文档](./AUTO_DOCKER_BUILD_CN.md)
- 📄 [English Full Documentation](./AUTO_DOCKER_BUILD.md)

### 2. 如何实现每次更改自动构建版本号+1的 Docker 镜像

已为您创建了新的工作流 **`auto-docker-build.yml`**，实现以下功能：

#### ✨ 功能特性

- ✅ 每次推送到 `main` 或 `next` 分支时自动构建
- ✅ 版本号自动递增（基于 commit 总数）
- ✅ 生成多种标签格式：
  - 主版本：`2.1.26-build.1234`
  - 日期+SHA：`20260211-abc1234`
  - 分支：`latest` 或 `next`
- ✅ 多架构支持：`linux/amd64` 和 `linux/arm64`
- ✅ 支持手动触发，可指定版本后缀（如 `beta`, `alpha`）

#### 📝 配置步骤（简化版）

1. **Fork 本仓库到你的账户**

2. **在 Docker Hub 创建仓库**
   - 访问 https://hub.docker.com
   - 创建一个新仓库（例如：`lobehub`）

3. **获取 Docker Hub 访问令牌**
   - 访问 https://hub.docker.com/settings/security
   - 创建新的访问令牌（权限：Read, Write, Delete）
   - 复制令牌（只显示一次！）

4. **在 GitHub 仓库中添加 Secrets**
   - Settings → Secrets and variables → Actions
   - 添加两个 secrets：
     ```
     DOCKER_REGISTRY_USER = 你的Docker Hub用户名
     DOCKER_REGISTRY_PASSWORD = 你的Docker Hub访问令牌
     ```

5. **修改工作流配置**
   - 编辑 `.github/workflows/auto-docker-build.yml` 第 31 行
   - 将 `REGISTRY_IMAGE: lobehub/lobehub` 改为 `REGISTRY_IMAGE: 你的用户名/仓库名`

6. **提交并推送代码**
   ```bash
   git add .github/workflows/auto-docker-build.yml
   git commit -m "🐳 配置自动 Docker 构建"
   git push origin main
   ```

#### 🎉 完成！

推送后，GitHub Actions 会自动：
1. 构建 Docker 镜像（amd64 和 arm64）
2. 生成版本号（基于 commit 数量）
3. 推送到你的 Docker Hub
4. 在 Actions 页面显示构建摘要

#### 📦 使用镜像

```bash
# 拉取最新版本
docker pull 你的用户名/lobehub:latest

# 拉取特定版本
docker pull 你的用户名/lobehub:2.1.26-build.1234

# 运行容器
docker run -d -p 3210:3210 \
  -e DATABASE_URL="your-db-url" \
  -e AUTH_SECRET="your-secret" \
  你的用户名/lobehub:latest
```

## 📚 详细文档

- 📖 [完整配置指南（中文）](./AUTO_DOCKER_BUILD_CN.md) - 包含所有工作流详情、配置步骤、常见问题
- 📖 [Full Configuration Guide (English)](./AUTO_DOCKER_BUILD.md) - Complete workflow details, setup steps, FAQ
- 📋 [配置示例](./AUTO_DOCKER_BUILD_EXAMPLE.md) - 快速参考配置示例

## 💡 版本号规则

每次 commit 后，构建号会自动 +1：

```
commit 1234 → 2.1.26-build.1234
commit 1235 → 2.1.26-build.1235
commit 1236 → 2.1.26-build.1236
...
```

构建号 = `git rev-list --count HEAD`（git commit 的总数）

## 🔍 监控构建

1. 访问你的 GitHub 仓库
2. 点击 **Actions** 标签
3. 查看 **Auto Build Docker Image** 工作流运行记录
4. 检查 Docker Hub: `https://hub.docker.com/r/你的用户名/仓库名/tags`

## ❓ 需要帮助？

查看 [完整文档](./AUTO_DOCKER_BUILD_CN.md) 中的 **常见问题** 部分，或在 GitHub 上提 Issue。

---

**提示**: 如果你只想在特定分支触发构建，可以修改工作流的 `on.push.branches` 部分。
