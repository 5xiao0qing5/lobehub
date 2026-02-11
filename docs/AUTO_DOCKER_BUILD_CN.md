# 自动构建 Docker 镜像配置指南

## 📋 概述

本指南说明如何配置自动构建 Docker 镜像的工作流，使其能够在每次代码更改时自动构建并推送带有递增版本号的 Docker 镜像到您的 Docker Hub。

## 🎯 功能特性

- ✅ **自动触发**: 每次推送到 `main` 或 `next` 分支时自动构建
- ✅ **版本自动递增**: 基于 commit 数量自动生成递增的构建号
- ✅ **多种版本标签**:
  - 主版本标签: `v2.1.26-build.123`
  - 日期+SHA 标签: `20260211-abc1234`
  - 分支标签: `latest` (main 分支) 或 `next`
- ✅ **多架构支持**: 自动构建 `linux/amd64` 和 `linux/arm64` 架构
- ✅ **手动触发**: 支持手动触发构建，可指定版本后缀

## 📝 所有 GitHub Actions 工作流说明

### 1. 测试与 CI (5 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `test.yml` | 运行所有测试（packages、app、desktop、database） | 每次 push 和 pull request |
| `e2e.yml` | 端到端测试（Playwright + PostgreSQL） | 每次 push 和 pull request |
| `claude-auto-testing.yml` | 使用 Claude AI 自动生成单元测试 | 每天 05:30 UTC 或手动触发 |
| `claude-auto-e2e-testing.yml` | 使用 Claude AI 自动生成 E2E 测试 | 每天 21:00 UTC 或手动触发 |
| `lighthouse.yml` | 性能审计（Lighthouse） | 每天或手动触发 |

### 2. 桌面应用构建与发布 (6 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `desktop-build-electron.yml` | 构建桌面应用的 Next.js bundle | 推送到 `next` 分支或 PR 修改桌面相关路径 |
| `pr-build-desktop.yml` | 为 PR 构建桌面应用（所有平台） | PR 更新 + 添加 `trigger:build-desktop` 标签 |
| `manual-build-desktop.yml` | 手动构建桌面应用，可选择渠道 | 手动触发（nightly/beta/stable） |
| `release-desktop-beta.yml` | 构建并发布 beta/nightly 版本 | 发布带有预发布后缀的 release |
| `release-desktop-stable.yml` | 构建并发布稳定版本 + 上传到 S3 | 发布稳定版 release 或手动触发 |
| `verify-desktop-patch.yml` | 桌面补丁更改的冒烟测试 | push/PR 到特定路径 |

### 3. Web/Docker 发布 (4 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `release.yml` | 发布 Web 应用：lint、测试、发布到 npm | 推送 git tag `v*.*.*` |
| `pr-build-docker.yml` | 为 PR 构建 Docker 镜像 | PR 更新 + 添加 `trigger:build-docker` 标签 |
| `release-docker.yml` | 构建并推送多架构 Docker 镜像 | 发布 release 或手动触发 |
| `**auto-docker-build.yml**` | **🆕 自动构建递增版本的 Docker 镜像** | **推送到 main/next 分支或手动触发** |
| `revalidate-docs.yml` | 重新验证文档站点缓存 | 推送到 `docs/**` (main/next 分支) |

### 4. 版本控制与自动化 (4 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `auto-tag-release.yml` | 从合并的 PR 创建 git tag | PR 合并到 main，标题为 `🚀 release: v*` |
| `auto-i18n.yml` | 生成 i18n 翻译 | 每天 00:00 UTC 或手动触发 |
| `sync-database-schema.yml` | 同步数据库 schema 可视化 | 推送 `database-schema.dbml` |
| `sync-main-to-dev.yaml` | 同步 main → dev 分支 | 推送到 main |

### 5. Claude AI 自动化 (6 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `claude.yml` | Claude 代码分析（提及 @claude） | Issue/PR 评论包含 `@claude` |
| `claude-translator.yml` | 自动翻译 issue/PR 为英文 | Issue 打开、评论、审查 |
| `claude-translate-comments.yml` | 翻译非英文代码注释 | 每天 02:00 UTC 或手动触发 |
| `claude-issue-triage.yml` | 自动分类 issue 并添加标签 | Issue 打开或添加 `trigger:triage` 标签 |
| `claude-dedupe-issues.yml` | 检测重复的 issue | Issue 打开或手动触发 |
| `claude-migration-support.yml` | 特定 issue 的迁移支持 | 特定 issue (#11757, #11707) 的评论 |

### 6. Issue 管理 (4 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `issue-auto-comments.yml` | Issue/PR 打开/关闭/合并时自动评论 | Issue/PR 打开、关闭 |
| `issue-auto-close-duplicates.yml` | 自动关闭重复的 issue | 每天 02:00 UTC 或手动触发 |
| `issue-close-require.yml` | 自动关闭带有特定标签的不活跃 issue | 每天 00:00 UTC |
| `lock-closed-issues.yml` | 锁定不活跃的已关闭 issue | 每天 01:00 UTC |

### 7. 工具与监控 (2 个工作流)

| 工作流文件 | 作用 | 触发条件 |
|-----------|------|----------|
| `sync.yml` | 同步上游 fork 的更改 | 每 6 小时或手动触发 |
| `bundle-analyzer.yml` | 分析 bundle 大小 | 手动触发 |

### 定时任务汇总

| 时间 (UTC) | 工作流 | 说明 |
|-----------|--------|------|
| 00:00 | `auto-i18n.yml` | 生成翻译 |
| 00:00 | `issue-close-require.yml` | 关闭不活跃 issue |
| 01:00 | `lock-closed-issues.yml` | 锁定已关闭 issue |
| 02:00 | `claude-translate-comments.yml` | 翻译代码注释 |
| 02:00 | `issue-auto-close-duplicates.yml` | 关闭重复 issue |
| 05:30 | `claude-auto-testing.yml` | 生成单元测试 |
| 每 6 小时 | `sync.yml` | 同步 fork |
| 21:00 | `claude-auto-e2e-testing.yml` | 生成 E2E 测试 |

## 🚀 配置步骤

### 步骤 1: Fork 仓库

1. 访问原仓库: https://github.com/lobehub/lobe-chat
2. 点击右上角的 **Fork** 按钮，将仓库 fork 到您的账户

### 步骤 2: 配置 Docker Hub

1. **创建 Docker Hub 仓库**（如果还没有）:
   - 访问 https://hub.docker.com
   - 点击 **Create Repository**
   - 输入仓库名称（例如：`lobehub`）
   - 选择 **Public** 或 **Private**

2. **获取 Docker Hub 访问令牌**:
   - 访问 https://hub.docker.com/settings/security
   - 点击 **New Access Token**
   - 输入令牌名称（例如：`github-actions`）
   - 权限选择 **Read, Write, Delete**
   - 复制生成的令牌（只显示一次！）

### 步骤 3: 配置 GitHub Secrets

1. 进入您 fork 的仓库设置:
   - 点击 **Settings** → **Secrets and variables** → **Actions**

2. 添加以下 Secrets（点击 **New repository secret**）:

| Secret 名称 | 说明 | 示例值 |
|------------|------|--------|
| `DOCKER_REGISTRY_USER` | Docker Hub 用户名 | `yourusername` |
| `DOCKER_REGISTRY_PASSWORD` | Docker Hub 访问令牌 | `dckr_pat_xxxxx...` |

### 步骤 4: 修改工作流配置

编辑 `.github/workflows/auto-docker-build.yml` 文件，修改第 31 行的镜像名称:

```yaml
env:
  # 修改为您的 Docker Hub 用户名和仓库名
  REGISTRY_IMAGE: yourusername/lobehub
```

**重要**: 将 `yourusername/lobehub` 替换为您的实际 Docker Hub 用户名和仓库名。

### 步骤 5: 提交更改

```bash
git add .github/workflows/auto-docker-build.yml
git commit -m "🐳 配置自动 Docker 构建"
git push origin main
```

## 📦 版本号说明

### 自动生成的版本标签

每次构建会自动生成以下标签:

1. **主版本标签** (基于 package.json + 构建号):
   - 格式: `v{版本号}-build.{构建号}`
   - 示例: `2.1.26-build.1234`
   - 说明: 构建号是 git commit 的总数，随每次提交递增

2. **日期+SHA 标签**:
   - 格式: `{日期}-{短SHA}`
   - 示例: `20260211-abc1234`
   - 说明: 使用 UTC 日期和 7 位 commit SHA

3. **分支标签**:
   - `latest`: 仅 main 分支的构建
   - `next`: next 分支的构建

### 版本号递增规则

- **构建号递增**: 每次提交后，`git rev-list --count HEAD` 的值会自动增加
- **基础版本号**: 从 `package.json` 的 `version` 字段读取
- **完整版本示例**: 如果 package.json 中版本是 `2.1.26`，第 1234 次提交后会生成 `2.1.26-build.1234`

### 手动指定版本后缀

您也可以手动触发构建并指定版本后缀:

1. 在 GitHub 仓库中点击 **Actions**
2. 选择 **Auto Build Docker Image**
3. 点击 **Run workflow**
4. 在 **Version suffix** 中输入后缀（例如: `beta`, `alpha`）
5. 点击 **Run workflow**

这将生成类似 `2.1.26-beta.1234` 的版本标签。

## 🎯 使用示例

### 拉取镜像

```bash
# 拉取最新版本 (main 分支)
docker pull yourusername/lobehub:latest

# 拉取特定构建版本
docker pull yourusername/lobehub:2.1.26-build.1234

# 拉取特定日期的构建
docker pull yourusername/lobehub:20260211-abc1234

# 拉取 next 分支的最新构建
docker pull yourusername/lobehub:next
```

### 运行容器

```bash
docker run -d \
  --name lobehub \
  -p 3210:3210 \
  -e DATABASE_URL="your-database-url" \
  -e AUTH_SECRET="your-auth-secret" \
  -e KEY_VAULTS_SECRET="your-key-vaults-secret" \
  yourusername/lobehub:latest
```

## 🔍 监控构建状态

### 查看构建日志

1. 进入您的 GitHub 仓库
2. 点击 **Actions** 标签
3. 选择 **Auto Build Docker Image** 工作流
4. 查看最近的运行记录

### 构建摘要

每次构建成功后，会在 **Summary** 页面显示:
- 🐳 镜像信息（仓库、版本标签）
- 📝 拉取命令
- 🔗 Docker Hub 链接

### Docker Hub 检查

访问 `https://hub.docker.com/r/yourusername/lobehub/tags` 查看所有已发布的标签。

## 🛠 常见问题

### Q1: 构建失败，提示没有权限推送到 Docker Hub

**A**: 请确保:
1. `DOCKER_REGISTRY_USER` 和 `DOCKER_REGISTRY_PASSWORD` secrets 已正确配置
2. Docker Hub 访问令牌具有 **Read, Write** 权限
3. `.github/workflows/auto-docker-build.yml` 中的 `REGISTRY_IMAGE` 已修改为您的仓库

### Q2: 如何禁用某些分支的自动构建？

**A**: 编辑 `.github/workflows/auto-docker-build.yml`，修改 `on.push.branches`:

```yaml
on:
  push:
    branches:
      - main  # 只保留 main 分支
      # - next  # 注释掉不需要的分支
```

### Q3: 如何修改版本号格式？

**A**: 编辑工作流文件中的 `Generate version tag` 步骤，修改 `VERSION_TAG` 的生成逻辑。

例如，使用日期作为主版本号:

```bash
VERSION_TAG="${BUILD_DATE}.${BUILD_NUMBER}"
```

### Q4: ARM64 架构构建失败

**A**: ARM64 构建需要 GitHub-hosted ARM runner（`ubuntu-24.04-arm`）。如果您的账户没有访问权限，可以:

1. 仅构建 AMD64 架构:

```yaml
strategy:
  matrix:
    include:
      - platform: linux/amd64
        os: ubuntu-latest
```

2. 或使用 QEMU 模拟（速度较慢）:

```yaml
- name: Set up QEMU
  uses: docker/setup-qemu-action@v3
```

### Q5: 如何在构建时传递自定义参数？

**A**: 修改 Dockerfile，添加 `ARG` 指令，然后在工作流中添加 `build-args`:

```yaml
build-args: |
  SHA=${{ steps.version.outputs.short_sha }}
  CUSTOM_ARG=value
```

## 📚 相关资源

- [Docker Hub 文档](https://docs.docker.com/docker-hub/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [LobeChat 官方文档](https://lobehub.com/docs)

## 🤝 贡献

如果您发现任何问题或有改进建议，欢迎:
- 提交 Issue
- 创建 Pull Request
- 参与讨论

## 📄 许可证

本项目遵循 MIT 许可证。详见 [LICENSE](../LICENSE) 文件。
