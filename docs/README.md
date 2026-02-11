# LobeHub 文档站点

本目录包含 LobeHub 的完整文档，可以通过 MkDocs Material 构建成文档网站并部署到 GitHub Pages。

## 📋 文档结构

```
docs/
├── index.md                    # 文档首页
├── usage/                      # 使用指南
│   ├── agent/                 # Agent 功能
│   ├── community/             # 社区功能
│   ├── getting-started/       # 入门教程
│   ├── providers/             # 模型提供商
│   ├── user-interface/        # 用户界面
│   └── workspace/             # 工作空间
├── self-hosting/              # 自部署指南
│   ├── advanced/              # 高级配置
│   ├── auth/                  # 认证
│   ├── environment-variables/ # 环境变量
│   ├── examples/              # 部署示例
│   ├── faq/                   # 常见问题
│   ├── migration/             # 数据迁移
│   └── platform/              # 平台部署
├── docker/                    # Docker 构建文档
│   ├── index.md              # Docker 概述
│   ├── quickstart.md         # 快速开始
│   ├── complete-guide.md     # 完整指南（中文）
│   ├── complete-guide-en.md  # 完整指南（英文）
│   └── examples.md           # 配置示例
├── workflows/                 # 工作流管理文档
│   ├── index.md              # 工作流概述
│   ├── quickstart.md         # 快速参考
│   └── complete-guide.md     # 完整指南
├── development/               # 开发指南
│   ├── basic/                # 基础知识
│   ├── internationalization/ # 国际化
│   ├── state-management/     # 状态管理
│   ├── tests/                # 测试
│   └── others/               # 其他
├── changelog/                 # 更新日志
├── wiki/                      # Wiki
└── stylesheets/               # 自定义样式
```

## 🚀 本地预览

### 安装依赖

```bash
pip install mkdocs-material
pip install mkdocs-i18n
```

### 启动本地服务器

```bash
mkdocs serve
```

访问 http://127.0.0.1:8000 查看文档站点。

### 构建静态文件

```bash
mkdocs build
```

生成的文件在 `site/` 目录中。

## 📦 GitHub Pages 部署

### 自动部署

已配置 GitHub Actions 自动部署工作流 (`.github/workflows/deploy-docs.yml`)。

当以下情况发生时自动部署：
- 推送到 `main` 分支
- `docs/` 目录或 `mkdocs.yml` 文件有更改

### 手动部署

也可以使用 MkDocs 命令手动部署：

```bash
mkdocs gh-deploy
```

## 🔧 配置说明

### mkdocs.yml

主配置文件，包含：
- 站点信息
- 主题配置
- 导航结构
- 插件配置
- Markdown 扩展

### 重要配置项

```yaml
site_name: LobeHub Documentation
site_url: https://5xiao0qing5.github.io/lobehub/
repo_name: 5xiao0qing5/lobehub
repo_url: https://github.com/5xiao0qing5/lobehub

theme:
  name: material
  language: zh
  features:
    - navigation.instant
    - navigation.tabs
    - search.suggest
```

## 📝 编写文档

### Markdown 语法

支持标准 Markdown 和扩展语法：

- **代码块**: 支持语法高亮
- **告示框**: 使用 `!!! note` 等
- **表格**: 标准 Markdown 表格
- **任务列表**: `- [x]` 和 `- [ ]`
- **表情符号**: `:smile:` → 😄
- **Mermaid 图表**: 支持流程图、时序图等

### 卡片网格

使用 `grid cards` 创建漂亮的卡片布局：

```markdown
<div class="grid cards" markdown>

-   :material-icon:{ .lg .middle } __标题__

    ---

    描述内容

    [:octicons-arrow-right-24: 链接](path/to/page.md)

</div>
```

### 告示框

```markdown
!!! note "标题"
    这是一个提示框

!!! warning "警告"
    这是一个警告框

!!! tip "提示"
    这是一个技巧提示

!!! danger "危险"
    这是一个危险警告
```

## 🌐 多语言支持

文档支持中英文：

- 中文文件：`example.md` 或 `example.zh-CN.md`
- 英文文件：`example.md` 或 `example.en.md`

MkDocs i18n 插件会自动处理多语言导航。

## 📚 添加新文档

1. 在相应目录创建 `.md` 文件
2. 在 `mkdocs.yml` 的 `nav` 部分添加导航链接
3. 提交更改，自动部署

例如添加新页面：

```yaml
nav:
  - 使用指南:
    - usage/index.md
    - 新功能: usage/new-feature.md  # 添加这行
```

## 🎨 自定义样式

自定义CSS在 `docs/stylesheets/extra.css`。

可以覆盖Material主题的默认样式。

## 🔗 有用的链接

- [MkDocs 文档](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Markdown 语法](https://www.markdownguide.org/)
- [Material Icons](https://materialdesignicons.com/)

## 💡 提示

1. **本地预览**: 编写文档时使用 `mkdocs serve` 实时预览
2. **检查链接**: 构建前检查内部链接是否正确
3. **导航结构**: 保持导航结构清晰简洁
4. **文件命名**: 使用小写字母和连字符，如 `quick-start.md`
5. **图片**: 图片放在 `docs/images/` 或使用外部链接

## ❓ 常见问题

### Q: 如何更新文档站点？

**A**: 只需推送更改到 `main` 分支，GitHub Actions 会自动部署。

### Q: 如何添加新的文档分类？

**A**: 
1. 在 `docs/` 创建新目录
2. 添加 `index.md` 作为分类首页
3. 在 `mkdocs.yml` 的 `nav` 添加导航项

### Q: 如何自定义主题颜色？

**A**: 修改 `mkdocs.yml` 中的 `theme.palette` 配置。

### Q: 支持搜索功能吗？

**A**: 是的，Material主题内置全文搜索，支持中英文。

## 📞 获取帮助

如有问题，请访问：
- [GitHub Issues](https://github.com/lobehub/lobe-chat/issues)
- [Discord 社区](https://discord.gg/AYFPHvv2jT)

---

Happy documenting! 📖✨
