# LobeHub 文档中心

<div align="center">
  <img src="https://registry.npmmirror.com/@lobehub/assets-logo/latest/files/assets/logo-3d.webp" alt="LobeHub Logo" width="200"/>
  
  <h1>LobeHub 完整文档</h1>
  
  <p>开源的现代化 AI Agent 工作空间</p>
  
  [![][github-release-shield]][github-release-link]
  [![][discord-shield]][discord-link]
  [![][github-stars-shield]][github-stars-link]
</div>

[github-release-shield]: https://img.shields.io/github/v/release/lobehub/lobe-chat?label=Release&style=flat-square
[github-release-link]: https://github.com/lobehub/lobe-chat/releases
[discord-shield]: https://img.shields.io/discord/1127171173982154893?label=Discord&style=flat-square
[discord-link]: https://discord.gg/AYFPHvv2jT
[github-stars-shield]: https://img.shields.io/github/stars/lobehub/lobe-chat?style=flat-square
[github-stars-link]: https://github.com/lobehub/lobe-chat/stargazers

## 🎯 快速导航

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .lg .middle } __快速开始__

    ---

    快速了解如何使用 LobeHub，包括基本功能和常见操作

    [:octicons-arrow-right-24: 开始使用](usage/start.md)

-   :material-server:{ .lg .middle } __自部署指南__

    ---

    完整的自部署指南，包括 Docker、环境变量和认证配置

    [:octicons-arrow-right-24: 部署指南](self-hosting/start.md)

-   :fontawesome-brands-docker:{ .lg .middle } __Docker 构建__

    ---

    自动构建 Docker 镜像，版本号自动递增，多架构支持

    [:octicons-arrow-right-24: Docker 指南](docker/quickstart.md)

-   :material-cog:{ .lg .middle } __工作流管理__

    ---

    GitHub Actions 工作流管理，批量禁用/启用工具

    [:octicons-arrow-right-24: 工作流管理](workflows/quickstart.md)

-   :material-code-braces:{ .lg .middle } __开发指南__

    ---

    为 LobeHub 贡献代码，了解架构和开发流程

    [:octicons-arrow-right-24: 开发文档](development/start.md)

-   :material-help-circle:{ .lg .middle } __帮助中心__

    ---

    常见问题解答和疑难解答

    [:octicons-arrow-right-24: 获取帮助](usage/help.md)

</div>

## 📚 文档分类

### 📖 使用指南

适合所有用户，了解如何使用 LobeHub 的各项功能：

- **[快速开始](usage/start.md)** - 新手入门指南
- **[Agent 功能](usage/agent/index.md)** - Agent 团队、沙盒、定时任务等
- **[社区功能](usage/community/index.md)** - 插件开发、发布 Agent
- **[模型提供商](usage/providers.md)** - 支持的 AI 模型提供商配置

### 🚀 自部署

完整的自部署文档，适合需要私有化部署的用户：

- **[部署快速开始](self-hosting/start.md)** - 5 分钟快速部署
- **[环境变量配置](self-hosting/environment-variables.md)** - 完整的环境变量说明
- **[认证系统](self-hosting/auth.md)** - SSO、OAuth 等认证方式
- **[平台部署指南](self-hosting/platform/index.md)** - Vercel、Docker、云服务器部署

### 🐳 Docker 构建

自动化 Docker 镜像构建系统：

- **[快速开始](docker/quickstart.md)** - 5 步配置自动构建
- **[完整配置指南](docker/complete-guide.md)** - 详细的配置说明
- **[配置示例](docker/examples.md)** - 实用配置示例

**特性：**
- ✅ 版本号自动递增（基于 commit 数量）
- ✅ 多架构支持（amd64 + arm64）
- ✅ 多种标签格式
- ✅ 推送到自定义 Docker Hub

### ⚙️ 工作流管理

GitHub Actions 工作流管理工具：

- **[快速参考](workflows/quickstart.md)** - 常用命令和配置
- **[完整指南](workflows/complete-guide.md)** - 5 种禁用方法详解

**特性：**
- ✅ 批量禁用/启用工作流
- ✅ 按类别管理（claude/issue/desktop/test）
- ✅ 自动化管理脚本
- ✅ 节省 GitHub Actions 配额

### 💻 开发指南

适合开发者和贡献者：

- **[开始开发](development/start.md)** - 开发环境搭建
- **[基础知识](development/basic/index.md)** - 技术栈和架构
- **[国际化](development/internationalization/index.md)** - i18n 开发指南
- **[状态管理](development/state-management/index.md)** - Zustand 使用指南
- **[测试](development/tests/index.md)** - 测试编写指南

### 📝 更新日志

查看 LobeHub 的版本更新历史：

- **[更新日志](changelog/index.md)** - 所有版本的更新记录

### 📚 Wiki

- **[术语表](wiki/glossary.md)** - 专业术语解释

## 🔧 实用工具

### 工作流管理脚本

快速管理 GitHub Actions 工作流：

```bash
# 查看所有工作流
./scripts/manage-workflows.sh list

# 只保留 Docker 构建工作流
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml

# 按类别禁用
./scripts/manage-workflows.sh disable-category claude
```

### Docker 快速配置

自动构建 Docker 镜像：

```bash
# 1. 配置 Docker Hub Secrets
# 2. 修改工作流配置
# 3. 推送代码，自动构建

# 查看详细步骤
cat docs/docker/quickstart.md
```

## 🌐 多语言支持

本文档支持以下语言：

- 🇨🇳 简体中文（默认）
- 🇺🇸 English

切换语言请点击页面右上角的语言选择器。

## 🤝 贡献文档

发现文档问题或有改进建议？

1. 点击页面右上角的 **编辑此页面** 按钮
2. 提交 Pull Request
3. 我们会及时审核并合并

或者直接在 [GitHub Issues](https://github.com/lobehub/lobe-chat/issues) 提出问题。

## 📞 获取帮助

如果您在使用过程中遇到问题：

- 📖 查看 **[帮助中心](usage/help.md)**
- 💬 加入 **[Discord 社区](https://discord.gg/AYFPHvv2jT)**
- 🐛 提交 **[GitHub Issue](https://github.com/lobehub/lobe-chat/issues)**
- 📧 发送邮件到 **support@lobehub.com**

## 🔗 相关链接

- **官方网站**: [https://lobehub.com](https://lobehub.com)
- **GitHub 仓库**: [https://github.com/lobehub/lobe-chat](https://github.com/lobehub/lobe-chat)
- **更新日志**: [https://lobehub.com/changelog](https://lobehub.com/changelog)
- **博客**: [https://lobehub.com/blog](https://lobehub.com/blog)

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](https://github.com/lobehub/lobe-chat/blob/main/LICENSE) 文件。

---

<div align="center">
  <p>由 <a href="https://lobehub.com">LobeHub</a> 团队用 ❤️ 构建</p>
</div>
